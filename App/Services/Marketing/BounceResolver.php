<?php
namespace App\Services\Marketing;

use App\Repositories\MarketingRepository;
use Core\Config;
use Core\SecurityLogger;

/**
 * BounceResolver
 *
 * Servicio de procesamiento de eventos de rebote y quejas.
 * Recibe notificaciones de proveedores (webhooks) y actualiza
 * el estado de los contactos + send_log correspondiente.
 *
 * Clasificaciones de bounces:
 *   - hard: rebote permanente → suprimir contacto
 *   - soft: rebote temporal  → marcar en log, reintentar si dentro del límite
 *   - complaint: spam report → suprimir contacto
 *
 * @package App\Services\Marketing
 */
class BounceResolver
{
    private MarketingRepository $repo;

    // Umbrales anti-spam (configurables via Config)
    private const DEFAULT_BOUNCE_THRESHOLD    = 3.0;   // % tasa de rebote para pausar
    private const DEFAULT_COMPLAINT_THRESHOLD = 0.1;   // % tasa de queja para pausar

    public function __construct(MarketingRepository $repo)
    {
        $this->repo = $repo;
    }

    /**
     * Procesa un evento de bounce recibido desde un webhook de proveedor.
     *
     * @param string $email         Dirección que rebotó
     * @param string $bounceType    'hard' | 'soft' | 'complaint'
     * @param string $reason        Mensaje de error del proveedor
     * @param string|null $providerMsgId  ID de mensaje del proveedor (para correlacionar)
     * @param array  $rawPayload    Payload completo del webhook (para auditoría)
     * @return array{resolved: bool, action: string}
     */
    public function handle(
        string $email,
        string $bounceType,
        string $reason,
        ?string $providerMsgId = null,
        array $rawPayload = []
    ): array {
        $bounceType = strtolower($bounceType);
        $suppress   = $this->shouldSuppress($bounceType);

        // Correlacionar con send_log para obtener campaign_id
        $campaignId = null;
        if ($providerMsgId) {
            $this->updateSendLogByProviderId($providerMsgId, $bounceType, $reason);
            $campaignId = $this->getCampaignIdByProviderId($providerMsgId);
        }

        // Registrar el evento de bounce
        $this->recordBounceEvent($email, $bounceType, $reason, $providerMsgId);

        // Suprimir contacto + añadir a blacklist global en caso de hard bounce o complaint
        if ($suppress) {
            $this->repo->suppressContact($email, $bounceType . ': ' . $reason);
            $this->addToGlobalBlacklist($email, $bounceType . ': ' . $reason);

            SecurityLogger::log('marketing_contact_suppressed', [
                'email'       => $email,
                'bounce_type' => $bounceType,
                'reason'      => $reason,
                'blacklisted' => true,
            ], 'WARNING');

            // Verificar umbrales de la campaña y pausar si se superan
            if ($campaignId) {
                $this->checkThresholdsAndPause($campaignId);
            }

            return ['resolved' => true, 'action' => 'suppressed_and_blacklisted'];
        }

        // Soft bounce: solo registrar
        SecurityLogger::log('marketing_soft_bounce', [
            'email'  => $email,
            'reason' => $reason,
            'msg_id' => $providerMsgId,
        ], 'INFO');

        return ['resolved' => true, 'action' => 'soft_bounce_logged'];
    }

    /**
     * Procesa una baja (unsubscribe) por token RFC 8058.
     *
     * @param string $token   Token de baja del send_log
     * @return array{resolved: bool, action: string}
     */
    public function handleUnsubscribe(string $token): array
    {
        $sanitizedToken = preg_replace('/[^a-zA-Z0-9\-_]/', '', $token);
        if (empty($sanitizedToken)) {
            return ['resolved' => false, 'action' => 'invalid_token'];
        }

        $success = $this->repo->unsubscribeByToken($sanitizedToken);

        // Añadir email a blacklist global si la baja fue exitosa
        if ($success) {
            $email = $this->getEmailByUnsubToken($sanitizedToken);
            if ($email) {
                $this->addToGlobalBlacklist($email, 'unsubscribe_request');
            }
        }

        SecurityLogger::log('marketing_unsubscribe', [
            'token'   => $sanitizedToken,
            'success' => $success,
        ], 'INFO');

        return [
            'resolved' => $success,
            'action'   => $success ? 'unsubscribed' : 'token_not_found',
        ];
    }

    // =========================================================================
    // INTERNOS
    // =========================================================================

    private function shouldSuppress(string $bounceType): bool
    {
        $suppressBounced    = Config::get('marketing.compliance.suppress_bounced', true);
        $suppressComplained = Config::get('marketing.compliance.suppress_complained', true);

        return match ($bounceType) {
            'hard'      => $suppressBounced,
            'complaint' => $suppressComplained,
            default     => false,
        };
    }

    /**
     * Añade un email a la blacklist global para excluirlo de futuros envíos
     * a nivel de toda la plataforma (no solo del tenant actual).
     */
    private function addToGlobalBlacklist(string $email, string $reason): void
    {
        try {
            $db = \Core\Database::getInstance()->getConnection();
            $stmt = $db->prepare(
                "INSERT INTO blacklist (email, reason)
                 VALUES (?, ?)
                 ON DUPLICATE KEY UPDATE reason = VALUES(reason), created_at = NOW()"
            );
            $stmt->execute([strtolower(trim($email)), substr($reason, 0, 255)]);
        } catch (\Exception $e) {
            SecurityLogger::log('marketing_blacklist_insert_failed', [
                'email' => $email,
                'error' => $e->getMessage(),
            ], 'ERROR');
        }
    }

