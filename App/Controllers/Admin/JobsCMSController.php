<?php
namespace App\Controllers\Admin;

use Core\Controller;
use Core\View;
use Core\Session;
use Core\Validator;
use App\Models\JobApplication;
use App\Models\Candidate;

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

        $this->viewLayout('admin/jobs/index', 'admin', [
            'title' => 'Gestión de Postulantes',
            'applications' => $applications
        ]);
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

        // Fetch logs and Candidate history
        $logs = $model->getStatusLogs($id);
        $history = $model->getCandidateHistory($application['candidate_id']);

        $this->viewLayout('admin/jobs/view', 'admin', [
            'title' => 'Detalle de Postulación',
            'jobApp' => $application,
            'statusLogs' => $logs,
            'candidateHistory' => $history
        ]);
    }

    public function updateApplication($id)
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/admin/jobs/show/' . $id);
        }

        $status = Validator::sanitizeString($_POST['status'] ?? '');
        $vacancyName = Validator::sanitizeString($_POST['vacancy_name'] ?? '');

        $model = new JobApplication();
        $model->updateStatus($id, $status);
        $model->updateVacancy($id, $vacancyName);

        Session::flash('success', 'Postulación actualizada correctamente.');
        $this->redirect('/admin/jobs/show/' . $id);
    }

    public function updateProfile($candidateId)
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/admin/jobs');
        }

        // To redirect back to the correct view we need the job application ID.
        // The form stays on the application view, so let's redirect back.
        // Since we don't have the $app ID directly, we could pass it or rely on history.
        // Assuming we look up the latest application for this candidate to bounce back:
        $appModel = new JobApplication();
        $app = $appModel->findByCandidateId($candidateId);
        $redirectUrl = '/admin/jobs';
        if (!empty($app)) {
            $redirectUrl = '/admin/jobs/show/' . $app[0]['id'];
        }

        $data = [
            'country' => Validator::sanitizeString($_POST['country'] ?? ''),
            'city' => Validator::sanitizeString($_POST['city'] ?? ''),
            'address' => Validator::sanitizeString($_POST['address'] ?? '')
        ];

        $candidateModel = new Candidate();
        if ($candidateModel->updateProfile($candidateId, $data)) {
            Session::flash('success', 'Perfil del candidato actualizado.');
        } else {
            Session::flash('error', 'No se pudo actualizar el perfil.');
        }

        $this->redirect($redirectUrl);
    }

    public function export()
    {
        $model = new JobApplication();
        $applications = $model->findAll();

        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename=candidatos_' . date('Ymd_His') . '.csv');

        $output = fopen('php://output', 'w');
        fputcsv($output, ['ID', 'Nombre', 'Apellido', 'Email', 'Telefono', 'LinkedIn', 'País', 'Ciudad', 'Vacante', 'Estado', 'Fecha Registro']);

        foreach ($applications as $app) {
            fputcsv($output, [
                $app['id'],
                $app['first_name'],
                $app['last_name'],
                $app['email'],
                $app['phone'],
                $app['linkedin_url'],
                $app['country'] ?? '',
                $app['city'] ?? '',
                $app['vacancy_name'],
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
