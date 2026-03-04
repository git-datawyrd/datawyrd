<?php

namespace Core;

use Firebase\JWT\JWT as FirebaseJWT;
use Firebase\JWT\Key;
use Exception;

/**
 * JWT Wrapper for DataWyrd 9.5
 */
class JWT
{
    private \PDO $db;
    private string $secret;

    public function __construct(\PDO $db)
    {
        $this->db = $db;
        $this->secret = Config::get('security.jwt_secret', 'datawyrd-default-secret');
    }

    /**
     * Encode payload into a JWT string.
     */
    public function encode(array $payload, int $expiry = 3600): string
    {
        $payload['iat'] = time();
        $payload['exp'] = time() + $expiry;

        return FirebaseJWT::encode($payload, $this->secret, 'HS256');
    }

    /**
     * Decode JWT string into a payload array.
     */
    public function decode(string $token): ?array
    {
        try {
            $decoded = FirebaseJWT::decode($token, new Key($this->secret, 'HS256'));
            return (array) $decoded;
        } catch (Exception $e) {
            SecurityLogger::log('JWT_DECODE_FAILED', $e->getMessage(), 'WARN');
            return null;
        }
    }

    /**
     * Generate a random refresh token and store it.
     */
    public function generateRefreshToken(int $userId, int $days = 30): string
    {
        $token = bin2hex(random_bytes(32));
        $expiresAt = date('Y-m-d H:i:s', time() + ($days * 86400));

        $stmt = $this->db->prepare("INSERT INTO jwt_refresh_tokens (user_id, token, expires_at) VALUES (?, ?, ?)");
        $stmt->execute([$userId, $token, $expiresAt]);

        return $token;
    }

    /**
     * Validate a refresh token and return the user_id if valid.
     */
    public function validateRefreshToken(string $token): ?int
    {
        $stmt = $this->db->prepare("SELECT user_id FROM jwt_refresh_tokens WHERE token = ? AND expires_at > NOW()");
        $stmt->execute([$token]);
        $row = $stmt->fetch();

        if ($row) {
            return (int) $row['user_id'];
        }

        return null;
    }

    /**
     * Revoke a refresh token.
     */
    public function revokeRefreshToken(string $token): void
    {
        $stmt = $this->db->prepare("DELETE FROM jwt_refresh_tokens WHERE token = ?");
        $stmt->execute([$token]);
    }
}
