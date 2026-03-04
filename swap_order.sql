-- Data Wyrd - Ajuste de Orden de Pilares
-- Ejecutar en Entorno Demo y Producción

-- 1. Variables temporales para almacenar el orden actual de ambas categorías
SET @orden_arquitectura = (SELECT order_position FROM service_categories WHERE name LIKE '%Arquitectura%' LIMIT 1);
SET @orden_web = (SELECT order_position FROM service_categories WHERE name LIKE '%Web%' LIMIT 1);

-- 2. Intercambio cruzado de posiciones 
UPDATE service_categories 
SET order_position = @orden_web 
WHERE name LIKE '%Arquitectura%';

UPDATE service_categories 
SET order_position = @orden_arquitectura 
WHERE name LIKE '%Web%';

-- Con este script, el menú superior, el footer y todas las secciones de la Home
-- se actualizarán automáticamente respetando el enfoque Zero-Hardcode.
