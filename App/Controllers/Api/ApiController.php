<?php

namespace App\Controllers\Api;

use Core\SecurityLogger;
use Core\JWT;
use Core\App;

/**
 * ApiController - Base class for API controllers
 */
abstract class ApiController
{
    protected JWT $jwt;

    public function __construct(JWT $jwt)
    {
        $this->jwt = $jwt;
        $this->validateTrustMesh();
    }

    /**
     * Trust Mesh Validation (Malla de Confianza)
     * Verifies the X-App-Fingerprint header against trusted application signatures.
     */
    protected function validateTrustMesh(): void
    {
        // En DataWyrd 11.6, forzamos validación de origen en la API
        $headers = getallheaders();
        $fingerprint = $headers['X-App-Fingerprint'] ?? $headers['x-app-fingerprint'] ?? null;

        if (!$fingerprint && \Core\Config::get('api.enforce_trust_mesh', false)) {
            SecurityLogger::log('TRUST_MESH_VIOLATION', 'Missing App Fingerprint', 'CRITICAL');
            $this->error("API Trust Mesh violation: Identity not established", 403);
        }

        // Simulación de validación contra registro de aplicaciones autorizadas
        // En producción: verificar hash HMAC de la app o App ID registrado
        $trustedSignals = \Core\Config::get('api.trusted_fingerprints', ['DW-MOBILE-V1-ALPHA']);
        if ($fingerprint && !in_array($fingerprint, $trustedSignals) && \Core\Config::get('api.enforce_trust_mesh', false)) {
            SecurityLogger::log('TRUST_MESH_REJECTED', "Untrusted fingerprint: $fingerprint", 'CRITICAL');
            $this->error("API Trust Mesh violation: Unauthorized application signature", 403);
        }
    }

    /**
     * Standard JSON response helper
     */
    protected function json(array $data, int $code = 200): void
    {
        http_response_code($code);
        header('Content-Type: application/json');

        $data['requestId'] = App::$requestId;
        echo json_encode($data);
        exit;
    }

    /**
     * Error JSON response helper
     */
    protected function error(string $message, int $code = 400): void
    {
        $this->json(['success' => false, 'error' => $message], $code);
    }

    /**
     * JWT Authentication Middleware
     */
    protected function authenticate(): array
    {
        $headers = getallheaders();
        $authHeader = $headers['Authorization'] ?? '';

        if (!$authHeader || strpos($authHeader, 'Bearer ') !== 0) {
            $this->error("Missing or invalid Authorization header", 401);
        }

        $token = substr($authHeader, 7);
        $payload = $this->jwt->decode($token);

        if (!$payload) {
            $this->error("Invalid or expired token", 401);
        }

        return $payload;
    }
}
