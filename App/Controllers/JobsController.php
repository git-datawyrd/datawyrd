<?php
namespace App\Controllers;

use Core\Controller;
use Core\View;
use Core\Validator;
use Core\Session;
use Core\Config;
use App\Models\JobApplication;

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
     * Process job application
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
            'presentation_letter' => Validator::sanitizeString($_POST['presentation_letter'] ?? ''),
            'skills' => $_POST['skills'] ?? [] // Array of selected skills
        ];

        // Basic validations
        if (empty($data['first_name']) || empty($data['last_name']) || empty($data['email'])) {
            Session::flash('error', 'Por favor, complete todos los campos requeridos.');
            $this->redirect('/jobs');
        }

        if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            Session::flash('error', 'El correo electrónico no es válido.');
            $this->redirect('/jobs');
        }

        // File upload validation
        if (!isset($_FILES['cv']) || $_FILES['cv']['error'] !== UPLOAD_ERR_OK) {
            Session::flash('error', 'Por favor, adjunte su currículum.');
            $this->redirect('/jobs');
        }

        $file = $_FILES['cv'];
        $maxSize = 5 * 1024 * 1024; // 5MB limit
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

        // Generate safe unique filename
        $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
        $fileName = bin2hex(random_bytes(10)) . '_' . time() . '.' . $ext;
        $uploadDir = BASE_PATH . '/storage/cvs/';
        $destPath = $uploadDir . $fileName;

        if (!move_uploaded_file($file['tmp_name'], $destPath)) {
            Session::flash('error', 'Ocurrió un error al subir el archivo. Inténtelo de nuevo.');
            $this->redirect('/jobs');
        }

        $data['cv_path'] = $fileName;

        // Save application
        $model = new JobApplication();
        $applicationId = $model->create($data);

        if ($applicationId) {
            // Enviar Correo de Bienvenida al Candidato
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
                        <p style='color: #555; line-height: 1.6;'>
                            Mientras tanto, te invitamos a conocer más sobre nuestra cultura y proyectos siguiéndonos sutilmente en nuestras redes:
                        </p>
                        <div style='margin-top: 20px;'>
                            <a href='https://www.linkedin.com/company/datawyrd/' style='display: inline-block; padding: 10px 20px; background-color: #0077b5; color: white; text-decoration: none; border-radius: 5px; margin-right: 10px; font-weight: bold;'>LinkedIn</a>
                            <a href='https://instagram.com/datawyrd' style='display: inline-block; padding: 10px 20px; background-color: #e1306c; color: white; text-decoration: none; border-radius: 5px; font-weight: bold;'>Instagram</a>
                        </div>
                        <hr style='border: none; border-top: 1px solid #ddd; margin: 30px 0;'>
                        <p style='color: #999; font-size: 12px; text-align: center;'>
                            © " . date('Y') . " Data Wyrd. Transformamos complejidad en claridad estratégica.
                        </p>
                    </div>
                ";
                
                if (class_exists('\\Core\\Mail')) {
                    \Core\Mail::send($data['email'], $subject, $body);
                }
            } catch (\Exception $e) {
                // Silently handle email failure so the user flow isn't interrupted
                error_log('Error enviando correo de bienvenida RRHH: ' . $e->getMessage());
            }

            Session::flash('success', '¡Gracias por postularte! Hemos recibido tus datos y los analizaremos pronto.');
            $this->redirect('/');
        } else {
            Session::flash('error', 'Ocurrió un error al procesar la solicitud.');
            $this->redirect('/jobs');
        }
    }
}
