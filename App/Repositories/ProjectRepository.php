<?php
namespace App\Repositories;

use PDO;

class ProjectRepository extends BaseRepository
{
    protected string $table = 'active_services';

    public function getActiveServices(int $clientId = null)
    {
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        
        if ($clientId) {
            $sql = "SELECT s.*, p.name as plan_name,
                           i.total as invoice_total,
                           i.paid_amount as invoice_paid,
                           (i.total - i.paid_amount) as invoice_pending,
                           i.status as invoice_status,
                           i.id as invoice_id_ref,
                           (SELECT COUNT(*) FROM project_deliverables pd WHERE pd.active_service_id = s.id) as current_deliverables
                    FROM {$this->table} s 
                    JOIN service_plans p ON s.service_plan_id = p.id 
                    LEFT JOIN invoices i ON s.invoice_id = i.id
                    WHERE s.client_id = ? AND s.status = 'active' AND s.tenant_id = ?";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([$clientId, $tenantId]);
        } else {
            $sql = "SELECT s.*, u.name as client_name, p.name as plan_name,
                           i.total as invoice_total,
                           i.paid_amount as invoice_paid,
                           (i.total - i.paid_amount) as invoice_pending,
                           i.status as invoice_status,
                           i.id as invoice_id_ref
                    FROM {$this->table} s 
                    JOIN users u ON s.client_id = u.id 
                    JOIN service_plans p ON s.service_plan_id = p.id
                    LEFT JOIN invoices i ON s.invoice_id = i.id
                    WHERE s.tenant_id = ?
                    ORDER BY s.created_at DESC";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([$tenantId]);
        }

        return $stmt->fetchAll();
    }

    public function findServiceById(int $id)
    {
        $sql = "SELECT s.*, u.name as client_name, p.name as plan_name 
                FROM {$this->table} s 
                JOIN users u ON s.client_id = u.id 
                JOIN service_plans p ON s.service_plan_id = p.id 
                WHERE s.id = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function getDeliverables(int $serviceId)
    {
        $sql = "SELECT d.*, u.name as author_name 
                FROM project_deliverables d 
                JOIN users u ON d.uploaded_by = u.id 
                WHERE d.active_service_id = ? ORDER BY d.created_at DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$serviceId]);
        return $stmt->fetchAll();
    }

    public function getDeliverableById(int $id)
    {
        $sql = "SELECT d.*, s.client_id FROM project_deliverables d 
                JOIN active_services s ON d.active_service_id = s.id 
                WHERE d.id = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function createDeliverable(array $data)
    {
        $keys = array_keys($data);
        $fields = implode(', ', $keys);
        $placeholders = implode(', ', array_fill(0, count($keys), '?'));

        $sql = "INSERT INTO project_deliverables ({$fields}) VALUES ({$placeholders})";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute(array_values($data));
    }

    public function deleteDeliverable(int $id)
    {
        $stmt = $this->db->prepare("DELETE FROM project_deliverables WHERE id = ?");
        return $stmt->execute([$id]);
    }

    public function updateServiceDeliverablesCount(int $serviceId, int $total)
    {
        $stmt = $this->db->prepare("UPDATE active_services SET total_deliverables = ? WHERE id = ?");
        return $stmt->execute([$total, $serviceId]);
    }
}
