<?php
/**
 * Data Wyrd OS - Restart Failed Emails
 * Run via CLI: php tools/retry_failed_emails.php
 */

define('BASE_PATH', dirname(__DIR__));
require_once BASE_PATH . '/config/env.php';
\EnvLoader::load(BASE_PATH . '/.env');
require_once BASE_PATH . '/vendor/autoload.php';

\Core\Config::load();
$db = \Core\Database::getInstance()->getConnection();

echo "Buscando emails transaccionales marcados como 'failed'...\n";
$stmt = $db->query("UPDATE jobs SET status = 'pending', attempts = 0 WHERE status = 'failed'");
$count = $stmt->rowCount();
echo "Se han reseteado {$count} trabajos a estado 'pending'.\n";

echo "Buscando campañas de Email Marketing detenidas o pendientes...\n";
// Para Marketing, los logs en 'failed' se resetean a 'queued'
$stmtMktg = $db->query("UPDATE mktg_send_log SET status = 'queued', attempts = 0 WHERE status IN ('failed', 'processing')");
$mktgCount = $stmtMktg->rowCount();
echo "Se han reseteado {$mktgCount} correos de marketing a estado 'queued'.\n";

echo "\n¡Los workers procesarán automáticamente estos correos en su próximo ciclo!\n";
