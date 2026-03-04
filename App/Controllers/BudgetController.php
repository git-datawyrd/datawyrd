<?php
namespace App\Controllers;

use Core\Controller;
use Core\Database;
use Core\Auth;
use Core\Session;
use Core\Mail;
use PDO;

class BudgetController extends Controller
{
    public function __construct()
    {
        if (!Auth::check())
            $this->redirect('/auth/login');
    }

    /**
     * Show Budget Creation Form (from Ticket)
     */
    public function create($ticket_id)
    {
        if (Auth::isClient())
            $this->redirect('/dashboard');

        $db = Database::getInstance()->getConnection();

        // Get ticket info
        $stmt = $db->prepare("SELECT t.*, u.name as client_name, sp.name as plan_name, sp.price as plan_price, s.name as service_name
                             FROM tickets t 
                             JOIN users u ON t.client_id = u.id 
                             JOIN service_plans sp ON t.service_plan_id = sp.id 
                             JOIN services s ON sp.service_id = s.id
                             WHERE t.id = ?");
        $stmt->execute([$ticket_id]);
        $ticket = $stmt->fetch();

        if (!$ticket)
            $this->redirect('/dashboard');

        $this->viewLayout('staff/budgets/create', 'staff', [
            'title' => 'Generar Presupuesto | Data Wyrd',
            'ticket' => $ticket
        ]);
    }

    /**
     * Save Budget
     */
    public function store()
    {
        if (Auth::isClient())
            $this->redirect('/dashboard');

        $db = Database::getInstance()->getConnection();
        $db->beginTransaction();

        try {
            $ticket_id = $_POST['ticket_id'];
            $title = $_POST['title'];
            $scope = $_POST['scope'];
            $timeline = $_POST['timeline_weeks'];
            $items = $_POST['items']; // Array of items

            $subtotal = 0;
            foreach ($items as $item) {
                $subtotal += ($item['quantity'] * $item['unit_price']);
            }

            $tax_rate = \Core\Config::get('TAX_RATE', 16.00); // Dynamic tax from .env
            $tax_amount = $subtotal * ($tax_rate / 100);
            $total = $subtotal + $tax_amount;
            $budget_number = 'DW-B' . date('Y') . '-' . strtoupper(bin2hex(random_bytes(2)));

            // 1. Insert Budget
            $sql = "INSERT INTO budgets (budget_number, ticket_id, title, scope, timeline_weeks, subtotal, tax_rate, tax_amount, total, created_by, status) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'sent')";
            $stmt = $db->prepare($sql);
            $stmt->execute([
                $budget_number,
                $ticket_id,
                $title,
                $scope,
                $timeline,
                $subtotal,
                $tax_rate,
                $tax_amount,
                $total,
                Auth::user()['id']
            ]);
            $budget_id = $db->lastInsertId();

            // 2. Insert Items
            $sqlItem = "INSERT INTO budget_items (budget_id, description, quantity, unit_price, total) VALUES (?, ?, ?, ?, ?)";
            $stmtItem = $db->prepare($sqlItem);
            foreach ($items as $item) {
                $itemTotal = $item['quantity'] * $item['unit_price'];
                $stmtItem->execute([$budget_id, $item['description'], $item['quantity'], $item['unit_price'], $itemTotal]);
            }

            // 3. Update Ticket Status
            $db->prepare("UPDATE tickets SET status = 'budget_sent' WHERE id = ?")->execute([$ticket_id]);

            // 4. Notification to Client
            $stmt = $db->prepare("SELECT u.id, u.email, u.name FROM tickets t JOIN users u ON t.client_id = u.id WHERE t.id = ?");
            $stmt->execute([$ticket_id]);
            $client = $stmt->fetch();

            if ($client) {
                Mail::sendBudgetAvailable($client['email'], $client['name'], $budget_number, $budget_id);
                \App\Models\Notification::send($client['id'], 'budget_received', 'Nuevo Presupuesto', "Se ha generado el presupuesto $budget_number para tu solicitud '$title'.", '/budget/show/' . $budget_id);
            }

            $db->commit();
            Session::flash('success', 'Presupuesto generado y enviado al cliente.');
            $this->redirect('/ticket/detail/' . $ticket_id);

        } catch (\Exception $e) {
            $db->rollBack();
            die("Error generating budget: " . $e->getMessage());
        }
    }

    /**
     * View Budget (Client or Staff)
     */
    public function show($id)
    {
        $db = Database::getInstance()->getConnection();

        $sql = "SELECT b.*, t.ticket_number, t.client_id, u.name as client_name, u.email as client_email, u.company as client_company 
                FROM budgets b 
                JOIN tickets t ON b.ticket_id = t.id 
                JOIN users u ON t.client_id = u.id 
                WHERE b.id = ?";
        $stmt = $db->prepare($sql);
        $stmt->execute([$id]);
        $budget = $stmt->fetch();

        if (!$budget)
            $this->redirect('/dashboard');

        // Security: Clients can only see their own budgets
        if (Auth::isClient() && $budget['client_id'] != Auth::user()['id']) {
            Session::flash('error', 'No tienes permiso para ver este presupuesto.');
            $this->redirect('/dashboard');
        }

        $stmt = $db->prepare("SELECT * FROM budget_items WHERE budget_id = ?");
        $stmt->execute([$id]);
        $items = $stmt->fetchAll();

        // Get invoice id if exists
        $stmt = $db->prepare("SELECT id FROM invoices WHERE budget_id = ?");
        $stmt->execute([$id]);
        $invoice_id = $stmt->fetchColumn();

        $layout = Auth::role();
        $this->viewLayout($layout . '/budgets/view', $layout, [
            'title' => 'Presupuesto: ' . $budget['budget_number'],
            'budget' => $budget,
            'items' => $items,
            'invoice_id' => $invoice_id
        ]);
    }

    /**
     * Client Decision (Approve/Reject)
     */
    public function decision()
    {
        if (!Auth::isClient())
            $this->redirect('/dashboard');

        $budget_id = $_POST['budget_id'];
        $decision = $_POST['decision']; // 'approved' or 'rejected'

        $db = Database::getInstance()->getConnection();

        $status = ($decision == 'approved') ? 'approved' : 'rejected';
        $ticket_status = ($decision == 'approved') ? 'budget_approved' : 'budget_rejected';

        $db->beginTransaction();
        try {
            $stmt = $db->prepare("UPDATE budgets SET status = ?, approved_at = " . ($decision == 'approved' ? "NOW()" : "NULL") . " WHERE id = ?");
            $stmt->execute([$status, $budget_id]);

            // Get ticket_id
            $stmt = $db->prepare("SELECT ticket_id FROM budgets WHERE id = ?");
            $stmt->execute([$budget_id]);
            $ticket_id = $stmt->fetchColumn();

            $db->prepare("UPDATE tickets SET status = ? WHERE id = ?")->execute([$ticket_status, $ticket_id]);

            // AUTOMATION: If approved, generate invoice immediately
            if ($decision == 'approved') {
                $invoiceService = new \App\Services\InvoiceService();
                $result = $invoiceService->createFromBudget($budget_id, Auth::user()['id']);

                if (!$result['success']) {
                    // Log error but don't break the whole flow if invoice fails? 
                    // Actually, for consistency, we might want to know.
                    \App\Services\AuditService::log('auto_invoice_failed', ['budget_id' => $budget_id, 'error' => $result['error']], 'ERROR');
                }
            }

            // Notify Staff/Admin
            $stmt = $db->query("SELECT id FROM users WHERE role IN ('admin', 'staff')");
            $staff = $stmt->fetchAll();
            foreach ($staff as $s) {
                \App\Models\Notification::send($s['id'], 'budget_decision', 'Decisión de Presupuesto', "El cliente ha " . ($decision == 'approved' ? 'aprobado' : 'rechazado') . " el presupuesto.", '/budget/show/' . $budget_id);
            }

            $db->commit();
            $this->redirect('/budget/show/' . $budget_id);
        } catch (\Exception $e) {
            $db->rollBack();
            die("Error processing decision: " . $e->getMessage());
        }
    }
}
