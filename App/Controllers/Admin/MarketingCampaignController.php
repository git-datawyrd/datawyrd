<?php
namespace App\Controllers\Admin;

use Core\Controller;
use Core\Database;
use Core\Auth;
use Core\Session;
use App\Services\MailService;
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

        $this->viewLayout('admin/marketing/campaign_detail', 'admin', [
            'title'     => "Campaña: {$campaign['name']} | Marketing",
            'campaign'  => $campaign,
            'metrics'   => $metrics,
            'templates' => $this->repo->getAllTemplates(),
            'lists'     => $this->repo->getAllLists(),
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


}
