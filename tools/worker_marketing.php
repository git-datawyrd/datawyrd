<?php
/**
 * Data Wyrd OS - Marketing Queue Worker
 *
 * Worker dedicado al procesamiento asíncrono de campañas de email marketing.
 * Diseñado para entornos de hosting compartido (Hostinger/cPanel) donde
 * los workers persistentes no están disponibles — se ejecuta vía cron:
 *
 *   Cron recomendado (cada 5 minutos):
 *   *\/5 * * * * php /path/to/datawyrd/tools/worker_marketing.php >> /path/to/storage/logs/marketing_worker.log 2>&1
 *
 * Estrategia: el worker procesa un lote configurado (MARKETING_BATCH_SIZE)
 * y termina. El cron lo vuelve a lanzar en el próximo ciclo.
 * Esto evita procesos PHP zombies en hosting compartido.
 *
 * Uso manual:
 *   php tools/worker_marketing.php [--dry-run] [--batch=N]
 */

define('BASE_PATH', dirname(__DIR__));

require_once BASE_PATH . '/config/env.php';
\EnvLoader::load(BASE_PATH . '/.env');
require_once BASE_PATH . '/vendor/autoload.php';

// Autoloader de clases del proyecto
spl_autoload_register(function ($class) {
    $file = BASE_PATH . '/' . str_replace('\\', '/', $class) . '.php';
    if (file_exists($file)) {
        require_once $file;
    }
});

\Core\Config::load();

// =========================================================================
// OPCIONES DE CLI
// =========================================================================
$dryRun    = in_array('--dry-run', $argv ?? [], true);
$batchArg  = null;
foreach (($argv ?? []) as $arg) {
    if (str_starts_with($arg, '--batch=')) {
        $batchArg = (int) substr($arg, 8);
    }
}

if ($dryRun) {
    echo "[DRY-RUN] No se enviarán emails reales.\n";
}

// =========================================================================
// LOCK FILE (evita ejecuciones paralelas en hosting)
// =========================================================================
$lockFile = BASE_PATH . '/storage/locks/marketing_worker.lock';
$lockDir  = dirname($lockFile);
if (!is_dir($lockDir)) {
    mkdir($lockDir, 0755, true);
}

if (file_exists($lockFile)) {
    $lockAge = time() - (int) file_get_contents($lockFile);
    if ($lockAge < 300) { // 5 minutos de tolerancia
        echo "[" . date('Y-m-d H:i:s') . "] Worker ya en ejecución (lock activo hace {$lockAge}s). Saliendo.\n";
        exit(0);
    }
    // Lock expirado (worker anterior colgado) — continuar
    echo "[" . date('Y-m-d H:i:s') . "] Lock expirado ({$lockAge}s). Tomando control.\n";
}

file_put_contents($lockFile, time());

// Asegurar liberación del lock al terminar
register_shutdown_function(function () use ($lockFile) {
    if (file_exists($lockFile)) {
        unlink($lockFile);
    }
});

// =========================================================================
// PROCESAMIENTO
// =========================================================================
try {
    $db   = \Core\Database::getInstance()->getConnection();
    $repo = new \App\Repositories\MarketingRepository($db);

    // Override batch size desde CLI si se proporcionó
    if ($batchArg !== null) {
        \Core\Config::set('marketing.rate.batch_size', $batchArg);
    }

    $service = new \App\Services\Marketing\CampaignService($repo);

    $start = microtime(true);
    echo "[" . date('Y-m-d H:i:s') . "] Marketing Worker iniciado. Provider: "
        . \Core\Marketing\EmailProviderFactory::make()->getProviderName() . "\n";

    if ($dryRun) {
        // En dry-run, obtener el conteo pendiente sin procesar
        $stmt = $db->query("SELECT COUNT(*) FROM mktg_send_log WHERE status = 'queued'");
        $count = $stmt->fetchColumn();
        echo "[DRY-RUN] Emails en cola: {$count}\n";
    } else {
        $result = $service->processBatch();
        $elapsed = round(microtime(true) - $start, 2);

        echo "[" . date('Y-m-d H:i:s') . "] Lote completado en {$elapsed}s: "
            . "Procesados={$result['processed']}, "
            . "Enviados={$result['sent']}, "
            . "Fallidos={$result['failed']}\n";

        \Core\SecurityLogger::log('marketing_worker_batch', [
            'processed' => $result['processed'],
            'sent'      => $result['sent'],
            'failed'    => $result['failed'],
            'elapsed_s' => $elapsed,
        ], 'INFO');
    }

    // =========================================================================
    // LIMPIAR CAMPAÑAS ENVIADAS: marcar 'sent' si send_log está completo
    // =========================================================================
    if (!$dryRun) {
        $db->exec(
            "UPDATE mktg_campaigns c
             SET c.status = 'sent', c.sent_at = NOW()
             WHERE c.status = 'sending'
               AND NOT EXISTS (
                   SELECT 1 FROM mktg_send_log sl
                   WHERE sl.campaign_id = c.id
                     AND sl.status IN ('queued', 'processing')
               )"
        );
    }

    // =========================================================================
    // ACTIVAR CAMPAÑAS PROGRAMADAS QUE YA VENCIERON
    // =========================================================================
    if (!$dryRun) {
        $activatedStmt = $db->prepare(
            "UPDATE mktg_campaigns
             SET status = 'sending'
             WHERE status = 'scheduled'
               AND scheduled_at IS NOT NULL
               AND scheduled_at <= NOW()"
        );
        $activatedStmt->execute();
        $activatedCount = $activatedStmt->rowCount();
        if ($activatedCount > 0) {
            echo "[" . date('Y-m-d H:i:s') . "] {$activatedCount} campaña(s) activadas por scheduler.\n";
        }
    }

} catch (\Exception $e) {
    echo "[ERROR] " . date('Y-m-d H:i:s') . ": " . $e->getMessage() . "\n";
    \Core\SecurityLogger::log('marketing_worker_crash', [
        'error' => $e->getMessage(),
        'trace' => $e->getTraceAsString(),
    ], 'ERROR');
    exit(1);
}

echo "[" . date('Y-m-d H:i:s') . "] Worker finalizado correctamente.\n";
exit(0);
