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

class MarketingCampaignController extends Controller
{
    public function campaigns(): void
    {
        $this->viewLayout('admin/marketing/campaigns', 'admin', [
            'title'     => 'Campañas | Email Marketing',
            'campaigns' => $this->campaignService->getCampaigns(),
        ]);
    }


    public function createCampaign(): void
    {
        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        
        $countriesStmt = $db->prepare("SELECT DISTINCT country FROM mktg_contacts WHERE tenant_id = ? AND country IS NOT NULL AND country != '' AND deleted_at IS NULL ORDER BY country ASC");
        $countriesStmt->execute([$tenantId]);
        $countries = $countriesStmt->fetchAll(PDO::FETCH_COLUMN) ?: [];

        $industriesStmt = $db->prepare("SELECT DISTINCT industry FROM mktg_contacts WHERE tenant_id = ? AND industry IS NOT NULL AND industry != '' AND deleted_at IS NULL ORDER BY industry ASC");
        $industriesStmt->execute([$tenantId]);
        $industries = $industriesStmt->fetchAll(PDO::FETCH_COLUMN) ?: [];

        $campaignsStmt = $db->prepare("SELECT id, name FROM mktg_campaigns WHERE tenant_id = ? AND status = 'sent' AND deleted_at IS NULL ORDER BY name ASC");
        $campaignsStmt->execute([$tenantId]);
        $pastCampaigns = $campaignsStmt->fetchAll() ?: [];

        $this->viewLayout('admin/marketing/campaign_form', 'admin', [
            'title'         => 'Nueva Campaña | Email Marketing',
            'templates'     => $this->repo->getAllTemplates(),
            'lists'         => $this->repo->getAllLists(),
            'campaign'      => null,
            'countries'     => $countries,
            'industries'    => $industries,
            'pastCampaigns' => $pastCampaigns,
        ]);
    }


