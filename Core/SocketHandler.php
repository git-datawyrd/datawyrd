<?php
namespace Core;

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;
use Core\Database;
use PDO;

class SocketHandler implements MessageComponentInterface
{
    protected $clients;
    protected $userConnections; // userId => [connectionIds]

    public function __construct()
    {
        $this->clients = new \SplObjectStorage;
        $this->userConnections = [];
    }

    public function onOpen(ConnectionInterface $conn)
    {
        $this->clients->attach($conn);
        
        // Auth via Session Cookie
        $userId = $this->authenticate($conn);
        
        if ($userId) {
            $conn->userId = $userId;
            $this->userConnections[$userId][] = $conn->resourceId;
            echo "New connection! ({$conn->resourceId}) User ID: {$userId}\n";
        } else {
            echo "New anonymous connection! ({$conn->resourceId})\n";
        }
    }

    public function onMessage(ConnectionInterface $from, $msg)
    {
        $data = json_decode($msg, true);
        if (!$data) return;

        // Handle client-side messages if needed (e.g. ping)
        if (isset($data['type']) && $data['type'] === 'ping') {
            $from->send(json_encode(['type' => 'pong']));
        }
    }

    public function onClose(ConnectionInterface $conn)
    {
        $this->clients->detach($conn);
        
        if (isset($conn->userId)) {
            $userId = $conn->userId;
            if (isset($this->userConnections[$userId])) {
                $this->userConnections[$userId] = array_diff($this->userConnections[$userId], [$conn->resourceId]);
                if (empty($this->userConnections[$userId])) {
                    unset($this->userConnections[$userId]);
                }
            }
        }
        
        echo "Connection {$conn->resourceId} has disconnected\n";
    }

    public function onError(ConnectionInterface $conn, \Exception $e)
    {
        echo "An error has occurred: {$e->getMessage()}\n";
        $conn->close();
    }

    /**
     * Broadcast to all connected clients
     */
    public function broadcast($msg)
    {
        foreach ($this->clients as $client) {
            $client->send($msg);
        }
    }

    /**
     * Send message to a specific user
     */
    public function sendToUser($userId, $msg)
    {
        if (isset($this->userConnections[$userId])) {
            foreach ($this->clients as $client) {
                if (isset($client->userId) && $client->userId == $userId) {
                    $client->send($msg);
                }
            }
        }
    }

    /**
     * Simple Session Authentication
     */
    private function authenticate(ConnectionInterface $conn)
    {
        $cookies = $conn->httpRequest->getHeader('Cookie');
        if (empty($cookies)) return null;

        $sessionId = null;
        foreach ($cookies as $cookieLine) {
            if (preg_match('/PHPSESSID=([^;]+)/', $cookieLine, $matches)) {
                $sessionId = $matches[1];
                break;
            }
        }

        if (!$sessionId) return null;

        try {
            $db = Database::getInstance()->getConnection();
            $stmt = $db->prepare("SELECT user_id FROM sessions WHERE id = ? AND last_activity > ? LIMIT 1");
            $stmt->execute([$sessionId, time() - 7200]); // 2h session
            return $stmt->fetchColumn();
        } catch (\Exception $e) {
            echo "Auth Error: " . $e->getMessage() . "\n";
            return null;
        }
    }
}
