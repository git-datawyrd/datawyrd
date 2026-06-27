<?php
namespace App\Controllers\Admin;

use Core\Controller;
use Core\Database;
use Core\Auth;
use Core\Session;
use App\Services\MailService;
use App\Services\Marketing\CampaignService;
use App\Repositories\MarketingRepository;
use Core\Marketing\DnsValidator;
use PDO;

class MarketingController extends Controller
{
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


    public function settings(): void
    {
        $db = Database::getInstance()->getConnection();
        
        // Handle Delete from Blacklist
        if (isset($_GET['action']) && $_GET['action'] === 'remove_blacklist' && !empty($_GET['id'])) {
            $stmtDel = $db->prepare("DELETE FROM blacklist WHERE id = ?");
            $stmtDel->execute([(int)$_GET['id']]);
            Session::flash('success', 'Email eliminado de la lista negra.');
            $this->redirect('/admin/marketing/settings?tab=blacklist');
            return;
        }

        // Handle Add to Blacklist
        if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'add_blacklist') {
            $email = trim($_POST['email'] ?? '');
            $reason = trim($_POST['reason'] ?? 'Añadido manualmente');
            
            if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
                Session::flash('error', 'El correo ingresado no es válido.');
            } else {
                $stmtAdd = $db->prepare("INSERT INTO blacklist (email, reason, created_at) VALUES (?, ?, NOW()) ON DUPLICATE KEY UPDATE reason = ?, created_at = NOW()");
                $stmtAdd->execute([strtolower($email), $reason, $reason]);
                Session::flash('success', 'Email añadido a la lista negra.');
            }
            $this->redirect('/admin/marketing/settings?tab=blacklist');
            return;
        }

        $domain = $_POST['domain'] ?? \Core\Config::get('business.company_domain', '');
        $selector = $_POST['dkim_selector'] ?? \Core\Config::get('marketing.dkim_selector', 'mail');
        
        $spfResult = null;
        $dkimResult = null;

        if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'validate_dns' && !empty($domain)) {
            $validator = new DnsValidator();
            $spfResult = $validator->checkSPF($domain);
            $dkimResult = $validator->checkDKIM($domain, $selector);
        }

        // Fetch blacklist entries (searchable)
        $search = trim($_GET['search'] ?? '');
        if ($search !== '') {
            $stmtBl = $db->prepare("SELECT * FROM blacklist WHERE email LIKE ? ORDER BY created_at DESC LIMIT 100");
            $stmtBl->execute(['%' . $search . '%']);
        } else {
            $stmtBl = $db->query("SELECT * FROM blacklist ORDER BY created_at DESC LIMIT 100");
        }
        $blacklist = $stmtBl->fetchAll() ?: [];

        $this->viewLayout('admin/marketing/settings', 'admin', [
            'title'      => 'Configuración y Entregabilidad',
            'domain'     => $domain,
            'selector'   => $selector,
            'spfResult'  => $spfResult,
            'dkimResult' => $dkimResult,
            'blacklist'  => $blacklist,
            'search'     => $search,
        ]);
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


    // =========================================================================
    // AUTOMATIZACIONES (FASE 3)
    // =========================================================================

    public function automations(): void
    {
        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);

        $stmt = $db->prepare("SELECT * FROM mktg_automations WHERE tenant_id = ? AND deleted_at IS NULL ORDER BY created_at DESC");
        $stmt->execute([$tenantId]);
        $automations = $stmt->fetchAll() ?: [];

        $lists = $this->repo->getAllLists();
        $templates = $this->repo->getAllTemplates();

        $this->viewLayout('admin/marketing/automations', 'admin', [
            'title'       => 'Flujos Automatizados | Marketing',
            'automations' => $automations,
            'lists'       => $lists,
            'templates'   => $templates,
        ]);
    }

    public function showAutomation(int $id): void
    {
        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);

        $stmt = $db->prepare("SELECT * FROM mktg_automations WHERE id = ? AND tenant_id = ? AND deleted_at IS NULL");
        $stmt->execute([$id, $tenantId]);
        $automation = $stmt->fetch();

        if (!$automation) {
            Session::flash('error', 'Automatización no encontrada.');
            $this->redirect('/admin/marketing/automations');
            return;
        }

        $stmtSteps = $db->prepare("SELECT * FROM mktg_automation_steps WHERE automation_id = ? ORDER BY step_order ASC");
        $stmtSteps->execute([$id]);
        $steps = $stmtSteps->fetchAll() ?: [];

        $templates = $this->repo->getAllTemplates();

        $this->viewLayout('admin/marketing/automation_detail', 'admin', [
            'title'      => "Automatización: {$automation['name']}",
            'automation' => $automation,
            'steps'      => $steps,
            'templates'  => $templates,
        ]);
    }

    public function storeAutomation(): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/admin/marketing/automations');
            return;
        }

        $name = trim($_POST['name'] ?? '');
        $triggerType = $_POST['trigger_type'] ?? 'signup';
        $listId = !empty($_POST['list_id']) ? (int)$_POST['list_id'] : null;

        if (empty($name)) {
            Session::flash('error', 'El nombre es obligatorio.');
            $this->redirect('/admin/marketing/automations');
            return;
        }

        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $userId = \Core\Auth::user()['id'];

        $triggerData = [];
        if ($triggerType === 'signup' && $listId) {
            $triggerData['list_id'] = $listId;
        }

        $stmt = $db->prepare("INSERT INTO mktg_automations (tenant_id, name, trigger_type, trigger_data, status, created_by) VALUES (?, ?, ?, ?, 'draft', ?)");
        $stmt->execute([$tenantId, $name, $triggerType, json_encode($triggerData), $userId]);
        $newId = $db->lastInsertId();

        Session::flash('success', 'Flujo de automatización creado correctamente.');
        $this->redirect("/admin/marketing/showAutomation/{$newId}");
    }

    public function deleteAutomation(int $id): void
    {
        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);

        $stmt = $db->prepare("UPDATE mktg_automations SET deleted_at = NOW(), status = 'draft' WHERE id = ? AND tenant_id = ?");
        $stmt->execute([$id, $tenantId]);

        Session::flash('success', 'Automatización eliminada correctamente.');
        $this->redirect('/admin/marketing/automations');
    }

    public function toggleAutomationStatus(int $id): void
    {
        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);

        $stmt = $db->prepare("SELECT status FROM mktg_automations WHERE id = ? AND tenant_id = ? AND deleted_at IS NULL");
        $stmt->execute([$id, $tenantId]);
        $current = $stmt->fetchColumn();

        if ($current) {
            $newStatus = ($current === 'active') ? 'paused' : 'active';
            $db->prepare("UPDATE mktg_automations SET status = ? WHERE id = ?")->execute([$newStatus, $id]);
            Session::flash('success', "Automatización " . ($newStatus === 'active' ? 'activada' : 'pausada') . " correctamente.");
        }

        $this->redirect("/admin/marketing/showAutomation/{$id}");
    }

    public function addStep(int $automationId): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect("/admin/marketing/showAutomation/{$automationId}");
            return;
        }

        $stepType = $_POST['step_type'] ?? 'send_email';
        
        $config = [];
        if ($stepType === 'send_email') {
            $config['template_id'] = !empty($_POST['template_id']) ? (int)$_POST['template_id'] : null;
        } elseif ($stepType === 'tag') {
            $config['tag_name'] = trim($_POST['tag_name'] ?? '');
            $config['action'] = $_POST['tag_action'] ?? 'add';
        } elseif ($stepType === 'webhook') {
            $config['url'] = trim($_POST['webhook_url'] ?? '');
        }

        $db = Database::getInstance()->getConnection();
        
        // Determinar orden siguiente
        $stmtOrder = $db->prepare("SELECT COALESCE(MAX(step_order), 0) + 1 FROM mktg_automation_steps WHERE automation_id = ?");
        $stmtOrder->execute([$automationId]);
        $nextOrder = $stmtOrder->fetchColumn();

        $stmtInsert = $db->prepare("INSERT INTO mktg_automation_steps (automation_id, step_order, step_type, step_config) VALUES (?, ?, ?, ?)");
        $stmtInsert->execute([$automationId, $nextOrder, $stepType, json_encode($config)]);

        Session::flash('success', 'Paso añadido a la automatización.');
        $this->redirect("/admin/marketing/showAutomation/{$automationId}");
    }

    public function deleteStep(int $stepId): void
    {
        $db = Database::getInstance()->getConnection();
        
        $stmt = $db->prepare("SELECT automation_id, step_order FROM mktg_automation_steps WHERE id = ?");
        $stmt->execute([$stepId]);
        $step = $stmt->fetch();

        if ($step) {
            $db->prepare("DELETE FROM mktg_automation_steps WHERE id = ?")->execute([$stepId]);
            // Reordenar pasos restantes
            $db->prepare("UPDATE mktg_automation_steps SET step_order = step_order - 1 WHERE automation_id = ? AND step_order > ?")
               ->execute([$step['automation_id'], $step['step_order']]);
            
            Session::flash('success', 'Paso eliminado.');
            $this->redirect("/admin/marketing/showAutomation/{$step['automation_id']}");
            return;
        }

        $this->redirect('/admin/marketing/automations');
    }
}
