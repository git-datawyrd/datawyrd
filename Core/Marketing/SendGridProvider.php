<?php
namespace Core\Marketing;

use Core\Config;
use Core\SecurityLogger;

/**
 * SendGridProvider
 *
 * Adaptador para la API REST de SendGrid.
 *
 * Configuración en .env:
 *   SENDGRID_API_KEY=...
 *   SENDGRID_FROM_ADDRESS=...
 *
 * @package Core\Marketing
 */
class SendGridProvider implements EmailProviderInterface
{
    private array $config;

    public function __construct()
    {
        $this->config = Config::get('marketing.sendgrid', []);
    }

    /**
     * {@inheritdoc}
     */
    public function send(array $message): array
    {
        $apiKey = $this->config['api_key'] ?? '';
        if (empty($apiKey)) {
            return ['success' => false, 'provider_message_id' => null, 'error' => 'SENDGRID_API_KEY no configurada.'];
        }

        $from     = $message['from']      ?? ($this->config['from_address'] ?? '');
        $fromName = $message['from_name'] ?? ($this->config['from_name']    ?? 'Data Wyrd');

        // Construir payload según API de SendGrid v3
        $payload = [
            'personalizations' => [
                [
                    'to' => [['email' => $message['to'], 'name' => $message['to_name'] ?? '']],
                ]
            ],
            'from' => ['email' => $from, 'name' => $fromName],
            'subject' => $message['subject'],
            'content' => [
                ['type' => 'text/html', 'value' => $message['html_body'] ?? ''],
                ['type' => 'text/plain', 'value' => $message['text_body'] ?? strip_tags($message['html_body'] ?? '')]
            ]
        ];

        if (!empty($message['reply_to'])) {
            $payload['reply_to'] = ['email' => $message['reply_to']];
        }

        if (!empty($message['headers']) && is_array($message['headers'])) {
            $payload['headers'] = $message['headers'];
        }

        $ch = curl_init('https://api.sendgrid.com/v3/mail/send');
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => json_encode($payload),
            CURLOPT_HTTPHEADER     => [
                'Authorization: Bearer ' . $apiKey,
                'Content-Type: application/json'
            ],
            CURLOPT_TIMEOUT        => 15,
            CURLOPT_SSL_VERIFYPEER => true,
        ]);

        $response  = curl_exec($ch);
        $httpCode  = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);

        if ($curlError) {
            SecurityLogger::log('marketing_sendgrid_curl_error', ['error' => $curlError, 'to' => $message['to']], 'ERROR');
            return ['success' => false, 'provider_message_id' => null, 'error' => 'cURL error: ' . $curlError];
        }

        if ($httpCode >= 200 && $httpCode < 300) {
            $msgId = 'sg-' . uniqid('', true);
            SecurityLogger::log('marketing_sendgrid_sent', [
                'to'          => $message['to'],
                'message_id'  => $msgId,
                'campaign_id' => $message['campaign_id'] ?? null,
            ], 'INFO');
            return ['success' => true, 'provider_message_id' => $msgId, 'error' => null];
        }

        $errorResponse = json_decode($response, true);
        $errorMsg      = $errorResponse['errors'][0]['message'] ?? ('HTTP ' . $httpCode . ': ' . $response);
        
        SecurityLogger::log('marketing_sendgrid_send_failed', [
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
        return !empty($apiKey);
    }

    /**
     * {@inheritdoc}
     */
    public function getProviderName(): string
    {
        return 'SendGrid';
    }
}
