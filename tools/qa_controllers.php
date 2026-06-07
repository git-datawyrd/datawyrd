<?php
require __DIR__ . '/../Core/bootstrap.php';

// Mock Session & Auth so controllers don't redirect on __construct
\Core\Session::start();
$_SESSION['user'] = ['id' => 1, 'role' => 'super_admin', 'tenant_id' => 1];

$container = new \Core\Container();
$db = \Core\Database::getInstance()->getConnection();
$container->instance(\PDO::class, $db);

$dir = __DIR__ . '/../App/Controllers/';
$files = glob($dir . '*.php');
$errors = [];

foreach ($files as $file) {
    $class = 'App\\Controllers\\' . basename($file, '.php');
    try {
        require_once $file;
        $controller = $container->build($class);
        echo "Success: $class\n";
    } catch (\Throwable $e) {
        $errors[] = "Error in $class: " . $e->getMessage();
    }
}

if (!empty($errors)) {
    echo "\nERRORS FOUND:\n" . implode("\n", $errors);
} else {
    echo "\nALL CONTROLLERS INSTANTIATED SUCCESSFULLY.\n";
}
