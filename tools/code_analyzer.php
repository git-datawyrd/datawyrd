<?php
/**
 * Data Wyrd - Backend/Frontend Code Analyzer (Phase 4 & 5)
 */

$directories = [
    'App' => __DIR__ . '/../App',
    'Core' => __DIR__ . '/../Core',
    'public' => __DIR__ . '/../public',
    'resources' => __DIR__ . '/../resources'
];

$report = [
    'todos_fixmes' => [],
    'var_dumps_die' => [],
    'bloated_classes' => [],
    'high_coupling' => [],
    'frontend_issues' => []
];

function scanDirRecursive($dir, &$results = []) {
    if (!is_dir($dir)) return;
    $files = scandir($dir);
    foreach ($files as $value) {
        $path = realpath($dir . DIRECTORY_SEPARATOR . $value);
        if (!is_dir($path)) {
            $results[] = $path;
        } else if ($value != "." && $value != "..") {
            scanDirRecursive($path, $results);
        }
    }
}

$backendFiles = [];
scanDirRecursive($directories['App'], $backendFiles);
scanDirRecursive($directories['Core'], $backendFiles);

foreach ($backendFiles as $file) {
    if (pathinfo($file, PATHINFO_EXTENSION) !== 'php') continue;
    $content = file_get_contents($file);
    $lines = explode("\n", $content);
    $relFile = str_replace(realpath(__DIR__ . '/../'), '', $file);
    
    $useCount = 0;
    
    foreach ($lines as $num => $line) {
        $lineNum = $num + 1;
        // Check for TODOs
        if (preg_match('/(TODO|FIXME|HACK):/i', $line)) {
            $report['todos_fixmes'][] = "[$relFile:$lineNum] " . trim($line);
        }
        // Check for debug leftovers
        if (preg_match('/(var_dump|print_r|die|exit)\s*\(/i', $line) && strpos($line, '//') === false) {
            $report['var_dumps_die'][] = "[$relFile:$lineNum] Debug function found.";
        }
        // Check coupling
        if (preg_match('/^use\s+[A-Za-z0-9_\\\\]+;/', trim($line))) {
            $useCount++;
        }
    }
    
    if ($useCount > 10) {
        $report['high_coupling'][] = "[$relFile] Tiene $useCount dependencias (posible violación de SRP).";
    }
    if (count($lines) > 400) {
        $report['bloated_classes'][] = "[$relFile] " . count($lines) . " líneas (God Class).";
    }
}

// Frontend check
$frontendFiles = [];
scanDirRecursive($directories['public'], $frontendFiles);
if(file_exists($directories['resources'])) {
    scanDirRecursive($directories['resources'], $frontendFiles);
}
// Also check views in App/Views
scanDirRecursive(__DIR__ . '/../App/Views', $frontendFiles);

foreach ($frontendFiles as $file) {
    $ext = pathinfo($file, PATHINFO_EXTENSION);
    if (!in_array($ext, ['php', 'html'])) continue;
    
    $content = file_get_contents($file);
    $relFile = str_replace(realpath(__DIR__ . '/../'), '', $file);
    
    // Find forms with missing action
    if (preg_match_all('/<form[^>]*>/i', $content, $matches)) {
        foreach ($matches[0] as $form) {
            if (strpos($form, 'action=') === false && strpos($form, 'wire:submit') === false && strpos($form, 'onsubmit') === false) {
                $report['frontend_issues'][] = "[$relFile] Formulario sin atributo 'action' o manejador JS.";
            }
        }
    }
    
    // Find missing hrefs
    if (preg_match_all('/<a[^>]+href=["\'](#|)["\'][^>]*>/i', $content, $matches)) {
        $report['frontend_issues'][] = "[$relFile] Contiene enlaces rotos o vacíos (href='#').";
    }
}

file_put_contents(__DIR__ . '/audit_code_issues.json', json_encode($report, JSON_PRETTY_PRINT));
echo "Code analysis generated at tools/audit_code_issues.json\n";
