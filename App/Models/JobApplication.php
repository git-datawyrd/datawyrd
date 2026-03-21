<?php
namespace App\Models;

use Core\Model;

class JobApplication extends Model
{
    protected $table = 'job_applications';

    public function create($data)
    {
        $sql = "INSERT INTO {$this->table} 
                (candidate_id, vacancy_name, skills, presentation_letter, cv_path, status, status_updated_at) 
                VALUES (:candidate_id, :vacancy_name, :skills, :presentation_letter, :cv_path, :status, CURRENT_TIMESTAMP)";

        $stmt = $this->db->prepare($sql);
        
        $stmt->execute([
            'candidate_id' => $data['candidate_id'],
            'vacancy_name' => $data['vacancy_name'] ?? 'Candidatura Espontánea',
            'skills' => isset($data['skills']) ? json_encode($data['skills'], JSON_UNESCAPED_UNICODE) : null,
            'presentation_letter' => $data['presentation_letter'] ?? null,
            'cv_path' => $data['cv_path'],
            'status' => 'new'
        ]);
        
        return $this->db->lastInsertId();
    }

    public function updateStatus($id, $status)
    {
        $stmt = $this->db->prepare("UPDATE {$this->table} SET status = :status, status_updated_at = CURRENT_TIMESTAMP WHERE id = :id");
        return $stmt->execute(['status' => $status, 'id' => $id]);
    }

    public function updateVacancy($id, $vacancy_name)
    {
        $stmt = $this->db->prepare("UPDATE {$this->table} SET vacancy_name = :vacancy_name WHERE id = :id");
        return $stmt->execute(['vacancy_name' => $vacancy_name, 'id' => $id]);
    }

    public function findAll()
    {
        // Join with candidates to get candidate details
        $sql = "SELECT ja.*, c.first_name, c.last_name, c.email, c.phone, c.linkedin_url, c.country, c.city, c.address 
                FROM {$this->table} ja 
                JOIN candidates c ON ja.candidate_id = c.id 
                ORDER BY ja.created_at DESC";
                
        $stmt = $this->db->query($sql);
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
        $sql = "SELECT ja.*, c.first_name, c.last_name, c.email, c.phone, c.linkedin_url, c.country, c.city, c.address 
                FROM {$this->table} ja 
                JOIN candidates c ON ja.candidate_id = c.id 
                WHERE ja.id = :id";
                
        $stmt = $this->db->prepare($sql);
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        if ($row && !empty($row['skills'])) {
            $row['skills'] = json_decode($row['skills'], true);
        }
        return $row;
    }

    public function findByCandidateId($candidateId)
    {
        $sql = "SELECT * FROM {$this->table} WHERE candidate_id = :candidate_id ORDER BY created_at DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(['candidate_id' => $candidateId]);
        return $stmt->fetchAll();
    }
}
