<?php
namespace Core;

/**
 * Motor de Configuración - DataWyrd Multi-entorno
 */
class Config
{
    private static $config = [];
    private static $loaded = false;

    private static $validEnvironments = ['local', 'demo', 'production'];

    /**
     * Flujo de carga: .env ya fue cargado por EnvLoader -> app.php -> {env}.php
     */
    public static function load()
    {
        if (self::$loaded)
            return;

        // 1. Leer y validar ENVIRONMENT (ya cargado por EnvLoader)
        $env = getenv('ENVIRONMENT');

        if (!$env) {
            die("FATAL ERROR: ENVIRONMENT no está definida. Verifica que el loader de .env se haya ejecutado.");
        }

        if (!in_array($env, self::$validEnvironments)) {
            die("FATAL ERROR: Entorno '{$env}' no es válido. Opciones: " . implode(', ', self::$validEnvironments));
        }

        // 2. Cargar app.php (común)
        $commonFile = BASE_PATH . '/config/app.php';
        $common = file_exists($commonFile) ? require $commonFile : [];

        // 3. Cargar config/{ENVIRONMENT}.php (específico)
        $specificFile = BASE_PATH . "/config/{$env}.php";
        if (!file_exists($specificFile)) {
            die("FATAL ERROR: Archivo de configuración para el entorno '{$env}' no existe.");
        }
        $specific = require $specificFile;

        // 4. Unificar recursivamente (specific pisa common)
        self::$config = array_replace_recursive($common, $specific);
        self::$config['ENVIRONMENT'] = $env;

        self::$loaded = true;
    }

    /**
     * Obtiene un valor (soporta notación de punto)
     * Ejemplo: Config::get('db.host')
     */
    public static function get($key, $default = null)
    {
        if (!self::$loaded)
            self::load();

        if (strpos($key, '.') !== false) {
            $parts = explode('.', $key);
            $current = self::$config;
            foreach ($parts as $part) {
                if (!isset($current[$part]))
                    return $default;
                $current = $current[$part];
            }
            return $current;
        }

        return self::$config[$key] ?? $default;
    }

    public static function all()
    {
        if (!self::$loaded)
            self::load();
        return self::$config;
    }

    /**
     * Establece un valor en tiempo de ejecución (soporta notación de punto)
     */
    public static function set($key, $value)
    {
        if (!self::$loaded)
            self::load();

        if (strpos($key, '.') !== false) {
            $parts = explode('.', $key);
            $current = &self::$config;
            foreach ($parts as $part) {
                if (!isset($current[$part]) || !is_array($current[$part])) {
                    $current[$part] = [];
                }
                $current = &$current[$part];
            }
            $current = $value;
        } else {
            self::$config[$key] = $value;
        }
    }
}
