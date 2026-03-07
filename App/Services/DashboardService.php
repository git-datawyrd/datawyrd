<?php
namespace App\Services;

use Core\Database;
use PDO;

/**
 * Dashboard Service
 * Provides analytical data and KPIs for the dashboard.
 */
class DashboardService
{
    private $ticketRepo;
    private $userRepo;
    private $db;

    public function __construct(\App\Repositories\TicketRepository $ticketRepo, \App\Repositories\UserRepository $userRepo, \PDO $db)
    {
        $this->ticketRepo = $ticketRepo;
        $this->userRepo = $userRepo;
        $this->db = $db;
    }

    /**
     * Get recent tickets for admin/staff view.
     */
    public function getRecentTicketsWithClients(int $limit = 10): array
    {
        return $this->ticketRepo->getRecentWithClients($limit);
    }

    /**
     * Get the latest ticket ID for a client (for urgent support).
     */
    public function getLatestTicketId(int $clientId): ?int
    {
        $stmt = $this->db->prepare("SELECT id FROM tickets WHERE client_id = ? ORDER BY created_at DESC LIMIT 1");
        $stmt->execute([$clientId]);
        $id = $stmt->fetchColumn();
        return $id ? (int) $id : null;
    }

    /**
     * Get global statistics for SuperAdmin and Admin.
     */
    public function getAdminStats(): array
    {
        $ticketStats = $this->ticketRepo->getStats();

        // 1. % Tickets Cerrados: closed / (total - void)
        $totalTickets = (int) $this->db->query("SELECT COUNT(*) FROM tickets")->fetchColumn();
        $voidTickets = (int) $this->db->query("SELECT COUNT(*) FROM tickets WHERE status = 'void'")->fetchColumn();
        $closedTickets = (int) $this->db->query("SELECT COUNT(*) FROM tickets WHERE status = 'closed'")->fetchColumn();

        $validTickets = $totalTickets - $voidTickets;
        $closedPct = $validTickets > 0 ? round(($closedTickets / $validTickets) * 100) : 0;

        // 2. % Monto Pagado
        $invoiceTotals = $this->db->query("SELECT SUM(total) as total_amount, SUM(paid_amount) as total_paid FROM invoices")->fetch(PDO::FETCH_ASSOC);
        $totalAmount = (float) ($invoiceTotals['total_amount'] ?? 0);
        $totalPaid = (float) ($invoiceTotals['total_paid'] ?? 0);
        $paidPct = $totalAmount > 0 ? round(($totalPaid / $totalAmount) * 100) : 0;

        // 3. Desglose Usuarios
        $usersBreakdown = $this->db->query("SELECT role, COUNT(*) as count FROM users GROUP BY role")->fetchAll(PDO::FETCH_KEY_PAIR);

        return [
            'total_tickets' => $totalTickets,
            'open_tickets' => $ticketStats['open'],
            'closed_tickets_pct' => $closedPct,
            'active_services' => $this->db->query("SELECT COUNT(*) FROM active_services WHERE status = 'active'")->fetchColumn(),
            'paid_invoices_pct' => $paidPct,
            'total_users' => $this->db->query("SELECT COUNT(*) FROM users")->fetchColumn(),
            'users_breakdown' => $usersBreakdown
        ];
    }

    /**
     * Get daily performance data for the last 30 days.
     */
    public function getDailyPerformance(int $days = 30): array
    {
        $stmtTickets = $this->db->query("SELECT DATE(created_at) as date, COUNT(*) as count FROM tickets 
                                    WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL $days DAY) 
                                    GROUP BY date");
        $ticketsByDate = $stmtTickets->fetchAll(PDO::FETCH_KEY_PAIR);

        $stmtUsers = $this->db->query("SELECT DATE(created_at) as date, COUNT(*) as count FROM users 
                                 WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL $days DAY) 
                                 GROUP BY date");
        $usersByDate = $stmtUsers->fetchAll(PDO::FETCH_KEY_PAIR);

        $stmtClients = $this->db->query("SELECT DATE(created_at) as date, COUNT(*) as count FROM users 
                                   WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL $days DAY) AND role = 'client'
                                   GROUP BY date");
        $clientsByDate = $stmtClients->fetchAll(PDO::FETCH_KEY_PAIR);

        $dailyData = [];
        for ($i = $days - 1; $i >= 0; $i--) {
            $date = date('Y-m-d', strtotime("-$i days"));
            $dailyData[] = [
                'date' => $date,
                'tickets' => (int) ($ticketsByDate[$date] ?? 0),
                'users' => (int) ($usersByDate[$date] ?? 0),
                'clients' => (int) ($clientsByDate[$date] ?? 0)
            ];
        }

        return $dailyData;
    }

    /**
     * Get monthly performance data for the last 12 months.
     */
    public function getMonthlyPerformance(int $months = 12): array
    {
        $stmtTicketsM = $this->db->query("SELECT DATE_FORMAT(created_at, '%Y-%m') as month, COUNT(*) as count FROM tickets 
                                     WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL $months MONTH) 
                                     GROUP BY month");
        $ticketsByMonth = $stmtTicketsM->fetchAll(PDO::FETCH_KEY_PAIR);

        $stmtUsersM = $this->db->query("SELECT DATE_FORMAT(created_at, '%Y-%m') as month, COUNT(*) as count FROM users 
                                   WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL $months MONTH) 
                                   GROUP BY month");
        $usersByMonth = $stmtUsersM->fetchAll(PDO::FETCH_KEY_PAIR);

        $stmtClientsM = $this->db->query("SELECT DATE_FORMAT(created_at, '%Y-%m') as month, COUNT(*) as count FROM users 
                                     WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL $months MONTH) AND role = 'client'
                                     GROUP BY month");
        $clientsByMonth = $stmtClientsM->fetchAll(PDO::FETCH_KEY_PAIR);

        $monthlyData = [];
        for ($i = $months - 1; $i >= 0; $i--) {
            $month = date('Y-m', strtotime("-$i months"));
            $monthlyData[] = [
                'month' => $month,
                'tickets' => (int) ($ticketsByMonth[$month] ?? 0),
                'users' => (int) ($usersByMonth[$month] ?? 0),
                'clients' => (int) ($clientsByMonth[$month] ?? 0)
            ];
        }

        return $monthlyData;
    }

