<?php
namespace App\Controllers;

use Core\Controller;
use Core\Database;
use App\Models\User;
use Core\Session;
use Core\Auth;
use Core\Mail;
use App\Services\AIService;
use PDO;

class TicketController extends Controller
{
    public function __construct()
    {
        // Public request doesn't need auth, but list/detail does
    }

    /**
     * List Tickets (Admin/Staff sees all, Client sees own)
     */
    public function index()
    {
        if (!Auth::check()) {
            $this->redirect('/auth/login');
        }

        $db = Database::getInstance()->getConnection();
        $user = Auth::user();

        if (Auth::isClient()) {
            $sql = "SELECT t.*, sp.name as plan_name 
                    FROM tickets t 
                    JOIN service_plans sp ON t.service_plan_id = sp.id 
                    WHERE t.client_id = ? 
                    ORDER BY t.created_at DESC";
            $stmt = $db->prepare($sql);
            $stmt->execute([$user['id']]);
        } else {
            // Admin or Staff sees all tickets
            $sql = "SELECT t.*, u.name as client_name, sp.name as plan_name, s.name as service_name 
                    FROM tickets t 
                    JOIN users u ON t.client_id = u.id 
                    JOIN service_plans sp ON t.service_plan_id = sp.id 
                    JOIN services s ON sp.service_id = s.id 
                    ORDER BY t.created_at DESC";
            $stmt = $db->query($sql);
        }

        $tickets = $stmt->fetchAll();
        $isClient = Auth::isClient();

        // 🧠 Intelligence Services Integration
        $intelligence = new \App\Services\CRM\IntelligenceService();
        $leadService = new \App\Services\CRM\LeadService();

        foreach ($tickets as &$t) {
            // Predictivve Delay Risk
            $riskData = $intelligence->calculateDelayRisk($t);
            $t['is_at_risk'] = $riskData['is_at_risk'];
            $t['risk_reason'] = $riskData['risk_reason'];

            // Lead Intelligence Score (Only for Admin/Staff)
            if (!$isClient) {
                $clientId = $t['client_id'] ?? null;
                $t['lead_score'] = $clientId ? $leadService->calculateScore($clientId) : 0;
            }
        }

        $view = Auth::role() . '/tickets/index';
        $this->viewLayout($view, Auth::role(), [
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

        // Rate Limiting: Max 5 tickets per hour per IP
        $ip = $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
        if (!\Core\RateLimiter::attempt('ticket_submit_ip_' . $ip, 5, 3600)) {
            Session::flash('error', 'Límite de solicitudes mensuales/horarias excedido. Por favor, contacta a soporte directamente.');
            $this->redirect('/ticket/request');
            return;
        }

        $db = Database::getInstance()->getConnection();
        $userModel = new User();

        $name = $_POST['name'] ?? '';
        $email = $_POST['email'] ?? '';
        $phone = $_POST['phone'] ?? '';
        $company = $_POST['company'] ?? '';
        $subject = $_POST['subject'] ?? '';
        $service_id = $_POST['service_id'] ?? null;
        $plan_id = $_POST['service_plan_id'] ?? null;
        $description = $_POST['description'] ?? '';

        // Fallback: If service_id is provided but no specific plan_id, map to the first available plan
        if (!$plan_id && $service_id) {
            $stmt = $db->prepare("SELECT id FROM service_plans WHERE service_id = ? ORDER BY price ASC LIMIT 1");
            $stmt->execute([$service_id]);
            $plan_id = $stmt->fetchColumn() ?: null;
        }

        // Final check: service_plan_id is required by the database
        if (!$plan_id) {
            Session::flash('error', 'Debes seleccionar un servicio o plan válido.');
            $this->redirect($_SERVER['HTTP_REFERER'] ?? '/');
            return;
        }

        $user = $userModel->findByEmail($email);
        $isNewUser = false;
        if (!$user) {
            $isNewUser = true;
            $tempPass = bin2hex(random_bytes(4));
            $userModel->create([
                'name' => $name,
                'email' => $email,
                'password' => $tempPass,
                'role' => 'client',
                'company' => $company,
                'phone' => $phone
            ]);
            $user = $userModel->findByEmail($email);

            // Send Welcome Email
            Mail::sendWelcome($email, $name, $tempPass);
        }

        $ticket_number = 'TKT-' . strtoupper(bin2hex(random_bytes(3)));
        $sql = "INSERT INTO tickets (ticket_number, client_id, service_plan_id, subject, description, status) 
                VALUES (?, ?, ?, ?, ?, 'open')";
        $stmt = $db->prepare($sql);
        $result = $stmt->execute([$ticket_number, $user['id'], $plan_id, $subject, $description]);

        if ($result) {
            // Notification: Ticket Received (PRD v1.0 - Use professional template)
            Mail::sendRequestConfirmation($email, $name, $ticket_number, $subject);

            \Core\SecurityLogger::log('ticket_created', [
                'ticket_number' => $ticket_number,
                'email' => $email,
                'subject' => $subject
            ]);

            // Notify Staff/Admin
            $staffStmt = $db->query("SELECT id FROM users WHERE role IN ('admin', 'staff')");
            $staff = $staffStmt->fetchAll();
            foreach ($staff as $s) {
                \App\Models\Notification::send($s['id'], 'new_ticket', 'Nueva Solicitud', "Nueva solicitud recibida: $subject de $name.", '/ticket/detail/' . $db->lastInsertId());
            }

            Session::flash('success', '¡Solicitud recibida! Hemos enviado detalles a tu correo.');

            // 🤖 GAI-02: Extracción de Action Items (E11-007)
            $aiService = new AIService();
            if ($aiService->isEnabled()) {
                $lastTicketId = $db->lastInsertId();
                $tasks = $aiService->extractActionItems($description);
                if ($tasks && is_array($tasks)) {
                    $tenantId = \Core\Config::get('current_tenant_id', 1);
                    $taskSql = "INSERT INTO ticket_tasks (ticket_id, tenant_id, description) VALUES (?, ?, ?)";
                    $taskStmt = $db->prepare($taskSql);
                    foreach ($tasks as $task) {
                        $taskStmt->execute([$lastTicketId, $tenantId, $task]);
                    }
                    
                    // Insertar mensaje de sistema informando de las tareas sugeridas
                    $sysMsg = "🤖 Copilot GAI ha analizado tu requerimiento y sugerido " . count($tasks) . " tareas iniciales.";
                    $db->prepare("INSERT INTO chat_messages (ticket_id, user_id, message, message_type) VALUES (?, 0, ?, 'system')")
                      ->execute([$lastTicketId, $sysMsg]);
                }
            }

            // AUTO-LOGIN: Set user in session so they can access the dashboard immediately
            session_regenerate_id(true);
            Session::set('user', $user);

            $this->redirect('/quote/received');
        } else {
            Session::flash('error', 'Ocurrió un error al procesar tu solicitud.');
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
        $tenantId = \Core\Config::get('current_tenant_id', 1);
        $stmt = $db->prepare("SELECT * FROM ticket_tasks WHERE ticket_id = ? AND tenant_id = ? ORDER BY id ASC");
        $stmt->execute([$id, $tenantId]);
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

            $this->redirect('/ticket/detail/' . $id);
        }
    }
}
