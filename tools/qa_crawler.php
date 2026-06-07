<?php
$dir = __DIR__ . '/../App/Views/';
$files = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($dir));

$report = ['broken_links' => [], 'empty_alts' => [], 'unescaped_echoes' => []];

foreach ($files as $file) {
    if ($file->getExtension() === 'php') {
        $content = file_get_contents($file->getRealPath());
        $relPath = str_replace($dir, '', $file->getRealPath());

        // Check broken links (href="#")
        if (preg_match_all('/href=["\']#["\']/', $content, $matches)) {
            $report['broken_links'][] = ["file" => $relPath, "count" => count($matches[0])];
        }

        // Check empty alt tags
        if (preg_match_all('/<img[^>]*alt=["\']["\'][^>]*>/i', $content, $matches)) {
            $report['empty_alts'][] = ["file" => $relPath, "count" => count($matches[0])];
        }

        // Check unescaped echoes (e.g. <?php echo $_POST... or <?=$var without htmlspecialchars)
        // This is a naive check but good for QA
        if (preg_match_all('/<\?=\s*\$_[A-Z]+\[[^\]]+\]\s*\?>/', $content, $matches)) {
            $report['unescaped_echoes'][] = ["file" => $relPath, "count" => count($matches[0])];
        }
    }
}

echo json_encode($report, JSON_PRETTY_PRINT);
