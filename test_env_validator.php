<?php
require_once __DIR__ . '/config/env.php';
define('BASE_PATH', __DIR__);
require_once __DIR__ . '/vendor/autoload.php';

use Core\Config;
use Core\EnvValidator;

try {
    echo "Testing EnvValidator...\n";
    EnvLoader::load(BASE_PATH . '/.env');
    Config::load();
    EnvValidator::validate();
    echo "Validation PASSED (UNEXPECTED if secrets are missing/placeholders)\n";
} catch (\Throwable $e) {
    echo "Validation FAILED (EXPECTED):\n";
    echo $e->getMessage() . "\n";
}
