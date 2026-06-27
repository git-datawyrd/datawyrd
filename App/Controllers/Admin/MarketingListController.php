<?php
namespace App\Controllers\Admin;

use Core\Controller;
use Core\Database;
use Core\Auth;
use Core\Session;
use App\Services\MailService;
use App\Services\Marketing\CampaignService;
use App\Repositories\MarketingRepository;
use PDO;

class MarketingListController extends Controller
{
    public function lists(): void
    {
        $this->viewLayout('admin/marketing/lists', 'admin', [
            'title' => 'Listas de Contactos | Marketing',
            'lists' => $this->repo->getAllLists(),
        ]);
    }


    public function showList(int $listId): void
    {
        $list = $this->repo->findList($listId);
        if (!$list) {
            Session::flash('error', 'Lista no encontrada.');
            $this->redirect('/admin/marketing/lists');
            return;
        }

        $contacts = $this->repo->getContactsByList($listId, [
            'search' => $_GET['search'] ?? null,
            'status' => $_GET['status'] ?? null,
            'limit'  => 100,
        ]);

        $this->viewLayout('admin/marketing/list_detail', 'admin', [
            'title'    => "{$list['name']} | Listas",
            'list'     => $list,
            'contacts' => $contacts,
        ]);
    }


    public function storeList(): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/admin/marketing/lists');
            return;
        }

        $name = trim($_POST['name'] ?? '');
        if (empty($name)) {
            Session::flash('error', 'El nombre de la lista es obligatorio.');
            $this->redirect('/admin/marketing/lists');
            return;
        }

        $userId = Auth::user()['id'];
        $this->campaignService->createList(['name' => $name, 'description' => $_POST['description'] ?? ''], $userId);
        Session::flash('success', 'Lista creada correctamente.');
        $this->redirect('/admin/marketing/lists');
    }


    /**
     * Importación de contactos CSV con mapeo inteligente de columnas.
     * Soporta:
     *  - Autodetect: si los headers del CSV coinciden con los campos de la BD
     *  - Mapeo manual: enviando column_map como JSON desde el frontend de 2 pasos
     */
    public function importContacts(int $listId): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect("/admin/marketing/lists/{$listId}");
            return;
        }

        if (!isset($_FILES['csv_file']) || $_FILES['csv_file']['error'] !== UPLOAD_ERR_OK) {
            Session::flash('error', 'Error al subir el archivo CSV.');
            $this->redirect("/admin/marketing/showList/{$listId}");
            return;
        }

        // Leer mapeo de columnas (puede venir del UI de 2 pasos o autodetect)
        $columnMap = [];
        if (!empty($_POST['column_map'])) {
            $decoded = json_decode($_POST['column_map'], true);
            if (is_array($decoded)) {
                $columnMap = $decoded; // ['email' => 'Correo', 'first_name' => 'Nombre', ...]
            }
        }

        // Leer valores fijos
        $fixedValues = [];
        if (!empty($_POST['fixed_values'])) {
            $decodedFixed = json_decode($_POST['fixed_values'], true);
            if (is_array($decodedFixed)) {
                $fixedValues = $decodedFixed;
            }
        }

        $file   = $_FILES['csv_file']['tmp_name'];
        $handle = fopen($file, 'r');

        // Detectar separador (coma, punto-y-coma o tab)
        $firstLine = fgets($handle);
        $sep = str_contains($firstLine, ';') ? ';' : (str_contains($firstLine, "\t") ? "\t" : ',');
        rewind($handle);

        // Leer cabecera
        $rawHeaders = fgetcsv($handle, 0, $sep);
        $headers    = array_map(fn($h) => trim(str_replace(['"', "'"], '', $h)), $rawHeaders ?? []);

        // Campos de BD aceptados
        $validDbFields = ['email','first_name','last_name','phone','company','country','industry','tags'];

        // Si no hay mapeo manual, hacer autodetect por nombre de columna
        if (empty($columnMap)) {
            foreach ($headers as $h) {
                $normalized = strtolower(trim($h));
                if (in_array($normalized, $validDbFields, true)) {
                    $columnMap[$normalized] = $h;
                }
            }
        }

        // Invertir mapa: csvColumn → dbField
        $inverseMap = array_flip($columnMap); // ['Correo' => 'email', 'Nombre' => 'first_name', ...]

        // Obtener el nombre de la lista para auto-taggear
        $list = $this->repo->findList($listId);
        $listTagName = $list ? "[Lista: " . $list['name'] . "]" : null;

        $contacts = [];
        while (($row = fgetcsv($handle, 0, $sep)) !== false) {
            $mapped = [];
            foreach ($headers as $idx => $csvCol) {
                $dbField = $inverseMap[$csvCol] ?? null;
                if ($dbField && in_array($dbField, $validDbFields, true)) {
                    $mapped[$dbField] = trim($row[$idx] ?? '');
                }
            }

            // Aplicar valores fijos que el usuario haya ingresado en la interfaz
            foreach ($fixedValues as $dbField => $fixedVal) {
                if (in_array($dbField, $validDbFields, true) && trim((string)$fixedVal) !== '') {
                    $mapped[$dbField] = trim($fixedVal);
                }
            }

            // Auto-taggear con el nombre de la lista
            if ($listTagName) {
                $existingTags = !empty($mapped['tags']) ? explode(',', $mapped['tags']) : [];
                $existingTags = array_map('trim', $existingTags);
                if (!in_array($listTagName, $existingTags, true)) {
                    $existingTags[] = $listTagName;
                }
                $mapped['tags'] = implode(',', $existingTags);
            }

            if (!empty($mapped['email'])) {
                $contacts[] = $mapped;
            }
        }
        fclose($handle);

        if (empty($contacts)) {
            Session::flash('error', 'No se encontraron contactos válidos. Verifica que el campo Email esté mapeado correctamente.');
            $this->redirect("/admin/marketing/showList/{$listId}");
            return;
        }

        $result = $this->campaignService->importContacts($listId, $contacts);

        $msg = "Importación completada: {$result['imported']} importados, {$result['skipped']} duplicados.";
        if (!empty($result['errors'])) {
            $msg .= " " . count($result['errors']) . " filas con error.";
        }

        Session::flash('success', $msg);
        $this->redirect("/admin/marketing/showList/{$listId}");
    }


    public function storeContact(int $listId): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect("/admin/marketing/showList/{$listId}");
            return;
        }

        $email = trim($_POST['email'] ?? '');
        if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            Session::flash('error', 'El correo electrónico no es válido.');
            $this->redirect("/admin/marketing/showList/{$listId}");
            return;
        }

        $existing = $this->repo->findContactByEmail($email, $listId);
        if ($existing) {
            Session::flash('error', 'El contacto ya existe en esta lista.');
            $this->redirect("/admin/marketing/showList/{$listId}");
            return;
        }

        // Obtener el nombre de la lista para auto-taggear
        $list = $this->repo->findList($listId);
        $listTagName = $list ? "[Lista: " . $list['name'] . "]" : null;

        $tagsInput = trim($_POST['tags'] ?? '');
        if ($listTagName) {
            $existingTags = !empty($tagsInput) ? explode(',', $tagsInput) : [];
            $existingTags = array_map('trim', $existingTags);
            if (!in_array($listTagName, $existingTags, true)) {
                $existingTags[] = $listTagName;
            }
            $tagsInput = implode(',', $existingTags);
        }

        $doubleOptIn = \Core\Config::get('marketing.compliance.double_opt_in', false);
        $status      = $doubleOptIn ? 'pending' : 'subscribed';
        $unsubToken  = 'unsub-' . uniqid() . '-' . bin2hex(random_bytes(8));

        $data = [
            'list_id'           => $listId,
            'email'             => $email,
            'first_name'        => trim($_POST['first_name'] ?? ''),
            'last_name'         => trim($_POST['last_name'] ?? ''),
            'phone'             => trim($_POST['phone'] ?? ''),
            'company'           => trim($_POST['company'] ?? ''),
            'country'           => trim($_POST['country'] ?? ''),
            'industry'          => trim($_POST['industry'] ?? ''),
            'tags'              => $tagsInput ?: null,
            'status'            => $status,
            'source'            => 'manual',
            'unsubscribe_token' => $unsubToken,
        ];

        $contactId = $this->repo->createContact($data);

        if ($doubleOptIn) {
            $automationService = new \App\Services\Marketing\AutomationService();
            $automationService->sendDoubleOptInEmail($email, $unsubToken, $data['first_name']);
            Session::flash('success', 'Contacto creado. Se ha enviado un correo de confirmación de suscripción (Double Opt-In).');
        } else {
            $automationService = new \App\Services\Marketing\AutomationService();
            $automationService->trigger('signup', [
                'contact_id' => $contactId,
                'email'      => $email,
                'tenant_id'  => \Core\Config::get('current_tenant_id', 1),
            ]);
            Session::flash('success', 'Contacto agregado correctamente.');
        }
        $this->redirect("/admin/marketing/showList/{$listId}");
    }


    public function downloadCsvTemplate(): void
    {
        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="plantilla_contactos.csv"');
        
        $output = fopen('php://output', 'w');
        // BOM UTF-8
        fprintf($output, chr(0xEF).chr(0xBB).chr(0xBF));
        
        // Write headers
        fputcsv($output, ['Email', 'Nombre', 'Apellido', 'Teléfono', 'Compañía', 'País', 'Industria', 'Tags']);
        
        // Write sample data
        fputcsv($output, ['ejemplo@correo.com', 'Juan', 'Pérez', '+34600123456', 'Mi Empresa', 'España', 'Tecnología', 'cliente,vip']);
        
        fclose($output);
        exit;
    }


    public function deleteList(int $listId): void
    {
        $list = $this->repo->findList($listId);
        if (!$list) {
            Session::flash('error', 'Lista no encontrada.');
            $this->redirect('/admin/marketing/lists');
            return;
        }

        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        
        // Soft delete list
        $stmt = $db->prepare("UPDATE mktg_lists SET deleted_at = NOW() WHERE id = ? AND tenant_id = ?");
        $stmt->execute([$listId, $tenantId]);

        // Soft delete contacts
        $stmtContacts = $db->prepare("UPDATE mktg_contacts SET deleted_at = NOW() WHERE list_id = ? AND tenant_id = ?");
        $stmtContacts->execute([$listId, $tenantId]);

        Session::flash('success', 'Lista eliminada correctamente.');
        $this->redirect('/admin/marketing/lists');
    }


    public function __construct()
    {
        if (!Auth::can('manage_marketing')) {
            Session::flash('error', 'Acceso denegado. Se requieren permisos de Email Marketing.');
            $this->redirect('/dashboard');
            return;
        }

        $db = Database::getInstance()->getConnection();
        $this->repo            = new MarketingRepository($db);
        $this->campaignService = new CampaignService($this->repo);
    }


}
