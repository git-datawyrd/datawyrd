<?php
namespace App\Controllers;

use Core\Controller;
use Core\Database;
use App\Models\User;
use Core\Session;
use Core\Auth;
use Core\Mail;
use App\Services\AIService;
use App\Services\RealTimeService;
use PDO;
class TicketController extends Controller
{
    private \App\Services\TicketService $ticketService;

    public function __construct(\App\Services\TicketService $ticketService)
    {
        $this->ticketService = $ticketService;
    }

    /**
     * List Tickets (Admin/Staff sees all, Client sees own)
     */
    public function index()
    {
        if (!\Core\Auth::check()) {
            $this->redirect('/auth/login');
        }

        $user = \Core\Auth::user();
        $tickets = $this->ticketService->getTicketsForUser($user);

        $view = \Core\Auth::role() . '/tickets/index';
        $this->viewLayout($view, \Core\Auth::role(), [
            'title' => 'Gestión de Tickets | Data Wyrd',
            'tickets' => $tickets
        ]);
    }


    /**
     * Public Service Request Form
     */
    public function request()
    {
        $db = Database::getInstance()->getConnection();
        $stmt = $db->query("SELECT s.id, s.name as service_name, c.name as category_name 
                           FROM services s 
                           JOIN service_categories c ON s.category_id = c.id 
                           WHERE s.is_active = 1 
                           ORDER BY c.name, s.name");
        $services = $stmt->fetchAll();

        $this->viewLayout('public/tickets/request', 'public', [
            'title' => 'Solicitud de Servicio | Data Wyrd',
            'services' => $services
        ]);
    }

    /**
     * Submit Public Request
     */
    public function submit()
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/');
        }

        // Rate Limiting
        $ip = $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
        if (!\Core\RateLimiter::attempt('ticket_submit_ip_' . $ip, 5, 3600)) {
            \Core\Session::flash('error', 'Límite de solicitudes mensuales/horarias excedido.');
            $this->redirect('/ticket/request');
            return;
        }

        $result = $this->ticketService->createTicket($_POST);

        if ($result) {
            \Core\Session::flash('success', '¡Solicitud recibida! Hemos enviado detalles a tu correo.');
            
            // AUTO-LOGIN
            session_regenerate_id(true);
            \Core\Session::set('user', $result['user']);

            $this->redirect('/quote/received');
        } else {
            \Core\Session::flash('error', 'Ocurrió un error al procesar tu solicitud.');
            $this->redirect('/ticket/request');
        }
    }


    /**
     * Internal Ticket Detail
     */
    public function detail($id)
    {
        if (!Auth::check())
            $this->redirect('/auth/login');

        $db = Database::getInstance()->getConnection();

        // Get ticket with related data
        $sql = "SELECT t.*, u.name as client_name, u.email as client_email, u.company as client_company, sp.name as plan_name, s.name as service_name 
                FROM tickets t 
                JOIN users u ON t.client_id = u.id 
                JOIN service_plans sp ON t.service_plan_id = sp.id 
                JOIN services s ON sp.service_id = s.id 
                WHERE t.id = ?";
        $stmt = $db->prepare($sql);
        $stmt->execute([$id]);
        $ticket = $stmt->fetch();

        if (!$ticket)
            $this->redirect('/dashboard');

        // Security: clients can only see their own tickets
        if (Auth::isClient() && $ticket['client_id'] != Auth::user()['id']) {
            $this->redirect('/dashboard');
        }

        // Get chat messages
        $stmt = $db->prepare("SELECT m.*, u.name as user_name, u.role as user_role 
                             FROM chat_messages m 
                             LEFT JOIN users u ON m.user_id = u.id 
                             WHERE m.ticket_id = ? ORDER BY m.created_at ASC");
        $stmt->execute([$id]);
        $messages = $stmt->fetchAll();

        // Get budget if exists
        $stmt = $db->prepare("SELECT * FROM budgets WHERE ticket_id = ? ORDER BY created_at DESC LIMIT 1");
        $stmt->execute([$id]);
        $budget = $stmt->fetch();

        // Get invoice if budget exists
        $invoice = null;
        if ($budget) {
            $stmt = $db->prepare("SELECT * FROM invoices WHERE budget_id = ? ORDER BY created_at DESC LIMIT 1");
            $stmt->execute([$budget['id']]);
            $invoice = $stmt->fetch();
        }

        // Get AI Action Items
        $stmt = $db->prepare("SELECT * FROM ticket_tasks WHERE ticket_id = ? ORDER BY id ASC");
        $stmt->execute([$id]);
        $tasks = $stmt->fetchAll();

        $layout = Auth::role();
        $this->viewLayout(Auth::role() . '/tickets/detail', $layout, [
            'title' => 'Detalle de Ticket: ' . $ticket['ticket_number'],
            'ticket' => $ticket,
            'messages' => $messages,
            'budget' => $budget,
            'invoice' => $invoice,
            'tasks' => $tasks
        ]);
    }

    /**
     * Update Ticket Status (AJAX or Form)
     */
    public function updateStatus()
    {
        if (!Auth::check() || Auth::isClient())
            $this->json(['success' => false]);

        $id = $_POST['ticket_id'];
        $status = $_POST['status'];

        $db = Database::getInstance()->getConnection();

        // Get ticket info before updating
        $stmt = $db->prepare("SELECT u.email, t.ticket_number, t.assigned_to FROM tickets t JOIN users u ON t.client_id = u.id WHERE t.id = ?");
        $stmt->execute([$id]);
        $info = $stmt->fetch();

        // Auto-assign to current user if not assigned
        $assign_sql = "";
        $params = [$status, $id];
        if (empty($info['assigned_to'])) {
            $assign_sql = ", assigned_to = ?";
            $params = [$status, Auth::user()['id'], $id];
        }

        $stmt = $db->prepare("UPDATE tickets SET status = ?, updated_at = NOW() {$assign_sql} WHERE id = ?");
        $result = $stmt->execute($params);

        if ($result) {
            // Send Notification
            if ($info) {
                Mail::sendTicketUpdate($info['email'], $info['ticket_number'], $status);
            }
            \Core\SecurityLogger::log('ticket_status_changed', [
                'ticket_id' => $id,
                'ticket_number' => $info['ticket_number'] ?? 'unknown',
                'new_status' => $status
            ]);

            // Notify Client
            $clientStmt = $db->prepare("SELECT client_id FROM tickets WHERE id = ?");
            $clientStmt->execute([$id]);
            $client_id = $clientStmt->fetchColumn();
            if ($client_id) {
                \App\Models\Notification::send($client_id, 'ticket_update', 'Actualización de Ticket', "Tu ticket " . ($info['ticket_number'] ?? '') . " ha cambiado a estado: " . translateStatus($status), '/ticket/detail/' . $id);
            }

            // 🚀 Real-Time Broadcast (E11-011)
            RealTimeService::broadcast('ticket_status_update', [
                'ticket_id' => $id,
                'ticket_number' => $info['ticket_number'] ?? 'unknown',
                'status' => translateStatus($status)
            ]);

            $this->redirect('/ticket/detail/' . $id);
        }
    }
}