    public function getResourceDistribution(): array
    {
        $stmt = $this->db->query("
            SELECT sc.name as category, t.status, COUNT(*) as count 
            FROM tickets t 
            JOIN service_plans sp ON t.service_plan_id = sp.id 
            JOIN services s ON sp.service_id = s.id 
            JOIN service_categories sc ON s.category_id = sc.id 
            GROUP BY sc.name, t.status
        ");
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $distribution = [];
        foreach ($results as $row) {
            $cat = $row['category'];
            $status = $row['status'];
            if (!isset($distribution[$cat])) {
                $distribution[$cat] = [];
            }
            $distribution[$cat][$status] = (int) $row['count'];
        }

        return $distribution;
    }


    /**
     * Get recent leads with intelligence scoring.
     */
    public function getRecentLeadsWithScores(int $limit = 5): array
    {
        $stmt = $this->db->query("SELECT u.id, u.name, u.email, u.company, u.created_at,
                                  (SELECT COUNT(*) FROM tickets WHERE client_id = u.id) as ticket_count
                                  FROM users u WHERE u.role = 'client' 
                                  ORDER BY u.created_at DESC LIMIT $limit");
        $leads = $stmt->fetchAll();

        $leadService = new \App\Services\CRM\LeadService();
        foreach ($leads as &$lead) {
            $lead['score'] = $leadService->calculateScore($lead['id']);
        }

        return $leads;
    }

    /**
     * Get client-specific dashboard data.
     */
    public function getClientDashboardData(int $clientId): array
    {
        // Active services
        $stmt = $this->db->prepare("SELECT ax.*, sp.name as plan_name, 
                             (SELECT COUNT(*) FROM project_deliverables pd WHERE pd.active_service_id = ax.id) as current_deliverables
                             FROM active_services ax 
                             JOIN service_plans sp ON ax.service_plan_id = sp.id 
                             WHERE ax.client_id = ? AND ax.status = 'active'");
        $stmt->execute([$clientId]);
        $services = $stmt->fetchAll();

        foreach ($services as &$s) {
            $s['progress_percent'] = ($s['total_deliverables'] > 0)
                ? round(($s['current_deliverables'] / $s['total_deliverables']) * 100)
                : 0;
            if ($s['total_deliverables'] == 0) {
                $s['progress_text'] = 'En ejecución';
            }
        }

        // Recent tickets
        $stmt = $this->db->prepare("SELECT t.*, sp.name as plan_name 
                             FROM tickets t 
                             JOIN service_plans sp ON t.service_plan_id = sp.id 
                             WHERE t.client_id = ? 
                             ORDER BY t.created_at DESC LIMIT 5");
        $stmt->execute([$clientId]);
        $tickets = $stmt->fetchAll();

        // Unpaid invoices count
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM invoices WHERE client_id = ? AND status IN ('unpaid', 'pending')");
        $stmt->execute([$clientId]);
        $unpaidInvoices = $stmt->fetchColumn();

        return [
            'services' => $services,
            'tickets' => $tickets,
            'unpaid_count' => $unpaidInvoices
        ];
    }

    /**
     * Get staff-specific dashboard data.
     */
    public function getStaffDashboardData(int $staffId): array
    {
        $stmt = $this->db->prepare("SELECT t.*, u.name as client_name 
                             FROM tickets t 
                             JOIN users u ON t.client_id = u.id 
                             WHERE t.assigned_to = ? AND t.status != 'closed' 
                             ORDER BY t.priority DESC, t.created_at ASC");
        $stmt->execute([$staffId]);
        return $stmt->fetchAll();
    }

    /**
     * Get widget configuration for a specific user.
     */
    public function getWidgetConfig(int $userId): array
    {
        $stmt = $this->db->prepare("SELECT widget_key, is_visible, sort_order FROM user_dashboard_config WHERE user_id = ? ORDER BY sort_order ASC");
        $stmt->execute([$userId]);
        $config = $stmt->fetchAll(\PDO::FETCH_UNIQUE | \PDO::FETCH_ASSOC);

        // Default widgets if none configured
        $defaults = [
            'stats_cards' => ['is_visible' => 1, 'sort_order' => 1],
            'performance_chart' => ['is_visible' => 1, 'sort_order' => 2],
            'resource_dist' => ['is_visible' => 1, 'sort_order' => 3],
            'recent_leads' => ['is_visible' => 1, 'sort_order' => 4],
            'recent_tickets' => ['is_visible' => 1, 'sort_order' => 5]
        ];

        return array_merge($defaults, $config);
    }

    /**
     * Update widget configuration.
     */
    public function updateWidgetConfig(int $userId, array $widgets): bool
    {
        try {
            $this->db->beginTransaction();
            foreach ($widgets as $key => $config) {
                $stmt = $this->db->prepare("REPLACE INTO user_dashboard_config (user_id, widget_key, is_visible, sort_order) VALUES (?, ?, ?, ?)");
                $stmt->execute([$userId, $key, $config['is_visible'] ? 1 : 0, $config['sort_order'] ?? 0]);
            }
            $this->db->commit();
            return true;
        } catch (\Exception $e) {
            $this->db->rollBack();
            return false;
        }
    }
}
