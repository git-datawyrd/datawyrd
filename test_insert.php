<?php
define('BASE_PATH', __DIR__);
require_once __DIR__ . '/config/env.php';
\EnvLoader::load(__DIR__ . '/.env');
require_once __DIR__ . '/vendor/autoload.php';

\Core\Config::load();
$db = \Core\Database::getInstance()->getConnection();
try {
    $stmt = $db->query("SELECT * FROM mktg_campaigns");
    $camps = $stmt->fetchAll();
    print_r($camps);
} catch (\Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
