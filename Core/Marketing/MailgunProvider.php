<?php
namespace Core\Marketing;

use Core\Config;
use Core\SecurityLogger;

/**
 * MailgunProvider
 *
 * Adaptador para la API REST de Mailgun.
 *
 * Configuración en .env:
 *   MAILGUN_API_KEY=...
 *   MAILGUN_DOMAIN=...
 *   MAILGUN_FROM_ADDRESS=...
 *
 * @package Core\Marketing
 */
class MailgunProvider implements EmailProviderInterface
{
    private array $config;

    public function __construct()
    {
        $this->config = Config::get('marketing.mailgun', []);
    }

    /**
     * {@inheritdoc}
     */
    public function send(array $message): array
    {
        $apiKey = $this->config['api_key'] ?? '';
        $domain = $this->config['domain'] ?? '';

        if (empty($apiKey) || empty($domain)) {
            return ['success' => false, 'provider_message_id' => null, 'error' => 'MAILGUN_API_KEY o MAILGUN_DOMAIN no configurados.'];
        }

        $from     = $message['from']      ?? ($this->config['from_address'] ?? '');
        $fromName = $message['from_name'] ?? ($this->config['from_name']    ?? 'Data Wyrd');

        // Construir datos de envío por método POST
        $postData = [
            'from'    => "{$fromName} <{$from}>",
            'to'      => $message['to'],
            'subject' => $message['subject'],
            'html'    => $message['html_body'] ?? '',
            'text'    => $message['text_body'] ?? strip_tags($message['html_body'] ?? ''),
        ];

        if (!empty($message['reply_to'])) {
            $postData['h:Reply-To'] = $message['reply_to'];
        }

        if (!empty($message['headers']) && is_array($message['headers'])) {
            foreach ($message['headers'] as $name => $value) {
                $postData['h:' . $name] = $value;
            }
        }

        $apiUrl = "https://api.mailgun.net/v3/{$domain}/messages";

        $ch = curl_init($apiUrl);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => http_build_query($postData),
            CURLOPT_USERPWD        => 'api:' . $apiKey,
            CURLOPT_TIMEOUT        => 15,
            CURLOPT_SSL_VERIFYPEER => true,
        ]);

        $response  = curl_exec($ch);
        $httpCode  = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);

        if ($curlError) {
            SecurityLogger::log('marketing_mailgun_curl_error', ['error' => $curlError, 'to' => $message['to']], 'ERROR');
            return ['success' => false, 'provider_message_id' => null, 'error' => 'cURL error: ' . $curlError];
        }

        $body = json_decode($response, true);

        if ($httpCode >= 200 && $httpCode < 300) {
            $msgId = $body['id'] ?? ('mg-' . uniqid('', true));
            SecurityLogger::log('marketing_mailgun_sent', [
                'to'          => $message['to'],
                'message_id'  => $msgId,
                'campaign_id' => $message['campaign_id'] ?? null,
            ], 'INFO');
            return ['success' => true, 'provider_message_id' => $msgId, 'error' => null];
        }

        $errorMsg = $body['message'] ?? ('HTTP ' . $httpCode . ': ' . $response);
        
        SecurityLogger::log('marketing_mailgun_send_failed', [
            'to'        => $message['to'],
            'http_code' => $httpCode,
            'error'     => $errorMsg,
        ], 'ERROR');

        return ['success' => false, 'provider_message_id' => null, 'error' => $errorMsg];
    }

    /**
     * {@inheritdoc}
     */
    public function validateCredentials(): bool
    {
        $apiKey = $this->config['api_key'] ?? '';
        $domain = $this->config['domain'] ?? '';
        return !empty($apiKey) && !empty($domain);
    }

    /**
     * {@inheritdoc}
     */
    public function getProviderName(): string
    {
        return 'Mailgun';
    }
}
