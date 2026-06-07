<?php
/**
 * Data Wyrd - Integrations & Performance Analyzer (Phase 8 & 9)
 */

require_once __DIR__ . '/../Core/EnvLoader.php';
\Core\EnvLoader::load(__DIR__ . '/../.env');

$dbHost = $_ENV['DB_HOST'] ?? 'localhost';
$dbName = $_ENV['DB_DATABASE'] ?? 'datawyrd';
$dbUser = $_ENV['DB_USERNAME'] ?? 'root';
$dbPass = $_ENV['DB_PASSWORD'] ?? '';

try {
    $pdo = new PDO("mysql:host=$dbHost;dbname=$dbName;charset=utf8", $dbUser, $dbPass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die(json_encode(["error" => "Database connection failed: " . $e->getMessage()]));
}

$report = [
    'integrations' => [],
    'performance' => []
];

// 1. Check Integrations in .env
if (!empty($_ENV['MP_ACCESS_TOKEN']) && strpos($_ENV['MP_ACCESS_TOKEN'], 'tu-access-token') === false) {
    $report['integrations'][] = "[MercadoPago] Configurado con credenciales reales.";
} else {
    $report['integrations'][] = "[MercadoPago] Configurado con credenciales mock/falsas.";
}

if (!empty($_ENV['AI_API_KEY'])) {
    $provider = $_ENV['AI_PROVIDER'] ?? 'Desconocido';
    $report['integrations'][] = "[AI] Configurado usando proveedor: $provider.";
}

if ($_ENV['MAIL_ENABLED'] === 'true') {
    $report['integrations'][] = "[SMTP] Email habilitado vía {$_ENV['MAIL_HOST']}.";
} else {
    $report['integrations'][] = "[SMTP] Email deshabilitado.";
}

// 2. Check N+1 queries (basic heuristic: looking for SELECT inside loops in Controllers/Services)
$appDir = realpath(__DIR__ . '/../App');
function scanPHP($dir, &$results = []) {
    if (!is_dir($dir)) return;
    $files = scandir($dir);
    foreach ($files as $value) {
        $path = realpath($dir . DIRECTORY_SEPARATOR . $value);
        if (!is_dir($path)) {
            if (pathinfo($path, PATHINFO_EXTENSION) === 'php') $results[] = $path;
        } else if ($value != "." && $value != "..") {
            scanPHP($path, $results);
        }
    }
}
$phpFiles = [];
scanPHP($appDir, $phpFiles);

foreach ($phpFiles as $file) {
    $content = file_get_contents($file);
    $relFile = str_replace(realpath(__DIR__ . '/../'), '', $file);
    
    // Simplistic regex for N+1: foreach containing a query
    if (preg_match('/foreach\s*\([^{]*\{[^}]*(->query|->prepare|SELECT)[^}]*\}/is', $content)) {
        $report['performance'][] = "[$relFile] Posible N+1 Query: Bucle foreach ejecutando consultas a la BD.";
    }
}

// 3. Database Indexes check
$stmt = $pdo->query("SELECT TABLE_NAME, INDEX_NAME, COLUMN_NAME FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = '$dbName'");
$indexes = $stmt->fetchAll(PDO::FETCH_ASSOC);
$idxCount = count($indexes);
if ($idxCount < 50) {
    $report['performance'][] = "[DB] Pocos índices detectados ($idxCount). Se recomienda revisar campos frecuentemente consultados (ej. foreign keys) que carezcan de índice.";
} else {
    $report['performance'][] = "[DB] Cantidad saludable de índices detectados ($idxCount).";
}

file_put_contents(__DIR__ . '/audit_final.json', json_encode($report, JSON_PRETTY_PRINT));
echo "Integrations and Performance analysis generated.\n";
