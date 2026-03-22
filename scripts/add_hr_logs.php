<?php
define('BASE_PATH', realpath(__DIR__ . '/..'));
require_once __DIR__ . '/../config/env.php';
require_once __DIR__ . '/../vendor/autoload.php';

EnvLoader::load(__DIR__ . '/../.env');
\Core\Config::load();

$db = \Core\Database::getInstance()->getConnection();
$sql = file_get_contents(__DIR__ . '/../database/hr_logs.sql');
try {
    $db->exec($sql);
    echo "Tabla de logs de estatus RRHH creada.\n";
} catch (PDOException $e) {
    echo "Error ejecutando migración: " . $e->getMessage() . "\n";
}
