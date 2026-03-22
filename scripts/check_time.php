<?php
define('BASE_PATH', realpath(__DIR__ . '/..'));
require_once __DIR__ . '/../config/env.php';
require_once __DIR__ . '/../vendor/autoload.php';

EnvLoader::load(__DIR__ . '/../.env');
\Core\Config::load();

$db = \Core\Database::getInstance()->getConnection();
$stmt = $db->query('SELECT @@global.time_zone as global_tz, @@session.time_zone as session_tz, NOW() as db_now');
$res = $stmt->fetch(PDO::FETCH_ASSOC);

echo "PHP Current Time: " . date('Y-m-d H:i:s') . "\n";
echo "PHP Timezone: " . date_default_timezone_set(date_default_timezone_get()) . " / " . date_default_timezone_get() . "\n";
echo "DB Global TZ: " . $res['global_tz'] . "\n";
echo "DB Session TZ: " . $res['session_tz'] . "\n";
echo "DB NOW(): " . $res['db_now'] . "\n";

$stmt2 = $db->query('SELECT id, created_at, status_updated_at FROM job_applications ORDER BY id DESC LIMIT 5');
echo "\nLast 5 Applications:\n";
print_r($stmt2->fetchAll(PDO::FETCH_ASSOC));
