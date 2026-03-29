<?php
namespace Core;

/**
 * BlockchainClient - Handles RPC communication with external nodes.
 */
class BlockchainClient
{
    private string $endpoint;
    private ?string $apiKey;

    public function __construct()
    {
        $this->endpoint = Config::get('security.blockchain_node', 'https://rpc-mainnet.datawyrd.com');
        $this->apiKey = Config::get('security.blockchain_api_key');
    }

    /**
     * Notarize a hash into the configured blockchain.
     */
    public function notarize(string $id, string $hash, array $metadata = []): array
    {
        if (!Config::get('security.blockchain_enabled', false)) {
            return ['success' => false, 'error' => 'Blockchain disabled'];
        }

        $payload = [
            'jsonrpc' => '2.0',
            'method' => 'datawyrd_notarize',
            'params' => [
                'requestId' => $id,
                'hash' => $hash,
                'metadata' => $metadata,
                'timestamp' => time()
            ],
            'id' => rand(1000, 9999)
        ];

        return $this->call($payload);
    }

    /**
     * Internal RPC Caller
     */
    private function call(array $payload): array
    {
        $ch = curl_init($this->endpoint);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'X-API-Key: ' . ($this->apiKey ?? '')
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode >= 400 || $response === false) {
            return [
                'success' => false,
                'error' => "Blockchain Node Error (HTTP $httpCode)",
                'raw' => $response
            ];
        }

        return json_decode($response, true) ?? ['success' => false, 'error' => 'Invalid JSON response'];
    }
}
