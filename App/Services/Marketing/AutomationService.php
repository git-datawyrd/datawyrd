<?php
namespace App\Services\Marketing;

use Core\Config;
use Core\Database;
use Core\SecurityLogger;
use Core\Marketing\EmailProviderFactory;
use App\Repositories\MarketingRepository;

/**
 * AutomationService
 *
 * Motor de Automatizaciones para Email Marketing.
 * Procesa triggers en tiempo real y ejecuta pasos secuenciales.
 */
class AutomationService
{
    /**
     * Dispara una automatización basada en un trigger específico.
     *
     * @param string $triggerType Tipo de trigger ('signup', 'campaign_open', 'campaign_click', etc.)
     * @param array $context Datos de contexto (contact_id, campaign_id, list_id, tenant_id, etc.)
     * @return void
     */
    public function trigger(string $triggerType, array $context): void
    {
        try {
            $db = Database::getInstance()->getConnection();
            $tenantId = $context['tenant_id'] ?? Config::get('current_tenant_id', 1);

            // Obtener todas las automatizaciones activas para este trigger y tenant
            $stmt = $db->prepare(
                "SELECT * FROM mktg_automations 
                 WHERE trigger_type = ? 
                   AND tenant_id = ? 
                   AND status = 'active' 
                   AND deleted_at IS NULL"
            );
            $stmt->execute([$triggerType, $tenantId]);
            $automations = $stmt->fetchAll();

            if (empty($automations)) {
                return;
            }

            foreach ($automations as $auto) {
                $triggerData = json_decode($auto['trigger_data'] ?? '{}', true) ?: [];

                // Validar pertenencia a lista si el trigger es 'signup'
                if ($triggerType === 'signup' && isset($triggerData['list_id'])) {
                    $contactListId = $context['list_id'] ?? null;
                    if (!$contactListId && isset($context['contact_id'])) {
                        $stmtC = $db->prepare("SELECT list_id FROM mktg_contacts WHERE id = ?");
                        $stmtC->execute([$context['contact_id']]);
                        $contactListId = $stmtC->fetchColumn();
                    }
                    if ($contactListId != $triggerData['list_id']) {
                        continue; // No coincide con la lista del trigger
                    }
                }

                // Validar coincidencia de campaña en opens/clicks
                if (($triggerType === 'campaign_open' || $triggerType === 'campaign_click') && isset($triggerData['campaign_id'])) {
                    if (($context['campaign_id'] ?? null) != $triggerData['campaign_id']) {
                        continue; // No coincide con la campaña de origen
                    }
                }

                // Cargar los pasos ordenados por step_order
                $stmtSteps = $db->prepare(
                    "SELECT * FROM mktg_automation_steps 
                     WHERE automation_id = ? 
                     ORDER BY step_order ASC"
                );
                $stmtSteps->execute([$auto['id']]);
                $steps = $stmtSteps->fetchAll();

                if (!empty($steps)) {
                    $this->executeSteps($auto, $steps, $context);
                }
            }
        } catch (\Exception $e) {
            SecurityLogger::log('marketing_automation_trigger_failed', [
                'trigger' => $triggerType,
                'error'   => $e->getMessage()
            ], 'ERROR');
        }
    }