    /**
     * Verifica si la campaña supera los umbrales de bounce (>3%) o
     * complaint (>0.1%) y la pausa automáticamente si es así.
     */
    private function checkThresholdsAndPause(int $campaignId): void
    {
        try {
            $bounceThreshold    = (float) Config::get('marketing.thresholds.bounce_pct',    self::DEFAULT_BOUNCE_THRESHOLD);
            $complaintThreshold = (float) Config::get('marketing.thresholds.complaint_pct', self::DEFAULT_COMPLAINT_THRESHOLD);

            $db   = \Core\Database::getInstance()->getConnection();
            $stmt = $db->prepare(
                "SELECT
                    COUNT(*) as total,
                    SUM(CASE WHEN sl.status IN ('bounced','soft_bounced') THEN 1 ELSE 0 END) as bounces,
                    (SELECT COUNT(*) FROM mktg_events WHERE campaign_id = ? AND event_type = 'complaint') as complaints
                 FROM mktg_send_log sl
                 WHERE sl.campaign_id = ? AND sl.status != 'queued'"
            );
            $stmt->execute([$campaignId, $campaignId]);
            $row = $stmt->fetch();

            if (!$row || (int)$row['total'] < 50) {
                // No hay suficiente volumen para evaluar
                return;
            }

            $bounceRate    = ((int)$row['bounces']    / (int)$row['total']) * 100;
            $complaintRate = ((int)$row['complaints'] / (int)$row['total']) * 100;

            if ($bounceRate >= $bounceThreshold || $complaintRate >= $complaintThreshold) {
                $this->repo->updateCampaignStatus($campaignId, 'paused', [
                    'paused_reason' => "Auto-paused: bounce={$bounceRate}% complaint={$complaintRate}%",
                ]);

                SecurityLogger::log('marketing_campaign_auto_paused', [
                    'campaign_id'    => $campaignId,
                    'bounce_rate'    => round($bounceRate, 2),
                    'complaint_rate' => round($complaintRate, 2),
                    'threshold_b'    => $bounceThreshold,
                    'threshold_c'    => $complaintThreshold,
                ], 'WARNING');
            }
        } catch (\Exception $e) {
            SecurityLogger::log('marketing_threshold_check_failed', [
                'campaign_id' => $campaignId,
                'error'       => $e->getMessage(),
            ], 'ERROR');
        }
    }

    /**
     * Obtiene el campaign_id a partir del provider_message_id del send_log.
     */
    private function getCampaignIdByProviderId(string $providerMsgId): ?int
    {
        try {
            $db   = \Core\Database::getInstance()->getConnection();
            $stmt = $db->prepare(
                "SELECT campaign_id FROM mktg_send_log WHERE provider_message_id = ? LIMIT 1"
            );
            $stmt->execute([$providerMsgId]);
            $row = $stmt->fetch();
            return $row ? (int)$row['campaign_id'] : null;
        } catch (\Exception $e) {
            return null;
        }
    }

    /**
     * Recupera el email de un contacto a partir del unsubscribe_token.
     */
    private function getEmailByUnsubToken(string $token): ?string
    {
        try {
            $db   = \Core\Database::getInstance()->getConnection();
            $stmt = $db->prepare(
                "SELECT email FROM mktg_contacts WHERE unsubscribe_token = ? LIMIT 1"
            );
            $stmt->execute([$token]);
            $row = $stmt->fetch();
            return $row ? $row['email'] : null;
        } catch (\Exception $e) {
            return null;
        }
    }

    private function updateSendLogByProviderId(string $providerMsgId, string $bounceType, string $reason): void
    {
        try {
            // Nota: este query opera cross-tenant de forma intencional.
            // El provider_message_id es globalmente único por proveedor.
            $db = \Core\Database::getInstance()->getConnection();
            $stmt = $db->prepare(
                "UPDATE mktg_send_log
                 SET status = ?, error_message = ?
                 WHERE provider_message_id = ? AND status IN ('sent', 'processing')"
            );
            $stmt->execute([
                $bounceType === 'soft' ? 'soft_bounced' : 'bounced',
                $reason,
                $providerMsgId,
            ]);
        } catch (\Exception $e) {
            SecurityLogger::log('marketing_bounce_log_update_failed', [
                'msg_id' => $providerMsgId,
                'error'  => $e->getMessage(),
            ], 'ERROR');
        }
    }

    private function recordBounceEvent(string $email, string $bounceType, string $reason, ?string $providerMsgId): void
    {
        try {
            $db = \Core\Database::getInstance()->getConnection();

            // Buscar contact_id y send_log_id si hay message_id del proveedor
            $sendLogId = null;
            $contactId = null;

            if ($providerMsgId) {
                $stmt = $db->prepare(
                    "SELECT sl.id, sl.contact_id
                     FROM mktg_send_log sl
                     WHERE sl.provider_message_id = ? LIMIT 1"
                );
                $stmt->execute([$providerMsgId]);
                $row = $stmt->fetch();
                if ($row) {
                    $sendLogId = $row['id'];
                    $contactId = $row['contact_id'];
                }
            }

            $this->repo->recordEvent([
                'campaign_id'  => null, // Se puede recuperar del send_log si se necesita
                'contact_id'   => $contactId,
                'send_log_id'  => $sendLogId,
                'event_type'   => $bounceType === 'complaint' ? 'complaint' : 'bounce',
                'url_clicked'  => null,
                'ip_address'   => null,
                'user_agent'   => null,
            ]);
        } catch (\Exception $e) {
            SecurityLogger::log('marketing_bounce_event_record_failed', [
                'email' => $email,
                'error' => $e->getMessage(),
            ], 'ERROR');
        }
    }
}
