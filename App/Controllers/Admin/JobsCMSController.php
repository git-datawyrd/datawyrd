<?php
namespace App\Controllers\Admin;

use Core\Controller;
use Core\View;
use Core\Session;
use App\Models\JobApplication;

class JobsCMSController extends Controller
{
    public function getMiddlewares(): array
    {
        return [
            ['name' => 'auth', 'params' => [], 'only' => [], 'except' => []],
            ['name' => 'role', 'params' => ['admin'], 'only' => [], 'except' => []]
        ];
    }

    public function index()
    {
        $model = new JobApplication();
        $applications = $model->findAll();

        View::render('admin/jobs/index', [
            'title' => 'Gestión de Postulantes',
            'applications' => $applications
        ], 'layouts/admin');
    }

    public function show($id)
    {
        $model = new JobApplication();
        $application = $model->findById($id);

        if (!$application) {
            Session::flash('error', 'Postulación no encontrada.');
            $this->redirect('/admin/jobs');
        }
        
        // Mark as reviewed automatically
        if ($application['status'] === 'new') {
            $model->updateStatus($id, 'reviewed');
            $application['status'] = 'reviewed';
        }

        View::render('admin/jobs/view', [
            'title' => 'Detalle de Postulación',
            'application' => $application
        ], 'layouts/admin');
    }

    public function export()
    {
        $model = new JobApplication();
        $applications = $model->findAll();

        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename=candidatos_' . date('Ymd_His') . '.csv');

        $output = fopen('php://output', 'w');
        fputcsv($output, ['ID', 'Nombre', 'Apellido', 'Email', 'Telefono', 'LinkedIn', 'Estado', 'Fecha Registro']);

        foreach ($applications as $app) {
            fputcsv($output, [
                $app['id'],
                $app['first_name'],
                $app['last_name'],
                $app['email'],
                $app['phone'],
                $app['linkedin_url'],
                $app['status'],
                $app['created_at']
            ]);
        }
        fclose($output);
        exit;
    }

    public function downloadCv($id)
    {
        $model = new JobApplication();
        $application = $model->findById($id);

        if (!$application || empty($application['cv_path'])) {
            Session::flash('error', 'Archivo no encontrado.');
            $this->redirect('/admin/jobs');
        }

        $filePath = BASE_PATH . '/storage/cvs/' . $application['cv_path'];

        if (!file_exists($filePath)) {
            Session::flash('error', 'El archivo fue movido o eliminado físicamente.');
            $this->redirect('/admin/jobs');
        }

        $mimeType = mime_content_type($filePath);
        header('Content-Type: ' . $mimeType);
        header('Content-Disposition: attachment; filename="CV_' . $application['first_name'] . '_' . $application['last_name'] . '.' . pathinfo($filePath, PATHINFO_EXTENSION) . '"');
        header('Content-Length: ' . filesize($filePath));
        readfile($filePath);
        exit;
    }
}
