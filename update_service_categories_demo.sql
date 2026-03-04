-- Data Wyrd - Actualización de Pilares Estratégicos (Modelo Enterprise)
-- Ejecutar este archivo en el entorno remoto/demo (phpMyAdmin u otro gestor)

-- 1. ETL & Data Warehousing -> Arquitectura y Gobierno de Datos
UPDATE service_categories 
SET name = 'Arquitectura y Gobierno de Datos', 
    slug = 'arquitectura-gobierno-datos', 
    description = 'Diseñamos ecosistemas de datos robustos, escalables y seguros que garantizan calidad, trazabilidad y control total sobre la información crítica del negocio.',
    image = REPLACE(image, 'etl-data-warehousing', 'arquitectura-gobierno-datos')
WHERE slug = 'etl-data-warehousing' OR slug = 'arquitectura-gobierno-datos';

-- 2. Big Data & BI -> Inteligencia para la Toma de Decisiones
UPDATE service_categories 
SET name = 'Inteligencia para la Toma de Decisiones', 
    slug = 'inteligencia-decisiones', 
    description = 'Transformamos datos en información accionable mediante analítica avanzada, modelos predictivos y visualización ejecutiva enfocada en resultados financieros.',
    image = REPLACE(image, 'big-data-bi', 'inteligencia-decisiones')
WHERE slug = 'big-data-bi' OR slug = 'inteligencia-decisiones';

-- 3. Desarrollo Web & Apps -> Plataformas Digitales Basadas en Datos
UPDATE service_categories 
SET name = 'Plataformas Digitales Basadas en Datos', 
    slug = 'plataformas-digitales', 
    description = 'Construimos soluciones digitales y aplicaciones empresariales que integran datos en tiempo real para mejorar procesos, experiencia del cliente y eficiencia operativa.',
    image = REPLACE(image, 'desarrollo-web-apps', 'plataformas-digitales')
WHERE slug = 'desarrollo-web-apps' OR slug = 'plataformas-digitales';

-- 4. Optimización de Procesos -> Automatización y Eficiencia Operativa
UPDATE service_categories 
SET name = 'Automatización y Eficiencia Operativa', 
    slug = 'automatizacion-eficiencia', 
    description = 'Optimizamos procesos mediante automatización inteligente y modelos algorítmicos que reducen errores, dependencia manual y tiempos improductivos.',
    image = REPLACE(image, 'optimizacion-procesos', 'automatizacion-eficiencia')
WHERE slug = 'optimizacion-procesos' OR slug = 'automatizacion-eficiencia';
