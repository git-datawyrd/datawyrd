<?php
define('ROOT_DIR', __DIR__);
require 'Core/Config.php';
require 'App/Services/AIService.php';

// Cargar .env manualmente de forma basica
$lines = file(__DIR__ . '/.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
foreach ($lines as $line) {
    if (strpos(trim($line), '#') === 0) continue;
    list($name, $value) = explode('=', $line, 2);
    $_ENV[trim($name)] = trim($value, '"\'');
}

$ai = new \App\Services\AIService();
$res = $ai->generateEmailVariants('prueba');
print_r($res);
