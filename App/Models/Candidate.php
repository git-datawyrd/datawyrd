<?php
namespace App\Models;

use Core\Model;

class Candidate extends Model
{
    protected $table = 'candidates';

    public function findByEmail($email)
    {
        $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE email = :email");
        $stmt->execute(['email' => $email]);
        return $stmt->fetch();
    }

    public function findById($id)
    {
        $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE id = :id");
        $stmt->execute(['id' => $id]);
        return $stmt->fetch();
    }

    public function create($data)
    {
        $sql = "INSERT INTO {$this->table} 
                (first_name, last_name, email, phone, linkedin_url, country, city, address) 
                VALUES (:first_name, :last_name, :email, :phone, :linkedin_url, :country, :city, :address)";

        $stmt = $this->db->prepare($sql);
        
        $stmt->execute([
            'first_name'   => $data['first_name'],
            'last_name'    => $data['last_name'],
            'email'        => $data['email'],
            'phone'        => $data['phone'],
            'linkedin_url' => $data['linkedin_url'] ?? null,
            'country'      => $data['country'] ?? null,
            'city'         => $data['city'] ?? null,
            'address'      => $data['address'] ?? null
        ]);
        
        return $this->db->lastInsertId();
    }

    public function updateProfile($id, $data)
    {
        $sql = "UPDATE {$this->table} SET 
                country = :country,
                city = :city,
                address = :address
                WHERE id = :id";
                
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            'country' => $data['country'] ?? null,
            'city'    => $data['city'] ?? null,
            'address' => $data['address'] ?? null,
            'id'      => $id
        ]);
    }

    /**
     * Actualización completa de perfil (datos personales + CV opcional) tras verificación OTP
     */
    public function updateFullProfile($id, $data)
    {
        $fields = [];
        $params = ['id' => $id];

        $allowed = ['first_name', 'last_name', 'phone', 'linkedin_url', 'country', 'city', 'address'];
        foreach ($allowed as $field) {
            if (isset($data[$field])) {
                $fields[] = "{$field} = :{$field}";
                $params[$field] = $data[$field];
            }
        }

        if (empty($fields)) return false;

        $sql = "UPDATE {$this->table} SET " . implode(', ', $fields) . " WHERE id = :id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute($params);
    }

    // --- Métodos OTP ---

    /**
     * Genera un token OTP de 6 dígitos y lo guarda en BD con expiración de 15 minutos
     */
    public function createUpdateToken($candidateId)
    {
        // Invalidar tokens previos no usados
        $this->db->prepare("UPDATE candidate_update_tokens SET used_at = NOW() WHERE candidate_id = :id AND used_at IS NULL")
                 ->execute(['id' => $candidateId]);

        $token = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);
        $expires = date('Y-m-d H:i:s', strtotime('+15 minutes'));

        $stmt = $this->db->prepare(
            "INSERT INTO candidate_update_tokens (candidate_id, token, expires_at) VALUES (:cid, :token, :exp)"
        );
        $stmt->execute(['cid' => $candidateId, 'token' => $token, 'exp' => $expires]);

        return $token;
    }

    /**
     * Verifica que el token OTP sea válido, no expirado y no usado
     * Devuelve el candidate_id si es válido, false si no
     */
    public function verifyUpdateToken($candidateId, $token)
    {
        $stmt = $this->db->prepare(
            "SELECT id FROM candidate_update_tokens 
             WHERE candidate_id = :cid 
               AND token = :token 
               AND used_at IS NULL 
               AND expires_at > NOW()
             LIMIT 1"
        );
        $stmt->execute(['cid' => $candidateId, 'token' => $token]);
        $row = $stmt->fetch();

        if ($row) {
            // Marcar como usado
            $this->db->prepare("UPDATE candidate_update_tokens SET used_at = NOW() WHERE id = :id")
                     ->execute(['id' => $row['id']]);
            return true;
        }
        return false;
    }
}
