<?php
namespace App\Controllers;

use Core\Controller;
use Core\View;
use Core\Validator;
use Core\Session;
use Core\Config;
use App\Models\JobApplication;
use App\Models\Candidate;

class JobsController extends Controller
{
    /**
     * Show jobs form
     */
    public function index()
    {
        $this->viewLayout('public/jobs/index', 'public', [
            'title' => 'Carreras y Postulaciones | ' . Config::get('business.company_name')
        ]);
    }

    /**
     * Redirect home with thanks message for recurring candidate who didn't want to update
     */
    public function alreadyRegistered()
    {
        Session::flash('success', '¡Hola! Ya tenemos tus datos en nuestro sistema. Agradecemos tu interés en Data Wyrd.');
        $this->redirect('/');
    }

    /**
     * AJAX: Verifica si un email ya existe en candidates
     * Retorna JSON: { exists: bool, name: string|null, candidateId: int|null }
     */
    public function checkEmail()
    {
        header('Content-Type: application/json');

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            echo json_encode(['error' => 'Método no permitido']);
            exit;
        }

        $email = Validator::sanitizeEmail($_POST['email'] ?? '');
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            echo json_encode(['exists' => false]);
            exit;
        }

        $candidateModel = new Candidate();
        $existing = $candidateModel->findByEmail($email);

        if ($existing) {
            echo json_encode([
                'exists' => true,
                'name' => htmlspecialchars($existing['first_name']),
                'candidateId' => (int)$existing['id']
            ]);
        }
        else {
            echo json_encode(['exists' => false]);
        }
        exit;
    }

    /**
     * Genera y envía un OTP al email del candidato existente
     */
    public function requestUpdateCode()
    {
        header('Content-Type: application/json');

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            echo json_encode(['success' => false, 'message' => 'Método no permitido']);
            exit;
        }

        $candidateId = (int)($_POST['candidate_id'] ?? 0);
        if (!$candidateId) {
            echo json_encode(['success' => false, 'message' => 'Datos inválidos']);
            exit;
        }

        $candidateModel = new Candidate();
        $candidate = $candidateModel->findById($candidateId);

        if (!$candidate) {
            echo json_encode(['success' => false, 'message' => 'Candidato no encontrado']);
            exit;
        }

        $token = $candidateModel->createUpdateToken($candidateId);

        // Enviar email con el código
        try {
            $subject = "Código de verificación para actualizar tus datos | Data Wyrd";
            $body = "
                <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9; border-radius: 8px;'>
                    <h2 style='color: #1a1e3b;'>¡Hola, {$candidate['first_name']}!</h2>
                    <p style='color: #555; line-height: 1.6;'>
                        Recibimos una solicitud para actualizar tus datos en nuestro sistema de candidatos.
                    </p>
                    <p style='color: #555;'>Tu código de verificación es:</p>
                    <div style='background: #1a1e3b; color: #D4AF37; font-size: 36px; font-weight: bold; letter-spacing: 12px; text-align: center; padding: 20px; border-radius: 8px; margin: 20px 0;'>
                        {$token}
                    </div>
                    <p style='color: #999; font-size: 13px;'>Este código expira en <strong>15 minutos</strong>. Si no solicitaste este cambio, puedes ignorar este mensaje.</p>
                    <hr style='border: none; border-top: 1px solid #ddd; margin: 30px 0;'>
                    <p style='color: #999; font-size: 12px; text-align: center;'>
                        © " . date('Y') . " Data Wyrd. Transformamos complejidad en claridad estratégica.
                    </p>
                </div>
            ";

            if (class_exists('\Core\Mail')) {
                \Core\Mail::send($candidate['email'], $subject, $body);
            }

            echo json_encode(['success' => true]);
        }
        catch (\Exception $e) {
            error_log('Error enviando OTP RRHH: ' . $e->getMessage());
            echo json_encode(['success' => false, 'message' => 'Error al enviar el código. Intenta de nuevo.']);
        }
        exit;
    }

    /**
     * AJAX: Verifica el OTP ingresado por el candidato
     */
    public function verifyUpdateCode()
    {
        header('Content-Type: application/json');

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            echo json_encode(['success' => false]);
            exit;
        }

        $candidateId = (int)($_POST['candidate_id'] ?? 0);
        $token = trim($_POST['token'] ?? '');

        if (!$candidateId || !$token) {
            echo json_encode(['success' => false, 'message' => 'Datos incompletos']);
            exit;
        }

        $candidateModel = new Candidate();
        $valid = $candidateModel->verifyUpdateToken($candidateId, $token);

        if ($valid) {
            // Guardar en sesión que este candidato está verificado para editar
            Session::set('candidate_verified_id', $candidateId);
            echo json_encode(['success' => true]);
        }
        else {
            echo json_encode(['success' => false, 'message' => 'Código incorrecto o expirado. Solicita uno nuevo.']);
        }
        exit;
    }

    /**
     * AJAX: Retorna los datos completos de un candidato verificado por OTP
     */
    public function getCandidateData()
    {
        header('Content-Type: application/json');

        $verifiedId = Session::get('candidate_verified_id');
        $idRequest = (int)($_GET['candidate_id'] ?? 0);

        if (!$verifiedId || $verifiedId !== $idRequest) {
            echo json_encode(['success' => false, 'message' => 'Autorización fallida']);
            exit;
        }

        $candidateModel = new Candidate();
        $candidate = $candidateModel->findById($verifiedId);

        if ($candidate) {
            echo json_encode(['success' => true, 'data' => $candidate]);
        }
        else {
            echo json_encode(['success' => false, 'message' => 'No encontrado']);
        }
        exit;
    }

    /**
     * Actualiza los datos y/o CV de un candidato existente (tras verificación OTP)
     */
    public function updateCandidate()
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/jobs');
        }

        $candidateId = (int)($_POST['candidate_id'] ?? 0);
        $verifiedId = Session::get('candidate_verified_id');

        // Verificar que la sesión coincide y es válida
        if (!$verifiedId || (int)$verifiedId !== $candidateId) {
            Session::flash('error', 'Sesión de actualización inválida. Por favor, comienza de nuevo.');
            $this->redirect('/jobs');
        }

        $candidateModel = new Candidate();

        $data = [
            'first_name' => Validator::sanitizeString($_POST['first_name'] ?? ''),
            'last_name' => Validator::sanitizeString($_POST['last_name'] ?? ''),
            'phone' => Validator::sanitizeString($_POST['phone'] ?? ''),
            'linkedin_url' => Validator::sanitizeUrl($_POST['linkedin_url'] ?? ''),
            'country' => Validator::sanitizeString($_POST['country'] ?? ''),
            'city' => Validator::sanitizeString($_POST['city'] ?? ''),
            'address' => Validator::sanitizeString($_POST['address'] ?? '')
        ];

        // Actualizar datos del candidato
        $candidateModel->updateFullProfile($candidateId, $data);

        // Actualizar CV si se subió uno nuevo
        if (isset($_FILES['cv']) && $_FILES['cv']['error'] === UPLOAD_ERR_OK) {
            $file = $_FILES['cv'];
            $maxSize = 5 * 1024 * 1024;
            $allowedTypes = [
                'application/pdf',
                'application/msword',
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
            ];

            $finfo = finfo_open(FILEINFO_MIME_TYPE);
            $mime = finfo_file($finfo, $file['tmp_name']);
            finfo_close($finfo);

            if ($file['size'] <= $maxSize && in_array($mime, $allowedTypes)) {
                $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
                $fileName = bin2hex(random_bytes(10)) . '_' . time() . '.' . $ext;
                $destPath = BASE_PATH . '/storage/cvs/' . $fileName;

                if (move_uploaded_file($file['tmp_name'], $destPath)) {
                    // Actualizar el CV en la última postulación del candidato
                    $appModel = new JobApplication();
                    $apps = $appModel->findByCandidateId($candidateId);
                    if (!empty($apps)) {
                        $latestId = $apps[0]['id'];
                        $appModel->updateCvPath($latestId, $fileName);
                    }
                }
            }
        }

        // Limpiar sesión de verificación
        Session::forget('candidate_verified_id');

        Session::flash('success', '¡Tus datos han sido actualizados correctamente! Nos pondremos en contacto pronto.');
        $this->redirect('/');
    }

    /**
     * Process job application (nuevo candidato)
     */
    public function postulate()
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/jobs');
        }

        $validator = new Validator();

        $data = [
            'first_name' => Validator::sanitizeString($_POST['first_name'] ?? ''),
            'last_name' => Validator::sanitizeString($_POST['last_name'] ?? ''),
            'email' => Validator::sanitizeEmail($_POST['email'] ?? ''),
            'phone' => Validator::sanitizeString($_POST['phone'] ?? ''),
            'linkedin_url' => Validator::sanitizeUrl($_POST['linkedin_url'] ?? ''),
            'country' => Validator::sanitizeString($_POST['country'] ?? ''),
            'city' => Validator::sanitizeString($_POST['city'] ?? ''),
            'address' => Validator::sanitizeString($_POST['address'] ?? ''),
            'vacancy_name' => Validator::sanitizeString($_POST['vacancy_name'] ?? '') ?: 'Candidato Web',
            'presentation_letter' => Validator::sanitizeString($_POST['presentation_letter'] ?? ''),
            'skills' => $_POST['skills'] ?? []
        ];

        if (empty($data['first_name']) || empty($data['last_name']) || empty($data['email'])) {
            Session::flash('error', 'Por favor, complete todos los campos requeridos.');
            $this->redirect('/jobs');
        }

        if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            Session::flash('error', 'El correo electrónico no es válido.');
            $this->redirect('/jobs');
        }

        if (!isset($_FILES['cv']) || $_FILES['cv']['error'] !== UPLOAD_ERR_OK) {
            Session::flash('error', 'Por favor, adjunte su currículum.');
            $this->redirect('/jobs');
        }

        $file = $_FILES['cv'];
        $maxSize = 5 * 1024 * 1024;
        $allowedTypes = [
            'application/pdf',
            'application/msword',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        ];

        if ($file['size'] > $maxSize) {
            Session::flash('error', 'El archivo no debe exceder los 5MB.');
            $this->redirect('/jobs');
        }

        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mime = finfo_file($finfo, $file['tmp_name']);
        finfo_close($finfo);

        if (!in_array($mime, $allowedTypes)) {
            Session::flash('error', 'Formato no soportado. Use PDF o DOCX.');
            $this->redirect('/jobs');
        }

        $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
        $fileName = bin2hex(random_bytes(10)) . '_' . time() . '.' . $ext;
        $destPath = BASE_PATH . '/storage/cvs/' . $fileName;

        if (!move_uploaded_file($file['tmp_name'], $destPath)) {
            Session::flash('error', 'Ocurrió un error al subir el archivo. Inténtelo de nuevo.');
            $this->redirect('/jobs');
        }

        $data['cv_path'] = $fileName;

        // Candidate Management - RF: Prohibir duplicidad desde el formulario público
        $candidateModel = new Candidate();
        $existingCandidate = $candidateModel->findByEmail($data['email']);

        if ($existingCandidate) {
            Session::flash('error', 'Ya te encuentras registrado en nuestro sistema. Por favor, usa el proceso de actualización para renovar tus datos o CV.');
            $this->redirect('/jobs');
        }

        $candidateId = $candidateModel->create($data);

        if (!$candidateId) {
            Session::flash('error', 'Error al procesar el perfil del candidato.');
            $this->redirect('/jobs');
        }

        $data['candidate_id'] = $candidateId;

        // Save application
        $model = new JobApplication();
        $applicationId = $model->create($data);

        if ($applicationId) {
            try {
                $subject = "¡Gracias por postularte a Data Wyrd!";
                $body = "
                    <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9; border-radius: 8px;'>
                        <h2 style='color: #1a1e3b;'>¡Hola, {$data['first_name']}!</h2>
                        <p style='color: #555; line-height: 1.6;'>
                            Hemos recibido exitosamente tu postulación y tu currículum vitae. Agradecemos tu interés en unirte al equipo de <strong>Data Wyrd</strong>.
                        </p>
                        <p style='color: #555; line-height: 1.6;'>
                            Nuestro equipo revisará tu perfil en breve y nos pondremos en contacto contigo si tus habilidades se alinean con nuestras posiciones abiertas.
                        </p>
                        <hr style='border: none; border-top: 1px solid #ddd; margin: 30px 0;'>
                        <p style='color: #999; font-size: 12px; text-align: center;'>
                            © " . date('Y') . " Data Wyrd. Transformamos complejidad en claridad estratégica.
                        </p>
                    </div>
                ";

                if (class_exists('\Core\Mail')) {
                    \Core\Mail::send($data['email'], $subject, $body);
                }
            }
            catch (\Exception $e) {
                error_log('Error enviando correo de bienvenida RRHH: ' . $e->getMessage());
            }

            Session::flash('success', '¡Gracias por postularte! Hemos recibido tus datos y los analizaremos pronto.');
            $this->redirect('/');
        }
        else {
            Session::flash('error', 'Ocurrió un error al procesar la solicitud.');
            $this->redirect('/jobs');
        }
    }
}
