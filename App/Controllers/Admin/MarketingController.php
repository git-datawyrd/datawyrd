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


}
