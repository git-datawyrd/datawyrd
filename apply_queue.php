<?php
define('BASE_PATH', __DIR__);
require_once __DIR__ . '/config/env.php';
\EnvLoader::load(__DIR__ . '/.env');
require_once __DIR__ . '/Core/Database.php';
require_once __DIR__ . '/Core/Config.php';

// manual init
\Core\Config::load();

try {
    $pdo = \Core\Database::getInstance()->getConnection();

    echo "Creating jobs table...\n";
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS `jobs` (
          `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
          `job_class` varchar(255) NOT NULL,
          `payload` json NOT NULL,
          `attempts` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
          `status` enum('pending','processing','failed') NOT NULL DEFAULT 'pending',
          `error_message` text DEFAULT NULL,
          `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
          `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ");

    try {
        $pdo->exec("ALTER TABLE `invoices` ADD COLUMN `mp_preference_id` VARCHAR(255) NULL AFTER `status`");
        echo "Column mp_preference_id added to invoices.\n";
    } catch (Exception $e) {
        if (strpos($e->getMessage(), 'Duplicate column name') !== false) {
            echo "Column mp_preference_id already exists.\n";
        } else {
            echo "Error adding column: " . $e->getMessage() . "\n";
        }
    }

    echo "Migration completed.\n";

} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
