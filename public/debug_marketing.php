<?php
require_once __DIR__ . '/../Core/bootstrap.php';

$campaignId = isset($_GET['campaign_id']) ? (int)$_GET['campaign_id'] : 0;
if (!$campaignId) {
    die("Provee un campaign_id, ej: ?campaign_id=3");
}

$db = \Core\Database::getInstance()->getConnection();

// Manual run trigger
$run = isset($_GET['run']) ? (int)$_GET['run'] : 0;
if ($run) {
    echo "<h2>Ejecutando Lote de Marketing Manualmente...</h2>";
    echo "<pre>";
    try {
        $job = new \App\Jobs\MarketingBatchJob();
        $job->handle([]);
        echo "Lote ejecutado con éxito.\n";
    } catch (\Exception $e) {
        echo "Error en la ejecución: " . $e->getMessage() . "\n" . $e->getTraceAsString() . "\n";
    }
    echo "</pre>";
    echo "<hr>";
}

echo "<h2>Debug Campaign ID {$campaignId}</h2>";
echo "<pre>";


// 1. Check campaign
$stmt = $db->prepare("SELECT * FROM mktg_campaigns WHERE id = ?");
$stmt->execute([$campaignId]);
$campaign = $stmt->fetch();

if (!$campaign) {
    die("Campaign no existe.");
}
print_r($campaign);

$listId = $campaign['list_id'];
$tenantId = $campaign['tenant_id'];

// 2. Count total contacts in list
$stmt = $db->prepare("SELECT COUNT(*) FROM mktg_contacts WHERE list_id = ?");
$stmt->execute([$listId]);
$total = $stmt->fetchColumn();
echo "\nContactos totales en la lista {$listId}: {$total}\n";

// 3. Count contacts that match exactly the INSERT conditions
$sql = "SELECT COUNT(*)
        FROM mktg_contacts c
        WHERE c.list_id = ?
          AND c.tenant_id = ?
          AND c.status = 'subscribed'
          AND c.deleted_at IS NULL
          AND NOT EXISTS (SELECT 1 FROM blacklist b WHERE b.email = c.email)";

$stmt = $db->prepare($sql);
$stmt->execute([$listId, $tenantId]);
$eligible = $stmt->fetchColumn();
echo "Contactos elegibles para envío (subscribed, no borrados, no blacklist, tenant ok): {$eligible}\n";

if ($eligible == 0) {
    echo "\nPosibles razones de por qué es 0:\n";
    
    $stmt = $db->prepare("SELECT status, tenant_id, deleted_at, COUNT(*) as c FROM mktg_contacts WHERE list_id = ? GROUP BY status, tenant_id, deleted_at");
    $stmt->execute([$listId]);
    $stats = $stmt->fetchAll();
    echo "Distribución de contactos reales en esa lista:\n";
    print_r($stats);
}

// 4. Check send log for this campaign
echo "\n--- ESTADO DE COLA DE ENVÍOS (mktg_send_log) ---\n";
$stmt = $db->prepare("SELECT status, COUNT(*) as qty, MAX(attempts) as max_attempts FROM mktg_send_log WHERE campaign_id = ? GROUP BY status");
$stmt->execute([$campaignId]);
$sendLogSummary = $stmt->fetchAll();
if (empty($sendLogSummary)) {
    echo "No hay registros en mktg_send_log para esta campaña. (La campaña aún no ha hidratado la cola o falló al hacerlo).\n";
} else {
    print_r($sendLogSummary);
    
    // Detailed list of send logs (first 50)
    $stmt = $db->prepare("SELECT id, email, status, sent_at, error_message, attempts FROM mktg_send_log WHERE campaign_id = ? LIMIT 50");
    $stmt->execute([$campaignId]);
    $logs = $stmt->fetchAll();
    echo "\nDetalle de envíos (hasta 50):\n";
    print_r($logs);
}

// 5. Check active marketing provider
echo "\n--- CONFIGURACIÓN DE PROVEEDOR ---\n";
$mailEnabled = \Core\Config::get('mail_enabled') ? 'SÍ' : 'NO';
$mktgProvider = \Core\Config::get('marketing.provider', 'smtp');
echo "Email habilitado globalmente (mail_enabled): {$mailEnabled}\n";
echo "Proveedor marketing configurado: {$mktgProvider}\n";
try {
    $providerInstance = \Core\Marketing\EmailProviderFactory::make();
    echo "Proveedor resuelto: " . $providerInstance->getProviderName() . "\n";
    echo "Credenciales válidas (test de conexión): " . ($providerInstance->validateCredentials() ? "SÍ" : "NO") . "\n";
} catch (\Exception $provEx) {
    echo "Error al instanciar/validar proveedor: " . $provEx->getMessage() . "\n";
}

// 6. Check jobs table for queue status
echo "\n--- ESTADO DE TRABAJOS EN COLA (jobs) ---\n";
$stmt = $db->query("SELECT * FROM jobs ORDER BY id DESC LIMIT 10");
$jobs = $stmt->fetchAll();
if (empty($jobs)) {
    echo "La tabla 'jobs' está completamente vacía (no hay trabajos pendientes ni fallidos).\n";
} else {
    print_r($jobs);
}


echo "</pre>";

