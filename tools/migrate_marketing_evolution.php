<?php
/**
 * Data Wyrd OS - Runner de Migración de Email Marketing Evolution
 */
try {
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

    // 1. Crear tabla blacklist
    echo "Creando tabla blacklist si no existe...\n";
    $db->exec("CREATE TABLE IF NOT EXISTS `blacklist` (
        `id`          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        `email`       VARCHAR(190) NOT NULL UNIQUE,
        `reason`      VARCHAR(255) DEFAULT NULL,
        `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        KEY `idx_blacklist_email` (`email`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");

    // 2. Agregar columnas a mktg_contacts si no existen
    echo "Verificando columnas en mktg_contacts...\n";
    $columnsToAdd = [
        'phone' => "VARCHAR(50) DEFAULT NULL AFTER `last_name`",
        'company' => "VARCHAR(150) DEFAULT NULL AFTER `phone`",
        'country' => "VARCHAR(100) DEFAULT NULL AFTER `company`",
        'industry' => "VARCHAR(100) DEFAULT NULL AFTER `country`",
        'tags' => "VARCHAR(255) DEFAULT NULL AFTER `industry`"
    ];

    foreach ($columnsToAdd as $col => $definition) {
        $check = $db->query("SHOW COLUMNS FROM `mktg_contacts` LIKE '$col'")->fetch();
        if (!$check) {
            echo "Añadiendo columna '$col' a mktg_contacts...\n";
            $db->exec("ALTER TABLE `mktg_contacts` ADD COLUMN `$col` $definition");
        } else {
            echo "Columna '$col' ya existe.\n";
        }
    }

    // 3. Agregar índices a mktg_contacts
    echo "Verificando índices en mktg_contacts...\n";
    $indicesContacts = [
        'idx_contacts_segment' => "(`tenant_id`, `list_id`, `status`, `country`, `industry`)",
        'idx_contacts_tags' => "(`tenant_id`, `list_id`, `tags`)"
    ];
    foreach ($indicesContacts as $idxName => $cols) {
        $check = $db->query("SHOW INDEX FROM `mktg_contacts` WHERE Key_name = '$idxName'")->fetch();
        if (!$check) {
            echo "Creando índice '$idxName'...\n";
            $db->exec("ALTER TABLE `mktg_contacts` ADD INDEX `$idxName` $cols");
        } else {
            echo "Índice '$idxName' ya existe.\n";
        }
    }

    // 4. Agregar índices a mktg_events
    echo "Verificando índices en mktg_events...\n";
    $indicesEvents = [
        'idx_events_search'   => "(`campaign_id`, `event_type`, `contact_id`)",
        'idx_events_behavior' => "(`contact_id`, `event_type`, `occurred_at`)"
    ];
    foreach ($indicesEvents as $idxName => $cols) {
        $check = $db->query("SHOW INDEX FROM `mktg_events` WHERE Key_name = '$idxName'")->fetch();
        if (!$check) {
            echo "Creando índice '$idxName'...\n";
            $db->exec("ALTER TABLE `mktg_events` ADD INDEX `$idxName` $cols");
        } else {
            echo "Índice '$idxName' ya existe.\n";
        }
    }

    // 5. Columna paused_reason en mktg_campaigns
    echo "Verificando columna paused_reason en mktg_campaigns...\n";
    $checkPaused = $db->query("SHOW COLUMNS FROM `mktg_campaigns` LIKE 'paused_reason'")->fetch();
    if (!$checkPaused) {
        echo "Añadiendo columna 'paused_reason' a mktg_campaigns...\n";
        $db->exec("ALTER TABLE `mktg_campaigns`
                   ADD COLUMN `paused_reason` VARCHAR(500) DEFAULT NULL AFTER `status`");
    } else {
        echo "Columna 'paused_reason' ya existe.\n";
    }

    echo "✅ Migración completa aplicada correctamente.\n";

} catch (Exception $e) {
    echo "❌ Error al ejecutar la migración: " . $e->getMessage() . "\n";
    exit(1);
}
