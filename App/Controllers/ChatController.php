<?php
namespace App\Controllers;

use Core\Controller;
use Core\Database;
use Core\Auth;

class ChatController extends Controller
{
    public function __construct()
    {
        if (!Auth::check())
            $this->redirect('/auth/login');
    }

    /**
     * Send Message
     */
    public function send()
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST')
            $this->redirect('/dashboard');

        $ticket_id = $_POST['ticket_id'];
        $message = $_POST['message'];
        $user_id = Auth::user()['id'];

        if (empty(trim($message))) {
            $this->redirect('/ticket/detail/' . $ticket_id);
        }

        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare("INSERT INTO chat_messages (ticket_id, user_id, message) VALUES (?, ?, ?)");
        $result = $stmt->execute([$ticket_id, $user_id, $message]);

        if ($result) {
            // Update ticket updated_at
            $db->prepare("UPDATE tickets SET updated_at = NOW() WHERE id = ?")->execute([$ticket_id]);

            $this->redirect('/ticket/detail/' . $ticket_id);
        }
    }
}
