# FASE 3: AUDITORÍA DE BASE DE DATOS

Total de tablas: 39

### Tabla: `active_services`
Columnas: 15
`id`, `client_id`, `ticket_id`, `invoice_id`, `service_plan_id`, `name`, `description`, `status`, `start_date`, `end_date`, `renewal_date`, `activated_by`, `created_at`, `updated_at`, `tenant_id`

### Tabla: `audit_logs`
Columnas: 15
`id`, `request_id`, `tenant_id`, `user_id`, `user_email`, `user_role`, `action`, `details`, `level`, `ip_address`, `user_agent`, `request_uri`, `request_method`, `signature_hash`, `created_at`

### Tabla: `blacklist`
Columnas: 4
`id`, `email`, `reason`, `created_at`

### Tabla: `blog_categories`
Columnas: 8
`id`, `name`, `slug`, `description`, `color`, `is_active`, `created_at`, `updated_at`

### Tabla: `blog_posts`
Columnas: 16
`id`, `author_id`, `category_id`, `title`, `slug`, `excerpt`, `content`, `featured_image`, `status`, `published_at`, `views_count`, `allow_comments`, `meta_title`, `meta_description`, `created_at`, `updated_at`

### Tabla: `budget_items`
Columnas: 8
`id`, `budget_id`, `description`, `type`, `quantity`, `unit_price`, `total`, `order_position`

### Tabla: `budgets`
Columnas: 19
`id`, `budget_number`, `ticket_id`, `version`, `title`, `scope`, `timeline_weeks`, `subtotal`, `tax_rate`, `tax_amount`, `total`, `currency`, `valid_days`, `status`, `notes`, `approved_at`, `created_by`, `created_at`, `updated_at`

### Tabla: `candidate_update_tokens`
Columnas: 6
`id`, `candidate_id`, `token`, `expires_at`, `used_at`, `created_at`

### Tabla: `candidates`
Columnas: 12
`id`, `first_name`, `last_name`, `email`, `phone`, `linkedin_url`, `country`, `city`, `address`, `user_id`, `created_at`, `updated_at`

### Tabla: `chat_messages`
Columnas: 8
`id`, `ticket_id`, `user_id`, `message`, `message_type`, `attachment_path`, `is_read`, `created_at`

### Tabla: `comments`
Columnas: 11
`id`, `post_id`, `user_id`, `parent_id`, `author_name`, `author_email`, `content`, `status`, `ip_address`, `created_at`, `updated_at`

### Tabla: `email_logs`
Columnas: 10
`id`, `to_email`, `to_name`, `subject`, `body`, `status`, `error_message`, `related_type`, `related_id`, `created_at`

### Tabla: `invoice_events`
Columnas: 8
`id`, `invoice_id`, `tenant_id`, `event_type`, `amount`, `payload`, `created_by`, `created_at`

### Tabla: `invoices`
Columnas: 20
`id`, `invoice_number`, `budget_id`, `client_id`, `issue_date`, `due_date`, `subtotal`, `tax_rate`, `tax_amount`, `total`, `paid_amount`, `currency`, `status`, `mp_preference_id`, `paid_at`, `notes`, `created_by`, `created_at`, `updated_at`, `tenant_id`

### Tabla: `job_application_status_logs`
Columnas: 5
`id`, `application_id`, `old_status`, `new_status`, `created_at`

### Tabla: `job_applications`
Columnas: 10
`id`, `candidate_id`, `vacancy_name`, `skills`, `presentation_letter`, `cv_path`, `status`, `status_updated_at`, `created_at`, `updated_at`

### Tabla: `jobs`
Columnas: 8
`id`, `job_class`, `payload`, `attempts`, `status`, `error_message`, `created_at`, `updated_at`

### Tabla: `jwt_refresh_tokens`
Columnas: 5
`id`, `user_id`, `token`, `expires_at`, `created_at`

### Tabla: `login_logs`
Columnas: 7
`id`, `user_id`, `ip_address`, `email_attempted`, `success`, `user_agent`, `created_at`

### Tabla: `mktg_automation_steps`
Columnas: 6
`id`, `automation_id`, `step_order`, `step_type`, `step_config`, `created_at`

### Tabla: `mktg_automations`
Columnas: 10
`id`, `tenant_id`, `name`, `trigger_type`, `trigger_data`, `status`, `created_by`, `created_at`, `updated_at`, `deleted_at`

