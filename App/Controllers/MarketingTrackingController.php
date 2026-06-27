<?php
namespace App\Controllers;

use App\Repositories\MarketingRepository;
use App\Services\Marketing\BounceResolver;
use Core\Config;
use Core\Controller;
use Core\SecurityLogger;

/**
 * MarketingTrackingController
 *
 * Controlador público de tracking para el módulo de Email Marketing.
 * Gestiona: pixel de apertura, redirección de clics y bajas (unsubscribe).
 *
 * SEGURIDAD:
 *   - Todos los endpoints son públicos y EXCLUIDOS de validación CSRF
 *     (se registran en Core\App como bypass, al igual que los webhooks).
 *   - Los tokens son opacos (UUID/hash aleatorio) — no exponen IDs internos.
 *   - La IP se almacena hasheada para privacidad (no se guarda IP raw en logs).
 *   - Rate limiting no se aplica aquí — los clientes de email son legítimos.
 *
 * Rutas esperadas (configurar en router):
 *   GET  /track/open?t={token}              → pixelOpen()
 *   GET  /track/click?t={token}&u={url}     → trackClick()
 *   GET  /track/unsubscribe?t={token}       → showUnsubscribe()
 *   POST /track/unsubscribe                 → processUnsubscribe()
 *   POST /track/webhook/zepto              → webhookZepto()
 *
 * @package App\Controllers
 */
class MarketingTrackingController extends Controller
{
    private MarketingRepository $repo;
    private BounceResolver $bounceResolver;

    public function __construct(MarketingRepository $repo, BounceResolver $bounceResolver)
    {
        $this->repo           = $repo;
        $this->bounceResolver = $bounceResolver;
    }

    // =========================================================================
    // PIXEL DE APERTURA
    // =========================================================================

    /**
     * Retorna un GIF 1x1 transparente y registra el evento de apertura.
     * No genera errores visibles para el cliente de email.
     */
    public function pixelOpen(): void
    {
        $token = $_GET['t'] ?? '';

        if (!empty($token)) {
            $token = preg_replace('/[^a-zA-Z0-9\-_]/', '', $token);
            $this->registerTrackingEvent($token, 'open');
        }

        // Responder siempre con el pixel, independientemente del token
        header('Content-Type: image/gif');
        header('Cache-Control: no-cache, no-store, must-revalidate');
        header('Pragma: no-cache');
        header('Expires: 0');

        // GIF 1x1 transparente (43 bytes)
        echo base64_decode('R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7');
        exit;
    }

    // =========================================================================
    // TRACKING DE CLICS
    // =========================================================================

    /**
     * Registra el clic y redirige al destino original.
     * Valida la URL destino para evitar open-redirect.
     */
    public function trackClick(): void
    {
        $token  = preg_replace('/[^a-zA-Z0-9\-_]/', '', $_GET['t'] ?? '');
        $rawUrl = $_GET['u'] ?? '';

        // Validar y sanitizar URL destino (prevenir open-redirect)
        $destination = $this->sanitizeRedirectUrl($rawUrl);

        if (!empty($token)) {
            $this->registerTrackingEvent($token, 'click', $destination);
        }

        if ($destination) {
            header('Location: ' . $destination, true, 302);
        } else {
            // Fallback: redirigir a home si la URL es inválida
            $appUrl = rtrim(Config::get('base_url', '/'), '/');
            header('Location: ' . $appUrl, true, 302);
        }
        exit;
    }

    // =========================================================================
    // BAJA / UNSUBSCRIBE
    // =========================================================================

    /**
     * Muestra la página de confirmación de baja.
     */
    public function showUnsubscribe(): void
    {
        $token = preg_replace('/[^a-zA-Z0-9\-_]/', '', $_GET['t'] ?? '');

        // Verificar que el token existe antes de mostrar la página
        $sendLog = !empty($token) ? $this->repo->findSendLogByToken($token) : null;

        http_response_code($sendLog ? 200 : 404);

        // Renderizar vista simple inline (sin dependencias de template engine)
        $companyName = Config::get('business.company_name', 'Data Wyrd');
        $valid       = $sendLog !== null;

        echo $this->renderUnsubscribePage($companyName, $token, $valid);
        exit;
    }

