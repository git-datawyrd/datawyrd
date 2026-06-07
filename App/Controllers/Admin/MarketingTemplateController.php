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

class MarketingTemplateController extends Controller
{
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
