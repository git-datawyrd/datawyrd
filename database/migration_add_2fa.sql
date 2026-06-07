-- Corrección de Error: SQLSTATE[42S22]: Column not found: 1054 Unknown column 'two_factor_enabled'
-- Ejecutar en el servidor / phpMyAdmin para resolver el FATAL ERROR en ProfileController

ALTER TABLE `users` 
ADD COLUMN `two_factor_enabled` TINYINT(1) NOT NULL DEFAULT 0 AFTER `password`,
ADD COLUMN `two_factor_secret` VARCHAR(255) NULL AFTER `two_factor_enabled`;
