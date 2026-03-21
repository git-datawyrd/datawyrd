-- 1. Crear tabla de candidatos
CREATE TABLE IF NOT EXISTS candidates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(50) NOT NULL,
    linkedin_url VARCHAR(255) NULL,
    country VARCHAR(100) NULL,
    city VARCHAR(100) NULL,
    address VARCHAR(255) NULL,
    user_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_candidates_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Migrar datos existentes de job_applications a candidates (para preservar postulantes previos)
INSERT IGNORE INTO candidates (first_name, last_name, email, phone, linkedin_url, user_id, created_at)
SELECT first_name, last_name, email, phone, linkedin_url, user_id, created_at 
FROM job_applications
GROUP BY email;

-- 3. Modificar tabla job_applications para preparar la vinculación
ALTER TABLE job_applications 
ADD COLUMN candidate_id INT NULL AFTER id,
ADD COLUMN vacancy_name VARCHAR(150) DEFAULT 'Candidatura Espontánea' AFTER candidate_id,
ADD COLUMN status_updated_at TIMESTAMP NULL AFTER status;

-- 4. Vincular registros existentes
UPDATE job_applications ja
JOIN candidates c ON ja.email = c.email
SET ja.candidate_id = c.id;

-- 5. Hacer `candidate_id` obligatorio y crear la clave foránea
-- OMITIMOS LA RESTRICCIÓN FOREIGN KEY FÍSICA para simplificar fallos de motores, 
-- pero garantizamos integridad desde el código aplicativo.
ALTER TABLE job_applications MODIFY COLUMN candidate_id INT NOT NULL;
ALTER TABLE job_applications ADD INDEX idx_candidate_id (candidate_id);

-- 6. Actualizar las opciones del ENUM de estados en job_applications
ALTER TABLE job_applications MODIFY COLUMN status ENUM('new', 'reviewed', 'contacted', 'unreachable', 'scheduled', 'technical_interview', 'shortlisted', 'rejected', 'hired') DEFAULT 'new';

-- 7. Eliminar columnas redundantes que ahora viven en candidates
ALTER TABLE job_applications 
DROP COLUMN first_name,
DROP COLUMN last_name,
DROP COLUMN email,
DROP COLUMN phone,
DROP COLUMN linkedin_url,
DROP COLUMN user_id;
