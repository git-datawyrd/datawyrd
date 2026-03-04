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
        $stmt = $this->db->query("SELECT * FROM {$this->table} ORDER BY id DESC");
        return $stmt->fetchAll();
    }

    public function find(int $id)
    {
        $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->fetch() ?: null;
    }

    public function create(array $data)
    {
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
        $fields = "";
        foreach ($data as $key => $value) {
            $fields .= "{$key} = ?, ";
        }
        $fields = rtrim($fields, ', ');

        $sql = "UPDATE {$this->table} SET {$fields} WHERE id = ?";
        $stmt = $this->db->prepare($sql);

        $values = array_values($data);
        $values[] = $id;

        return $stmt->execute($values);
    }

    public function delete(int $id)
    {
        $stmt = $this->db->prepare("DELETE FROM {$this->table} WHERE id = ?");
        return $stmt->execute([$id]);
    }
}
