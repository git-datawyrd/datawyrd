<?php
define('BASE_PATH', __DIR__);
require 'Core/Config.php';
require 'Core/Database.php';

use Core\Config;
use Core\Database;

if (file_exists('.env')) {
    $lines = file('.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos($line, '=') !== false) {
            putenv($line);
        }
    }
}

Config::load();

try {
    $db = Database::getInstance()->getConnection();
    $tables = ['users', 'jwt_refresh_tokens', 'active_services', 'audit_logs', 'user_dashboard_config', 'budget_items', 'chat_messages', 'notifications', 'payment_receipts', 'tickets', 'sessions', 'service_plans', 'budgets', 'budget_items'];
    foreach ($tables as $table) {
        echo "\nTable: $table\n";
        try {
            $stmt = $db->query("DESCRIBE $table");
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                echo $row['Field'] . ' | ' . $row['Type'] . ' | ' . $row['Null'] . ' | ' . $row['Default'] . "\n";
            }
            echo "--- Indices ---\n";
            $stmt = $db->query("SHOW INDEX FROM $table");
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                echo $row['Key_name'] . ' | ' . $row['Column_name'] . ' | ' . $row['Non_unique'] . "\n";
            }
        } catch (Exception $et) {
            echo "Error: $table not found.\n";
        }
    }
} catch (Exception $e) {
    echo $e->getMessage();
}