### Tabla: `mktg_campaigns`
Columnas: 20
`id`, `tenant_id`, `name`, `subject`, `preview_text`, `from_name`, `from_email`, `reply_to`, `template_id`, `list_id`, `segment_filters`, `type`, `status`, `paused_reason`, `scheduled_at`, `sent_at`, `created_by`, `created_at`, `updated_at`, `deleted_at`

### Tabla: `mktg_contacts`
Columnas: 25
`id`, `tenant_id`, `list_id`, `email`, `first_name`, `last_name`, `phone`, `company`, `country`, `industry`, `tags`, `custom_fields`, `status`, `consent_given`, `consent_ip`, `consent_at`, `source`, `crm_contact_id`, `unsubscribe_token`, `unsubscribed_at`, `suppression_reason`, `suppressed_at`, `created_at`, `updated_at`, `deleted_at`

### Tabla: `mktg_conversion_events`
Columnas: 9
`id`, `tenant_id`, `campaign_id`, `contact_id`, `send_log_id`, `conversion_type`, `reference_id`, `revenue_amount`, `occurred_at`

### Tabla: `mktg_events`
Columnas: 9
`id`, `campaign_id`, `contact_id`, `send_log_id`, `event_type`, `url_clicked`, `ip_address`, `user_agent`, `occurred_at`

### Tabla: `mktg_lists`
Columnas: 9
`id`, `tenant_id`, `name`, `description`, `tags`, `created_by`, `created_at`, `updated_at`, `deleted_at`

### Tabla: `mktg_send_log`
Columnas: 13
`id`, `campaign_id`, `contact_id`, `email`, `status`, `tracking_token`, `unsubscribe_token`, `provider_message_id`, `error_message`, `attempts`, `queued_at`, `sent_at`, `opened_at`

### Tabla: `mktg_templates`
Columnas: 12
`id`, `tenant_id`, `name`, `subject`, `preview_text`, `html_body`, `text_body`, `category`, `created_by`, `created_at`, `updated_at`, `deleted_at`

### Tabla: `notifications`
Columnas: 9
`id`, `user_id`, `type`, `title`, `message`, `link`, `is_read`, `email_sent`, `created_at`

### Tabla: `payment_receipts`
Columnas: 13
`id`, `invoice_id`, `uploaded_by`, `filename`, `filepath`, `amount`, `payment_date`, `payment_method`, `status`, `verified_by`, `verified_at`, `notes`, `created_at`

### Tabla: `service_categories`
Columnas: 10
`id`, `name`, `slug`, `description`, `icon`, `image`, `order_position`, `is_active`, `created_at`, `updated_at`

### Tabla: `service_plans`
Columnas: 12
`id`, `service_id`, `name`, `level`, `price`, `currency`, `features`, `is_featured`, `is_active`, `created_at`, `updated_at`, `tenant_id`

### Tabla: `services`
Columnas: 14
`id`, `category_id`, `name`, `slug`, `short_description`, `full_description`, `icon`, `image`, `is_featured`, `is_active`, `order_position`, `created_at`, `updated_at`, `tenant_id`

### Tabla: `sessions`
Columnas: 6
`id`, `payload`, `last_activity`, `user_id`, `ip_address`, `user_agent`

### Tabla: `tenants`
Columnas: 5
`id`, `name`, `domain`, `is_active`, `created_at`

### Tabla: `ticket_attachments`
Columnas: 8
`id`, `ticket_id`, `user_id`, `filename`, `filepath`, `filetype`, `filesize`, `created_at`

### Tabla: `tickets`
Columnas: 13
`id`, `ticket_number`, `client_id`, `assigned_to`, `service_plan_id`, `subject`, `description`, `priority`, `status`, `created_at`, `updated_at`, `closed_at`, `tenant_id`

### Tabla: `user_dashboard_config`
Columnas: 5
`id`, `user_id`, `widget_key`, `is_visible`, `sort_order`

### Tabla: `users`
Columnas: 17
`id`, `uuid`, `name`, `email`, `phone`, `company`, `password`, `two_factor_enabled`, `two_factor_secret`, `role`, `avatar`, `is_active`, `email_verified_at`, `remember_token`, `created_at`, `updated_at`, `tenant_id`

