<?php
namespace App\Repositories;

use Core\Database;
use PDO;

/**
 * Abstract Base Repository
 */
abstract class BaseRepository implements RepositoryInterface
{
    protected $db;
    protected string $table;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }

    public function all()
    {
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $sql = "SELECT * FROM {$this->table} WHERE tenant_id = ? AND deleted_at IS NULL ORDER BY id DESC";
        try {
            $stmt = $this->db->prepare($sql);
            $stmt->execute([$tenantId]);
            return $stmt->fetchAll();
        } catch (\PDOException $e) {
            // Fallback for tables without those columns
            $stmt = $this->db->query("SELECT * FROM {$this->table} ORDER BY id DESC");
            return $stmt->fetchAll();
        }
    }

    public function find(int $id)
    {
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $sql = "SELECT * FROM {$this->table} WHERE id = ? AND tenant_id = ? AND deleted_at IS NULL";
        try {
            $stmt = $this->db->prepare($sql);
            $stmt->execute([$id, $tenantId]);
            return $stmt->fetch() ?: null;
        } catch (\PDOException $e) {
            $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE id = ?");
            $stmt->execute([$id]);
            return $stmt->fetch() ?: null;
        }
    }

    public function create(array $data)
    {
        // Auto-inject tenant_id if not present
        if (!isset($data['tenant_id'])) {
            $data['tenant_id'] = \Core\Config::get('current_tenant_id', 1);
        }

        $keys = array_keys($data);
        $fields = implode(', ', $keys);
        $placeholders = implode(', ', array_fill(0, count($keys), '?'));

        $sql = "INSERT INTO {$this->table} ({$fields}) VALUES ({$placeholders})";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(array_values($data));

        return $this->db->lastInsertId();
    }

    public function update(int $id, array $data)
    {
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $fields = "";
        foreach ($data as $key => $value) {
            $fields .= "{$key} = ?, ";
        }
        $fields = rtrim($fields, ', ');

        $sql = "UPDATE {$this->table} SET {$fields} WHERE id = ? AND tenant_id = ?";
        try {
            $stmt = $this->db->prepare($sql);
            $values = array_values($data);
            $values[] = $id;
            $values[] = $tenantId;
            return $stmt->execute($values);
        } catch (\PDOException $e) {
            $sql = "UPDATE {$this->table} SET {$fields} WHERE id = ?";
            $stmt = $this->db->prepare($sql);
            $values = array_values($data);
            $values[] = $id;
            return $stmt->execute($values);
        }
    }

    public function delete(int $id)
    {
        // Soft delete if possible, else hard delete
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        try {
            $stmt = $this->db->prepare("UPDATE {$this->table} SET deleted_at = NOW() WHERE id = ? AND tenant_id = ?");
            return $stmt->execute([$id, $tenantId]);
        } catch (\PDOException $e) {
            $stmt = $this->db->prepare("DELETE FROM {$this->table} WHERE id = ? AND tenant_id = ?");
            try {
                return $stmt->execute([$id, $tenantId]);
            } catch (\PDOException $e2) {
                // Hardest fallback
                $stmt = $this->db->prepare("DELETE FROM {$this->table} WHERE id = ?");
                return $stmt->execute([$id]);
            }
        }
    }
}
