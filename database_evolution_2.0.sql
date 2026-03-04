-- DATA WYRD EVOLUTION 2.0 - SQL MIGRATION
-- Copia y pega esto en el SQL de phpMyAdmin en Hostinger

CREATE TABLE IF NOT EXISTS `jwt_refresh_tokens` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `token` VARCHAR(255) NOT NULL UNIQUE,
    `expires_at` DATETIME NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX(`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `user_dashboard_config` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `widget_key` VARCHAR(50) NOT NULL,
    `is_visible` TINYINT(1) DEFAULT 1,
    `sort_order` INT DEFAULT 0,
    UNIQUE KEY `user_widget_unique` (`user_id`, `widget_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `users` MODIFY COLUMN `phone` VARCHAR(255) NULL;
