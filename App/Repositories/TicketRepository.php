<?php
namespace App\Repositories;

use PDO;

class TicketRepository extends BaseRepository
{
    protected string $table = 'tickets';

    /**
     * Get all tickets with joins (optionally filtered by client)
     */
    public function all(int $clientId = null)
    {
        if ($clientId) {
            $sql = "SELECT t.*, sp.name as plan_name 
                    FROM {$this->table} t 
                    JOIN service_plans sp ON t.service_plan_id = sp.id 
                    WHERE t.client_id = ? 
                    ORDER BY t.created_at DESC";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([$clientId]);
        } else {
            $sql = "SELECT t.*, u.name as client_name, sp.name as plan_name, s.name as service_name 
                    FROM {$this->table} t 
                    JOIN users u ON t.client_id = u.id 
                    JOIN service_plans sp ON t.service_plan_id = sp.id 
                    JOIN services s ON sp.service_id = s.id 
                    ORDER BY t.created_at DESC";
            $stmt = $this->db->query($sql);
        }

        return $stmt->fetchAll();
    }

    /**
     * Find a ticket with full details (Used in detail pages)
     */
    public function find(int $id)
    {
        $sql = "SELECT t.*, u.name as client_name, u.email as client_email, u.company as client_company, 
                       sp.name as plan_name, s.name as service_name 
                FROM {$this->table} t 
                JOIN users u ON t.client_id = u.id 
                JOIN service_plans sp ON t.service_plan_id = sp.id 
                JOIN services s ON sp.service_id = s.id 
                WHERE t.id = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function create(array $data)
    {
        // Auto-inject ticket number if not present
        if (!isset($data['ticket_number'])) {
            $data['ticket_number'] = 'TKT-' . strtoupper(bin2hex(random_bytes(3)));
        }
        return parent::create($data);
    }

    public function updateStatus(int $id, string $status, int $assignedTo = null)
    {
        $assignSql = $assignedTo ? ", assigned_to = ?" : "";
        $params = [$status];
        if ($assignedTo) $params[] = $assignedTo;
        $params[] = $id;

        $sql = "UPDATE {$this->table} SET status = ?, updated_at = NOW() {$assignSql} WHERE id = ?";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute($params);
    }

    public function getMessages(int $ticketId)
    {
        $stmt = $this->db->prepare("SELECT m.*, u.name as user_name, u.role as user_role 
                                     FROM chat_messages m 
                                     LEFT JOIN users u ON m.user_id = u.id 
                                     WHERE m.ticket_id = ? ORDER BY m.created_at ASC");
        $stmt->execute([$ticketId]);
        return $stmt->fetchAll();
    }

    public function getRecentWithClients(int $limit, array $excludeStatuses = [])
    {
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $excludeSql = "";
        $params = [$tenantId];
        
        if (!empty($excludeStatuses)) {
            $placeholders = implode(',', array_fill(0, count($excludeStatuses), '?'));
            $excludeSql = " AND t.status NOT IN ($placeholders)";
            $params = array_merge($params, $excludeStatuses);
        }
        
        $sql = "SELECT t.*, u.name as client_name, u.email as client_email, 
                       sp.name as plan_name, s.name as service_name 
                FROM {$this->table} t 
                JOIN users u ON t.client_id = u.id 
                JOIN service_plans sp ON t.service_plan_id = sp.id 
                JOIN services s ON sp.service_id = s.id 
                WHERE t.tenant_id = ? {$excludeSql}
                ORDER BY t.created_at DESC LIMIT ?";
        
        $stmt = $this->db->prepare($sql);
        $i = 1;
        foreach ($params as $p) {
            $stmt->bindValue($i++, $p);
        }
        $stmt->bindValue($i, $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function getStats()
    {
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare("SELECT 
                                    SUM(CASE WHEN status = 'open' THEN 1 ELSE 0 END) as open,
                                    SUM(CASE WHEN status = 'closed' THEN 1 ELSE 0 END) as closed,
                                    SUM(CASE WHEN status = 'void' THEN 1 ELSE 0 END) as void,
                                    COUNT(*) as total
                                    FROM {$this->table} WHERE tenant_id = ?");
        $stmt->execute([$tenantId]);
        return $stmt->fetch();
    }

    public function addMessage(int $ticketId, int $userId, string $message, string $type = 'user')
    {
        $realUserId = ($userId === 0) ? null : $userId;
        $sql = "INSERT INTO chat_messages (ticket_id, user_id, message, message_type, created_at) VALUES (?, ?, ?, ?, NOW())";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([$ticketId, $realUserId, $message, $type]);
    }
}
