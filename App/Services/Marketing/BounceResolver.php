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

        // Actualizar send_log si podemos correlacionar el mensaje
        if ($providerMsgId) {
            $this->updateSendLogByProviderId($providerMsgId, $bounceType, $reason);
        }

        // Registrar el evento de bounce
        $this->recordBounceEvent($email, $bounceType, $reason, $providerMsgId);

        // Suprimir contacto en caso de hard bounce o complaint
        if ($suppress) {
            $suppressed = $this->repo->suppressContact($email, $bounceType . ': ' . $reason);

            SecurityLogger::log('marketing_contact_suppressed', [
                'email'       => $email,
                'bounce_type' => $bounceType,
                'reason'      => $reason,
                'suppressed'  => $suppressed,
            ], 'WARNING');

            return ['resolved' => true, 'action' => 'suppressed'];
        }

        // Soft bounce: solo registrar, no suprimir
        SecurityLogger::log('marketing_soft_bounce', [
            'email'       => $email,
            'reason'      => $reason,
            'msg_id'      => $providerMsgId,
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
            default     => false, // 'soft' y otros tipos no se suprimen automáticamente
        };
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