    /**
     * Ejecuta ordenadamente la lista de pasos para un contacto.
     */
    private function executeSteps(array $automation, array $steps, array $context): void
    {
        $db = Database::getInstance()->getConnection();
        $contactId = $context['contact_id'] ?? null;

        if (!$contactId) return;

        // Cargar detalles del contacto
        $stmtC = $db->prepare("SELECT * FROM mktg_contacts WHERE id = ? AND deleted_at IS NULL");
        $stmtC->execute([$contactId]);
        $contact = $stmtC->fetch();

        // Las automatizaciones se ejecutan sólo para contactos activos y suscritos
        if (!$contact || $contact['status'] !== 'subscribed') {
            return;
        }

        foreach ($steps as $step) {
            $config = json_decode($step['step_config'] ?? '{}', true) ?: [];
            $stepType = $step['step_type'];

            switch ($stepType) {
                case 'send_email':
                    $templateId = $config['template_id'] ?? null;
                    if ($templateId) {
                        $this->sendAutomationEmail((int)$templateId, $contact, (int)$automation['id']);
                    }
                    break;

                case 'tag':
                    $tagName = trim($config['tag_name'] ?? '');
                    $action  = $config['action'] ?? 'add';
                    if ($tagName !== '') {
                        $existingTags = !empty($contact['tags']) ? explode(',', $contact['tags']) : [];
                        $existingTags = array_map('trim', $existingTags);

                        if ($action === 'add' && !in_array($tagName, $existingTags, true)) {
                            $existingTags[] = $tagName;
                        } elseif ($action === 'remove') {
                            $existingTags = array_diff($existingTags, [$tagName]);
                        }

                        $newTags = implode(',', $existingTags);
                        $db->prepare("UPDATE mktg_contacts SET tags = ? WHERE id = ?")
                           ->execute([$newTags ?: null, $contact['id']]);
                    }
                    break;

                case 'webhook':
                    $url = trim($config['url'] ?? '');
                    if ($url !== '') {
                        $this->fireWebhook($url, [
                            'event'         => 'automation_step_executed',
                            'automation_id' => $automation['id'],
                            'step_id'       => $step['id'],
                            'contact'       => [
                                'id'         => $contact['id'],
                                'email'      => $contact['email'],
                                'first_name' => $contact['first_name'],
                                'last_name'  => $contact['last_name'],
                                'company'    => $contact['company'],
                            ]
                        ]);
                    }
                    break;
            }
        }
    }

    /**
     * Envía el correo de la automatización reutilizando renderTemplate y compliance headers
     */
    private function sendAutomationEmail(int $templateId, array $contact, int $automationId): void
    {
        try {
            $db = Database::getInstance()->getConnection();
            $repo = new MarketingRepository($db);
            
            $template = $repo->findTemplate($templateId);
            if (!$template) return;

            $campaign = [
                'id'              => 0,
                'template_id'     => $templateId,
                'name'            => 'Auto-Flow #' . $automationId,
                'subject'         => $template['subject'] ?? 'Novedades',
                'from_email'      => Config::get('marketing.zepto.from_address') ?: Config::get('mail.from_address') ?: '',
                'from_name'       => Config::get('marketing.zepto.from_name')    ?: Config::get('mail.from_name')    ?: 'Data Wyrd',
                'reply_to'        => null,
                'segment_filters' => null,
            ];

            $unsubToken = $contact['unsubscribe_token'] ?? bin2hex(random_bytes(16));
            $log = [
                'id'                => 0,
                'email'             => $contact['email'],
                'first_name'        => $contact['first_name'] ?? '',
                'last_name'         => $contact['last_name']  ?? '',
                'company'           => $contact['company']    ?? '',
                'phone'             => $contact['phone']      ?? '',
                'tracking_token'    => 'auto-' . uniqid(),
                'unsubscribe_token' => $unsubToken,
                'tenant_id'         => $contact['tenant_id'],
            ];

            $service = new CampaignService($repo);
            
            // Acceso mediante Reflexión a métodos privados para evitar duplicar lógica de parseo
            $reflection = new \ReflectionClass(CampaignService::class);
            $method = $reflection->getMethod('renderTemplate');
            $method->setAccessible(true);
            $body = $method->invokeArgs($service, [$campaign, $log]);

            $reflectionHeaders = $reflection->getMethod('buildComplianceHeaders');
            $reflectionHeaders->setAccessible(true);
            $headers = $reflectionHeaders->invokeArgs($service, [$campaign, $log]);

            $provider = EmailProviderFactory::make();
            $provider->send([
                'to'          => $contact['email'],
                'subject'     => $template['subject'] ?? 'Novedades',
                'html_body'   => $body,
                'from'        => $campaign['from_email'] ?: null,
                'from_name'   => $campaign['from_name']  ?: null,
                'headers'     => $headers,
                'campaign_id' => 0,
                'send_log_id' => 0,
            ]);

            // Registrar envío en logs generales
            $stmt = $db->prepare("INSERT INTO email_logs (email, subject, status, sent_at) VALUES (?, ?, 'sent', NOW())");
            $stmt->execute([$contact['email'], $template['subject']]);

            SecurityLogger::log('marketing_automation_email_sent', [
                'contact_id'    => $contact['id'],
                'template_id'   => $templateId,
                'automation_id' => $automationId
            ], 'INFO');
        } catch (\Exception $e) {
            SecurityLogger::log('marketing_automation_email_failed', [
                'contact_id' => $contact['id'],
                'error'      => $e->getMessage()
            ], 'ERROR');
        }
    }

