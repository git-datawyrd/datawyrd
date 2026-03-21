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

    public function create($data)
    {
        $sql = "INSERT INTO {$this->table} 
                (first_name, last_name, email, phone, linkedin_url, country, city, address) 
                VALUES (:first_name, :last_name, :email, :phone, :linkedin_url, :country, :city, :address)";

        $stmt = $this->db->prepare($sql);
        
        $stmt->execute([
            'first_name' => $data['first_name'],
            'last_name' => $data['last_name'],
            'email' => $data['email'],
            'phone' => $data['phone'],
            'linkedin_url' => $data['linkedin_url'] ?? null,
            'country' => $data['country'] ?? null,
            'city' => $data['city'] ?? null,
            'address' => $data['address'] ?? null
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
            'city' => $data['city'] ?? null,
            'address' => $data['address'] ?? null,
            'id' => $id
        ]);
    }
}
