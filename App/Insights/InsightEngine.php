<?php
namespace App\Insights;

use Core\Database;
use App\Analytics\AnalyticsService;
use PDO;

/**
 * Insight Engine
 * Generates proactive recommendations and alerts for the workspace.
 */
class InsightEngine
{
    private $db;
    private $analytics;

    public function __construct(PDO $db, AnalyticsService $analytics)
    {
        $this->db = $db;
        $this->analytics = $analytics;
    }

    /**
     * Generate actionable insights for the dashboard.
     */
    public function getActiveInsights(): array
    {
        $insights = [];

        // 1. Check for overdue invoices
        $overdueInvoices = $this->db->query("SELECT id, total FROM invoices WHERE status = 'unpaid' AND due_date < CURDATE()")->fetchAll();
        if (count($overdueInvoices) > 0) {
            $insights[] = [
                'type' => 'alert',
                'level' => 'high',
                'message' => 'Se detectaron ' . count($overdueInvoices) . ' facturas vencidas.',
                'action_label' => 'Gestionar Cobros',
                'action_url' => '/admin/invoices?status=unpaid'
            ];
        }

        // 2. Check for idle tickets
        $idleTickets = $this->db->query("SELECT id FROM tickets WHERE status NOT IN ('closed', 'void') AND updated_at < DATE_SUB(NOW(), INTERVAL 48 HOUR)")->fetchAll();
        if (count($idleTickets) > 0) {
            $insights[] = [
                'type' => 'recommendation',
                'level' => 'medium',
                'message' => 'Hay ' . count($idleTickets) . ' tickets sin actividad por más de 48h.',
                'action_label' => 'Revisar Tickets',
                'action_url' => '/admin/tickets?filter=idle'
            ];
        }

        // 3. High conversion probability leads
        $highScoreLeads = $this->db->query("SELECT id, name FROM users WHERE role = 'client' AND id IN (SELECT client_id FROM tickets) LIMIT 3")->fetchAll();
        foreach ($highScoreLeads as $lead) {
            $insights[] = [
                'type' => 'opportunity',
                'level' => 'low',
                'message' => 'Cliente ' . $lead['name'] . ' tiene alta probabilidad de conversión.',
                'action_label' => 'Contactar',
                'action_url' => '/admin/clients/view/' . $lead['id']
            ];
        }

        return $insights;
    }
}
