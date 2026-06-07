<?php
require_once __DIR__ . '/../Core/bootstrap.php';

$output = [];
$total = 0;
$passed = 0;
$failed = 0;

function getControllers($dir) {
    $results = [];
    $files = scandir($dir);
    foreach ($files as $value) {
        $path = realpath($dir . DIRECTORY_SEPARATOR . $value);
        if (!is_dir($path)) {
            if (strpos($path, 'Controller.php') !== false) {
                $results[] = $path;
            }
        } else if ($value != "." && $value != "..") {
            $results = array_merge($results, getControllers($path));
        }
    }
    return $results;
}

$controllers = getControllers(__DIR__ . '/../App/Controllers');
$baseDir = realpath(__DIR__ . '/../App/Controllers');

foreach ($controllers as $file) {
    // Determine class name
    $rel = str_replace($baseDir, '', $file);
    $rel = ltrim($rel, DIRECTORY_SEPARATOR);
    $rel = str_replace('.php', '', $rel);
    $className = '\\App\\Controllers\\' . str_replace(DIRECTORY_SEPARATOR, '\\', $rel);

    if (class_exists($className)) {
        $ref = new ReflectionClass($className);
        foreach ($ref->getMethods(ReflectionMethod::IS_PUBLIC) as $method) {
            // Ignore magic methods
            if (strpos($method->getName(), '__') === 0) continue;

            $total++;
            // Check if it expects required parameters (can't blindly call it easily)
            $reqParams = $method->getNumberOfRequiredParameters();
            
            // We just log it as an endpoint to review for now, 
            // since calling it might execute destructive actions (DELETE, UPDATE) without warning.
            // The prompt says "No asumir comportamientos. Validar mediante evidencia."
            
            // For safety, we will just inventory the endpoints. 
            // We will execute a safe test suite via PHPUnit.
            $output[] = [
                'module' => $rel,
                'endpoint' => $method->getName(),
                'required_params' => $reqParams,
                'risks' => strpos(strtolower($method->getName()), 'delete') !== false ? 'HIGH' : (strpos(strtolower($method->getName()), 'update') !== false ? 'MEDIUM' : 'LOW')
            ];
        }
    }
}

file_put_contents(__DIR__ . '/qa_inventory.json', json_encode($output, JSON_PRETTY_PRINT));
echo "Inventory completed. Found $total endpoints.\n";
