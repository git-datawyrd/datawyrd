<?php
namespace App\Controllers;

use Core\Controller;
use Core\Auth;
use Core\Database;
use App\Services\AIService;

class AIController extends Controller
{
    private $aiService;
    private $db;

    public function __construct()
    {
        $this->aiService = new AIService();
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GAI-01: Genera el resumen de un ticket para el Staff.
     */
    public function generateSummary($ticketId)
    {
        if (!Auth::isAdmin() && !Auth::isStaff()) {
            echo json_encode(['success' => false, 'error' => 'No autorizado']);
            return;
        }

        // Obtener historial del ticket
        $stmt = $this->db->prepare("SELECT c.*, u.role FROM chats c JOIN users u ON c.user_id = u.id WHERE c.ticket_id = ? ORDER BY c.created_at ASC");
        $stmt->execute([$ticketId]);
        $chats = $stmt->fetchAll();

        if (count($chats) < 5) {
            echo json_encode(['success' => false, 'error' => 'No hay suficientes mensajes para generar un resumen significativo.']);
            return;
        }

        $messagesForAI = array_map(function($chat) {
            return [
                'is_admin' => in_array($chat['role'], ['admin', 'staff']),
                'created_at' => $chat['created_at'],
                'message' => $chat['message']
            ];
        }, $chats);

        $summary = $this->aiService->generateTicketSummary($messagesForAI);

        if (!$summary) {
            echo json_encode(['success' => false, 'error' => 'No se pudo generar el resumen. Verifica tu API Key o conexión.']);
            return;
        }

        echo json_encode(['success' => true, 'summary' => $summary]);
    }

    /**
     * GAI-03: Asistente Copilot en Chat.
     */
    public function rewriteDraft()
    {
        if (!Auth::isAdmin() && !Auth::isStaff()) {
            echo json_encode(['success' => false, 'error' => 'No autorizado']);
            return;
        }

        $input = json_decode(file_get_contents('php://input'), true);
        $draft = $input['draft'] ?? '';
        $tone = $input['tone'] ?? 'formal y profesional';

        if (empty($draft)) {
            echo json_encode(['success' => false, 'error' => 'Borrador vacío']);
            return;
        }

        $rewritten = $this->aiService->rewriteDraft($draft, $tone);

        if (!$rewritten) {
            echo json_encode(['success' => false, 'error' => 'El Copilot no pudo reescribir el borrador.']);
            return;
        }

        echo json_encode(['success' => true, 'rewritten' => $rewritten]);
    }
}
