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

        $data = [
            'name'         => trim($_POST['name']         ?? ''),
            'subject'      => trim($_POST['subject']      ?? ''),
            'preview_text' => trim($_POST['preview_text'] ?? ''),
            'from_name'    => trim($_POST['from_name']    ?? ''),
            'from_email'   => trim($_POST['from_email']   ?? ''),
            'reply_to'     => trim($_POST['reply_to']     ?? ''),
            'template_id'  => !empty($_POST['template_id']) ? (int)$_POST['template_id'] : null,
            'list_id'      => !empty($_POST['list_id'])     ? (int)$_POST['list_id']     : null,
            'type'         => $_POST['type']               ?? 'one_time',
            'scheduled_at' => !empty($_POST['scheduled_at']) ? $_POST['scheduled_at'] : null,
        ];

        if (empty($data['name']) || empty($data['subject'])) {
            Session::flash('error', 'Nombre y asunto son obligatorios.');
            $this->redirect('/admin/marketing/campaigns/create');
            return;
        }

        $id = $this->campaignService->createCampaign($data, $userId);
        Session::flash('success', 'Campaña creada correctamente.');
        $this->redirect("/admin/marketing/campaigns/{$id}");
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
            'title'    => "Campaña: {$campaign['name']} | Marketing",
            'campaign' => $campaign,
            'metrics'  => $metrics,
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

        $this->redirect("/admin/marketing/campaigns/{$id}");
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
     * Importación de contactos CSV.
     * El CSV debe tener cabecera: email,first_name,last_name
     */
    public function importContacts(int $listId): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect("/admin/marketing/lists/{$listId}");
            return;
        }

        if (!isset($_FILES['csv_file']) || $_FILES['csv_file']['error'] !== UPLOAD_ERR_OK) {
            Session::flash('error', 'Error al subir el archivo CSV.');
            $this->redirect("/admin/marketing/lists/{$listId}");
            return;
        }

        $file     = $_FILES['csv_file']['tmp_name'];
        $handle   = fopen($file, 'r');
        $headers  = fgetcsv($handle); // Leer cabecera
        $contacts = [];

        while (($row = fgetcsv($handle)) !== false) {
            $mapped = [];
            foreach ($headers as $idx => $header) {
                $mapped[trim(strtolower($header))] = $row[$idx] ?? '';
            }
            if (!empty($mapped['email'])) {
                $contacts[] = $mapped;
            }
        }
        fclose($handle);

        $result = $this->campaignService->importContacts($listId, $contacts);

        $msg = "Importación completada: {$result['imported']} importados, {$result['skipped']} duplicados.";
        if (!empty($result['errors'])) {
            $msg .= " Errores: " . count($result['errors']) . ".";
        }

        Session::flash('success', $msg);
        $this->redirect("/admin/marketing/lists/{$listId}");
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

        $this->viewLayout('admin/marketing/analytics', 'admin', [
            'title'    => "Analytics: {$campaign['name']}",
            'campaign' => $campaign,
            'metrics'  => $metrics,
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
}
