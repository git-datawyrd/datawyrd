<?php
// Mock server to prevent routing from executing in App constructor
$_SERVER['REQUEST_URI'] = '/';
$_GET['url'] = '/';
$_SERVER['REQUEST_METHOD'] = 'GET';
$_SERVER['HTTP_HOST'] = 'localhost';

define('BASE_PATH', __DIR__);
require_once BASE_PATH . '/vendor/autoload.php';

// Cargar .env
$dotenv = Dotenv\Dotenv::createImmutable(BASE_PATH);
$dotenv->load();

// Configuraciones base
require_once BASE_PATH . '/config/config.php';
require_once BASE_PATH . '/Core/Helpers.php';

$container = new \Core\Container();
$db = \Core\Database::getInstance()->getConnection();
$container->instance(\PDO::class, $db);

try {
    $dashboard = $container->build('App\Controllers\DashboardController');
    echo "Success!";
} catch (\Exception $e) {
    echo "Exception: " . $e->getMessage() . "\n";
    echo $e->getTraceAsString();
}
