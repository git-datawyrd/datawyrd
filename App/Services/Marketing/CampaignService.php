<?php
namespace App\Services\Marketing;

use App\Repositories\MarketingRepository;
use Core\Config;
use Core\Marketing\EmailProviderFactory;
use Core\SecurityLogger;
use PDO;

/**
 * CampaignService
 *
 * Servicio central del módulo de Email Marketing.
 * Orquesta el ciclo de vida completo de campañas:
 * creación, programación, hidratación de la cola y despacho por lotes.
 *
 * Flujo de envío:
 *   1. createCampaign()   → crea el registro con status='draft'
 *   2. scheduleCampaign() → valida y pone status='scheduled' o 'sending'
 *   3. launchCampaign()   → hidrata mktg_send_log con todos los contactos
 *   4. processBatch()     → llamado por worker_marketing.php en cada ciclo
 *
 * @package App\Services\Marketing
 */
class CampaignService
{
    private MarketingRepository $repo;
    private array $rateCfg;
    private array $trackingCfg;
    private array $complianceCfg;
    private array $retryCfg;

    public function __construct(MarketingRepository $repo)
    {
        $this->repo          = $repo;
        $this->rateCfg       = Config::get('marketing.rate',       []);
        $this->trackingCfg   = Config::get('marketing.tracking',   []);
        $this->complianceCfg = Config::get('marketing.compliance', []);
        $this->retryCfg      = Config::get('marketing.retry',      []);
    }

    // =========================================================================
    // GESTIÓN DE LISTAS
    // =========================================================================

    public function getLists(): array
    {
        return $this->repo->getAllLists();
    }

    public function createList(array $data, int $userId): int
    {
        $data['created_by'] = $userId;
        return $this->repo->createList($data);
    }

    // =========================================================================
    // GESTIÓN DE CONTACTOS
    // =========================================================================

    /**
     * Importa un array de contactos a una lista, respetando duplicados.
     * Retorna ['imported' => int, 'skipped' => int, 'errors' => array]
     */
    public function importContacts(int $listId, array $contacts): array
    {
        $imported = 0;
        $skipped  = 0;
        $errors   = [];

        foreach ($contacts as $idx => $contact) {
            if (empty($contact['email']) || !filter_var($contact['email'], FILTER_VALIDATE_EMAIL)) {
                $errors[] = "Fila {$idx}: email inválido o vacío.";
                continue;
            }

            // Verificar duplicado en la lista
            $existing = $this->repo->findContactByEmail($contact['email'], $listId);
            if ($existing) {
                $skipped++;
                continue;
            }

            $this->repo->createContact(array_merge($contact, [
                'list_id' => $listId,
                'source'  => $contact['source'] ?? 'import',
            ]));
            $imported++;
        }

        return ['imported' => $imported, 'skipped' => $skipped, 'errors' => $errors];
    }

    // =========================================================================
    // GESTIÓN DE CAMPAÑAS
    // =========================================================================

    public function getCampaigns(): array
    {
        return $this->repo->getAllCampaigns();
    }

    public function getCampaignMetrics(int $campaignId): array
    {
        $campaign = $this->repo->findCampaign($campaignId);
        if (!$campaign) {
            return [];
        }

        $metrics = $this->repo->getCampaignMetrics($campaignId);
        if (($metrics['total_sent'] ?? 0) > 0) {
            $metrics['open_rate']  = round(($metrics['unique_opens']  / $metrics['total_sent']) * 100, 2);
            $metrics['click_rate'] = round(($metrics['unique_clicks'] / $metrics['total_sent']) * 100, 2);
            $metrics['bounce_rate']= round(($metrics['bounces']       / $metrics['total_sent']) * 100, 2);
        } else {
            $metrics['open_rate'] = $metrics['click_rate'] = $metrics['bounce_rate'] = 0;
        }

        return $metrics;
    }

    public function createCampaign(array $data, int $userId): int
    {
        $data['created_by'] = $userId;
        return $this->repo->createCampaign($data);
    }

    /**
     * Lanza una campaña: hidrata el send_log y actualiza el estado.
     * Si scheduled_at está en el futuro, deja en 'scheduled'.
     */
    public function scheduleCampaign(int $campaignId, ?string $scheduledAt = null): array
    {
        $campaign = $this->repo->findCampaign($campaignId);
        if (!$campaign) {
            return ['success' => false, 'error' => 'Campaña no encontrada.'];
        }
        if (!in_array($campaign['status'], ['draft', 'paused'], true)) {
            return ['success' => false, 'error' => "No se puede lanzar una campaña en estado '{$campaign['status']}'."];
        }
        if (empty($campaign['list_id'])) {
            return ['success' => false, 'error' => 'La campaña no tiene una lista de contactos asignada.'];
        }
        if (empty($campaign['template_id'])) {
            return ['success' => false, 'error' => 'La campaña no tiene una plantilla asignada.'];
        }

        $tenantId = Config::get('current_tenant_id', 1);

        // Hidratar la cola de envíos
        $queued = $this->repo->hydrateSendLog($campaignId, (int)$campaign['list_id'], $tenantId);

        // Determinar estado final
        $newStatus    = 'sending';
        $scheduledCol = [];

        if ($scheduledAt) {
            $schedTs = strtotime($scheduledAt);
            if ($schedTs && $schedTs > time()) {
                $newStatus    = 'scheduled';
                $scheduledCol = ['scheduled_at' => $scheduledAt];
            }
        }

        $this->repo->updateCampaignStatus($campaignId, $newStatus, $scheduledCol);

        SecurityLogger::log('marketing_campaign_launched', [
            'campaign_id' => $campaignId,
            'status'      => $newStatus,
            'queued'      => $queued,
            'tenant_id'   => $tenantId,
        ], 'INFO');

        return ['success' => true, 'queued' => $queued, 'status' => $newStatus];
    }

