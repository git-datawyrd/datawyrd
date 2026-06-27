<?php
require 'vendor/autoload.php';
// Load .env manually for testing
if (file_exists(__DIR__.'/.env')) {
    $lines = file(__DIR__.'/.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) continue;
        list($name, $value) = explode('=', $line, 2);
        putenv(trim($name) . '=' . trim($value));
        $_ENV[trim($name)] = trim($value);
    }
}
define('BASE_PATH', __DIR__);
require 'config/app.php';
require 'Core/Config.php';
require 'Core/Mail.php';

\Core\Config::load(__DIR__ . '/config');

try {
    echo "Testing Mail::send()...\n";
    $result = \Core\Mail::send('test@example.com', 'Test Subject', 'Test Body');
    echo "Result: " . ($result ? "Success" : "Failed") . "\n";
} catch (\Exception $e) {
    echo "Exception: " . $e->getMessage() . "\n";
}
