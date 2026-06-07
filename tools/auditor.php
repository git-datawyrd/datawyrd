<?php
/**
 * Data Wyrd - 360 System Auditor
 * Generates an automated inventory of the codebase and database.
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

$inventory = [
    'modules' => [],
    'classes' => [],
    'frontend' => [],
    'database' => [],
    'routes' => [],
];

// 1. Scan PHP Classes (Backend)
function scanDirectory($dir, &$results = []) {
    $files = scandir($dir);
    foreach ($files as $key => $value) {
        $path = realpath($dir . DIRECTORY_SEPARATOR . $value);
        if (!is_dir($path)) {
            if (pathinfo($path, PATHINFO_EXTENSION) === 'php') {
                $results[] = $path;
            }
        } else if ($value != "." && $value != "..") {
            scanDirectory($path, $results);
            $results[] = $path;
        }
    }
    return $results;
}

$appFiles = [];
if (file_exists(__DIR__ . '/../App')) scanDirectory(__DIR__ . '/../App', $appFiles);
if (file_exists(__DIR__ . '/../Core')) scanDirectory(__DIR__ . '/../Core', $appFiles);

foreach ($appFiles as $file) {
    if (is_dir($file)) continue;
    $content = file_get_contents($file);
    $lines = substr_count($content, "\n");
    
    $type = 'unknown';
    if (strpos($file, 'Controller.php') !== false) $type = 'Controller';
    elseif (strpos($file, 'Service.php') !== false) $type = 'Service';
    elseif (strpos($file, 'Repository.php') !== false) $type = 'Repository';
    elseif (strpos($file, 'Model.php') !== false) $type = 'Model';
    elseif (strpos($file, 'Middleware.php') !== false) $type = 'Middleware';
    
    // Find class names and methods
    preg_match('/class\s+([a-zA-Z0-9_]+)/', $content, $matches);
    $className = $matches[1] ?? basename($file, '.php');
    
    preg_match_all('/function\s+([a-zA-Z0-9_]+)/', $content, $methodMatches);
    $methods = $methodMatches[1] ?? [];
    
    $inventory['classes'][] = [
        'file' => str_replace(realpath(__DIR__ . '/../'), '', $file),
        'class' => $className,
        'type' => $type,
        'lines' => $lines,
        'methods_count' => count($methods),
        'methods' => $methods
    ];
}

// 2. Scan Frontend (Views/Public)
$frontendFiles = [];
if (file_exists(__DIR__ . '/../public')) scanDirectory(__DIR__ . '/../public', $frontendFiles);
if (file_exists(__DIR__ . '/../App/Views')) scanDirectory(__DIR__ . '/../App/Views', $frontendFiles);

foreach ($frontendFiles as $file) {
    if (is_dir($file)) continue;
    $ext = pathinfo($file, PATHINFO_EXTENSION);
    if (in_array($ext, ['php', 'html', 'js', 'css'])) {
        $inventory['frontend'][] = [
            'file' => str_replace(realpath(__DIR__ . '/../'), '', $file),
            'type' => $ext,
            'size' => filesize($file)
        ];
    }
}

// 3. Database Schema
$stmt = $pdo->query("SHOW TABLES");
$tables = $stmt->fetchAll(PDO::FETCH_COLUMN);

foreach ($tables as $table) {
    $stmtCols = $pdo->query("SHOW COLUMNS FROM `$table`");
    $columns = $stmtCols->fetchAll(PDO::FETCH_ASSOC);
    
    $inventory['database'][$table] = [
        'columns' => $columns
    ];
}

file_put_contents(__DIR__ . '/audit_inventory.json', json_encode($inventory, JSON_PRETTY_PRINT));
echo "Inventory generated at tools/audit_inventory.json\n";
