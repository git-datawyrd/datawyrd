<?php
/**
 * Data Wyrd - Functional & Security Analyzer (Phase 6 & 7)
 */

$appDir = realpath(__DIR__ . '/../App');
$viewsDir = realpath(__DIR__ . '/../App/Views');

$report = [
    'missing_views' => [],
    'security_issues' => []
];

// Phase 6: Scan Controllers for missing views
$controllersDir = $appDir . '/Controllers';
function scanControllers($dir, &$results = []) {
    if (!is_dir($dir)) return;
    $files = scandir($dir);
    foreach ($files as $value) {
        $path = realpath($dir . DIRECTORY_SEPARATOR . $value);
        if (!is_dir($path)) {
            $results[] = $path;
        } else if ($value != "." && $value != "..") {
            scanControllers($path, $results);
        }
    }
}

$controllers = [];
scanControllers($controllersDir, $controllers);

foreach ($controllers as $controller) {
    if (pathinfo($controller, PATHINFO_EXTENSION) !== 'php') continue;
    $content = file_get_contents($controller);
    $relFile = str_replace(realpath(__DIR__ . '/../'), '', $controller);
    
    // Find $this->viewLayout('path/to/view', ...) or $this->view('path/to/view', ...)
    if (preg_match_all('/\$this->view(Layout)?\(\s*[\'"]([a-zA-Z0-9_\-\/]+)[\'"]/i', $content, $matches)) {
        foreach ($matches[2] as $viewPath) {
            $viewFile = $viewsDir . DIRECTORY_SEPARATOR . str_replace('/', DIRECTORY_SEPARATOR, $viewPath) . '.php';
            if (!file_exists($viewFile)) {
                $report['missing_views'][] = "[$relFile] Llama a vista '$viewPath' que NO EXISTE.";
            }
        }
    }
}

// Phase 7: Security (Mass assignment check)
// Look for direct use of $_POST without validation
foreach ($controllers as $controller) {
    $content = file_get_contents($controller);
    $relFile = str_replace(realpath(__DIR__ . '/../'), '', $controller);
    
    // Look for unsafe array access like $data = $_POST;
    if (preg_match('/\$([a-zA-Z0-9_]+)\s*=\s*\$_POST\s*;/i', $content)) {
        $report['security_issues'][] = "[$relFile] Posible Mass Assignment: $_POST se asigna directamente a una variable sin filtrar.";
    }
}

file_put_contents(__DIR__ . '/audit_functional_security.json', json_encode($report, JSON_PRETTY_PRINT));
echo "Functional & Security analysis generated.\n";
