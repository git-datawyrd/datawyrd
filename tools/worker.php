<?php
/**
 * Data Wyrd OS - Console Queue Worker
 * Run via CLI: php worker.php
 */

define('BASE_PATH', __DIR__);
require_once __DIR__ . '/config/env.php';
\EnvLoader::load(__DIR__ . '/.env');

// 3. Autoload Estructural (Composer)
require_once BASE_PATH . '/vendor/autoload.php';

// Fallback para clases no gestionadas por composer
spl_autoload_register(function ($class) {
    $file = BASE_PATH . '/' . str_replace('\\', '/', $class) . '.php';
    if (file_exists($file)) {
        require_once $file;
    }
});

\Core\Config::load();

$db = \Core\Database::getInstance()->getConnection();

echo "Starting Data Wyrd Queue Worker. Waiting for jobs...\n";

while (true) {
    try {
        $db->beginTransaction();

        // 1. Fetch oldest pending job
        $stmt = $db->query("SELECT * FROM jobs WHERE status = 'pending' ORDER BY created_at ASC LIMIT 1 FOR UPDATE");
        $job = $stmt->fetch();

        if ($job) {
            echo "[" . date('Y-m-d H:i:s') . "] Processing Job ID {$job['id']} ({$job['job_class']})\n";

            // Mark as processing
            $stmtUpdate = $db->prepare("UPDATE jobs SET status = 'processing', attempts = attempts + 1 WHERE id = ?");
            $stmtUpdate->execute([$job['id']]);

            $db->commit();

            try {
                $class = $job['job_class'];
                $payload = json_decode($job['payload'], true);

                // Set tenant context for this job (Zero Trust Segregation)
                if (isset($job['tenant_id'])) {
                    \Core\Config::set('current_tenant_id', (int) $job['tenant_id']);
                } else {
                    \Core\Config::set('current_tenant_id', 1); // Default system tenant
                }

                if (class_exists($class)) {
                    $instance = new $class();
                    if (method_exists($instance, 'handle')) {
                        $instance->handle($payload);

                        // Success: delete job
                        $db->prepare("DELETE FROM jobs WHERE id = ?")->execute([$job['id']]);
                        echo "[" . date('Y-m-d H:i:s') . "] Completed Job ID {$job['id']} for Tenant {$job['tenant_id']}\n";
                    } else {
                        throw new \Exception("Method handle() missing in {$class}");
                    }
                } else {
                    throw new \Exception("Class {$class} not found");
                }
            } catch (\Exception $jobEx) {
                // Determine if we should fail or retry based on attempts (max 3 for now)
                $db->prepare("UPDATE jobs SET status = 'failed', error_message = ? WHERE id = ?")
                    ->execute([$jobEx->getMessage(), $job['id']]);

                echo "[" . date('Y-m-d H:i:s') . "] Failed Job ID {$job['id']}: " . $jobEx->getMessage() . "\n";
            }
        } else {
            $db->commit();
            // No jobs, sleep to prevent CPU spike
            sleep(2);
        }
    } catch (\PDOException $e) {
        if ($db->inTransaction()) {
            $db->rollBack();
        }
        echo "Database Error: " . $e->getMessage() . "\n";
        sleep(5); // Wait longer on DB errors
    } catch (\Exception $e) {
        echo "Worker Error: " . $e->getMessage() . "\n";
        sleep(2);
    }
}
