<?php
/**
 * Data Wyrd OS - Bootstrap Logic
 */

if (!defined('BASE_PATH')) {
    define('BASE_PATH', dirname(__DIR__));
}

// 1. Cargar el loader de entorno manualmente
require_once BASE_PATH . '/config/env.php';

// 2. Autoload Estructural (Composer)
require_once BASE_PATH . '/vendor/autoload.php';

// 3. Autoload Estructural Manual (Fallback)
spl_autoload_register(function ($class) {
    $file = BASE_PATH . '/' . str_replace('\\', '/', $class) . '.php';
    if (file_exists($file)) {
        require_once $file;
    }
});

use Core\Config;
use Core\EnvLoader;

try {
    // 4. Carga de Variables de Entorno (.env)
    EnvLoader::load(BASE_PATH . '/.env');

    // 5. Inicialización de Componentes Core (Orden Crítico)
    Config::load();
    
    // Solo iniciar sesión si no es CLI
    if (PHP_SAPI !== 'cli') {
        \Core\Session::start();
    }

    // Configuración de Timezone
    date_default_timezone_set(Config::get('timezone', 'America/Argentina/Buenos_Aires'));

} catch (\Throwable $e) {
    error_log("Bootstrap Error: " . $e->getMessage() . " in " . $e->getFile() . " on line " . $e->getLine());
    if (PHP_SAPI === 'cli') {
        fwrite(STDERR, "FATAL BOOTSTRAP ERROR: " . $e->getMessage() . "\n");
    }
    throw $e;
}
