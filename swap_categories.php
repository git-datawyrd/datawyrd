<?php
require_once __DIR__ . '/vendor/autoload.php';

use Core\Database;

try {
    $db = Database::getInstance()->getConnection();

    // Buscar "Arquitectura y Gobierno de Datos" (posiblemente contiene 'Arquitectura' o 'ETL' si cambió el nombre)
    $stmt1 = $db->query("SELECT id, name, order_position FROM service_categories WHERE name LIKE '%Arquitectura%' OR name LIKE '%ETL%'");
    $cat1 = $stmt1->fetch();

    // Buscar "Aplicaciones Web y Apps"
    $stmt2 = $db->query("SELECT id, name, order_position FROM service_categories WHERE name LIKE '%Web%'");
    $cat2 = $stmt2->fetch();

    if ($cat1 && $cat2) {
        echo "Categoría 1 Encontrada: {$cat1['name']} (Orden actual: {$cat1['order_position']})\n";
        echo "Categoría 2 Encontrada: {$cat2['name']} (Orden actual: {$cat2['order_position']})\n";

        // Intercambiar ordenes
        $newOrder1 = $cat2['order_position'];
        $newOrder2 = $cat1['order_position'];

        $update1 = $db->prepare("UPDATE service_categories SET order_position = ? WHERE id = ?");
        $update1->execute([$newOrder1, $cat1['id']]);

        $update2 = $db->prepare("UPDATE service_categories SET order_position = ? WHERE id = ?");
        $update2->execute([$newOrder2, $cat2['id']]);

        echo "\nÓrdenes intercambiados exitosamente.\n";
        echo "Nuevo Orden para '{$cat1['name']}': {$newOrder1}\n";
        echo "Nuevo Orden para '{$cat2['name']}': {$newOrder2}\n";
    } else {
        echo "No se encontraron ambas categorías. Revisa los nombres.\n";
    }

} catch (Exception $e) {
    echo "Excepcion: " . $e->getMessage() . "\n";
}
