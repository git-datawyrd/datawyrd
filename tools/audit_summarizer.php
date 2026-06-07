<?php
$json = file_get_contents(__DIR__ . '/audit_inventory.json');
$data = json_decode($json, true);

// PHASE 1: INVENTORY
$md1 = "# FASE 1: INVENTARIO TOTAL DEL SISTEMA\n\n";
$md1 .= "## Resumen de Clases Backend\n";
$types = [];
foreach ($data['classes'] as $class) {
    $t = $class['type'] === 'unknown' ? 'Core/Model/Domain' : $class['type'];
    if (!isset($types[$t])) $types[$t] = 0;
    $types[$t]++;
}
foreach ($types as $type => $count) {
    $md1 .= "- **$type**: $count\n";
}

$md1 .= "\n## Listado de Controladores\n";
foreach ($data['classes'] as $class) {
    if (strpos($class['class'], 'Controller') !== false) {
        $md1 .= "- `{$class['class']}` ({$class['methods_count']} métodos)\n";
    }
}

$md1 .= "\n## Listado de Servicios\n";
foreach ($data['classes'] as $class) {
    if (strpos($class['class'], 'Service') !== false) {
        $md1 .= "- `{$class['class']}` ({$class['methods_count']} métodos)\n";
    }
}

$md1 .= "\n## Frontend Assets\n";
$feTypes = [];
foreach ($data['frontend'] as $f) {
    if (!isset($feTypes[$f['type']])) $feTypes[$f['type']] = 0;
    $feTypes[$f['type']]++;
}
foreach ($feTypes as $type => $count) {
    $md1 .= "- **.$type**: $count archivos\n";
}

file_put_contents(__DIR__ . '/audit_phase1.md', $md1);

// PHASE 3: DATABASE
$md3 = "# FASE 3: AUDITORÍA DE BASE DE DATOS\n\n";
$md3 .= "Total de tablas: " . count($data['database']) . "\n\n";
foreach ($data['database'] as $table => $info) {
    $md3 .= "### Tabla: `$table`\n";
    $md3 .= "Columnas: " . count($info['columns']) . "\n";
    $cols = [];
    foreach ($info['columns'] as $col) {
        $cols[] = $col['Field'];
    }
    $md3 .= "`" . implode('`, `', $cols) . "`\n\n";
}

file_put_contents(__DIR__ . '/audit_phase3.md', $md3);
echo "Reports generated.\n";
