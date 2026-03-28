<?php
$db = new PDO("mysql:host=localhost;dbname=datawyrd;charset=utf8mb4", "root", "");
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

try {
    $db->exec("ALTER TABLE invoices MODIFY COLUMN status ENUM('draft', 'unpaid', 'processing', 'partial', 'paid', 'overdue') NOT NULL DEFAULT 'unpaid'");
    echo "Status ENUM altered\n";
} catch (Exception $e) {
    echo $e->getMessage() . "\n";
}

try {
    $db->exec("ALTER TABLE invoices ADD COLUMN paid_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER total");
    echo "paid_amount column added\n";
} catch (Exception $e) {
    echo $e->getMessage() . "\n";
}

echo "Done\n";
