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
