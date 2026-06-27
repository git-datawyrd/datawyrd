<?php
/**
 * Configuración común para todos los entornos
 */
return [
    'name' => getenv('APP_NAME') ?: 'Data Wyrd OS',
    'app_key' => getenv('APP_KEY'),
    'timezone' => getenv('APP_TIMEZONE') ?: 'America/Argentina/Buenos_Aires',
    'charset' => getenv('APP_CHARSET') ?: 'UTF-8',
    'security' => [
        'session_lifetime' => getenv('SESSION_LIFETIME') ?: 7200,
        'session_heartbeat' => getenv('SESSION_HEARTBEAT') ?: 300,
        'session_warning' => getenv('SESSION_WARNING') ?: 300,
        'csrf_token_name' => '_token',
        'auth_max_attempts' => getenv('AUTH_MAX_ATTEMPTS') ?: 5,
        'auth_rate_limit_decay' => getenv('AUTH_RATE_LIMIT_DECAY') ?: 60,
        'auth_brute_force_block' => getenv('AUTH_BRUTE_FORCE_BLOCK') ?: 1800,
        'auth_account_lock' => getenv('AUTH_ACCOUNT_LOCK') ?: 900,
        'hash_algo' => getenv('AUTH_HASH_ALGO') ?: 'argon2id',
        'jwt_secret' => getenv('JWT_SECRET'), // Quitado el default inseguro
        'jwt_ttl' => getenv('JWT_TTL') ?: 3600,
    ],
    'intelligence' => [
        'rbac_mode' => getenv('RBAC_MODE') ?: 'classic',
        'lead_scoring' => getenv('LEAD_SCORING_ENABLED') === 'true',
        'roi_metrics' => getenv('ROI_METRICS_ENABLED') === 'true',
        'internal_events' => getenv('INTERNAL_EVENTS_ENABLED') === 'true',
    ],
    'mail' => [
        'host' => getenv('MAIL_HOST'),
        'port' => getenv('MAIL_PORT'),
        'user' => getenv('MAIL_USERNAME'),
        'pass' => getenv('MAIL_PASSWORD'),
        'enc' => getenv('MAIL_ENCRYPTION'),
        'from_address' => getenv('MAIL_FROM_ADDRESS'),
        'from_name' => getenv('MAIL_FROM_NAME'),
    ],
    'business' => [
        'company_name' => getenv('COMPANY_NAME') ?: 'Data Wyrd',
        'company_slogan' => getenv('COMPANY_SLOGAN') ?: 'Ingeniería de Datos',
        'sla_response_time' => getenv('SLA_RESPONSE_TIME') ?: '24h',
        'currency_symbol' => getenv('CURRENCY_SYMBOL') ?: '$',
        'tax_rate' => getenv('TAX_RATE') ?: 0,
        'show_enterprise_profile' => getenv('SHOW_ENTERPRISE_PROFILE') === 'true',
        'years_exp' => getenv('COMPANY_YEARS_EXP') ?: 10,
        'projects_delivered' => getenv('COMPANY_PROJECTS_DELIVERED') ?: 45,
    ],
    'limits' => [
        'max_upload_size' => getenv('MAX_UPLOAD_SIZE') ?: 10485760, // 10MB
    ],
    'typography' => [
        'font_heading' => getenv('FONT_HEADING') ?: "'Space Grotesk', sans-serif",
        'font_body' => getenv('FONT_BODY') ?: "'Outfit', sans-serif",
        'scale_ratio' => getenv('TYPO_SCALE_RATIO') ?: 1.25,
    ],
    'payment' => [
        'mp_access_token' => getenv('MP_ACCESS_TOKEN') ?: '',
        'mp_public_key' => getenv('MP_PUBLIC_KEY') ?: '',
        'mp_currency_id' => getenv('MP_CURRENCY_ID') ?: 'ARS',
        'exchange_rate' => getenv('MP_EXCHANGE_RATE') ?: 1,
    ],
    'bank' => [
        'name' => getenv('BANK_NAME') ?: 'Ecosistema Digital Bank',
        'account_name' => getenv('BANK_ACCOUNT_NAME') ?: 'Data Wyrd Services LLC',
        'account_number' => getenv('BANK_ACCOUNT_NUMBER') ?: '1234-5678-9012',
        'cbu_alias' => getenv('BANK_CBU_ALIAS') ?: 'datawyrd.usd',
    ],

    // =========================================================================
    // MÓDULO DE EMAIL MARKETING & ENGAGEMENT
    // =========================================================================
    'marketing' => [
        // --- Provider principal de envío masivo ---
        // Opciones: 'smtp' | 'zepto' | 'sendgrid' | 'mailgun'
        'provider' => getenv('MARKETING_PROVIDER') ?: 'smtp',

        // --- Credenciales ZeptoMail (Zoho) ---
        'zepto' => [
            'api_key'       => getenv('ZEPTO_API_KEY') ?: '',
            'api_url'       => getenv('ZEPTO_API_URL') ?: 'https://api.zeptomail.com/v1.1/email',
            'from_address'  => getenv('ZEPTO_FROM_ADDRESS') ?: getenv('MAIL_FROM_ADDRESS') ?: '',
            'from_name'     => getenv('ZEPTO_FROM_NAME') ?: getenv('MAIL_FROM_NAME') ?: 'Data Wyrd',
            'bounce_address'=> getenv('ZEPTO_BOUNCE_ADDRESS') ?: '',
        ],
        'sendgrid' => [
            'api_key'      => getenv('SENDGRID_API_KEY') ?: '',
            'from_address' => getenv('SENDGRID_FROM_ADDRESS') ?: getenv('MAIL_FROM_ADDRESS') ?: '',
            'from_name'    => getenv('SENDGRID_FROM_NAME') ?: getenv('MAIL_FROM_NAME') ?: 'Data Wyrd',
        ],
        'mailgun' => [
            'api_key'      => getenv('MAILGUN_API_KEY') ?: '',
            'domain'       => getenv('MAILGUN_DOMAIN') ?: '',
            'from_address' => getenv('MAILGUN_FROM_ADDRESS') ?: getenv('MAIL_FROM_ADDRESS') ?: '',
            'from_name'    => getenv('MAILGUN_FROM_NAME') ?: getenv('MAIL_FROM_NAME') ?: 'Data Wyrd',
        ],

        // --- Límites de envío (Rate Limiting & Throttle) ---
        'rate' => [
            'batch_size'        => (int)(getenv('MARKETING_BATCH_SIZE') ?: 50),      // Emails por lote de worker
            'delay_between_ms'  => (int)(getenv('MARKETING_DELAY_MS') ?: 200),        // ms entre cada envío
            'max_per_minute'    => (int)(getenv('MARKETING_MAX_PER_MINUTE') ?: 250),  // Límite por minuto (ej: 250 por defecto, editable según proveedor SMTP)
            'max_per_hour'      => (int)(getenv('MARKETING_MAX_PER_HOUR') ?: 500),    // Límite horario global
            'max_per_day'       => (int)(getenv('MARKETING_MAX_PER_DAY') ?: 5000),   // Límite diario global
        ],

        // --- Tracking de aperturas y clics ---
        'tracking' => [
            'pixel_enabled'     => getenv('MARKETING_PIXEL_ENABLED') !== 'false',    // Pixel de apertura
            'click_enabled'     => getenv('MARKETING_CLICK_ENABLED') !== 'false',    // Tracking de clics
            'base_url'          => getenv('MARKETING_TRACKING_URL') ?: getenv('APP_URL') ?: '',
            'pixel_path'        => '/track/open',
            'click_path'        => '/track/click',
            'unsubscribe_path'  => '/track/unsubscribe',
        ],

        // --- Cumplimiento GDPR / CAN-SPAM / RFC 8058 ---
        'compliance' => [
            'unsubscribe_enabled'       => getenv('MARKETING_UNSUB_ENABLED') !== 'false',
            'list_unsubscribe_header'   => getenv('MARKETING_LIST_UNSUB_HEADER') !== 'false', // RFC 8058
            'double_opt_in'             => getenv('MARKETING_DOUBLE_OPT_IN') === 'true',
            'gdpr_consent_required'     => getenv('MARKETING_GDPR_CONSENT') === 'true',
            'suppress_bounced'          => getenv('MARKETING_SUPPRESS_BOUNCED') !== 'false', // Bloquea hard bounces
            'suppress_complained'       => getenv('MARKETING_SUPPRESS_COMPLAINED') !== 'false',
        ],

        // --- Reintentos de envío fallido ---
        'retry' => [
            'max_attempts'  => (int)(getenv('MARKETING_MAX_RETRIES') ?: 3),
            'delay_seconds' => (int)(getenv('MARKETING_RETRY_DELAY') ?: 300), // 5 min entre reintentos
        ],

        // --- Dominio de tracking para email reputation ---
        'reputation' => [
            'dkim_domain'   => getenv('MARKETING_DKIM_DOMAIN') ?: '',
            'custom_domain' => getenv('MARKETING_CUSTOM_DOMAIN') ?: '',
        ],
    ],

    // =========================================================================
    // MITIGACIÓN DE BOTS & CAPTCHA
    // =========================================================================
    'captcha' => [
        'provider'      => getenv('CAPTCHA_PROVIDER') ?: 'local',
        'site_key'      => getenv('CAPTCHA_SITE_KEY') ?: '',
        'secret_key'    => getenv('CAPTCHA_SECRET_KEY') ?: '',
        'honeypot_name' => getenv('CAPTCHA_HONEYPOT_NAME') ?: 'website_extra',
    ],
];

