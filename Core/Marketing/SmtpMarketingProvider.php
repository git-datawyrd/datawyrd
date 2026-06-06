<?php
namespace Core\Marketing;

use Core\Config;
use Core\SecurityLogger;

/**
 * SmtpMarketingProvider
 *
 * Adaptador SMTP para envíos de marketing vía PHPMailer.
 * Reutiliza la configuración MAIL_* del .env y permite override
 * con credenciales específicas de marketing si se definen.
 *
 * Ideal para entornos locales o cuando no se dispone de API REST.
 *
 * @package Core\Marketing
 */
class SmtpMarketingProvider implements EmailProviderInterface
{
    private array $mailConfig;
    private array $marketingConfig;

    public function __construct()
    {
        $this->mailConfig      = Config::get('mail', []);
        $this->marketingConfig = Config::get('marketing', []);
    }

    /**
     * {@inheritdoc}
     */
    public function send(array $message): array
    {
        $mailConfig = $this->mailConfig;

        if (empty($mailConfig['host'])) {
            return ['success' => false, 'provider_message_id' => null, 'error' => 'MAIL_HOST no configurado.'];
        }

        try {
            $mail = new \PHPMailer\PHPMailer\PHPMailer(true);

            // Configuración SMTP
            $mail->isSMTP();
            $mail->Host       = $mailConfig['host'];
            $mail->SMTPAuth   = true;
            $mail->Username   = $mailConfig['user'];
            $mail->Password   = $mailConfig['pass'];
            $mail->SMTPSecure = strtolower($mailConfig['enc'] ?? '') === 'tls'
                ? \PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS
                : \PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_SMTPS;
            $mail->Port       = $mailConfig['port'] ?: 587;
            $mail->CharSet    = 'UTF-8';

            // Remitente (permite override por mensaje)
            $fromAddr = $message['from']      ?? ($mailConfig['from_address'] ?? '');
            $fromName = $message['from_name'] ?? ($mailConfig['from_name']    ?? 'Data Wyrd');
            $mail->setFrom($fromAddr, $fromName);

            if (!empty($message['reply_to'])) {
                $mail->addReplyTo($message['reply_to']);
            }

            // Destinatario
            $mail->addAddress($message['to'], $message['to_name'] ?? '');

            // Cuerpo
            $mail->isHTML(true);
            $mail->Subject = $message['subject'];
            $mail->Body    = $message['html_body'] ?? '';
            $mail->AltBody = $message['text_body']  ?? strip_tags($message['html_body'] ?? '');

            // Headers adicionales (List-Unsubscribe, X-Campaign-ID, etc.)
            if (!empty($message['headers']) && is_array($message['headers'])) {
                foreach ($message['headers'] as $headerName => $headerValue) {
                    $mail->addCustomHeader($headerName, $headerValue);
                }
            }

            $mail->send();

            // PHPMailer no retorna un Message-ID propio fácilmente accesible
            // Generamos uno para correlación interna
            $internalMsgId = 'smtp-' . uniqid('', true);

            SecurityLogger::log('marketing_smtp_sent', [
                'to'          => $message['to'],
                'campaign_id' => $message['campaign_id'] ?? null,
                'msg_id'      => $internalMsgId,
            ], 'INFO');

            return ['success' => true, 'provider_message_id' => $internalMsgId, 'error' => null];

        } catch (\Exception $e) {
            $error = isset($mail) ? $mail->ErrorInfo : $e->getMessage();

            SecurityLogger::log('marketing_smtp_send_failed', [
                'to'          => $message['to'],
                'error'       => $error,
                'campaign_id' => $message['campaign_id'] ?? null,
            ], 'ERROR');

            return ['success' => false, 'provider_message_id' => null, 'error' => $error];
        }
    }

    /**
     * {@inheritdoc}
     */
    public function validateCredentials(): bool
    {
        $mailConfig = $this->mailConfig;
        if (empty($mailConfig['host']) || empty($mailConfig['user'])) {
            return false;
        }

        try {
            $mail = new \PHPMailer\PHPMailer\PHPMailer(true);
            $mail->isSMTP();
            $mail->Host       = $mailConfig['host'];
            $mail->SMTPAuth   = true;
            $mail->Username   = $mailConfig['user'];
            $mail->Password   = $mailConfig['pass'];
            $mail->SMTPSecure = \PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS;
            $mail->Port       = $mailConfig['port'] ?: 587;
            $mail->SMTPDebug  = 0;

            return $mail->smtpConnect();
        } catch (\Exception $e) {
            return false;
        }
    }

    /**
     * {@inheritdoc}
     */
    public function getProviderName(): string
    {
        return 'SMTP (PHPMailer)';
    }
}
