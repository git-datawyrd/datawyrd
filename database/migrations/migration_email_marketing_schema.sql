-- ============================================================================
-- DATA WYRD OS - MÓDULO DE EMAIL MARKETING & ENGAGEMENT v2.0
-- Esquema de base de datos - Prefijo mktg_* para aislamiento limpio
-- Todas las tablas incluyen tenant_id para multitenancy estricto
-- ============================================================================

USE `datawyrd`;

SET FOREIGN_KEY_CHECKS = 0;
SET sql_mode = '';

-- ============================================================================
-- TABLA 1: mktg_lists (Listas de suscriptores)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `mktg_lists` (
    `id`          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `tenant_id`   INT UNSIGNED NOT NULL DEFAULT 1,
    `name`        VARCHAR(150) NOT NULL,
    `description` TEXT DEFAULT NULL,
    `tags`        JSON DEFAULT NULL,
    `created_by`  INT UNSIGNED NOT NULL,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at`  TIMESTAMP NULL DEFAULT NULL,
    KEY `idx_mktg_lists_tenant` (`tenant_id`),
    KEY `idx_mktg_lists_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Listas de suscriptores del módulo de marketing';

-- ============================================================================
-- TABLA 2: mktg_contacts (Contactos / Suscriptores)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `mktg_contacts` (
    `id`                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `tenant_id`         INT UNSIGNED NOT NULL DEFAULT 1,
    `list_id`           INT UNSIGNED NOT NULL,
    `email`             VARCHAR(190) NOT NULL,
    `first_name`        VARCHAR(100) DEFAULT NULL,
    `last_name`         VARCHAR(100) DEFAULT NULL,
    `custom_fields`     JSON DEFAULT NULL,
    `status`            ENUM('subscribed','unsubscribed','suppressed','pending') NOT NULL DEFAULT 'subscribed',
    `consent_given`     TINYINT(1) NOT NULL DEFAULT 0,
    `consent_ip`        VARCHAR(45) DEFAULT NULL,
    `consent_at`        TIMESTAMP NULL DEFAULT NULL,
    `source`            VARCHAR(100) DEFAULT NULL,
    `crm_contact_id`    INT UNSIGNED DEFAULT NULL,
    `unsubscribe_token` VARCHAR(64) NOT NULL DEFAULT '',
    `unsubscribed_at`   TIMESTAMP NULL DEFAULT NULL,
    `suppression_reason` VARCHAR(255) DEFAULT NULL,
    `suppressed_at`     TIMESTAMP NULL DEFAULT NULL,
    `created_at`        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at`        TIMESTAMP NULL DEFAULT NULL,
    UNIQUE KEY `uk_mktg_contacts_email_list` (`email`, `list_id`),
    UNIQUE KEY `uk_mktg_contacts_token`      (`unsubscribe_token`),
    KEY `idx_mktg_contacts_tenant`  (`tenant_id`),
    KEY `idx_mktg_contacts_list`    (`list_id`),
    KEY `idx_mktg_contacts_status`  (`status`),
    KEY `idx_mktg_contacts_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Suscriptores/contactos de listas de marketing';

-- ============================================================================
-- TABLA 3: mktg_templates (Plantillas de Email HTML)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `mktg_templates` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `tenant_id`    INT UNSIGNED NOT NULL DEFAULT 1,
    `name`         VARCHAR(150) NOT NULL,
    `subject`      VARCHAR(255) NOT NULL,
    `preview_text` VARCHAR(255) DEFAULT NULL,
    `html_body`    LONGTEXT NOT NULL,
    `text_body`    TEXT DEFAULT NULL,
    `category`     VARCHAR(100) DEFAULT NULL,
    `created_by`   INT UNSIGNED NOT NULL,
    `created_at`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at`   TIMESTAMP NULL DEFAULT NULL,
    KEY `idx_mktg_templates_tenant`  (`tenant_id`),
    KEY `idx_mktg_templates_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Plantillas HTML reutilizables para campañas';

-- ============================================================================
-- TABLA 4: mktg_campaigns (Campañas de Email Marketing)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `mktg_campaigns` (
    `id`               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `tenant_id`        INT UNSIGNED NOT NULL DEFAULT 1,
    `name`             VARCHAR(150) NOT NULL,
    `subject`          VARCHAR(255) NOT NULL,
    `preview_text`     VARCHAR(255) DEFAULT NULL,
    `from_name`        VARCHAR(100) DEFAULT NULL,
    `from_email`       VARCHAR(190) DEFAULT NULL,
    `reply_to`         VARCHAR(190) DEFAULT NULL,
    `template_id`      INT UNSIGNED DEFAULT NULL,
    `list_id`          INT UNSIGNED DEFAULT NULL,
    `segment_filters`  JSON DEFAULT NULL,
    `type`             ENUM('one_time','recurring','automated') NOT NULL DEFAULT 'one_time',
    `status`           ENUM('draft','scheduled','sending','sent','paused','cancelled') NOT NULL DEFAULT 'draft',
    `scheduled_at`     TIMESTAMP NULL DEFAULT NULL,
    `sent_at`          TIMESTAMP NULL DEFAULT NULL,
    `created_by`       INT UNSIGNED NOT NULL,
    `created_at`       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at`       TIMESTAMP NULL DEFAULT NULL,
    KEY `idx_mktg_campaigns_tenant`   (`tenant_id`),
    KEY `idx_mktg_campaigns_status`   (`status`),
    KEY `idx_mktg_campaigns_schedule` (`scheduled_at`),
    KEY `idx_mktg_campaigns_deleted`  (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Campañas de email marketing';

-- ============================================================================
-- TABLA 5: mktg_send_log (Cola de envíos individuales - hydration pattern)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `mktg_send_log` (
    `id`                   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `campaign_id`          INT UNSIGNED NOT NULL,
    `contact_id`           INT UNSIGNED DEFAULT NULL,
    `email`                VARCHAR(190) NOT NULL,
    `status`               ENUM('queued','processing','sent','failed','soft_bounced','bounced') NOT NULL DEFAULT 'queued',
    `tracking_token`       VARCHAR(64) NOT NULL DEFAULT '',
    `unsubscribe_token`    VARCHAR(64) NOT NULL DEFAULT '',
    `provider_message_id`  VARCHAR(255) DEFAULT NULL,
    `error_message`        TEXT DEFAULT NULL,
    `attempts`             TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `queued_at`            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `sent_at`              TIMESTAMP NULL DEFAULT NULL,
    `opened_at`            TIMESTAMP NULL DEFAULT NULL,
    UNIQUE KEY `uk_mktg_send_log_token`    (`tracking_token`),
    KEY `idx_mktg_send_log_campaign`       (`campaign_id`),
    KEY `idx_mktg_send_log_status`         (`status`),
    KEY `idx_mktg_send_log_provider_msg`   (`provider_message_id`),
    KEY `idx_mktg_send_log_queued`         (`queued_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Cola de envíos individuales por campaña';

-- ============================================================================
-- TABLA 6: mktg_events (Eventos de tracking: open, click, bounce, unsub)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `mktg_events` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `campaign_id`  INT UNSIGNED DEFAULT NULL,
    `contact_id`   INT UNSIGNED DEFAULT NULL,
    `send_log_id`  INT UNSIGNED DEFAULT NULL,
    `event_type`   ENUM('open','click','bounce','complaint','unsub','delivered','conversion') NOT NULL,
    `url_clicked`  VARCHAR(2048) DEFAULT NULL,
    `ip_address`   VARCHAR(64) DEFAULT NULL,
    `user_agent`   VARCHAR(512) DEFAULT NULL,
    `occurred_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_mktg_events_campaign`  (`campaign_id`),
    KEY `idx_mktg_events_contact`   (`contact_id`),
    KEY `idx_mktg_events_send_log`  (`send_log_id`),
    KEY `idx_mktg_events_type`      (`event_type`),
    KEY `idx_mktg_events_occurred`  (`occurred_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Eventos de interacción con emails de marketing';

-- ============================================================================
-- TABLA 7: mktg_automations (Automatizaciones / Flujos de Email)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `mktg_automations` (
    `id`          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `tenant_id`   INT UNSIGNED NOT NULL DEFAULT 1,
    `name`        VARCHAR(150) NOT NULL,
    `trigger_type` ENUM('signup','tag_added','campaign_open','campaign_click','purchase','date_based','manual') NOT NULL DEFAULT 'signup',
    `trigger_data` JSON DEFAULT NULL,
    `status`      ENUM('active','paused','draft') NOT NULL DEFAULT 'draft',
    `created_by`  INT UNSIGNED NOT NULL,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at`  TIMESTAMP NULL DEFAULT NULL,
    KEY `idx_mktg_auto_tenant`  (`tenant_id`),
    KEY `idx_mktg_auto_status`  (`status`),
    KEY `idx_mktg_auto_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Definición de automatizaciones de email';

-- ============================================================================
-- TABLA 8: mktg_automation_steps (Pasos de cada automatización)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `mktg_automation_steps` (
    `id`              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `automation_id`   INT UNSIGNED NOT NULL,
    `step_order`      TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `step_type`       ENUM('send_email','wait','condition','tag','webhook') NOT NULL DEFAULT 'send_email',
    `step_config`     JSON NOT NULL,
    `created_at`      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_mktg_steps_automation` (`automation_id`),
    KEY `idx_mktg_steps_order`      (`step_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Pasos individuales de cada automatización';

-- ============================================================================
-- TABLA 9: mktg_conversion_events (Atribución de conversiones/ROI)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `mktg_conversion_events` (
    `id`               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `tenant_id`        INT UNSIGNED NOT NULL DEFAULT 1,
    `campaign_id`      INT UNSIGNED DEFAULT NULL,
    `contact_id`       INT UNSIGNED DEFAULT NULL,
    `send_log_id`      INT UNSIGNED DEFAULT NULL,
    `conversion_type`  ENUM('invoice_paid','signup','upgrade','custom') NOT NULL DEFAULT 'invoice_paid',
    `reference_id`     INT UNSIGNED DEFAULT NULL,
    `revenue_amount`   DECIMAL(12,2) DEFAULT NULL,
    `occurred_at`      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_mktg_conv_tenant`    (`tenant_id`),
    KEY `idx_mktg_conv_campaign`  (`campaign_id`),
    KEY `idx_mktg_conv_contact`   (`contact_id`),
    KEY `idx_mktg_conv_type`      (`conversion_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Eventos de conversión atribuidos a campañas (ROI)';

SET FOREIGN_KEY_CHECKS = 1;
