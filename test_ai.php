<?php
require 'vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

$ai = new \App\Services\AIService();
$res = $ai->generateEmailVariants('prueba');
var_dump($res);
