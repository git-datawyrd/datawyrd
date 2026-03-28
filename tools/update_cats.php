<?php
define('BASE_PATH', __DIR__);
require_once __DIR__ . '/config/env.php';

spl_autoload_register(function ($class) {
    $file = BASE_PATH . '/' . str_replace('\\', '/', $class) . '.php';
    if (file_exists($file)) {
        require_once $file;
    }
});

EnvLoader::load(BASE_PATH . '/.env');
Core\Config::load();

use Core\Database;

$db = Database::getInstance()->getConnection();

// Mapping array
$updates = [
    'etl-data-warehousing' => [
        'name' => 'Arquitectura y Gobierno de Datos',
        'slug' => 'arquitectura-gobierno-datos',
        'description' => 'Diseñamos ecosistemas de datos robustos, escalables y seguros que garantizan calidad, trazabilidad y control total sobre la información crítica del negocio.'
    ],
    'big-data-bi' => [
        'name' => 'Inteligencia para la Toma de Decisiones',
        'slug' => 'inteligencia-decisiones',
        'description' => 'Transformamos datos en información accionable mediante analítica avanzada, modelos predictivos y visualización ejecutiva enfocada en resultados financieros.'
    ],
    'desarrollo-web-apps' => [
        'name' => 'Plataformas Digitales Basadas en Datos',
        'slug' => 'plataformas-digitales',
        'description' => 'Construimos soluciones digitales y aplicaciones empresariales que integran datos en tiempo real para mejorar procesos, experiencia del cliente y eficiencia operativa.'
    ],
    'optimizacion-procesos' => [
        'name' => 'Automatización y Eficiencia Operativa',
        'slug' => 'automatizacion-eficiencia',
        'description' => 'Optimizamos procesos mediante automatización inteligente y modelos algorítmicos que reducen errores, dependencia manual y tiempos improductivos.'
    ]
];

$stmt = $db->query('SELECT * FROM service_categories');
$categories = $stmt->fetchAll(PDO::FETCH_ASSOC);

foreach ($categories as $cat) {
    if (isset($updates[$cat['slug']])) {
        $u = $updates[$cat['slug']];
        $newImg = null;
        if (!empty($cat['image'])) {
            $oldImgPath = __DIR__ . '/public/' . ltrim($cat['image'], '/');
            $ext = pathinfo($oldImgPath, PATHINFO_EXTENSION);
            if (!$ext)
                $ext = 'png';
            $newImgPathRel = 'assets/images/service_categories/' . $u['slug'] . '.' . $ext;
            $newImgPathFull = __DIR__ . '/public/' . ltrim($newImgPathRel, '/');

            if (file_exists($oldImgPath)) {
                if (!is_dir(dirname($newImgPathFull))) {
                    mkdir(dirname($newImgPathFull), 0777, true);
                }
                rename($oldImgPath, $newImgPathFull);
                $newImg = ltrim($newImgPathRel, '/');
            }
        }

        $sql = "UPDATE service_categories SET name = ?, slug = ?, description = ?";
        $params = [$u['name'], $u['slug'], $u['description']];
        if ($newImg !== null) {
            $sql .= ", image = ?";
            $params[] = $newImg;
        }
        $sql .= " WHERE id = ?";
        $params[] = $cat['id'];

        $db->prepare($sql)->execute($params);
        echo "Updated category ID: {$cat['id']} -> {$u['name']}\n";
    }
}
echo "Categories updated successfully.\n";