    /**
     * Envía correo transaccional de Double Opt-In
     */
    public function sendDoubleOptInEmail(string $email, string $token, string $firstName = ''): void
    {
        try {
            $companyName = Config::get('business.company_name', 'Data Wyrd');
            $baseUrl     = rtrim(Config::get('marketing.tracking.base_url') ?: Config::get('base_url') ?: 'http://localhost', '/');
            $confirmUrl  = $baseUrl . '/track/optin?t=' . urlencode($token);

            $subject = "Confirma tu suscripción a {$companyName}";
            
            $html = "
            <div style='background:#f4f4f5;padding:40px;font-family:Arial,sans-serif;'>
                <div style='background:#ffffff;padding:32px;border-radius:8px;max-width:600px;margin:0 auto;box-shadow:0 4px 6px rgba(0,0,0,0.05);'>
                    <h2 style='color:#111827;margin-top:0;'>¡Hola" . ($firstName ? " " . htmlspecialchars($firstName) : "") . "!</h2>
                    <p style='color:#4b5563;font-size:16px;line-height:1.6;'>
                        Gracias por registrarte para recibir nuestras comunicaciones de <strong>{$companyName}</strong>. 
                        Para completar tu suscripción y empezar a recibir correos, por favor confirma tu dirección haciendo clic en el botón de abajo:
                    </p>
                    <div style='text-align:center;margin:32px 0;'>
                        <a href='{$confirmUrl}' style='background:#30C5FF;color:#ffffff;padding:14px 28px;border-radius:6px;text-decoration:none;font-weight:bold;font-size:16px;display:inline-block;'>Confirmar mi Suscripción</a>
                    </div>
                    <p style='color:#9ca3af;font-size:12px;margin-bottom:0;'>
                        Si no solicitaste este registro, puedes ignorar este correo de forma segura.
                    </p>
                </div>
            </div>
            ";

            $provider = EmailProviderFactory::make();
            $provider->send([
                'to'        => $email,
                'subject'   => $subject,
                'html_body' => $html,
                'from'      => Config::get('marketing.zepto.from_address') ?: Config::get('mail.from_address') ?: null,
                'from_name' => Config::get('marketing.zepto.from_name')    ?: Config::get('mail.from_name')    ?: null,
            ]);

            SecurityLogger::log('marketing_double_optin_sent', ['email' => $email], 'INFO');
        } catch (\Exception $e) {
            SecurityLogger::log('marketing_double_optin_failed', [
                'email' => $email,
                'error' => $e->getMessage()
            ], 'ERROR');
        }
    }

    /**
     * Lanza petición HTTP POST asíncrona hacia webhooks de automatizaciones
     */
    private function fireWebhook(string $url, array $payload): void
    {
        try {
            $ch = curl_init($url);
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_POST           => true,
                CURLOPT_POSTFIELDS     => json_encode($payload),
                CURLOPT_HTTPHEADER     => ['Content-Type: application/json'],
                CURLOPT_TIMEOUT        => 5,
                CURLOPT_SSL_VERIFYPEER => true,
            ]);
            curl_exec($ch);
            curl_close($ch);
        } catch (\Exception $e) {
            SecurityLogger::log('marketing_automation_webhook_failed', [
                'url'   => $url,
                'error' => $e->getMessage()
            ], 'WARNING');
        }
    }
}
