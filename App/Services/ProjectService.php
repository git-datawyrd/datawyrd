<?php
namespace App\Services;

use App\Repositories\ProjectRepository;
use Core\Auth;
use Core\Validator;
use Core\Config;
use Exception;

class ProjectService
{
    private ProjectRepository $projectRepo;

    public function __construct(ProjectRepository $projectRepo)
    {
        $this->projectRepo = $projectRepo;
    }

    public function getWorkspaceData(array $user)
    {
        if (Auth::isClient()) {
            $services = $this->projectRepo->getActiveServices($user['id']);
            $deliverables = [];

            foreach ($services as &$s) {
                $s['progress_percent'] = ($s['total_deliverables'] > 0)
                    ? round(($s['current_deliverables'] / $s['total_deliverables']) * 100)
                    : 0;

                // Handle default values
                $s['invoice_total'] = $s['invoice_total'] ?? 0;
                $s['invoice_paid'] = $s['invoice_paid'] ?? 0;
                $s['invoice_status'] = $s['invoice_status'] ?? 'draft';

                $deliverables[$s['id']] = $this->projectRepo->getDeliverables($s['id']);
            }

            return ['services' => $services, 'deliverables' => $deliverables];
        } else {
            $services = $this->projectRepo->getActiveServices();
            foreach ($services as &$s) {
                $s['invoice_total'] = $s['invoice_total'] ?? 0;
                $s['invoice_paid'] = $s['invoice_paid'] ?? 0;
                $s['invoice_status'] = $s['invoice_status'] ?? 'draft';
            }
            return ['services' => $services];
        }
    }

    public function getDeliverableDetails(int $id)
    {
        $service = $this->projectRepo->findServiceById($id);
        if (!$service) return null;

        $deliverables = $this->projectRepo->getDeliverables($id);

        return [
            'service' => $service,
            'deliverables' => $deliverables
        ];
    }

    public function handleUpload(int $serviceId, array $file, array $meta, int $userId)
    {
        $maxSize = Config::get('limits.max_upload_size');
        $errors = Validator::validateFile($file, $maxSize, ['pdf', 'zip', 'doc', 'docx', 'xls', 'xlsx', 'jpg', 'png']);
        
        if (!empty($errors)) {
            throw new Exception(implode(' ', $errors));
        }

        $secureFilename = Validator::generateSecureFileName($file['name']);
        $targetDir = BASE_PATH . DIRECTORY_SEPARATOR . 'public' . DIRECTORY_SEPARATOR . 'storage' . DIRECTORY_SEPARATOR . 'projects' . DIRECTORY_SEPARATOR . $serviceId;

        if (!is_dir($targetDir)) {
            mkdir($targetDir, 0755, true);
        }

        $targetPath = $targetDir . DIRECTORY_SEPARATOR . $secureFilename;
        $dbFilepath = '/storage/projects/' . $serviceId . '/' . $secureFilename;

        if (!move_uploaded_file($file['tmp_name'], $targetPath)) {
            throw new Exception('Error al mover el archivo al servidor.');
        }

        return $this->projectRepo->createDeliverable([
            'active_service_id' => $serviceId,
            'uploaded_by' => $userId,
            'title' => $meta['title'],
            'description' => $meta['description'],
            'filename' => $file['name'],
            'filepath' => $dbFilepath,
            'file_type' => $meta['type'] ?? 'other',
            'file_size' => $file['size'],
            'version' => $meta['version'] ?? '1.0'
        ]);
    }

    public function processDownload(int $id, array $user)
    {
        $file = $this->projectRepo->getDeliverableById($id);
        if (!$file) throw new Exception('Archivo no encontrado.');

        if (Auth::isClient() && $file['client_id'] != $user['id']) {
            throw new Exception('Sin permisos para este archivo.');
        }

        $relativePath = ltrim(str_replace('/', DIRECTORY_SEPARATOR, $file['filepath']), DIRECTORY_SEPARATOR);
        $physicalPath = BASE_PATH . DIRECTORY_SEPARATOR . 'public' . DIRECTORY_SEPARATOR . $relativePath;

        if (!file_exists($physicalPath)) {
            throw new Exception('El archivo físico no existe en el servidor.');
        }

        return [
            'path' => $physicalPath,
            'mime' => mime_content_type($physicalPath) ?: 'application/octet-stream',
            'name' => $file['filename'] ?: basename($file['filepath'])
        ];
    }

    public function deleteDeliverable(int $id)
    {
        $file = $this->projectRepo->getDeliverableById($id);
        if ($file) {
            $physicalPath = BASE_PATH . DIRECTORY_SEPARATOR . 'public' . DIRECTORY_SEPARATOR . ltrim(str_replace('/', DIRECTORY_SEPARATOR, $file['filepath']), DIRECTORY_SEPARATOR);
            if (file_exists($physicalPath)) {
                unlink($physicalPath);
            }
            return $this->projectRepo->deleteDeliverable($id);
        }
        return false;
    }

    public function updateScope(int $serviceId, int $total)
    {
        return $this->projectRepo->updateServiceDeliverablesCount($serviceId, $total);
    }
}
