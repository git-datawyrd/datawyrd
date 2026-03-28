<?php
namespace App\Controllers;

use Core\Controller;
use Core\Auth;
use Core\Session;
use App\Services\ProjectService;

class ProjectController extends Controller
{
    private ProjectService $projectService;

    public function __construct(ProjectService $projectService)
    {
        if (!Auth::check()) {
            $this->redirect('/auth/login');
        }
        $this->projectService = $projectService;
    }

    public function workspace()
    {
        $data = $this->projectService->getWorkspaceData(Auth::user());

        if (Auth::isClient()) {
            $this->viewLayout('client/project/workspace', 'client', [
                'title' => 'Mi Workspace de Proyecto | Data Wyrd',
                'services' => $data['services'] ?? [],
                'deliverables' => $data['deliverables'] ?? []
            ]);
        } else {
            $this->viewLayout(Auth::role() . '/project/manage', Auth::role(), [
                'title' => 'Gestión de Workspaces | Data Wyrd',
                'services' => $data['services'] ?? []
            ]);
        }
    }

    public function manage($id)
    {
        if (Auth::isClient())
            $this->redirect('/project/workspace');

        $data = $this->projectService->getDeliverableDetails((int)$id);
        if (!$data)
            $this->redirect('/project/workspace');

        $this->viewLayout(Auth::role() . '/project/detail', Auth::role(), [
            'title' => 'Workspace: ' . $data['service']['name'],
            'service' => $data['service'],
            'deliverables' => $data['deliverables']
        ]);
    }

    public function upload()
    {
        if (Auth::isClient() || $_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/project/workspace');
        }

        $service_id = (int)$_POST['active_service_id'];
        
        try {
            $this->projectService->handleUpload(
                $service_id, 
                $_FILES['deliverable'], 
                [
                    'title'       => $_POST['title'],
                    'description' => $_POST['description'],
                    'version'     => $_POST['version'] ?? '1.0',
                    'type'        => $_POST['file_type'] ?? 'other'
                ],
                Auth::user()['id']
            );
            Session::flash('success', 'Entregable subido correctamente.');
        } catch (\Exception $e) {
            Session::flash('error', $e->getMessage());
        }

        $this->redirect('/project/manage/' . $service_id);
    }

    public function download($id)
    {
        try {
            $fileData = $this->projectService->processDownload((int)$id, Auth::user());
            
            // Limpiar cualquier output buffer previo
            if (ob_get_level()) {
                ob_end_clean();
            }

            header('Content-Type: ' . $fileData['mime']);
            header('Content-Disposition: attachment; filename="' . rawurlencode($fileData['name']) . '"');
            header('Content-Length: ' . filesize($fileData['path']));
            header('Cache-Control: no-store, no-cache, must-revalidate');
            header('Pragma: no-cache');
            header('Expires: 0');
            readfile($fileData['path']);
            exit;

        } catch (\Exception $e) {
            Session::flash('error', $e->getMessage());
            $this->redirect('/project/workspace');
        }
    }

    public function delete($id)
    {
        if (Auth::isClient())
            $this->redirect('/project/workspace');

        if ($this->projectService->deleteDeliverable((int)$id)) {
            Session::flash('success', 'Entregable eliminado.');
        } else {
            Session::flash('error', 'Error al eliminar el entregable.');
        }

        $this->redirect('/project/workspace');
    }

    public function updateScope()
    {
        if (Auth::isClient() || $_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/project/workspace');
        }

        $service_id = (int)$_POST['active_service_id'];
        $total = (int) $_POST['total_deliverables'];

        if ($this->projectService->updateScope($service_id, $total)) {
            \Core\SecurityLogger::log('project_scope_updated', [
                'service_id' => $service_id,
                'total_deliverables' => $total
            ]);
            Session::flash('success', 'Alcance del proyecto actualizado correctamente.');
        }

        $this->redirect('/project/manage/' . $service_id);
    }
}
