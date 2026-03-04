-- Data Wyrd - Security Hardening (Fase 10)
-- Ejecutar en Entorno Local, Demo y Producción

-- 1. Creación de la tabla `login_logs` para auditoría y anti brute-force
CREATE TABLE IF NOT EXISTS `login_logs` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NULL,
  `ip_address` VARCHAR(45) NOT NULL,
  `email_attempted` VARCHAR(255) NOT NULL,
  `success` TINYINT(1) NOT NULL DEFAULT 0,
  `user_agent` TEXT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_ip_address` (`ip_address`),
  INDEX `idx_email_attempted` (`email_attempted`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
