<?php
$homePath = __DIR__ . '/../App/Views/public/home.php';
$partialsDir = __DIR__ . '/../App/Views/public/partials';

if (!is_dir($partialsDir)) {
    mkdir($partialsDir, 0777, true);
}

$lines = file($homePath);
if (!$lines) {
    die("No se pudo leer home.php");
}

$hero = array_slice($lines, 0, 35);
$why_us = array_slice($lines, 36, 177); // lines 37 to 213 -> 213 - 37 + 1 = 177
$process = array_slice($lines, 214, 109); // lines 215 to 323
$cta = array_slice($lines, 324, 236); // lines 325 to 560
$blog = array_slice($lines, 561, 55); // lines 562 to 616
$scripts = array_slice($lines, 617); // scripts at the end

file_put_contents($partialsDir . '/home_hero.php', implode("", $hero));
file_put_contents($partialsDir . '/home_why_us.php', implode("", $why_us));
file_put_contents($partialsDir . '/home_process.php', implode("", $process));
file_put_contents($partialsDir . '/home_cta.php', implode("", $cta));
file_put_contents($partialsDir . '/home_blog.php', implode("", $blog));
file_put_contents($partialsDir . '/home_scripts.php', implode("", $scripts));

$newHome = "<?php\n";
$newHome .= "require __DIR__ . '/partials/home_hero.php';\n";
$newHome .= "require __DIR__ . '/partials/home_why_us.php';\n";
$newHome .= "require __DIR__ . '/partials/home_process.php';\n";
$newHome .= "require __DIR__ . '/partials/home_cta.php';\n";
$newHome .= "require __DIR__ . '/partials/home_blog.php';\n";
$newHome .= "require __DIR__ . '/partials/home_scripts.php';\n";
$newHome .= "?>\n";

file_put_contents($homePath, $newHome);
echo "Refactorización de home.php completada.\n";
