<?php
namespace App\Repositories;

use PDO;

class TicketRepository extends BaseRepository
{
    protected string $table = 'tickets';

    public function getRecentWithClients(int $limit = 10, array $excludeStatuses = [])
    {
        $excludeSql = "";
        $params = [PDO::PARAM_INT => $limit];

        if (!empty($excludeStatuses)) {
            $placeholders = implode(',', array_fill(0, count($excludeStatuses), '?'));
            $excludeSql = " WHERE t.status NOT IN ($placeholders) ";
        }

        $sql = "SELECT t.*, u.name as client_name, sp.name as plan_name, s.name as service_name 
                FROM {$this->table} t 
                JOIN users u ON t.client_id = u.id 
                LEFT JOIN service_plans sp ON t.service_plan_id = sp.id
                LEFT JOIN services s ON sp.service_id = s.id
                $excludeSql
                ORDER BY t.created_at DESC LIMIT ?";

        $stmt = $this->db->prepare($sql);

        $i = 1;
        foreach ($excludeStatuses as $status) {
            $stmt->bindValue($i++, $status);
        }
        $stmt->bindValue($i, $limit, PDO::PARAM_INT);

        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function getStats(): array
    {
        return [
            'total' => $this->db->query("SELECT COUNT(*) FROM {$this->table}")->fetchColumn(),
            'open' => $this->db->query("SELECT COUNT(*) FROM {$this->table} WHERE status = 'open'")->fetchColumn(),
        ];
    }

    public function getDistribution(): array
    {
        return [
            'open' => (int) $this->db->query("SELECT COUNT(*) FROM {$this->table} WHERE status = 'open'")->fetchColumn(),
            'in_progress' => (int) $this->db->query("SELECT COUNT(*) FROM {$this->table} WHERE status IN ('in_analysis', 'budget_sent', 'budget_approved', 'invoiced', 'payment_pending')")->fetchColumn(),
            'resolved' => (int) $this->db->query("SELECT COUNT(*) FROM {$this->table} WHERE status = 'active'")->fetchColumn(),
            'closed' => (int) $this->db->query("SELECT COUNT(*) FROM {$this->table} WHERE status = 'closed'")->fetchColumn()
        ];
    }
}