    // =========================================================================
    // PROCESAMIENTO POR LOTES (llamado por worker_marketing.php)
    // =========================================================================

    /**
     * Procesa un lote de emails pendientes en el send_log.
     * Respeta rate limiting, delay entre envíos y max reintentos.
     *
     * @return array{processed: int, sent: int, failed: int}
     */
    public function processBatch(): array
    {
        $batchSize = $this->rateCfg['batch_size']   ?? 50;
        $delayMs   = $this->rateCfg['delay_between_ms'] ?? 200;
        $maxRetries= $this->retryCfg['max_attempts'] ?? 3;

        $pending = $this->repo->getPendingBatch($batchSize);
        if (empty($pending)) {
            return ['processed' => 0, 'sent' => 0, 'failed' => 0];
        }

        // Marcar como 'processing' en bloque para evitar doble pick-up
        $ids = array_column($pending, 'id');
        $this->repo->markSendLogProcessing($ids);

        $sent   = 0;
        $failed = 0;
        $provider = EmailProviderFactory::make();

        foreach ($pending as $log) {
            // Establecer contexto tenant para este envío
            Config::set('current_tenant_id', (int) $log['tenant_id']);

            // Obtener campaña y plantilla
            $campaign = $this->repo->findCampaign((int) $log['campaign_id']);
            if (!$campaign) {
                $this->repo->updateSendLogResult((int)$log['id'], 'failed', null, 'Campaña no encontrada.');
                $failed++;
                continue;
            }

            // Renderizar template con personalización
            $body = $this->renderTemplate($campaign, $log);

            // Construir headers de compliance
            $headers = $this->buildComplianceHeaders($campaign, $log);

            $result = $provider->send([
                'to'          => $log['email'],
                'subject'     => $campaign['subject'],
                'html_body'   => $body,
                'from'        => $campaign['from_email'] ?: null,
                'from_name'   => $campaign['from_name']  ?: null,
                'reply_to'    => $campaign['reply_to']   ?: null,
                'headers'     => $headers,
                'campaign_id' => $log['campaign_id'],
                'send_log_id' => $log['id'],
            ]);

            if ($result['success']) {
                $this->repo->updateSendLogResult(
                    (int)$log['id'],
                    'sent',
                    $result['provider_message_id']
                );
                $sent++;
            } else {
                $nextStatus = ((int)($log['attempts'] ?? 0) + 1) >= $maxRetries ? 'failed' : 'queued';
                $this->repo->updateSendLogResult(
                    (int)$log['id'],
                    $nextStatus,
                    null,
                    $result['error']
                );
                $failed++;
            }

            // Delay entre envíos para respetar límites del proveedor
            if ($delayMs > 0) {
                usleep($delayMs * 1000);
            }
        }

        return ['processed' => count($pending), 'sent' => $sent, 'failed' => $failed];
    }

    // =========================================================================
    // INTERNOS
    // =========================================================================

    /**
     * Renderiza el template HTML con variables de personalización y
     * añade el pixel de tracking de apertura.
     */
    private function renderTemplate(array $campaign, array $log): string
    {
        // Obtener HTML de la plantilla
        $template = $this->repo->findTemplate((int) $campaign['template_id']);
        $html = $template['html_body'] ?? $campaign['html_body'] ?? '';

        // Personalización básica con variables {{nombre}}, {{email}}, etc.
        $html = str_replace('{{email}}',      htmlspecialchars($log['email'] ?? ''), $html);
        $html = str_replace('{{first_name}}', htmlspecialchars($log['first_name'] ?? ''), $html);
        $html = str_replace('{{last_name}}',  htmlspecialchars($log['last_name']  ?? ''), $html);

        // Pixel de apertura
        if ($this->trackingCfg['pixel_enabled'] ?? true) {
            $baseUrl  = rtrim($this->trackingCfg['base_url']  ?? '', '/');
            $pixelPath = $this->trackingCfg['pixel_path'] ?? '/track/open';
            $token    = $log['tracking_token'] ?? '';
            $pixelUrl = "{$baseUrl}{$pixelPath}?t=" . urlencode($token);
            $html    .= "<img src=\"{$pixelUrl}\" width=\"1\" height=\"1\" alt=\"\" style=\"display:none;\">";
        }

        return $html;
    }

    /**
     * Construye los headers de compliance por envío:
     *   - List-Unsubscribe (RFC 8058)
     *   - X-Campaign-ID para trazabilidad
     */
    private function buildComplianceHeaders(array $campaign, array $log): array
    {
        $headers = [];

        // X-Campaign-ID siempre
        $headers['X-Campaign-ID'] = (string) $campaign['id'];

        // List-Unsubscribe (RFC 8058) — activo por defecto
        if ($this->complianceCfg['list_unsubscribe_header'] ?? true) {
            $baseUrl      = rtrim($this->trackingCfg['base_url'] ?? '', '/');
            $unsubPath    = $this->trackingCfg['unsubscribe_path'] ?? '/track/unsubscribe';
            $token        = $log['unsubscribe_token'] ?? $log['tracking_token'] ?? '';
            $unsubUrl     = "{$baseUrl}{$unsubPath}?t=" . urlencode($token);
            $mailtoUnsub  = "mailto:unsubscribe@" . parse_url($baseUrl, PHP_URL_HOST)
                           . "?subject=unsubscribe";

            // RFC 8058 requiere ambos formatos (mailto + https)
            $headers['List-Unsubscribe']      = "<{$mailtoUnsub}>, <{$unsubUrl}>";
            $headers['List-Unsubscribe-Post']  = "List-Unsubscribe=One-Click";
        }

        return $headers;
    }
}
