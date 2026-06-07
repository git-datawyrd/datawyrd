<?php
namespace App\Controllers\Admin;

use App\Repositories\MarketingRepository;
use App\Services\Marketing\CampaignService;
use Core\Marketing\DnsValidator;
use Core\Auth;
use Core\Controller;
use Core\Database;
use Core\Session;

/**
 * MarketingController (Admin)
 *
 * Panel de administración del módulo de Email Marketing & Engagement.
 * Gestiona campañas, listas, contactos, plantillas y analytics.
 *
 * Requiere permiso: 'manage_marketing'
 *
 * @package App\Controllers\Admin
 */
class MarketingController extends Controller
{
    private MarketingRepository $repo;
    private CampaignService $campaignService;

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

    // =========================================================================
    // DASHBOARD DE MARKETING
    // =========================================================================

    public function index(): void
    {
        $campaigns = $this->campaignService->getCampaigns();

        // KPIs globales (últimos 30 días)
        $db     = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $stmt   = $db->prepare(
            "SELECT
                COUNT(DISTINCT c.id)                                              as total_campaigns,
                COALESCE(SUM(CASE WHEN c.status='sent' THEN 1 END), 0)           as completed,
                COALESCE(SUM(CASE WHEN c.status IN ('sending','scheduled') THEN 1 END), 0) as active,
                COALESCE((SELECT COUNT(*) FROM mktg_contacts WHERE tenant_id=? AND status='subscribed' AND deleted_at IS NULL), 0) as total_contacts,
                COALESCE((SELECT COUNT(*) FROM mktg_lists WHERE tenant_id=? AND deleted_at IS NULL), 0) as total_lists
             FROM mktg_campaigns c
             WHERE c.tenant_id = ? AND c.deleted_at IS NULL"
        );
        $stmt->execute([$tenantId, $tenantId, $tenantId]);
        $kpis = $stmt->fetch() ?: [];

        $this->viewLayout('admin/marketing/index', 'admin', [
            'title'     => 'Email Marketing | Data Wyrd',
            'campaigns' => $campaigns,
            'kpis'      => $kpis,
        ]);
    }

    // =========================================================================
    // CAMPAÑAS
    // =========================================================================

    public function campaigns(): void
    {
        $this->viewLayout('admin/marketing/campaigns', 'admin', [
            'title'     => 'Campañas | Email Marketing',
            'campaigns' => $this->campaignService->getCampaigns(),
        ]);
    }

    public function createCampaign(): void
    {
        $this->viewLayout('admin/marketing/campaign_form', 'admin', [
            'title'     => 'Nueva Campaña | Email Marketing',
            'templates' => $this->repo->getAllTemplates(),
            'lists'     => $this->repo->getAllLists(),
            'campaign'  => null,
        ]);
    }

