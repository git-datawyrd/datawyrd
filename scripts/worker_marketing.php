<?php
/**
 * Worker para Email Marketing
 * 
 * Este script procesa la cola de envíos de marketing de forma asíncrona.
 * Debe configurarse como un CRON o correr en background.
 * 
 * Uso: php scripts/worker_marketing.php
 */

require_once __DIR__ . '/../Core/bootstrap.php';

use App\Repositories\MarketingRepository;
use App\Services\Marketing\CampaignService;
use Core\Database;

try {
    $db = Database::getInstance()->getConnection();
    $repo = new MarketingRepository($db);
    $service = new CampaignService($repo);

    echo "[" . date('Y-m-d H:i:s') . "] Iniciando procesamiento de lote de Marketing...\n";

    $result = $service->processBatch();

    echo "[" . date('Y-m-d H:i:s') . "] Lote procesado. Procesados: {$result['processed']}, Enviados: {$result['sent']}, Fallidos: {$result['failed']}\n";

} catch (\Throwable $e) {
    echo "[" . date('Y-m-d H:i:s') . "] FATAL ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
