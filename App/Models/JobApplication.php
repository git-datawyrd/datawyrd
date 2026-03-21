<?php
namespace App\Models;

use Core\Model;

class JobApplication extends Model
{
    protected $table = 'job_applications';

    public function create($data)
    {
        $sql = "INSERT INTO {$this->table} 
                (first_name, last_name, email, phone, linkedin_url, skills, presentation_letter, cv_path, user_id) 
                VALUES (:first_name, :last_name, :email, :phone, :linkedin_url, :skills, :presentation_letter, :cv_path, :user_id)";

        $stmt = $this->db->prepare($sql);
        
        $stmt->execute([
            'first_name' => $data['first_name'],
            'last_name' => $data['last_name'],
            'email' => $data['email'],
            'phone' => $data['phone'],
            'linkedin_url' => $data['linkedin_url'] ?? null,
            'skills' => isset($data['skills']) ? json_encode($data['skills'], JSON_UNESCAPED_UNICODE) : null,
            'presentation_letter' => $data['presentation_letter'] ?? null,
            'cv_path' => $data['cv_path'],
            'user_id' => $data['user_id'] ?? null
        ]);
        
        return $this->db->lastInsertId();
    }

    public function updateStatus($id, $status)
    {
        $stmt = $this->db->prepare("UPDATE {$this->table} SET status = :status WHERE id = :id");
        return $stmt->execute(['status' => $status, 'id' => $id]);
    }

    public function findAll()
    {
        $stmt = $this->db->query("SELECT * FROM {$this->table} ORDER BY created_at DESC");
        $results = $stmt->fetchAll();
        foreach ($results as &$row) {
            if (!empty($row['skills'])) {
                $row['skills'] = json_decode($row['skills'], true);
            }
        }
        return $results;
    }

    public function findById($id)
    {
        $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE id = :id");
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        if ($row && !empty($row['skills'])) {
            $row['skills'] = json_decode($row['skills'], true);
        }
        return $row;
    }
}
