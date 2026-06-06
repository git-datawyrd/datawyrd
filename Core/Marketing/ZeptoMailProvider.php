<?php
namespace Core\Marketing;

use Core\Config;
use Core\SecurityLogger;

/**
 * ZeptoMailProvider
 *
 * Adaptador para la API REST de ZeptoMail (Zoho).
 * Ideal para envíos masivos en producción sobre Hostinger.
 * No requiere SMTP abierto — usa HTTP puro (sin restricciones de puerto).
 *
 * Configuración necesaria en .env:
 *   MARKETING_PROVIDER=zepto
 *   ZEPTO_API_KEY=...
 *   ZEPTO_FROM_ADDRESS=...
 *
 * @package Core\Marketing
 */
class ZeptoMailProvider implements EmailProviderInterface
{
    private array $config;

    public function __construct()
    {
        $this->config = Config::get('marketing.zepto', []);
    }

    /**
     * {@inheritdoc}
     */
    public function send(array $message): array
    {
        $apiKey   = $this->config['api_key'] ?? '';
        $apiUrl   = $this->config['api_url'] ?? 'https://api.zeptomail.com/v1.1/email';

        if (empty($apiKey)) {
            return ['success' => false, 'provider_message_id' => null, 'error' => 'ZEPTO_API_KEY no configurada.'];
        }

        $from        = $message['from']      ?? ($this->config['from_address'] ?? '');
        $fromName    = $message['from_name'] ?? ($this->config['from_name']    ?? 'Data Wyrd');
        $bounceAddr  = $this->config['bounce_address'] ?? '';

        // Construir payload según ZeptoMail API v1.1
        $payload = [
            'from'    => ['address' => $from, 'name' => $fromName],
            'to'      => [['email_address' => ['address' => $message['to'], 'name' => $message['to_name'] ?? '']]],
            'subject' => $message['subject'],
            'htmlbody'=> $message['html_body'] ?? '',
            'textbody'=> $message['text_body']  ?? strip_tags($message['html_body'] ?? ''),
        ];

        if (!empty($message['reply_to'])) {
            $payload['reply_to'] = [['address' => $message['reply_to']]];
        }
        if (!empty($bounceAddr)) {
            $payload['bounce_address'] = $bounceAddr;
        }

        // Añadir headers adicionales (List-Unsubscribe, X-Campaign-ID, etc.)
        if (!empty($message['headers']) && is_array($message['headers'])) {
            $payload['additional_headers'] = $message['headers'];
        }

        $jsonPayload = json_encode($payload);

        // Envío via cURL (compatible con Hostinger sin extensiones especiales)
        $ch = curl_init($apiUrl);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => $jsonPayload,
            CURLOPT_HTTPHEADER     => [
                'Accept: application/json',
                'Content-Type: application/json',
                'Authorization: Zoho-enczapikey ' . $apiKey,
            ],
            CURLOPT_TIMEOUT        => 15,
            CURLOPT_SSL_VERIFYPEER => true,
        ]);

        $response   = curl_exec($ch);
        $httpCode   = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError  = curl_error($ch);
        curl_close($ch);

        if ($curlError) {
            SecurityLogger::log('marketing_zepto_curl_error', ['error' => $curlError, 'to' => $message['to']], 'ERROR');
            return ['success' => false, 'provider_message_id' => null, 'error' => 'cURL error: ' . $curlError];
        }

        $body = json_decode($response, true);

        if ($httpCode >= 200 && $httpCode < 300) {
            $messageId = $body['data'][0]['message_id'] ?? null;
            SecurityLogger::log('marketing_zepto_sent', [
                'to'         => $message['to'],
                'message_id' => $messageId,
                'campaign_id'=> $message['campaign_id'] ?? null,
            ], 'INFO');
            return ['success' => true, 'provider_message_id' => $messageId, 'error' => null];
        }

        $errorMsg = $body['message'] ?? ('HTTP ' . $httpCode . ': ' . $response);
        SecurityLogger::log('marketing_zepto_send_failed', [
            'to'          => $message['to'],
            'http_code'   => $httpCode,
            'error'       => $errorMsg,
            'campaign_id' => $message['campaign_id'] ?? null,
        ], 'ERROR');

        return ['success' => false, 'provider_message_id' => null, 'error' => $errorMsg];
    }

    /**
     * {@inheritdoc}
     */
    public function validateCredentials(): bool
    {
        $apiKey = $this->config['api_key'] ?? '';
        if (empty($apiKey)) {
            return false;
        }

        // Llama a la API de ZeptoMail con un payload mínimo para validar auth
        $ch = curl_init('https://api.zeptomail.com/v1.1/email');
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => '{}',
            CURLOPT_HTTPHEADER     => [
                'Accept: application/json',
                'Content-Type: application/json',
                'Authorization: Zoho-enczapikey ' . $apiKey,
            ],
            CURLOPT_TIMEOUT        => 10,
            CURLOPT_SSL_VERIFYPEER => true,
        ]);

        curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        // 400 = request malformada pero autenticada correctamente
        // 401/403 = credenciales inválidas
        return !in_array($httpCode, [401, 403], true);
    }

    /**
     * {@inheritdoc}
     */
    public function getProviderName(): string
    {
        return 'ZeptoMail';
    }
}
