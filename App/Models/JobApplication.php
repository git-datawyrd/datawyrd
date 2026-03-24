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
            'vacancy_name' => !empty($data['vacancy_name']) ? $data['vacancy_name'] : null,
            'skills' => isset($data['skills']) ? json_encode($data['skills'], JSON_UNESCAPED_UNICODE) : null,
            'presentation_letter' => $data['presentation_letter'] ?? null,
            'cv_path' => $data['cv_path'],
            'status' => 'new'
        ]);
        
        return $this->db->lastInsertId();
    }

    public function updateStatus($id, $status)
    {
        // Get old status first for logging
        $current = $this->findById($id);
        $oldStatus = $current['status'] ?? null;

        $stmt = $this->db->prepare("UPDATE {$this->table} SET status = :status, status_updated_at = CURRENT_TIMESTAMP WHERE id = :id");
        $success = $stmt->execute(['status' => $status, 'id' => $id]);

        if ($success && $oldStatus !== $status) {
            $this->logStatusChange($id, $oldStatus, $status);
        }
        
        return $success;
    }

    private function logStatusChange($applicationId, $old, $new)
    {
        $stmt = $this->db->prepare("INSERT INTO job_application_status_logs (application_id, old_status, new_status) VALUES (:app_id, :old, :new)");
        return $stmt->execute(['app_id' => $applicationId, 'old' => $old, 'new' => $new]);
    }

    public function getStatusLogs($applicationId)
    {
        $stmt = $this->db->prepare("SELECT * FROM job_application_status_logs WHERE application_id = :id ORDER BY created_at DESC");
        $stmt->execute(['id' => $applicationId]);
        return $stmt->fetchAll();
    }

    public function updateVacancy($id, $vacancy_name)
    {
        $stmt = $this->db->prepare("UPDATE {$this->table} SET vacancy_name = :vacancy_name WHERE id = :id");
        return $stmt->execute(['vacancy_name' => $vacancy_name, 'id' => $id]);
    }

    public function updateCvPath($id, $cvPath)
    {
        $stmt = $this->db->prepare("UPDATE {$this->table} SET cv_path = :cv_path WHERE id = :id");
        return $stmt->execute(['cv_path' => $cvPath, 'id' => $id]);
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

    public function getCandidateHistory($candidateId)
    {
        // Get all applications for this candidate with their latest status change date
        $sql = "SELECT id, vacancy_name, status, created_at, status_updated_at 
                FROM {$this->table} 
                WHERE candidate_id = :candidate_id 
                ORDER BY created_at DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(['candidate_id' => $candidateId]);
        return $stmt->fetchAll();
    }

    /**
     * Crear nueva postulación desde la vista Admin sobre un candidato existente
     */
    public function createByAdmin($candidateId, $vacancyName, $cvPath = null, $notes = null)
    {
        $sql = "INSERT INTO {$this->table} 
                (candidate_id, vacancy_name, cv_path, presentation_letter, status, status_updated_at) 
                VALUES (:candidate_id, :vacancy_name, :cv_path, :notes, 'new', CURRENT_TIMESTAMP)";

        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            'candidate_id' => $candidateId,
            'vacancy_name' => $vacancyName ?: 'Candidatura Espontánea',
            'cv_path'      => $cvPath,
            'notes'        => $notes
        ]);

        return $this->db->lastInsertId();
    }
}
