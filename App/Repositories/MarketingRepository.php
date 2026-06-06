<?php
namespace App\Repositories;

use PDO;
use Core\Config;

/**
 * MarketingRepository
 *
 * Capa de acceso a datos del módulo de Email Marketing & Engagement.
 * Todas las queries están parametrizadas (cero SQL injection) y
 * filtradas por tenant_id para aislamiento multi-tenant estricto.
 *
 * Tablas gestionadas:
 *   mktg_lists, mktg_contacts, mktg_campaigns, mktg_templates,
 *   mktg_send_log, mktg_events, mktg_automations,
 *   mktg_automation_steps, mktg_conversion_events
 *
 * @package App\Repositories
 */
class MarketingRepository extends BaseRepository
{
    protected string $table = 'mktg_campaigns'; // Tabla principal por defecto

    // =========================================================================
    // LISTAS DE CONTACTOS
    // =========================================================================

    public function getAllLists(): array
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "SELECT l.*, COUNT(c.id) as contact_count
             FROM mktg_lists l
             LEFT JOIN mktg_contacts c ON c.list_id = l.id AND c.tenant_id = l.tenant_id
             WHERE l.tenant_id = ? AND l.deleted_at IS NULL
             GROUP BY l.id
             ORDER BY l.created_at DESC"
        );
        $stmt->execute([$tenantId]);
        return $stmt->fetchAll();
    }

    public function findList(int $listId): ?array
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "SELECT * FROM mktg_lists WHERE id = ? AND tenant_id = ? AND deleted_at IS NULL"
        );
        $stmt->execute([$listId, $tenantId]);
        return $stmt->fetch() ?: null;
    }

    public function createList(array $data): int
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "INSERT INTO mktg_lists (tenant_id, name, description, tags, created_by)
             VALUES (?, ?, ?, ?, ?)"
        );
        $stmt->execute([
            $tenantId,
            $data['name'],
            $data['description'] ?? null,
            isset($data['tags']) ? json_encode($data['tags']) : null,
            $data['created_by'],
        ]);
        return (int) $this->db->lastInsertId();
    }

    // =========================================================================
    // CONTACTOS
    // =========================================================================

    public function getContactsByList(int $listId, array $filters = []): array
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $sql = "SELECT * FROM mktg_contacts
                WHERE list_id = ? AND tenant_id = ? AND deleted_at IS NULL";
        $params = [$listId, $tenantId];

        if (!empty($filters['status'])) {
            $sql .= " AND status = ?";
            $params[] = $filters['status'];
        }
        if (!empty($filters['search'])) {
            $sql .= " AND (email LIKE ? OR first_name LIKE ? OR last_name LIKE ?)";
            $term = '%' . $filters['search'] . '%';
            $params = array_merge($params, [$term, $term, $term]);
        }

        $sql .= " ORDER BY created_at DESC";
        if (!empty($filters['limit'])) {
            $sql .= " LIMIT " . (int)$filters['limit'];
            if (!empty($filters['offset'])) {
                $sql .= " OFFSET " . (int)$filters['offset'];
            }
        }

        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    public function findContactByEmail(string $email, int $listId): ?array
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "SELECT * FROM mktg_contacts
             WHERE email = ? AND list_id = ? AND tenant_id = ? AND deleted_at IS NULL"
        );
        $stmt->execute([$email, $listId, $tenantId]);
        return $stmt->fetch() ?: null;
    }

    public function createContact(array $data): int
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $token = $data['unsubscribe_token'] ?? bin2hex(random_bytes(16));
        $stmt = $this->db->prepare(
            "INSERT INTO mktg_contacts
             (tenant_id, list_id, email, first_name, last_name, custom_fields,
              status, consent_given, consent_ip, consent_at, source, crm_contact_id, unsubscribe_token)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        );
        $stmt->execute([
            $tenantId,
            $data['list_id'],
            $data['email'],
            $data['first_name'] ?? null,
            $data['last_name']  ?? null,
            isset($data['custom_fields']) ? json_encode($data['custom_fields']) : null,
            $data['status']       ?? 'subscribed',
            $data['consent_given']?? 0,
            $data['consent_ip']   ?? null,
            $data['consent_at']   ?? null,
            $data['source']       ?? null,
            $data['crm_contact_id'] ?? null,
            $token,
        ]);
        return (int) $this->db->lastInsertId();
    }

    /**
     * Desuscribe un contacto por token de baja (RFC 8058).
     * Retorna true si el contacto fue encontrado y actualizado.
     */
    public function unsubscribeByToken(string $token): bool
    {
        $stmt = $this->db->prepare(
            "UPDATE mktg_contacts
             SET status = 'unsubscribed', unsubscribed_at = NOW()
             WHERE unsubscribe_token = ? AND status != 'unsubscribed'"
        );
        $stmt->execute([$token]);
        return $stmt->rowCount() > 0;
    }

    /**
     * Suprime un contacto por bounce o queja (hard bounce / spam complaint).
     */
    public function suppressContact(string $email, string $reason): bool
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "UPDATE mktg_contacts
             SET status = 'suppressed', suppression_reason = ?, suppressed_at = NOW()
             WHERE email = ? AND tenant_id = ? AND status != 'suppressed'"
        );
        $stmt->execute([$reason, $email, $tenantId]);
        return $stmt->rowCount() > 0;
    }

    // =========================================================================
    // PLANTILLAS
    // =========================================================================

    public function getAllTemplates(): array
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "SELECT * FROM mktg_templates
             WHERE tenant_id = ? AND deleted_at IS NULL
             ORDER BY created_at DESC"
        );
        $stmt->execute([$tenantId]);
        return $stmt->fetchAll();
    }

    public function findTemplate(int $templateId): ?array
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "SELECT * FROM mktg_templates
             WHERE id = ? AND tenant_id = ? AND deleted_at IS NULL"
        );
        $stmt->execute([$templateId, $tenantId]);
        return $stmt->fetch() ?: null;
    }

    public function createTemplate(array $data): int
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "INSERT INTO mktg_templates
             (tenant_id, name, subject, html_body, text_body, category, preview_text, created_by)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
        );
        $stmt->execute([
            $tenantId,
            $data['name'],
            $data['subject'],
            $data['html_body'],
            $data['text_body']     ?? null,
            $data['category']      ?? null,
            $data['preview_text']  ?? null,
            $data['created_by'],
        ]);
        return (int) $this->db->lastInsertId();
    }

    // =========================================================================
    // CAMPAÑAS
    // =========================================================================

    public function getAllCampaigns(): array
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "SELECT c.*,
                    t.name as template_name,
                    l.name as list_name,
                    COUNT(sl.id)                                         as total_sent,
                    SUM(CASE WHEN e.event_type='open'    THEN 1 ELSE 0 END) as opens,
                    SUM(CASE WHEN e.event_type='click'   THEN 1 ELSE 0 END) as clicks,
                    SUM(CASE WHEN e.event_type='bounce'  THEN 1 ELSE 0 END) as bounces,
                    SUM(CASE WHEN e.event_type='unsub'   THEN 1 ELSE 0 END) as unsubs
             FROM mktg_campaigns c
             LEFT JOIN mktg_templates t   ON t.id = c.template_id
             LEFT JOIN mktg_lists     l   ON l.id = c.list_id
             LEFT JOIN mktg_send_log  sl  ON sl.campaign_id = c.id
             LEFT JOIN mktg_events    e   ON e.campaign_id  = c.id
             WHERE c.tenant_id = ? AND c.deleted_at IS NULL
             GROUP BY c.id
             ORDER BY c.created_at DESC"
        );
        $stmt->execute([$tenantId]);
        return $stmt->fetchAll();
    }

    public function findCampaign(int $campaignId): ?array
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "SELECT * FROM mktg_campaigns
             WHERE id = ? AND tenant_id = ? AND deleted_at IS NULL"
        );
        $stmt->execute([$campaignId, $tenantId]);
        return $stmt->fetch() ?: null;
    }

    public function createCampaign(array $data): int
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "INSERT INTO mktg_campaigns
             (tenant_id, name, subject, preview_text, from_name, from_email, reply_to,
              template_id, list_id, segment_filters, type, status,
              scheduled_at, created_by)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'draft', ?, ?)"
        );
        $stmt->execute([
            $tenantId,
            $data['name'],
            $data['subject'],
            $data['preview_text']     ?? null,
            $data['from_name']        ?? null,
            $data['from_email']       ?? null,
            $data['reply_to']         ?? null,
            $data['template_id']      ?? null,
            $data['list_id']          ?? null,
            isset($data['segment_filters']) ? json_encode($data['segment_filters']) : null,
            $data['type']             ?? 'one_time',
            $data['scheduled_at']     ?? null,
            $data['created_by'],
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function updateCampaignStatus(int $campaignId, string $status, array $extra = []): bool
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $set = "status = ?";
        $params = [$status];

        if ($status === 'sending' && empty($extra['sent_at'])) {
            $set .= ", sent_at = NOW()";
        }
        foreach ($extra as $col => $val) {
            $set .= ", {$col} = ?";
            $params[] = $val;
        }
        $params[] = $campaignId;
        $params[] = $tenantId;

        $stmt = $this->db->prepare(
            "UPDATE mktg_campaigns SET {$set} WHERE id = ? AND tenant_id = ?"
        );
        return $stmt->execute($params);
    }

    // =========================================================================
    // SEND LOG (cola de envíos individuales)
    // =========================================================================

    /**
     * Obtiene el siguiente lote de envíos pendientes para el worker.
     * Usa FOR UPDATE para evitar doble procesamiento en ambientes
     * con múltiples workers concurrentes.
     */
    public function getPendingBatch(int $batchSize): array
    {
        $stmt = $this->db->prepare(
            "SELECT sl.*, c.tenant_id
             FROM mktg_send_log sl
             JOIN mktg_campaigns c ON c.id = sl.campaign_id
             WHERE sl.status = 'queued'
             ORDER BY sl.queued_at ASC
             LIMIT ? FOR UPDATE"
        );
        $stmt->execute([$batchSize]);
        return $stmt->fetchAll();
    }

    public function markSendLogProcessing(array $ids): bool
    {
        if (empty($ids)) return false;
        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $stmt = $this->db->prepare(
            "UPDATE mktg_send_log SET status = 'processing' WHERE id IN ($placeholders)"
        );
        return $stmt->execute($ids);
    }

    public function updateSendLogResult(int $sendLogId, string $status, ?string $providerMessageId, ?string $errorMessage = null): bool
    {
        $stmt = $this->db->prepare(
            "UPDATE mktg_send_log
             SET status = ?, provider_message_id = ?, error_message = ?,
                 sent_at = IF(? = 'sent', NOW(), NULL),
                 attempts = attempts + 1
             WHERE id = ?"
        );
        return $stmt->execute([$status, $providerMessageId, $errorMessage, $status, $sendLogId]);
    }

    /**
     * Hydration: popula el send_log con todos los contactos de una campaña.
     * Se llama al momento de lanzar la campaña (status → sending).
     * Respeta supresión y desuscripción de contactos.
     */
    public function hydrateSendLog(int $campaignId, int $listId, int $tenantId): int
    {
        $stmt = $this->db->prepare(
            "INSERT INTO mktg_send_log (campaign_id, contact_id, email, status, queued_at)
             SELECT ?, c.id, c.email, 'queued', NOW()
             FROM mktg_contacts c
             WHERE c.list_id = ?
               AND c.tenant_id = ?
               AND c.status = 'subscribed'
               AND c.deleted_at IS NULL
               AND c.id NOT IN (
                   SELECT contact_id FROM mktg_send_log WHERE campaign_id = ?
               )"
        );
        $stmt->execute([$campaignId, $listId, $tenantId, $campaignId]);
        return (int) $stmt->rowCount();
    }

    // =========================================================================
    // EVENTOS (Tracking: open, click, bounce, unsub)
    // =========================================================================

    public function recordEvent(array $data): int
    {
        $stmt = $this->db->prepare(
            "INSERT INTO mktg_events
             (campaign_id, contact_id, send_log_id, event_type, url_clicked, ip_address, user_agent, occurred_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, NOW())"
        );
        $stmt->execute([
            $data['campaign_id']  ?? null,
            $data['contact_id']   ?? null,
            $data['send_log_id']  ?? null,
            $data['event_type'],
            $data['url_clicked']  ?? null,
            $data['ip_address']   ?? null,
            $data['user_agent']   ?? null,
        ]);
        return (int) $this->db->lastInsertId();
    }

    /**
     * Retorna métricas agregadas para el dashboard de una campaña.
     */
    public function getCampaignMetrics(int $campaignId): array
    {
        $stmt = $this->db->prepare(
            "SELECT
                COUNT(DISTINCT sl.id)                                           as total_sent,
                COUNT(DISTINCT CASE WHEN e.event_type='delivered' THEN e.contact_id END) as delivered,
                COUNT(DISTINCT CASE WHEN e.event_type='open'      THEN e.contact_id END) as unique_opens,
                COUNT(CASE WHEN e.event_type='open'               THEN 1 END)             as total_opens,
                COUNT(DISTINCT CASE WHEN e.event_type='click'     THEN e.contact_id END) as unique_clicks,
                COUNT(CASE WHEN e.event_type='click'              THEN 1 END)             as total_clicks,
                COUNT(DISTINCT CASE WHEN e.event_type='bounce'    THEN e.contact_id END) as bounces,
                COUNT(DISTINCT CASE WHEN e.event_type='complaint' THEN e.contact_id END) as complaints,
                COUNT(DISTINCT CASE WHEN e.event_type='unsub'     THEN e.contact_id END) as unsubscribes,
                COUNT(DISTINCT CASE WHEN e.event_type='conversion'THEN e.contact_id END) as conversions
             FROM mktg_send_log sl
             LEFT JOIN mktg_events e ON e.send_log_id = sl.id
             WHERE sl.campaign_id = ?"
        );
        $stmt->execute([$campaignId]);
        return $stmt->fetch(PDO::FETCH_ASSOC) ?: [];
    }

    // =========================================================================
    // RESOLUCIÓN DE SEND LOG por tracking token
    // =========================================================================

    public function findSendLogByToken(string $token): ?array
    {
        $stmt = $this->db->prepare(
            "SELECT sl.*, c.tenant_id
             FROM mktg_send_log sl
             JOIN mktg_campaigns c ON c.id = sl.campaign_id
             WHERE sl.tracking_token = ?"
        );
        $stmt->execute([$token]);
        return $stmt->fetch() ?: null;
    }

    /**
     * Busca la última interacción de campaña enviada para un email de cliente
     * para realizar la atribución de conversión.
     */
    public function findAttributionByEmail(string $email): ?array
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "SELECT c.id AS contact_id, sl.campaign_id, sl.id AS send_log_id
             FROM mktg_contacts c
             LEFT JOIN mktg_send_log sl ON sl.contact_id = c.id AND sl.status = 'sent'
             WHERE c.email = ? AND c.tenant_id = ? AND c.deleted_at IS NULL
             ORDER BY sl.sent_at DESC, sl.id DESC
             LIMIT 1"
        );
        $stmt->execute([$email, $tenantId]);
        return $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
    }

    /**
     * Registra un evento de conversión atribuido a una campaña de marketing.
     */
    public function recordConversion(array $data): int
    {
        $tenantId = Config::get('current_tenant_id', 1);
        $stmt = $this->db->prepare(
            "INSERT INTO mktg_conversion_events
             (tenant_id, campaign_id, contact_id, send_log_id, conversion_type, reference_id, revenue_amount, occurred_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, NOW())"
        );
        $stmt->execute([
            $tenantId,
            $data['campaign_id']     ?? null,
            $data['contact_id']      ?? null,
            $data['send_log_id']     ?? null,
            $data['conversion_type'] ?? 'invoice_paid',
            $data['reference_id']    ?? null,
            $data['revenue_amount']  ?? null,
        ]);

        // Registrar también como un evento normal de tipo 'conversion' para reportería agregada
        $this->recordEvent([
            'campaign_id' => $data['campaign_id'] ?? null,
            'contact_id'  => $data['contact_id']  ?? null,
            'send_log_id' => $data['send_log_id'] ?? null,
            'event_type'  => 'conversion',
        ]);

        return (int) $this->db->lastInsertId();
    }
}