    /**
     * Procesa la baja por POST (compatible con RFC 8058 one-click).
     * También acepta List-Unsubscribe-Post desde clientes de email.
     */
    public function processUnsubscribe(): void
    {
        // RFC 8058: el cliente envía el token vía POST o query string
        $token = preg_replace(
            '/[^a-zA-Z0-9\-_]/',
            '',
            $_POST['t'] ?? $_GET['t'] ?? ''
        );

        if (empty($token)) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Token inválido.']);
            exit;
        }

        $result = $this->bounceResolver->handleUnsubscribe($token);

        // Responder según Accept header (RFC 8058 espera 200 OK)
        $wantsJson = str_contains($_SERVER['HTTP_ACCEPT'] ?? '', 'application/json');

        if ($wantsJson) {
            header('Content-Type: application/json');
            http_response_code($result['resolved'] ? 200 : 404);
            echo json_encode($result);
        } else {
            // Redirigir a página de confirmación
            $appUrl = rtrim(Config::get('base_url', '/'), '/');
            $msg    = $result['resolved'] ? 'success' : 'error';
            header("Location: {$appUrl}/track/unsubscribe/done?s={$msg}", true, 303);
        }
        exit;
    }

    // =========================================================================
    // WEBHOOK ZEPTO (Bounces & Complaints)
    // =========================================================================

    /**
     * Webhook para recibir notificaciones de entrega/bounce de ZeptoMail.
     * Este endpoint está EXCLUIDO de CSRF.
     *
     * Ref: https://www.zoho.com/zeptomail/help/api/webhooks.html
     */
    public function webhookZepto(): void
    {
        // Verificar IP de origen permitida (ZeptoMail usa IPs conocidas)
        // Se puede configurar ZEPTO_WEBHOOK_SECRET para HMAC en el futuro.
        $payload = file_get_contents('php://input');
        $data    = json_decode($payload, true);

        if (!$data || !isset($data['type'])) {
            http_response_code(400);
            echo json_encode(['error' => 'Payload inválido']);
            exit;
        }

        SecurityLogger::log('marketing_webhook_zepto_received', [
            'type' => $data['type'],
        ], 'INFO');

        $type      = strtolower($data['type'] ?? '');
        $email     = $data['recipient'] ?? ($data['email'] ?? '');
        $msgId     = $data['message_id'] ?? null;
        $reason    = $data['reason']     ?? $data['description'] ?? 'unknown';

        match ($type) {
            'bounce', 'hard_bounce' => $this->bounceResolver->handle($email, 'hard', $reason, $msgId, $data),
            'soft_bounce'           => $this->bounceResolver->handle($email, 'soft', $reason, $msgId, $data),
            'complaint', 'spam'     => $this->bounceResolver->handle($email, 'complaint', $reason, $msgId, $data),
            default                 => null, // Ignorar tipos no manejados
        };

        http_response_code(200);
        echo json_encode(['status' => 'ok']);
        exit;
    }

    // =========================================================================
    // INTERNOS
    // =========================================================================

    private function registerTrackingEvent(string $token, string $eventType, ?string $urlClicked = null): void
    {
        try {
            $sendLog = $this->repo->findSendLogByToken($token);
            if (!$sendLog) return;

            // Hashear IP para privacidad — no almacenar IP raw
            $ipRaw  = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? '';
            $ipHash = hash('sha256', $ipRaw . Config::get('app_key', ''));

            $this->repo->recordEvent([
                'campaign_id'  => $sendLog['campaign_id'],
                'contact_id'   => $sendLog['contact_id'],
                'send_log_id'  => $sendLog['id'],
                'event_type'   => $eventType,
                'url_clicked'  => $urlClicked,
                'ip_address'   => $ipHash, // Hash, no IP raw
                'user_agent'   => substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 512),
            ]);

            // Si es primera apertura, actualizar send_log a 'delivered' (implícito)
            if ($eventType === 'open' && $sendLog['status'] === 'sent') {
                $db = \Core\Database::getInstance()->getConnection();
                $db->prepare("UPDATE mktg_send_log SET opened_at = NOW() WHERE id = ? AND opened_at IS NULL")
                   ->execute([$sendLog['id']]);
            }

            // Trigger automaciones correspondientes
            if ($eventType === 'open') {
                $autoService = new \App\Services\Marketing\AutomationService();
                $autoService->trigger('campaign_open', [
                    'contact_id'  => $sendLog['contact_id'],
                    'campaign_id' => $sendLog['campaign_id'],
                ]);
            } elseif ($eventType === 'click') {
                $autoService = new \App\Services\Marketing\AutomationService();
                $autoService->trigger('campaign_click', [
                    'contact_id'  => $sendLog['contact_id'],
                    'campaign_id' => $sendLog['campaign_id'],
                    'url'         => $urlClicked,
                ]);
            }
        } catch (\Exception $e) {
            // Silenciar errores de tracking — no deben afectar la UX del usuario final
            SecurityLogger::log('marketing_tracking_event_failed', [
                'event' => $eventType,
                'token' => $token,
                'error' => $e->getMessage(),
            ], 'ERROR');
        }
    }

    /**
     * Valida que la URL sea del dominio propio o dominio de confianza.
     * Previene ataques de open-redirect.
     */
    private function sanitizeRedirectUrl(string $rawUrl): ?string
    {
        if (empty($rawUrl)) return null;

        $decoded = urldecode($rawUrl);
        $parsed  = parse_url($decoded);
        if (!$parsed || !isset($parsed['scheme']) || !isset($parsed['host'])) {
            return null;
        }

        $scheme = strtolower($parsed['scheme']);
        if (!in_array($scheme, ['http', 'https'], true)) {
            return null;
        }

        // Sólo permitir redirección a dominios configurados
        $allowedDomain  = parse_url(Config::get('base_url', ''), PHP_URL_HOST);
        $customDomain   = Config::get('marketing.reputation.custom_domain', '');
        $allowedHosts   = array_filter([$allowedDomain, $customDomain]);

        if (!in_array($parsed['host'], $allowedHosts, true)) {
            SecurityLogger::log('marketing_click_redirect_blocked', [
                'attempted_host' => $parsed['host'],
                'raw_url'        => substr($rawUrl, 0, 255),
            ], 'WARNING');
            return null;
        }

        return $decoded;
    }

    /**
     * Renderiza la página de baja sin dependencias de template engine.
     * Usa el sistema de colores del CRM para consistencia visual.
     */
    private function renderUnsubscribePage(string $companyName, string $token, bool $valid): string
    {
        $escapedCompany = htmlspecialchars($companyName, ENT_QUOTES, 'UTF-8');
        $escapedToken   = htmlspecialchars($token, ENT_QUOTES, 'UTF-8');
        $appUrl         = rtrim(Config::get('base_url', '/'), '/');

        $formContent = $valid
            ? "<p style='color:#ccc;margin-bottom:24px;'>Confirma que deseas darte de baja de las comunicaciones de <strong>{$escapedCompany}</strong>.</p>
               <form method='POST' action='/track/unsubscribe'>
                   <input type='hidden' name='t' value='{$escapedToken}'>
                   <button type='submit' style='background:#D4AF37;color:#000;border:none;padding:14px 28px;font-size:16px;font-weight:700;border-radius:8px;cursor:pointer;'>Confirmar baja</button>
               </form>
               <p style='color:#666;font-size:12px;margin-top:20px;'>No volverás a recibir emails de marketing de nuestra parte.</p>"
            : "<p style='color:#FF5555;'>El enlace de baja no es válido o ya fue utilizado.</p>
               <a href='{$appUrl}' style='color:#30C5FF;'>Volver al inicio</a>";

        return "<!DOCTYPE html>
<html lang='es'>
<head>
    <meta charset='UTF-8'>
    <meta name='robots' content='noindex,nofollow'>
    <title>Dar de baja · {$escapedCompany}</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
</head>
<body style='background:#0A0A0A;color:#fff;font-family:Arial,sans-serif;display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0;'>
    <div style='background:#111;border:1px solid #333;border-radius:12px;padding:48px;max-width:480px;width:100%;text-align:center;'>
        <h1 style='background:linear-gradient(to right,#D4AF37,#30C5FF);-webkit-background-clip:text;color:transparent;margin:0 0 8px;'>{$escapedCompany}</h1>
        <h2 style='color:#ccc;font-size:20px;margin:0 0 32px;'>Gestión de suscripción</h2>
        {$formContent}
    </div>
</body>
</html>";
    }

    public function confirmOptIn(): void
    {
        $token = preg_replace('/[^a-zA-Z0-9\-_]/', '', $_GET['t'] ?? '');
        if (empty($token)) {
            http_response_code(400);
            echo "Token no válido.";
            exit;
        }

        $db = \Core\Database::getInstance()->getConnection();
        $stmt = $db->prepare("SELECT * FROM mktg_contacts WHERE unsubscribe_token = ? AND deleted_at IS NULL");
        $stmt->execute([$token]);
        $contact = $stmt->fetch();

        if (!$contact) {
            http_response_code(404);
            echo "Suscriptor no encontrado.";
            exit;
        }

        $companyName = \Core\Config::get('business.company_name', 'Data Wyrd');

        if ($contact['status'] === 'pending') {
            $ipRaw = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? '';
            
            // Confirm subscription
            $stmtUpd = $db->prepare("UPDATE mktg_contacts SET status = 'subscribed', consent_given = 1, consent_ip = ?, consent_at = NOW() WHERE id = ?");
            $stmtUpd->execute([$ipRaw, $contact['id']]);

            // Trigger signup automation
            $automationService = new \App\Services\Marketing\AutomationService();
            $automationService->trigger('signup', [
                'contact_id' => $contact['id'],
                'email'      => $contact['email'],
                'tenant_id'  => $contact['tenant_id'],
            ]);

            $message = "¡Tu suscripción ha sido confirmada con éxito! Ya estás registrado para recibir nuestras novedades.";
            $success = true;
        } else {
            $message = "Esta suscripción ya está confirmada o activa.";
            $success = true;
        }

        echo $this->renderOptinConfirmPage($companyName, $message, $success);
        exit;
    }

    private function renderOptinConfirmPage(string $companyName, string $message, bool $success): string
    {
        $escapedCompany = htmlspecialchars($companyName, ENT_QUOTES, 'UTF-8');
        $escapedMessage = htmlspecialchars($message, ENT_QUOTES, 'UTF-8');
        $appUrl         = rtrim(\Core\Config::get('base_url', '/'), '/');

        $statusColor = $success ? '#30C5FF' : '#FF5555';
        $statusIcon  = $success ? 'verified_user' : 'error';

        return "<!DOCTYPE html>
<html lang='es'>
<head>
    <meta charset='UTF-8'>
    <meta name='robots' content='noindex,nofollow'>
    <title>Confirmación de Suscripción · {$escapedCompany}</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0'>
</head>
<body style='background:#0A0A0A;color:#fff;font-family:Arial,sans-serif;display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0;'>
    <div style='background:#111;border:1px solid #333;border-radius:12px;padding:48px;max-width:480px;width:100%;text-align:center;'>
        <span class='material-symbols-outlined' style='font-size:64px;color:{$statusColor};margin-bottom:16px;'>{$statusIcon}</span>
        <h1 style='background:linear-gradient(to right,#D4AF37,#30C5FF);-webkit-background-clip:text;color:transparent;margin:0 0 8px;'>{$escapedCompany}</h1>
        <h2 style='color:#ccc;font-size:20px;margin:0 0 24px;'>Confirmar Suscripción</h2>
        <p style='color:#ccc;margin-bottom:32px;line-height:1.6;'>{$escapedMessage}</p>
        <a href='{$appUrl}' style='background:#D4AF37;color:#000;border:none;padding:14px 28px;font-size:16px;font-weight:700;border-radius:8px;text-decoration:none;display:inline-block;'>Ir al Inicio</a>
    </div>
</body>
</html>";
    }
}
