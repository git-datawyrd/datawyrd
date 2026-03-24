-- Migración: Tabla para tokens OTP de actualización de candidatos
-- Ejecutar en producción ANTES de desplegar los cambios de código
-- Fecha: 2026-03-23

CREATE TABLE IF NOT EXISTS candidate_update_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    candidate_id INT NOT NULL,
    token VARCHAR(6) NOT NULL,
    expires_at DATETIME NOT NULL,
    used_at DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_candidate_token (candidate_id, token),
    INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