    public function storeCampaign(): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/admin/marketing/campaigns');
            return;
        }

        $userId = Auth::user()['id'];

        $segmentFilters = [];
        if (!empty($_POST['segment_country'])) {
            $segmentFilters['country'] = trim($_POST['segment_country']);
        }
        if (!empty($_POST['segment_industry'])) {
            $segmentFilters['industry'] = trim($_POST['segment_industry']);
        }
        if (!empty($_POST['segment_tags'])) {
            $segmentFilters['tags'] = trim($_POST['segment_tags']);
        }
        if (!empty($_POST['segment_behavior_type'])) {
            $segmentFilters['behavior'] = [
                'type' => $_POST['segment_behavior_type'],
                'campaign_id' => !empty($_POST['segment_behavior_campaign_id']) ? (int)$_POST['segment_behavior_campaign_id'] : null,
                'days' => !empty($_POST['segment_behavior_days']) ? (int)$_POST['segment_behavior_days'] : null,
            ];
        }

        // Add UTM tags
        $utmEnabled = !empty($_POST['utm_enabled']);
        $segmentFilters['utm'] = [
            'enabled'  => $utmEnabled,
            'source'   => trim($_POST['utm_source'] ?? 'email'),
            'medium'   => trim($_POST['utm_medium'] ?? 'email'),
            'campaign' => trim($_POST['utm_campaign'] ?? ''),
        ];

        $data = [
            'name'            => trim($_POST['name']         ?? ''),
            'subject'         => trim($_POST['subject']      ?? ''),
            'preview_text'    => trim($_POST['preview_text'] ?? ''),
            'from_name'       => trim($_POST['from_name']    ?? ''),
            'from_email'      => trim($_POST['from_email']   ?? ''),
            'reply_to'        => trim($_POST['reply_to']     ?? ''),
            'template_id'     => !empty($_POST['template_id']) ? (int)$_POST['template_id'] : null,
            'list_id'         => !empty($_POST['list_id'])     ? (int)$_POST['list_id']     : null,
            'type'            => $_POST['type']               ?? 'one_time',
            'scheduled_at'    => !empty($_POST['scheduled_at']) ? $_POST['scheduled_at'] : null,
            'segment_filters' => !empty($segmentFilters) ? $segmentFilters : null,
        ];

        if (empty($data['name']) || empty($data['subject'])) {
            Session::flash('error', 'Nombre y asunto son obligatorios.');
            $this->redirect('/admin/marketing/campaigns/create');
            return;
        }

        $id = $this->campaignService->createCampaign($data, $userId);
        Session::flash('success', 'Campaña creada correctamente.');
        $this->redirect("/admin/marketing/showCampaign/{$id}");
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

        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        
        $countriesStmt = $db->prepare("SELECT DISTINCT country FROM mktg_contacts WHERE tenant_id = ? AND country IS NOT NULL AND country != '' AND deleted_at IS NULL ORDER BY country ASC");
        $countriesStmt->execute([$tenantId]);
        $countries = $countriesStmt->fetchAll(PDO::FETCH_COLUMN) ?: [];

        $industriesStmt = $db->prepare("SELECT DISTINCT industry FROM mktg_contacts WHERE tenant_id = ? AND industry IS NOT NULL AND industry != '' AND deleted_at IS NULL ORDER BY industry ASC");
        $industriesStmt->execute([$tenantId]);
        $industries = $industriesStmt->fetchAll(PDO::FETCH_COLUMN) ?: [];

        $campaignsStmt = $db->prepare("SELECT id, name FROM mktg_campaigns WHERE tenant_id = ? AND status = 'sent' AND deleted_at IS NULL ORDER BY name ASC");
        $campaignsStmt->execute([$tenantId]);
        $pastCampaigns = $campaignsStmt->fetchAll() ?: [];

        $this->viewLayout('admin/marketing/campaign_detail', 'admin', [
            'title'         => "Campaña: {$campaign['name']} | Marketing",
            'campaign'      => $campaign,
            'metrics'       => $metrics,
            'templates'     => $this->repo->getAllTemplates(),
            'lists'         => $this->repo->getAllLists(),
            'countries'     => $countries,
            'industries'    => $industries,
            'pastCampaigns' => $pastCampaigns,
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

        $this->redirect("/admin/marketing/showCampaign/{$id}");
    }


    public function testSend(int $id): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect("/admin/marketing/showCampaign/{$id}");
            return;
        }

        $email = trim($_POST['email'] ?? '');
        if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            Session::flash('error', 'El correo de destino para la prueba no es válido.');
            $this->redirect("/admin/marketing/showCampaign/{$id}");
            return;
        }

        $userId = \Core\Auth::user()['id'];
        $result = $this->campaignService->sendTestEmail($id, $email, $userId);

        if ($result['success']) {
            Session::flash('success', "Email de prueba enviado correctamente a {$email}.");
        } else {
            Session::flash('error', 'Error al enviar el email de prueba: ' . ($result['error'] ?? 'desconocido'));
        }

        $this->redirect("/admin/marketing/showCampaign/{$id}");
    }


    public function pauseCampaign(int $campaignId): void
    {
        $this->repo->updateCampaignStatus($campaignId, 'paused');
        Session::flash('success', 'Campaña pausada correctamente.');
        $this->redirect("/admin/marketing/showCampaign/{$campaignId}");
    }


    public function deleteCampaign(int $id): void
    {
        $campaign = $this->repo->findCampaign($id);
        if (!$campaign) {
            Session::flash('error', 'Campaña no encontrada.');
            $this->redirect('/admin/marketing/campaigns');
            return;
        }

        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $stmt = $db->prepare("UPDATE mktg_campaigns SET deleted_at = NOW() WHERE id = ? AND tenant_id = ?");
        $stmt->execute([$id, $tenantId]);

        Session::flash('success', 'Campaña eliminada correctamente.');
        $this->redirect('/admin/marketing/campaigns');
    }


    public function duplicateCampaign(int $id): void
    {
        $campaign = $this->repo->findCampaign($id);
        if (!$campaign) {
            Session::flash('error', 'Campaña no encontrada.');
            $this->redirect('/admin/marketing/campaigns');
            return;
        }

        $userId = Auth::user()['id'];
        $data = [
            'name'            => $campaign['name'] . ' (Copia)',
            'subject'         => $campaign['subject'],
            'preview_text'    => $campaign['preview_text'],
            'from_name'       => $campaign['from_name'],
            'from_email'      => $campaign['from_email'],
            'reply_to'        => $campaign['reply_to'],
            'template_id'     => $campaign['template_id'],
            'list_id'         => $campaign['list_id'],
            'type'            => $campaign['type'],
            'segment_filters' => !empty($campaign['segment_filters']) ? json_decode($campaign['segment_filters'], true) : null,
            'scheduled_at'    => null,
            'created_by'      => $userId,
        ];

        $newId = $this->campaignService->createCampaign($data, $userId);
        Session::flash('success', 'Campaña duplicada correctamente como borrador.');
        $this->redirect("/admin/marketing/showCampaign/{$newId}");
    }


    public function updateCampaign(int $id): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect("/admin/marketing/showCampaign/{$id}");
            return;
        }

        $campaign = $this->repo->findCampaign($id);
        if (!$campaign) {
            Session::flash('error', 'Campaña no encontrada.');
            $this->redirect('/admin/marketing/campaigns');
            return;
        }

        $segmentFilters = [];
        if (!empty($_POST['segment_country'])) {
            $segmentFilters['country'] = trim($_POST['segment_country']);
        }
        if (!empty($_POST['segment_industry'])) {
            $segmentFilters['industry'] = trim($_POST['segment_industry']);
        }
        if (!empty($_POST['segment_tags'])) {
            $segmentFilters['tags'] = trim($_POST['segment_tags']);
        }
        if (!empty($_POST['segment_behavior_type'])) {
            $segmentFilters['behavior'] = [
                'type' => $_POST['segment_behavior_type'],
                'campaign_id' => !empty($_POST['segment_behavior_campaign_id']) ? (int)$_POST['segment_behavior_campaign_id'] : null,
                'days' => !empty($_POST['segment_behavior_days']) ? (int)$_POST['segment_behavior_days'] : null,
            ];
        }

        // Add UTM tags
        $utmEnabled = !empty($_POST['utm_enabled']);
        $segmentFilters['utm'] = [
            'enabled'  => $utmEnabled,
            'source'   => trim($_POST['utm_source'] ?? 'email'),
            'medium'   => trim($_POST['utm_medium'] ?? 'email'),
            'campaign' => trim($_POST['utm_campaign'] ?? ''),
        ];

        $data = [
            'name'            => trim($_POST['name']         ?? ''),
            'subject'         => trim($_POST['subject']      ?? ''),
            'preview_text'    => trim($_POST['preview_text'] ?? ''),
            'from_name'       => trim($_POST['from_name']    ?? ''),
            'from_email'      => trim($_POST['from_email']   ?? ''),
            'reply_to'        => trim($_POST['reply_to']     ?? ''),
            'template_id'     => !empty($_POST['template_id']) ? (int)$_POST['template_id'] : null,
            'list_id'         => !empty($_POST['list_id'])     ? (int)$_POST['list_id']     : null,
            'type'            => $_POST['type']               ?? 'one_time',
            'scheduled_at'    => !empty($_POST['scheduled_at']) ? $_POST['scheduled_at'] : null,
            'segment_filters' => !empty($segmentFilters) ? $segmentFilters : null,
        ];

        if (empty($data['name']) || empty($data['subject'])) {
            Session::flash('error', 'Nombre y asunto son obligatorios.');
            $this->redirect("/admin/marketing/showCampaign/{$id}");
            return;
        }

        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $stmt = $db->prepare(
            "UPDATE mktg_campaigns 
              SET name = ?, subject = ?, preview_text = ?, from_name = ?, from_email = ?, reply_to = ?, 
                  template_id = ?, list_id = ?, type = ?, scheduled_at = ?, segment_filters = ?
              WHERE id = ? AND tenant_id = ?"
        );
        $stmt->execute([
            $data['name'],
            $data['subject'],
            $data['preview_text'],
            $data['from_name'],
            $data['from_email'],
            $data['reply_to'],
            $data['template_id'],
            $data['list_id'],
            $data['type'],
            $data['scheduled_at'],
            !empty($data['segment_filters']) ? json_encode($data['segment_filters']) : null,
            $id,
            $tenantId
        ]);

        Session::flash('success', 'Campaña actualizada correctamente.');
        $this->redirect("/admin/marketing/showCampaign/{$id}");
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


    public function countMatchingContacts(): void
    {
        $db = Database::getInstance()->getConnection();
        $tenantId = \Core\Config::get('current_tenant_id', 1);

        $listId = !empty($_GET['list_id']) ? (int)$_GET['list_id'] : 0;
        $country = $_GET['country'] ?? '';
        $industry = $_GET['industry'] ?? '';
        $tags = $_GET['tags'] ?? '';
        $behaviorType = $_GET['behavior_type'] ?? '';
        $behaviorCampaignId = !empty($_GET['behavior_campaign_id']) ? (int)$_GET['behavior_campaign_id'] : null;
        $behaviorDays = !empty($_GET['behavior_days']) ? (int)$_GET['behavior_days'] : null;

        // Contar total de la lista
        $stmtTotal = $db->prepare("SELECT COUNT(*) FROM mktg_contacts WHERE list_id = ? AND tenant_id = ? AND status = 'subscribed' AND deleted_at IS NULL AND NOT EXISTS (SELECT 1 FROM blacklist b WHERE b.email = mktg_contacts.email)");
        $stmtTotal->execute([$listId, $tenantId]);
        $total = (int)$stmtTotal->fetchColumn();

        if ($listId <= 0) {
            header('Content-Type: application/json');
            echo json_encode(['matching' => 0, 'total' => 0]);
            exit;
        }

        $sql = "SELECT COUNT(*) FROM mktg_contacts c
                WHERE c.list_id = ?
                  AND c.tenant_id = ?
                  AND c.status = 'subscribed'
                  AND c.deleted_at IS NULL
                  AND NOT EXISTS (SELECT 1 FROM blacklist b WHERE b.email = c.email)";
        $params = [$listId, $tenantId];

        if ($country !== '') {
            $sql .= " AND c.country = ?";
            $params[] = $country;
        }
        if ($industry !== '') {
            $sql .= " AND c.industry = ?";
            $params[] = $industry;
        }
        if ($tags !== '') {
            $sql .= " AND c.tags LIKE ?";
            $params[] = '%' . $tags . '%';
        }
        if ($behaviorType !== '') {
            if ($behaviorType === 'opened' && $behaviorCampaignId) {
                $sql .= " AND EXISTS (SELECT 1 FROM mktg_events e WHERE e.contact_id = c.id AND e.campaign_id = ? AND e.event_type = 'open')";
                $params[] = $behaviorCampaignId;
            } elseif ($behaviorType === 'clicked' && $behaviorCampaignId) {
                $sql .= " AND EXISTS (SELECT 1 FROM mktg_events e WHERE e.contact_id = c.id AND e.campaign_id = ? AND e.event_type = 'click')";
                $params[] = $behaviorCampaignId;
            } elseif ($behaviorType === 'inactive' && $behaviorDays) {
                $sql .= " AND NOT EXISTS (SELECT 1 FROM mktg_events e WHERE e.contact_id = c.id AND e.occurred_at >= DATE_SUB(NOW(), INTERVAL ? DAY) AND e.event_type IN ('open', 'click'))";
                $params[] = $behaviorDays;
            }
        }

        $stmtMatch = $db->prepare($sql);
        $stmtMatch->execute($params);
        $matching = (int)$stmtMatch->fetchColumn();

        header('Content-Type: application/json');
        echo json_encode(['matching' => $matching, 'total' => $total]);
        exit;
    }

    public function getTemplateHtml(): void
    {
        $templateId = !empty($_GET['id']) ? (int)$_GET['id'] : 0;
        $template = $this->repo->findTemplate($templateId);
        $html = $template ? ($template['html_body'] ?: '<p style="color:#ccc; padding:24px; font-family:sans-serif; text-align:center;">Esta plantilla no tiene cuerpo HTML.</p>') : '<p style="color:#ccc; padding:24px; font-family:sans-serif; text-align:center;">Plantilla no seleccionada.</p>';
        
        header('Content-Type: text/html; charset=utf-8');
        echo $html;
        exit;
    }
}
