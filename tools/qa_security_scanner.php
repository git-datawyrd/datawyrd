<?php
$dir = __DIR__ . '/../App/Controllers/';
$files = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($dir));

$report = ['unprotected_methods' => 0, 'protected_methods' => 0, 'warnings' => []];

foreach ($files as $file) {
    if ($file->getExtension() === 'php') {
        $content = file_get_contents($file->getRealPath());
        
        // Exclude AuthController and public controllers
        if (strpos($file->getFilename(), 'AuthController') !== false || strpos($file->getRealPath(), 'public') !== false) {
            continue;
        }

        // Check if constructor has Auth::requireLogin() or similar
        $hasConstructorAuth = (strpos($content, 'Auth::requireLogin') !== false) || (strpos($content, 'Auth::check') !== false);
        
        if (!$hasConstructorAuth) {
            // If constructor doesn't have it, we check methods
            preg_match_all('/public function ([a-zA-Z0-9_]+)\s*\(/', $content, $methods);
            foreach ($methods[1] as $method) {
                if ($method == '__construct') continue;
                $report['warnings'][] = "Possible unprotected method: {$file->getFilename()}::{$method}";
                $report['unprotected_methods']++;
            }
        } else {
            $report['protected_methods']++;
        }
    }
}

echo json_encode($report, JSON_PRETTY_PRINT);
