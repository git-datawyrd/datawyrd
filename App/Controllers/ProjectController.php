<?php
namespace App\Controllers;

use Core\Controller;
use Core\Database;
use Core\Auth;
use Core\Session;
use PDO;

class ProjectController extends Controller
{
    public function __construct()
    {
        if (!Auth::check()) {
            $this->redirect('/auth/login');
        }
    }

    public function workspace()
    {
        $db = Database::getInstance()->getConnection();
        $user = Auth::user();

        if (Auth::isClient()) {
            // Client sees their active services and deliverables (PRD v1.0 - Progress logic)
            $stmt = $db->prepare("SELECT s.*, p.name as plan_name,
                                 i.total as invoice_total,
                                 i.paid_amount as invoice_paid,
                                 (i.total - i.paid_amount) as invoice_pending,
                                 i.status as invoice_status,
                                 i.id as invoice_id_ref,
                                 (SELECT COUNT(*) FROM project_deliverables pd WHERE pd.active_service_id = s.id) as current_deliverables
                                 FROM active_services s 
                                 JOIN service_plans p ON s.service_plan_id = p.id 
                                 LEFT JOIN invoices i ON s.invoice_id = i.id
                                 WHERE s.client_id = ? AND s.status = 'active'");
            $stmt->execute([$user['id']]);
            $services = $stmt->fetchAll();

            // Calculate progress
            foreach ($services as &$s) {
                $s['progress_percent'] = ($s['total_deliverables'] > 0)
                    ? round(($s['current_deliverables'] / $s['total_deliverables']) * 100)
                    : 0;
                // Handle null invoice values
                if (!isset($s['invoice_total'])) {
                    $s['invoice_total'] = 0;
                    $s['invoice_paid'] = 0;
                    $s['invoice_pending'] = 0;
                    $s['invoice_status'] = 'draft';
                    $s['invoice_id_ref'] = 0;
                }
            }

            // Fetch deliverables for these services
            $deliverables = [];
            foreach ($services as $service) {
                $stmt = $db->prepare("SELECT * FROM project_deliverables WHERE active_service_id = ? ORDER BY created_at DESC");
                $stmt->execute([$service['id']]);
                $deliverables[$service['id']] = $stmt->fetchAll();
            }

            $this->viewLayout('client/project/workspace', 'client', [
                'title' => 'Mi Workspace de Proyecto | Data Wyrd',
                'services' => $services,
                'deliverables' => $deliverables
            ]);
        } else {
            // Staff/Admin see all active services to manage
            $stmt = $db->query("SELECT s.*, u.name as client_name, p.name as plan_name,
                               i.total as invoice_total,
                               i.paid_amount as invoice_paid,
                               (i.total - i.paid_amount) as invoice_pending,
                               i.status as invoice_status,
                               i.id as invoice_id_ref
                               FROM active_services s 
                               JOIN users u ON s.client_id = u.id 
                               JOIN service_plans p ON s.service_plan_id = p.id
                               LEFT JOIN invoices i ON s.invoice_id = i.id
                               ORDER BY s.created_at DESC");
            $services = $stmt->fetchAll();

            // Handle null invoice values for admin too
            foreach ($services as &$s) {
                if (!isset($s['invoice_total'])) {
                    $s['invoice_total'] = 0;
                    $s['invoice_paid'] = 0;
                    $s['invoice_pending'] = 0;
                    $s['invoice_status'] = 'draft';
                    $s['invoice_id_ref'] = 0;
                }
            }

            $this->viewLayout(Auth::role() . '/project/manage', Auth::role(), [
                'title' => 'Gestión de Workspaces | Data Wyrd',
                'services' => $services
            ]);
        }
    }

    /**
     * Manage a specific service workspace (Staff/Admin)
     */
    public function manage($id)
    {
        if (Auth::isClient())
            $this->redirect('/project/workspace');

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare("SELECT s.*, u.name as client_name, p.name as plan_name 
                             FROM active_services s 
                             JOIN users u ON s.client_id = u.id 
                             JOIN service_plans p ON s.service_plan_id = p.id 
                             WHERE s.id = ?");
        $stmt->execute([$id]);
        $service = $stmt->fetch();

        if (!$service)
            $this->redirect('/project/workspace');

        $stmt = $db->prepare("SELECT d.*, u.name as author_name 
                             FROM project_deliverables d 
                             JOIN users u ON d.uploaded_by = u.id 
                             WHERE d.active_service_id = ? ORDER BY d.created_at DESC");
        $stmt->execute([$id]);
        $deliverables = $stmt->fetchAll();

        $this->viewLayout(Auth::role() . '/project/detail', Auth::role(), [
            'title' => 'Workspace: ' . $service['name'],
            'service' => $service,
            'deliverables' => $deliverables
        ]);
    }

    /**
     * Upload Deliverable
     */
    public function upload()
    {
        if (Auth::isClient() || $_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/project/workspace');
        }

        $service_id = $_POST['active_service_id'];
        $title = $_POST['title'];
        $description = $_POST['description'];
        $version = $_POST['version'] ?? '1.0';
        $type = $_POST['file_type'] ?? 'other';

        if (isset($_FILES['deliverable']) && $_FILES['deliverable']['error'] === UPLOAD_ERR_OK) {
            $file = $_FILES['deliverable'];

            // Hardened validation
            $maxSize = \Core\Config::get('limits.max_upload_size');
            $errors = \Core\Validator::validateFile($file, $maxSize, ['pdf', 'zip', 'zipx', 'doc', 'docx', 'xls', 'xlsx', 'jpg', 'jpeg', 'png']);

            if (!empty($errors)) {
                Session::flash('error', implode(' ', $errors));
                $this->redirect('/project/manage/' . $service_id);
                return;
            }

            $secureFilename = \Core\Validator::generateSecureFileName($file['name']);

            // Usar BASE_PATH para ruta absoluta — evita ambiguedad de CWD según entorno
            $targetDir = BASE_PATH . DIRECTORY_SEPARATOR . 'public' . DIRECTORY_SEPARATOR
                . 'storage' . DIRECTORY_SEPARATOR . 'projects' . DIRECTORY_SEPARATOR . $service_id;

            if (!is_dir($targetDir)) {
                mkdir($targetDir, 0755, true);
            }

            $targetPath = $targetDir . DIRECTORY_SEPARATOR . $secureFilename;

            // filepath relativo a public/ — consistente entre upload y download
            $dbFilepath = '/storage/projects/' . $service_id . '/' . $secureFilename;

            if (move_uploaded_file($file['tmp_name'], $targetPath)) {
                $db = Database::getInstance()->getConnection();
                $sql = "INSERT INTO project_deliverables (active_service_id, uploaded_by, title, description, filename, filepath, file_type, file_size, version) 
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                $stmt = $db->prepare($sql);
                $stmt->execute([
                    $service_id,
                    Auth::user()['id'],
                    $title,
                    $description,
                    $file['name'],
                    $dbFilepath,
                    $type,
                    $file['size'],
                    $version
                ]);

                Session::flash('success', 'Entregable subido correctamente.');
            } else {
                Session::flash('error', 'Error al mover el archivo al servidor. Verifica permisos del directorio storage.');
            }
        }

        $this->redirect('/project/manage/' . $service_id);
    }

    /**
     * Secure File Download
     * Verifies access and serves the file with correct HTTP headers.
     */
    public function download($id)
    {
        if (!Auth::check()) {
            $this->redirect('/auth/login');
        }

        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare("SELECT d.*, s.client_id FROM project_deliverables d 
                              JOIN active_services s ON d.active_service_id = s.id 
                              WHERE d.id = ?");
        $stmt->execute([$id]);
        $file = $stmt->fetch();

        if (!$file) {
            Session::flash('error', 'Archivo no encontrado.');
            $this->redirect('/project/workspace');
        }

        // Security: clients can only download files from their own services
        if (Auth::isClient() && $file['client_id'] != Auth::user()['id']) {
            Session::flash('error', 'No tienes permiso para descargar este archivo.');
            $this->redirect('/project/workspace');
        }

        // Build physical path usando DIRECTORY_SEPARATOR para compatibilidad Win/Linux
        $relativePath = ltrim(str_replace('/', DIRECTORY_SEPARATOR, $file['filepath']), DIRECTORY_SEPARATOR);
        $physicalPath = BASE_PATH . DIRECTORY_SEPARATOR . 'public' . DIRECTORY_SEPARATOR . $relativePath;

        if (!file_exists($physicalPath)) {
            // Log para depuración
            error_log('[DataWyrd] Download 404 - filepath en BD: ' . $file['filepath']);
            error_log('[DataWyrd] Download 404 - ruta física buscada: ' . $physicalPath);
            Session::flash('error', 'El archivo no se encontró en el servidor. Por favor, contacta al equipo indicando el error: archivo no disponible.');
            $this->redirect('/project/workspace');
        }

        // Servir el archivo con headers correctos
        $mimeType = mime_content_type($physicalPath) ?: 'application/octet-stream';
        $originalName = $file['filename'] ?: basename($file['filepath']);

        // Limpiar cualquier output buffer previo
        if (ob_get_level()) {
            ob_end_clean();
        }

        header('Content-Type: ' . $mimeType);
        header('Content-Disposition: attachment; filename="' . rawurlencode($originalName) . '"');
        header('Content-Length: ' . filesize($physicalPath));
        header('Cache-Control: no-store, no-cache, must-revalidate');
        header('Pragma: no-cache');
        header('Expires: 0');
        readfile($physicalPath);
        exit;
    }

    /**
     * Delete Deliverable
     */
    public function delete($id)
    {
        if (Auth::isClient())
            $this->redirect('/project/workspace');

        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare("SELECT * FROM project_deliverables WHERE id = ?");
        $stmt->execute([$id]);
        $file = $stmt->fetch();

        if ($file) {
            $fullPath = 'public' . $file['filepath'];
            if (file_exists($fullPath)) {
                unlink($fullPath);
            }
            $stmt = $db->prepare("DELETE FROM project_deliverables WHERE id = ?");
            $stmt->execute([$id]);
            Session::flash('success', 'Entregable eliminado.');
            $this->redirect('/project/manage/' . $file['active_service_id']);
        }

        $this->redirect('/project/workspace');
    }

    /**
     * Update Project Scope (PRD v1.0)
     */
    public function updateScope()
    {
        if (Auth::isClient() || $_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/project/workspace');
        }

        $service_id = $_POST['active_service_id'];
        $total = (int) $_POST['total_deliverables'];

        if ($service_id) {
            $db = Database::getInstance()->getConnection();
            $stmt = $db->prepare("UPDATE active_services SET total_deliverables = ? WHERE id = ?");
            $stmt->execute([$total, $service_id]);

            \Core\SecurityLogger::log('project_scope_updated', [
                'service_id' => $service_id,
                'total_deliverables' => $total
            ]);

            Session::flash('success', 'Alcance del proyecto actualizado correctamente.');
            $this->redirect('/project/manage/' . $service_id);
        }

        $this->redirect('/project/workspace');
    }
}
