<?php
require_once __DIR__ . '/../Core/Controller.php';
require_once __DIR__ . '/../App/Controllers/Admin/MarketingController.php';

$ref = new ReflectionClass('\App\Controllers\Admin\MarketingController');
foreach($ref->getMethods() as $method) {
    if ($method->class === 'App\Controllers\Admin\MarketingController') {
        echo $method->getName() . "\n";
    }
}
