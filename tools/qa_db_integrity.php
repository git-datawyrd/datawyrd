<?php
require_once __DIR__ . '/../Core/bootstrap.php';
$db = \Core\Database::getInstance()->getConnection();

$report = [
    'orphans' => [],
    'empty_tables' => []
];

// 1. Check empty tables
$tables = $db->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
foreach ($tables as $t) {
    $count = $db->query("SELECT COUNT(*) FROM `$t`")->fetchColumn();
    if ($count == 0) {
        $report['empty_tables'][] = $t;
    }
}

// 2. Check orphans (tickets -> users)
try {
    $orphanTickets = $db->query("SELECT COUNT(*) FROM tickets WHERE client_id NOT IN (SELECT id FROM users)")->fetchColumn();
    if ($orphanTickets > 0) $report['orphans']['tickets_without_users'] = $orphanTickets;
} catch (Exception $e) {}

// (invoices -> budgets)
try {
    $orphanInvoices = $db->query("SELECT COUNT(*) FROM invoices WHERE budget_id NOT IN (SELECT id FROM budgets) AND budget_id IS NOT NULL")->fetchColumn();
    if ($orphanInvoices > 0) $report['orphans']['invoices_without_budgets'] = $orphanInvoices;
} catch (Exception $e) {}

// (active_services -> invoices)
try {
    $orphanServices = $db->query("SELECT COUNT(*) FROM active_services WHERE invoice_id NOT IN (SELECT id FROM invoices)")->fetchColumn();
    if ($orphanServices > 0) $report['orphans']['services_without_invoices'] = $orphanServices;
} catch (Exception $e) {}

echo json_encode($report, JSON_PRETTY_PRINT);
