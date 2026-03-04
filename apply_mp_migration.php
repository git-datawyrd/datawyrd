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

    try {
        $pdo->exec("ALTER TABLE `payment_receipts` ADD COLUMN `mp_payment_id` VARCHAR(255) NULL AFTER `status`");
        echo "Column mp_payment_id added to payment_receipts.\n";
    } catch (Exception $e) {
        if (strpos($e->getMessage(), 'Duplicate column name') !== false) {
            echo "Column mp_payment_id already exists.\n";
        } else {
            echo "Error adding column: " . $e->getMessage() . "\n";
        }
    }

    echo "Migration completed.\n";

} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
