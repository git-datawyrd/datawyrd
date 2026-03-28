<?php
namespace App\Controllers;

use Core\Controller;
use Core\Auth;
use Core\Session;
use App\Services\InvoiceService;

class InvoiceController extends Controller
{
    private InvoiceService $invoiceService;

    public function __construct(InvoiceService $invoiceService)
    {
        if (!Auth::check())
            $this->redirect('/auth/login');
        
        $this->invoiceService = $invoiceService;
    }

    /**
     * List Invoices (Client sees own, Admin sees all)
     */
    public function index()
    {
        $invoices = $this->invoiceService->getInvoices(Auth::user());
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

        $result = $this->invoiceService->createFromBudget((int)$budget_id, Auth::user()['id']);

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
        $data = $this->invoiceService->getInvoiceDetails((int)$id);
        if (!$data)
            $this->redirect('/dashboard');

        $layout = Auth::role();
        $this->viewLayout($layout . '/invoices/view', $layout, [
            'title' => 'Factura: ' . $data['invoice']['invoice_number'],
            'invoice' => $data['invoice'],
            'receipt' => $data['receipt']
        ]);
    }

    /**
     * Upload Payment Receipt (Client)
     */
    public function pay()
    {
        if (!Auth::isClient())
            $this->redirect('/dashboard');

        $invoice_id = (int)$_POST['invoice_id'];
        $amount = isset($_POST['amount']) ? floatval($_POST['amount']) : 0;

        try {
            if (isset($_FILES['receipt']) && $_FILES['receipt']['error'] == 0) {
                $this->invoiceService->handlePaymentReceipt($invoice_id, $_FILES['receipt'], $amount, Auth::user()['id']);
                Session::flash('success', 'Comprobante enviado. El staff verificará tu pago en breve.');
            }
        } catch (\Exception $e) {
            Session::flash('error', $e->getMessage());
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

        $result = $this->invoiceService->confirmPayment((int)$id, Auth::user()['id']);

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

        $invoice_id = (int)($_POST['invoice_id'] ?? 0);
        $amount = isset($_POST['amount']) ? floatval($_POST['amount']) : 0;

        try {
            $url = $this->invoiceService->createMpPreference($invoice_id, $amount, Auth::user());
            header('Location: ' . $url);
            exit;
        } catch (\Exception $e) {
            Session::flash('error', $e->getMessage());
            $this->redirect('/invoice/show/' . $invoice_id);
        }
    }
}
