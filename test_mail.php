<?php
require 'vendor/autoload.php';
require 'config/app.php';
require 'Core/Config.php';
require 'Core/Mail.php';

// Bootstrap minimal app
define('BASE_PATH', __DIR__);
\Core\Config::load(__DIR__ . '/config');
// Load .env manually for testing
if (file_exists(__DIR__.'/.env')) {
    $lines = file(__DIR__.'/.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) continue;
        list($name, $value) = explode('=', $line, 2);
        putenv(trim($name) . '=' . trim($value));
    }
}

try {
    echo "Testing Mail::send()...\n";
    $result = \Core\Mail::send('test@example.com', 'Test Subject', 'Test Body');
    echo "Result: " . ($result ? "Success" : "Failed") . "\n";
} catch (\Exception $e) {
    echo "Exception: " . $e->getMessage() . "\n";
}