    public function storeCampaign(): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/admin/marketing/campaigns');
            return;
        }

        $userId = Auth::user()['id'];

        $segmentFilters = [];
        if (!empty($_POST['segment_country'])) {
            $segmentFilters['country'] = trim($_POST['segment_country']);
        }
        if (!empty($_POST['segment_industry'])) {
            $segmentFilters['industry'] = trim($_POST['segment_industry']);
        }
        if (!empty($_POST['segment_tags'])) {
            $segmentFilters['tags'] = trim($_POST['segment_tags']);
        }
        if (!empty($_POST['segment_behavior_type'])) {
            $segmentFilters['behavior'] = [
                'type' => $_POST['segment_behavior_type'],
                'campaign_id' => !empty($_POST['segment_behavior_campaign_id']) ? (int)$_POST['segment_behavior_campaign_id'] : null,
                'days' => !empty($_POST['segment_behavior_days']) ? (int)$_POST['segment_behavior_days'] : null,
            ];
        }

        $data = [
            'name'            => trim($_POST['name']         ?? ''),
            'subject'         => trim($_POST['subject']      ?? ''),
            'preview_text'    => trim($_POST['preview_text'] ?? ''),
            'from_name'       => trim($_POST['from_name']    ?? ''),
            'from_email'      => trim($_POST['from_email']   ?? ''),
            'reply_to'        => trim($_POST['reply_to']     ?? ''),
            'template_id'     => !empty($_POST['template_id']) ? (int)$_POST['template_id'] : null,
            'list_id'         => !empty($_POST['list_id'])     ? (int)$_POST['list_id']     : null,
            'type'            => $_POST['type']               ?? 'one_time',
            'scheduled_at'    => !empty($_POST['scheduled_at']) ? $_POST['scheduled_at'] : null,
            'segment_filters' => !empty($segmentFilters) ? $segmentFilters : null,
        ];

        if (empty($data['name']) || empty($data['subject'])) {
            Session::flash('error', 'Nombre y asunto son obligatorios.');
            $this->redirect('/admin/marketing/campaigns/create');
            return;
        }

        $id = $this->campaignService->createCampaign($data, $userId);
        Session::flash('success', 'Campaña creada correctamente.');
        $this->redirect("/admin/marketing/showCampaign/{$id}");
    }

    public function showCampaign(int $id): void
    {
        $campaign = $this->repo->findCampaign($id);
        if (!$campaign) {
            Session::flash('error', 'Campaña no encontrada.');
            $this->redirect('/admin/marketing/campaigns');
            return;
        }

        $metrics = $this->campaignService->getCampaignMetrics($id);

        $this->viewLayout('admin/marketing/campaign_detail', 'admin', [
            'title'     => "Campaña: {$campaign['name']} | Marketing",
            'campaign'  => $campaign,
            'metrics'   => $metrics,
            'templates' => $this->repo->getAllTemplates(),
            'lists'     => $this->repo->getAllLists(),
        ]);
    }

    public function launchCampaign(int $id): void
    {
        $scheduledAt = !empty($_POST['scheduled_at']) ? $_POST['scheduled_at'] : null;
        $result      = $this->campaignService->scheduleCampaign($id, $scheduledAt);

        if ($result['success']) {
            $msg = $result['status'] === 'scheduled'
                ? "Campaña programada para {$scheduledAt}."
                : "Campaña lanzada: {$result['queued']} emails en cola.";
            Session::flash('success', $msg);
        } else {
            Session::flash('error', $result['error'] ?? 'Error al lanzar la campaña.');
        }

        $this->redirect("/admin/marketing/showCampaign/{$id}");
    }

    // =========================================================================
    // LISTAS Y CONTACTOS
    // =========================================================================

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

    // =========================================================================
    // PLANTILLAS
    // =========================================================================

    public function templates(): void
    {
        $this->viewLayout('admin/marketing/templates', 'admin', [
            'title'     => 'Plantillas de Email | Marketing',
            'templates' => $this->repo->getAllTemplates(),
        ]);
    }

    public function createTemplate(): void
    {
        $this->viewLayout('admin/marketing/template_form', 'admin', [
            'title'    => 'Nueva Plantilla | Marketing',
            'template' => null,
        ]);
    }

    public function storeTemplate(): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/admin/marketing/templates');
            return;
        }

        $userId = Auth::user()['id'];
        $data   = [
            'name'         => trim($_POST['name']         ?? ''),
            'subject'      => trim($_POST['subject']      ?? ''),
            'html_body'    => $_POST['html_body']         ?? '',
            'text_body'    => $_POST['text_body']         ?? '',
            'category'     => trim($_POST['category']     ?? ''),
            'preview_text' => trim($_POST['preview_text'] ?? ''),
            'created_by'   => $userId,
        ];

        if (empty($data['name']) || empty($data['html_body'])) {
            Session::flash('error', 'Nombre y contenido HTML son obligatorios.');
            $this->redirect('/admin/marketing/templates/create');
            return;
        }

        $id = $this->repo->createTemplate($data);
        Session::flash('success', 'Plantilla creada correctamente.');
        $this->redirect('/admin/marketing/templates');
    }

    // =========================================================================
    // ANALYTICS
    // =========================================================================

    public function analytics(int $campaignId): void
    {
        $campaign = $this->repo->findCampaign($campaignId);
        if (!$campaign) {
            Session::flash('error', 'Campaña no encontrada.');
            $this->redirect('/admin/marketing/campaigns');
            return;
        }

        $metrics = $this->campaignService->getCampaignMetrics($campaignId);

        // Últimas 200 interacciones individuales para la tabla
        $db   = Database::getInstance()->getConnection();
        $stmt = $db->prepare(
            "SELECT e.event_type, e.occurred_at, e.url_clicked, e.ip_address,
                    c.email, c.first_name, c.last_name
             FROM mktg_events e
             LEFT JOIN mktg_contacts c ON c.id = e.contact_id
             WHERE e.campaign_id = ?
             ORDER BY e.occurred_at DESC
             LIMIT 200"
        );
        $stmt->execute([$campaignId]);
        $interactions = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        $this->viewLayout('admin/marketing/analytics', 'admin', [
            'title'        => "Analytics: {$campaign['name']}",
            'campaign'     => $campaign,
            'metrics'      => $metrics,
            'interactions' => $interactions,
        ]);
    }

    // =========================================================================
    // SETTINGS Y ENTREGABILIDAD
    // =========================================================================

    public function settings(): void
    {
        $domain = $_POST['domain'] ?? \Core\Config::get('business.company_domain', '');
        $selector = $_POST['dkim_selector'] ?? \Core\Config::get('marketing.dkim_selector', 'mail');
        
        $spfResult = null;
        $dkimResult = null;

        if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($domain)) {
            $validator = new DnsValidator();
            $spfResult = $validator->checkSPF($domain);
            $dkimResult = $validator->checkDKIM($domain, $selector);
        }

        $this->viewLayout('admin/marketing/settings', 'admin', [
            'title'      => 'Configuración y Entregabilidad',
            'domain'     => $domain,
            'selector'   => $selector,
            'spfResult'  => $spfResult,
            'dkimResult' => $dkimResult
        ]);
    }

    // =========================================================================
    // NUEVOS MÉTODOS EVOLUTION
    // =========================================================================

    public function generateAiEmail(): void
    {
        $data = json_decode(file_get_contents('php://input'), true) ?? $_POST;
        $brief = trim($data['brief'] ?? '');

        if (empty($brief)) {
            http_response_code(400);
            $this->json(['error' => 'El brief es obligatorio.']);
            return;
        }

        $aiService = new \App\Services\AIService();
        if (!$aiService->isEnabled()) {
            http_response_code(400);
            $this->json(['error' => 'El servicio de IA no está configurado (falta la API Key).']);
            return;
        }

        $variants = $aiService->generateEmailVariants($brief);
        if (is_array($variants) && isset($variants['error'])) {
            http_response_code(500);
            $this->json(['error' => $variants['error']]);
            return;
        }
        if (!$variants) {
            http_response_code(500);
            $this->json(['error' => 'No se pudieron generar variantes de correo.']);
            return;
        }

        $this->json(['success' => true, 'variants' => $variants]);
    }

    public function exportInteractions(int $campaignId): void
    {
        $campaign = $this->repo->findCampaign($campaignId);
        if (!$campaign) {
            Session::flash('error', 'Campaña no encontrada.');
            $this->redirect('/admin/marketing/campaigns');
            return;
        }

        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare(
            "SELECT e.event_type, e.occurred_at, e.url_clicked, e.ip_address, e.user_agent,
                    c.email, c.first_name, c.last_name, c.phone, c.company
             FROM mktg_events e
             LEFT JOIN mktg_contacts c ON c.id = e.contact_id
             WHERE e.campaign_id = ?
             ORDER BY e.occurred_at DESC"
        );
        $stmt->execute([$campaignId]);
        $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="campania_' . $campaignId . '_interacciones.csv"');
        
        $output = fopen('php://output', 'w');
        // BOM UTF-8
        fprintf($output, chr(0xEF).chr(0xBB).chr(0xBF));
        
        fputcsv($output, ['Email', 'Nombre', 'Apellido', 'Teléfono', 'Compañía', 'Tipo de Evento', 'Fecha', 'URL Clickeada', 'IP (Hash)', 'User Agent']);
        
        foreach ($rows as $row) {
            fputcsv($output, [
                $row['email'],
                $row['first_name'],
                $row['last_name'],
                $row['phone'],
                $row['company'],
                translateStatus($row['event_type']),
                $row['occurred_at'],
                $row['url_clicked'] ?? '',
                $row['ip_address'] ?? '',
                $row['user_agent'] ?? ''
            ]);
        }
        fclose($output);
        exit;
    }

    public function pauseCampaign(int $campaignId): void
    {
        $this->repo->updateCampaignStatus($campaignId, 'paused');
        Session::flash('success', 'Campaña pausada correctamente.');
        $this->redirect("/admin/marketing/showCampaign/{$campaignId}");
    }

    public function editTemplate(int $id): void
    {
        $template = $this->repo->findTemplate($id);
        if (!$template) {
            Session::flash('error', 'Plantilla no encontrada.');
            $this->redirect('/admin/marketing/templates');
            return;
        }

        $this->viewLayout('admin/marketing/template_form', 'admin', [
            'title'    => 'Editar Plantilla | Marketing',
            'template' => $template,
        ]);
    }

    public function updateTemplate(int $id): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/admin/marketing/templates');
            return;
        }

        $data = [
            'name'         => trim($_POST['name']         ?? ''),
            'subject'      => trim($_POST['subject']      ?? ''),
            'html_body'    => $_POST['html_body']         ?? '',
            'text_body'    => $_POST['text_body']         ?? '',
            'category'     => trim($_POST['category']     ?? ''),
            'preview_text' => trim($_POST['preview_text'] ?? ''),
        ];

        if (empty($data['name']) || empty($data['html_body'])) {
            Session::flash('error', 'Nombre y contenido HTML son obligatorios.');
            $this->redirect("/admin/marketing/editTemplate/{$id}");
            return;
        }

        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $stmt = $db->prepare(
            "UPDATE mktg_templates 
             SET name = ?, subject = ?, html_body = ?, text_body = ?, category = ?, preview_text = ?
             WHERE id = ? AND tenant_id = ?"
        );
        $stmt->execute([
            $data['name'],
            $data['subject'],
            $data['html_body'],
            $data['text_body'],
            $data['category'],
            $data['preview_text'],
            $id,
            $tenantId
        ]);

        Session::flash('success', 'Plantilla actualizada correctamente.');
        $this->redirect('/admin/marketing/templates');
    }

    public function improveText(): void
    {
        $data = json_decode(file_get_contents('php://input'), true) ?? [];
        $text = trim($data['text'] ?? '');
        if (empty($text)) {
            $this->json(['error' => 'Texto vacío.']);
            return;
        }
        $ai = new \App\Services\AIService();
        if (!$ai->isEnabled()) {
            $this->json(['error' => 'La API Key de la IA no está configurada en el archivo .env.']);
            return;
        }
        $improved = $ai->improveEmailText($text);
        if (is_array($improved) && isset($improved['error'])) {
            $this->json(['error' => $improved['error']]);
            return;
        }
        if (!$improved) {
            $this->json(['error' => 'No se pudo mejorar el texto.']);
            return;
        }
        $this->json(['improved' => $improved]);
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

        $data = [
            'list_id'    => $listId,
            'email'      => $email,
            'first_name' => trim($_POST['first_name'] ?? ''),
            'last_name'  => trim($_POST['last_name'] ?? ''),
            'phone'      => trim($_POST['phone'] ?? ''),
            'company'    => trim($_POST['company'] ?? ''),
            'country'    => trim($_POST['country'] ?? ''),
            'industry'   => trim($_POST['industry'] ?? ''),
            'tags'       => $tagsInput ?: null,
            'status'     => 'subscribed',
            'source'     => 'manual',
        ];

        $this->repo->createContact($data);
        Session::flash('success', 'Contacto agregado correctamente.');
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

    public function deleteCampaign(int $id): void
    {
        $campaign = $this->repo->findCampaign($id);
        if (!$campaign) {
            Session::flash('error', 'Campaña no encontrada.');
            $this->redirect('/admin/marketing/campaigns');
            return;
        }

        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $stmt = $db->prepare("UPDATE mktg_campaigns SET deleted_at = NOW() WHERE id = ? AND tenant_id = ?");
        $stmt->execute([$id, $tenantId]);

        Session::flash('success', 'Campaña eliminada correctamente.');
        $this->redirect('/admin/marketing/campaigns');
    }

    public function duplicateCampaign(int $id): void
    {
        $campaign = $this->repo->findCampaign($id);
        if (!$campaign) {
            Session::flash('error', 'Campaña no encontrada.');
            $this->redirect('/admin/marketing/campaigns');
            return;
        }

        $userId = Auth::user()['id'];
        $data = [
            'name'            => $campaign['name'] . ' (Copia)',
            'subject'         => $campaign['subject'],
            'preview_text'    => $campaign['preview_text'],
            'from_name'       => $campaign['from_name'],
            'from_email'      => $campaign['from_email'],
            'reply_to'        => $campaign['reply_to'],
            'template_id'     => $campaign['template_id'],
            'list_id'         => $campaign['list_id'],
            'type'            => $campaign['type'],
            'segment_filters' => !empty($campaign['segment_filters']) ? json_decode($campaign['segment_filters'], true) : null,
            'scheduled_at'    => null,
            'created_by'      => $userId,
        ];

        $newId = $this->campaignService->createCampaign($data, $userId);
        Session::flash('success', 'Campaña duplicada correctamente como borrador.');
        $this->redirect("/admin/marketing/showCampaign/{$newId}");
    }

    public function updateCampaign(int $id): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect("/admin/marketing/showCampaign/{$id}");
            return;
        }

        $campaign = $this->repo->findCampaign($id);
        if (!$campaign) {
            Session::flash('error', 'Campaña no encontrada.');
            $this->redirect('/admin/marketing/campaigns');
            return;
        }

        $segmentFilters = [];
        if (!empty($_POST['segment_country'])) {
            $segmentFilters['country'] = trim($_POST['segment_country']);
        }
        if (!empty($_POST['segment_industry'])) {
            $segmentFilters['industry'] = trim($_POST['segment_industry']);
        }
        if (!empty($_POST['segment_tags'])) {
            $segmentFilters['tags'] = trim($_POST['segment_tags']);
        }

        $data = [
            'name'            => trim($_POST['name']         ?? ''),
            'subject'         => trim($_POST['subject']      ?? ''),
            'preview_text'    => trim($_POST['preview_text'] ?? ''),
            'from_name'       => trim($_POST['from_name']    ?? ''),
            'from_email'      => trim($_POST['from_email']   ?? ''),
            'reply_to'        => trim($_POST['reply_to']     ?? ''),
            'template_id'     => !empty($_POST['template_id']) ? (int)$_POST['template_id'] : null,
            'list_id'         => !empty($_POST['list_id'])     ? (int)$_POST['list_id']     : null,
            'type'            => $_POST['type']               ?? 'one_time',
            'scheduled_at'    => !empty($_POST['scheduled_at']) ? $_POST['scheduled_at'] : null,
            'segment_filters' => !empty($segmentFilters) ? $segmentFilters : null,
        ];

        if (empty($data['name']) || empty($data['subject'])) {
            Session::flash('error', 'Nombre y asunto son obligatorios.');
            $this->redirect("/admin/marketing/showCampaign/{$id}");
            return;
        }

        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $stmt = $db->prepare(
            "UPDATE mktg_campaigns 
              SET name = ?, subject = ?, preview_text = ?, from_name = ?, from_email = ?, reply_to = ?, 
                  template_id = ?, list_id = ?, type = ?, scheduled_at = ?, segment_filters = ?
              WHERE id = ? AND tenant_id = ?"
        );
        $stmt->execute([
            $data['name'],
            $data['subject'],
            $data['preview_text'],
            $data['from_name'],
            $data['from_email'],
            $data['reply_to'],
            $data['template_id'],
            $data['list_id'],
            $data['type'],
            $data['scheduled_at'],
            !empty($data['segment_filters']) ? json_encode($data['segment_filters']) : null,
            $id,
            $tenantId
        ]);

        Session::flash('success', 'Campaña actualizada correctamente.');
        $this->redirect("/admin/marketing/showCampaign/{$id}");
    }
}
