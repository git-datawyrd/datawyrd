<?php
/**
 * Data Wyrd OS - Runner de Migración de Email Marketing
 */
try {
    // Intentamos cargar el .env por si las credenciales de base de datos son distintas a las por defecto
    $envPath = dirname(__DIR__) . '/.env';
    $host = 'localhost';
    $dbname = 'datawyrd';
    $user = 'root';
    $pass = '';

    if (file_exists($envPath)) {
        $lines = file($envPath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos($line, '=') !== false && strpos($line, '#') !== 0) {
                list($key, $value) = explode('=', $line, 2);
                $key = trim($key);
                $value = trim($value);
                if ($key === 'DB_HOST') $host = $value;
                if ($key === 'DB_DATABASE') $dbname = $value;
                if ($key === 'DB_USERNAME') $user = $value;
                if ($key === 'DB_PASSWORD') $pass = $value;
            }
        }
    }

    echo "Conectando a la base de datos mysql:host=$host;dbname=$dbname...\n";
    $db = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $pass);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $sqlPath = dirname(__DIR__) . '/database/migrations/migration_email_marketing_schema.sql';
    if (!file_exists($sqlPath)) {
        die("Error: Archivo SQL no encontrado en $sqlPath\n");
    }

    echo "Cargando archivo SQL...\n";
    $sql = file_get_contents($sqlPath);

    echo "Ejecutando consultas de la migración...\n";
    $db->exec($sql);

    echo "✅ Migración de Email Marketing completada con éxito.\n";
} catch (Exception $e) {
    echo "❌ Error al ejecutar la migración: " . $e->getMessage() . "\n";
}
