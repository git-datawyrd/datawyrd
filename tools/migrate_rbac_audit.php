<?php
/**
 * Migration: Create RBAC Audit Logs Table
 * Phase 11.5.0 Hardening
 */
require_once __DIR__ . '/../Core/bootstrap.php';

use Core\Database;

$db = Database::getInstance()->getConnection();

echo "Creating rbac_audit_logs table...\n";

$sql = "CREATE TABLE IF NOT EXISTS rbac_audit_logs (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    admin_id INT(11) NOT NULL,
    target_user_id INT(11) NOT NULL,
    action VARCHAR(50) NOT NULL, -- 'role_change', 'permission_assignment'
    old_value TEXT,
    new_value TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";


try {
    $db->exec($sql);
    echo "Success: Table rbac_audit_logs created.\n";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
