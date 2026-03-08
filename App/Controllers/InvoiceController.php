<?php
namespace App\Controllers;

use Core\Controller;
use Core\Database;
use Core\Auth;
use Core\Session;
use PDO;

class InvoiceController extends Controller
{
    public function __construct()
    {
        if (!Auth::check())
            $this->redirect('/auth/login');
    }

    /**
     * List Invoices (Client sees own)
     */
    public function index()
    {
        $db = Database::getInstance()->getConnection();
        $user = Auth::user();

        if (Auth::isClient()) {
            $stmt = $db->prepare("SELECT i.*, b.budget_number 
                                 FROM invoices i 
                                 LEFT JOIN budgets b ON i.budget_id = b.id 
                                 WHERE i.client_id = ? 
                                 ORDER BY i.created_at DESC");
            $stmt->execute([$user['id']]);
        } else {
            // Admin/Staff sees all
            $stmt = $db->query("SELECT i.*, u.name as client_name, b.budget_number 
                               FROM invoices i 
                               JOIN users u ON i.client_id = u.id 
                               LEFT JOIN budgets b ON i.budget_id = b.id 
                               ORDER BY i.created_at DESC");
        }

        $invoices = $stmt->fetchAll();

        $view = Auth::isClient() ? 'client/invoices/index' : 'admin/invoices/index';
        $this->viewLayout($view, Auth::role(), [
            'title' => 'Mis Facturas | Data Wyrd',
            'invoices' => $invoices
        ]);
    }

    /**
     * Create Invoice from Budget
     */
    public function createFromBudget($budget_id)
    {
        if (Auth::isClient())
            $this->redirect('/dashboard');

        $invoiceService = new \App\Services\InvoiceService();
        $result = $invoiceService->createFromBudget($budget_id, Auth::user()['id']);

        if ($result['success']) {
            Session::flash('success', 'Factura generada con éxito.');
            $this->redirect('/invoice/show/' . $result['invoice_id']);
        } else {
            Session::flash('error', $result['error']);
            $this->redirect('/budget/show/' . $budget_id);
        }
    }

    /**
     * View Invoice
     */
    public function show($id)
    {
        $db = Database::getInstance()->getConnection();

        $sql = "SELECT i.*, u.name as client_name, u.email as client_email, u.company as client_company, u.phone as client_phone, b.budget_number 
                FROM invoices i 
                JOIN users u ON i.client_id = u.id 
                LEFT JOIN budgets b ON i.budget_id = b.id 
                WHERE i.id = ?";
        $stmt = $db->prepare($sql);
        $stmt->execute([$id]);
        $invoice = $stmt->fetch();

        if (!$invoice)
            $this->redirect('/dashboard');

        // Get payment receipt if exists
        $stmt = $db->prepare("SELECT * FROM payment_receipts WHERE invoice_id = ? ORDER BY created_at DESC LIMIT 1");
        $stmt->execute([$id]);
        $receipt = $stmt->fetch();

        $layout = Auth::role();
        $this->viewLayout($layout . '/invoices/view', $layout, [
            'title' => 'Factura: ' . $invoice['invoice_number'],
            'invoice' => $invoice,
            'receipt' => $receipt
        ]);
    }

    /**
     * Upload Payment Receipt (Client)
     */
    public function pay()
    {
        if (!Auth::isClient())
            $this->redirect('/dashboard');

        $invoice_id = $_POST['invoice_id'];
        $db = Database::getInstance()->getConnection();

        // Hardened file upload logic
        if (isset($_FILES['receipt']) && $_FILES['receipt']['error'] == 0) {
            $errors = \Core\Validator::validateFile($_FILES['receipt'], 5 * 1024 * 1024, ['jpg', 'jpeg', 'png', 'pdf']);

            if (!empty($errors)) {
                Session::flash('error', implode(' ', $errors));
                $this->redirect('/invoice/show/' . $invoice_id);
            }

            $upload_dir = 'public/uploads/receipts/';
            if (!is_dir($upload_dir))
                mkdir($upload_dir, 0777, true);

            $filename = \Core\Validator::generateSecureFileName($_FILES['receipt']['name']);
            $filepath = 'uploads/receipts/' . $filename;
            move_uploaded_file($_FILES['receipt']['tmp_name'], $upload_dir . $filename);

            $db->beginTransaction();
            try {
                // 1. Insert into payment_receipts
                $sql = "INSERT INTO payment_receipts (invoice_id, uploaded_by, filename, filepath, amount, payment_date, status) 
                        VALUES (?, ?, ?, ?, ?, CURDATE(), 'pending')";
                $stmt = $db->prepare($sql);

                // Get amount from invoice and input
                $stmtAmt = $db->prepare("SELECT total, paid_amount FROM invoices WHERE id = ?");
                $stmtAmt->execute([$invoice_id]);
                $invoiceData = $stmtAmt->fetch();

                $pending = $invoiceData['total'] - $invoiceData['paid_amount'];
                $amt = isset($_POST['amount']) ? floatval($_POST['amount']) : $pending;
                if ($amt <= 0 || $amt > $pending) {
                    $amt = $pending; // fallback
                }

                $stmt->execute([$invoice_id, Auth::user()['id'], $filename, $filepath, $amt]);

                $db->prepare("UPDATE invoices SET status = 'processing' WHERE id = ?")->execute([$invoice_id]);

                \Core\SecurityLogger::log('payment_receipt_uploaded', [
                    'invoice_id' => $invoice_id,
                    'filename' => $filename
                ]);

                // Notify Staff/Admin
                $staffStmt = $db->query("SELECT id FROM users WHERE role IN ('admin', 'staff')");
                $staff = $staffStmt->fetchAll();
                foreach ($staff as $s) {
                    \App\Models\Notification::send($s['id'], 'payment_upload', 'Comprobante de Pago', "Un cliente ha subido un comprobante para la factura #" . $invoice_id, '/invoice/show/' . $invoice_id);
                }

                $db->commit();
                Session::flash('success', 'Comprobante enviado. El staff verificará tu pago en breve.');
            } catch (\Exception $e) {
                $db->rollBack();
                Session::flash('error', 'Error al registrar el pago: ' . $e->getMessage());
            }
        }

        $this->redirect('/invoice/show/' . $invoice_id);
    }

    /**
     * Confirm Payment & Activate Service (Staff/Admin)
     */
    public function confirm($id)
    {
        if (Auth::isClient())
            $this->redirect('/dashboard');

        $invoiceService = new \App\Services\InvoiceService();
        $result = $invoiceService->confirmPayment($id, Auth::user()['id']);

        if ($result['success']) {
            Session::flash('success', 'Pago verificado. El servicio ha sido activado.');
        } else {
            Session::flash('error', 'Error al confirmar pago: ' . $result['error']);
        }

        $this->redirect('/invoice/show/' . $id);
    }
    /**
     * Iniciar Checkout con MercadoPago
     */
    public function payMp()
    {
        if (!Auth::isClient()) {
            $this->redirect('/dashboard');
        }

        $invoice_id = $_POST['invoice_id'] ?? null;
        $amount = isset($_POST['amount']) ? floatval($_POST['amount']) : 0;

        if (!$invoice_id || $amount <= 0) {
            Session::flash('error', 'Datos de pago inválidos.');
            $this->redirect('/invoice');
        }

        $db = Database::getInstance()->getConnection();

        // Ensure invoice belongs to user
        $stmt = $db->prepare("SELECT * FROM invoices WHERE id = ? AND client_id = ?");
        $stmt->execute([$invoice_id, Auth::user()['id']]);
        $invoice = $stmt->fetch();

        if (!$invoice) {
            Session::flash('error', 'Factura no encontrada.');
            $this->redirect('/invoice');
        }

        $pending = $invoice['total'] - $invoice['paid_amount'];
        if ($amount > $pending) {
            Session::flash('error', 'El monto supera el total adeudado.');
            $this->redirect('/invoice/show/' . $invoice_id);
        }

        $mpToken = trim(\Core\Config::get('payment.mp_access_token'));
        if (empty($mpToken)) {
            Session::flash('error', 'MercadoPago no configurado.');
            $this->redirect('/invoice/show/' . $invoice_id);
        }

        // Send cURL request to MP to create preference
        $preferenceData = [
            'items' => [
                [
                    'title' => 'Pago Factura #' . $invoice['invoice_number'],
                    'quantity' => 1,
                    'unit_price' => (float) $amount,
                    'currency_id' => \Core\Config::get('payment.mp_currency_id') ?: 'ARS'
                ]
            ],
            'external_reference' => (string) $invoice_id,
            'back_urls' => [
                'success' => rtrim(\Core\Config::get('app_url') ?? 'http://localhost/datawyrd', '/') . '/invoice/show/' . $invoice_id,
                'failure' => rtrim(\Core\Config::get('app_url') ?? 'http://localhost/datawyrd', '/') . '/invoice/show/' . $invoice_id,
                'pending' => rtrim(\Core\Config::get('app_url') ?? 'http://localhost/datawyrd', '/') . '/invoice/show/' . $invoice_id,
            ],
            'auto_return' => 'approved',
            'notification_url' => rtrim(\Core\Config::get('app_url') ?? 'http://localhost/datawyrd', '/') . '/webhook/mercadopago'
        ];

        $ch = curl_init('https://api.mercadopago.com/checkout/preferences');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: Bearer ' . $mpToken,
            'Content-Type: application/json'
        ]);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($preferenceData));
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        $result = json_decode($response, true);

        if ($httpCode >= 200 && $httpCode < 300 && isset($result['init_point'])) {
            header('Location: ' . $result['init_point']);
            exit;
        } else {
            \Core\SecurityLogger::log('mp_preference_error', ['response' => $result]);
            Session::flash('error', 'Error al crear solicitud en MercadoPago.');
            $this->redirect('/invoice/show/' . $invoice_id);
        }
    }
}
