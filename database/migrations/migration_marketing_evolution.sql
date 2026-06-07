-- ============================================================================
-- DATA WYRD OS - MÓDULO DE EMAIL MARKETING & ENGAGEMENT EVOLUTION
-- Esquema de base de datos y optimización de índices para segmentación
-- ============================================================================

USE `datawyrd`;

-- 1. Tabla global de blacklist
CREATE TABLE IF NOT EXISTS `blacklist` (
    `id`          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `email`       VARCHAR(190) NOT NULL UNIQUE,
    `reason`      VARCHAR(255) DEFAULT NULL,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_blacklist_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Lista negra global para evitar envíos a correos desuscritos o rebotados';

-- 2. Adición de columnas de atributos para segmentación en mktg_contacts
-- Usamos validaciones y sentencias condicionales/try en el runner, o alter table directo
ALTER TABLE `mktg_contacts`
    ADD COLUMN `phone` VARCHAR(50) DEFAULT NULL AFTER `last_name`,
    ADD COLUMN `company` VARCHAR(150) DEFAULT NULL AFTER `phone`,
    ADD COLUMN `country` VARCHAR(100) DEFAULT NULL AFTER `company`,
    ADD COLUMN `industry` VARCHAR(100) DEFAULT NULL AFTER `country`,
    ADD COLUMN `tags` VARCHAR(255) DEFAULT NULL AFTER `industry`;

-- 3. Índices combinados optimizados en mktg_contacts (evitar Full Table Scans)
ALTER TABLE `mktg_contacts`
    ADD INDEX `idx_contacts_segment` (`tenant_id`, `list_id`, `status`, `country`, `industry`),
    ADD INDEX `idx_contacts_tags` (`tenant_id`, `list_id`, `tags`);

-- 4. Índices combinados optimizados en mktg_events (búsqueda rápida de comportamiento)
ALTER TABLE `mktg_events`
    ADD INDEX `idx_events_search` (`campaign_id`, `event_type`, `contact_id`),
    ADD INDEX `idx_events_behavior` (`contact_id`, `event_type`, `occurred_at`);

-- 5. Columna paused_reason en mktg_campaigns (registra motivo de pausa automática por umbrales)
ALTER TABLE `mktg_campaigns`
    ADD COLUMN IF NOT EXISTS `paused_reason` VARCHAR(500) DEFAULT NULL AFTER `status`;

