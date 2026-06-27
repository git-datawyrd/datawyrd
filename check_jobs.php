<?php
define('BASE_PATH', __DIR__);
require_once BASE_PATH . '/config/env.php';
\EnvLoader::load(BASE_PATH . '/.env');
require_once BASE_PATH . '/vendor/autoload.php';

\Core\Config::load();
$db = \Core\Database::getInstance()->getConnection();
$stmt = $db->query("SELECT * FROM jobs");
$jobs = $stmt->fetchAll();
print_r($jobs);
