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
     * Respeta rate limiting dinámico basado en max_per_minute y delay entre envíos.
     *
     * El delay por email se calcula como: floor(60 / max_per_minute * 1_000_000) µs.
     * Esto garantiza no superar el límite SMTP configurado. El valor puede incrementarse
     * progresivamente en .env (MARKETING_MAX_PER_MINUTE) según lo permita el proveedor.
     *
     * @return array{processed: int, sent: int, failed: int}
     */
    public function processBatch(): array
    {
        $batchSize     = $this->rateCfg['batch_size']      ?? 50;
        $maxPerMinute  = $this->rateCfg['max_per_minute']  ?? 250;
        $delayFloorMs  = $this->rateCfg['delay_between_ms'] ?? 200;
        $maxRetries    = $this->retryCfg['max_attempts']   ?? 3;

        // Calcular delay dinámico: microsegundos por email para no superar max_per_minute.
        // Mínimo: el floor configurado en delay_between_ms para no saturar el servidor.
        $dynamicDelayUs = (int) floor((60 / max(1, $maxPerMinute)) * 1_000_000);
        $floorUs        = $delayFloorMs * 1000;
        $delayUs        = max($floorUs, $dynamicDelayUs);

        $pending = $this->repo->getPendingBatch($batchSize);
        if (empty($pending)) {
            return ['processed' => 0, 'sent' => 0, 'failed' => 0];
        }

        // Marcar como 'processing' en bloque para evitar doble pick-up
        $ids = array_column($pending, 'id');
        $this->repo->markSendLogProcessing($ids);

        $sent     = 0;
        $failed   = 0;
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

            // Throttle dinámico — espera calculada para no superar MARKETING_MAX_PER_MINUTE
            usleep($delayUs);
        }

        return ['processed' => count($pending), 'sent' => $sent, 'failed' => $failed];
    }

    // =========================================================================
    // INTERNOS
    // =========================================================================

    /**
     * Renderiza el template HTML con personalización completa:
     *  - Placeholders simples:   {email}, {first_name}, {last_name}, {company}, {phone}
     *  - Placeholders con fallback: {first_name|Estimado cliente}
     *  - Pixel de tracking de apertura
     *  - Footer de baja RFC-compliant con enlace visible en el cuerpo
     */
    private function renderTemplate(array $campaign, array $log): string
    {
        // Obtener HTML de la plantilla
        $template = $this->repo->findTemplate((int) $campaign['template_id']);
        $html = $template['html_body'] ?? $campaign['html_body'] ?? '';

        // Mapa de variables disponibles para la personalización
        $vars = [
            'email'      => $log['email']      ?? '',
            'first_name' => $log['first_name'] ?? '',
            'last_name'  => $log['last_name']  ?? '',
            'company'    => $log['company']    ?? '',
            'phone'      => $log['phone']      ?? '',
            'full_name'  => trim(($log['first_name'] ?? '') . ' ' . ($log['last_name'] ?? '')),
        ];

        // Reemplazar placeholders con fallback: {variable|valor por defecto}
        // Formato soportado: {var}, {var|fallback}, {{var}}, {{var|fallback}}
        $html = preg_replace_callback(
            '/\{\{?([a-zA-Z_]+)(?:\|([^}]*))?\}?\}/',
            function (array $m) use ($vars): string {
                $key      = strtolower(trim($m[1]));
                $fallback = isset($m[2]) ? trim($m[2]) : '';
                $value    = isset($vars[$key]) ? trim((string) $vars[$key]) : '';
                return htmlspecialchars($value !== '' ? $value : $fallback, ENT_QUOTES | ENT_HTML5, 'UTF-8');
            },
            $html
        );

        // --- Footer de baja (visible en el cuerpo) conforme a RFC 8058 ---
        $baseUrl    = rtrim($this->trackingCfg['base_url'] ?? '', '/');
        $unsubPath  = $this->trackingCfg['unsubscribe_path'] ?? '/track/unsubscribe';
        $token      = $log['unsubscribe_token'] ?? $log['tracking_token'] ?? '';
        $unsubUrl   = $baseUrl . $unsubPath . '?t=' . urlencode($token);
        $complianceName = $this->complianceCfg['company_name'] ?? 'Data Wyrd';
        $complianceAddr = $this->complianceCfg['physical_address'] ?? '';

        $footer = <<<HTML
<table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin-top:32px;border-top:1px solid #e0e0e0;">
  <tr>
    <td align="center" style="padding:20px 16px;font-family:Arial,sans-serif;font-size:11px;color:#888888;line-height:1.6;">
      <p style="margin:0 0 6px 0;">{$complianceName}{$complianceAddr}</p>
      <p style="margin:0;">No deseas recibir más correos de esta lista?
        <a href="{$unsubUrl}" style="color:#888888;text-decoration:underline;">Haz clic aquí para darte de baja</a>.
      </p>
    </td>
  </tr>
</table>
HTML;

        // Insertar footer antes de </body> si existe, si no, al final
        if (stripos($html, '</body>') !== false) {
            $html = str_ireplace('</body>', $footer . '</body>', $html);
        } else {
            $html .= $footer;
        }

        // --- Pixel de apertura (1×1 px invisible) ---
        if ($this->trackingCfg['pixel_enabled'] ?? true) {
            $pixelPath = $this->trackingCfg['pixel_path'] ?? '/track/open';
            $pixelUrl  = $baseUrl . $pixelPath . '?t=' . urlencode($log['tracking_token'] ?? '');
            $pixel     = "<img src=\"{$pixelUrl}\" width=\"1\" height=\"1\" alt=\"\" style=\"display:none;\">";
            if (stripos($html, '</body>') !== false) {
                $html = str_ireplace('</body>', $pixel . '</body>', $html);
            } else {
                $html .= $pixel;
            }
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
