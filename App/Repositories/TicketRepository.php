<?php
namespace App\Repositories;

use PDO;

class TicketRepository extends BaseRepository
{
    protected string $table = 'tickets';

    public function getRecentWithClients(int $limit = 10)
    {
        $sql = "SELECT t.*, u.name as client_name 
                FROM {$this->table} t 
                JOIN users u ON t.client_id = u.id 
                ORDER BY t.created_at DESC LIMIT ?";

        $stmt = $this->db->prepare($sql);
        $stmt->bindValue(1, $limit, PDO::PARAM_INT);
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
