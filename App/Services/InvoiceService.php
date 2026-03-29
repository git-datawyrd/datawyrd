<?php
namespace App\Services;

use App\Domain\Invoice\InvoiceStatus;
use App\Policies\InvoicePolicy;
use App\Services\AuditService;
use App\Services\FinOpsService;
use App\Models\Notification;
use Core\Database;
use Exception;

/**
 * Invoice Service
 */
class InvoiceService
{
    private $db;
    private $invoiceRepo;
    public function __construct(\App\Repositories\InvoiceRepository $invoiceRepo = null)
    {
        $this->db = Database::getInstance()->getConnection();
        $this->invoiceRepo = $invoiceRepo ?? new \App\Repositories\InvoiceRepository($this->db);
    }

    /**
     * Crea una factura a partir de un presupuesto aprobado.
     */
    public function createFromBudget(int $budget_id, int $created_by): array
    {
        // Obtener presupuesto
        $budget = $this->invoiceRepo->getApprovedBudget($budget_id);

        if (!$budget) {
            return ['success' => false, 'error' => 'Presupuesto no encontrado o no aprobado'];
        }

        // Verificar si ya existe factura
        if ($this->invoiceRepo->hasInvoiceForBudget($budget_id)) {
            return ['success' => false, 'error' => 'Ya existe una factura para este presupuesto.'];
        }

        $ownsTransaction = false;
        if (!$this->db->inTransaction()) {
            $this->db->beginTransaction();
            $ownsTransaction = true;
        }

        try {

            $invoice_number = 'DW-INV-' . date('Ymd') . '-' . strtoupper(bin2hex(random_bytes(2)));

            // Obtener client_id del ticket
            $client_id = $this->invoiceRepo->getClientIdByTicket($budget['ticket_id']);

            $invoiceId = $this->invoiceRepo->createInvoice([
                'invoice_number' => $invoice_number,
                'client_id' => $client_id,
                'budget_id' => $budget_id,
                'service_reference' => $budget['service_reference'],
                'subtotal' => $budget['subtotal'],
                'tax_amount' => $budget['tax_amount'],
                'total' => $budget['total'],
                'created_by' => $created_by
            ]);

            // 🚀 Event Sourcing (E11-012)
            $finOps = new FinOpsService();
            $finOps->recordEvent($invoiceId, 'CREATE', $budget['total'], [
                'budget_id' => $budget_id,
                'subtotal' => $budget['subtotal'],
                'tax_amount' => $budget['tax_amount']
            ], $created_by);

            // Actualizar estado del ticket a 'invoiced'
            $this->invoiceRepo->updateTicketStatus($budget['ticket_id'], 'invoiced');

            \Core\SecurityLogger::log('INVOICE_GENERATED', [
                'invoice_id' => $invoiceId,
                'invoice_number' => $invoice_number,
                'total' => $budget['total'],
                'client_id' => $client_id
            ], 'WARN');

            // Notificar al Cliente
            Notification::send($client_id, 'invoice_generated', 'Factura Generada', "Se ha generado automáticamente la factura $invoice_number para tu servicio.", "/invoice/show/" . $invoiceId);

            // Dispatch Event (Evolution 2.0)
            \Core\EventDispatcher::dispatch(new \App\Events\InvoiceIssued([
                'invoice_id' => $invoiceId,
                'client_id' => $client_id,
                'amount' => $budget['total']
            ]));

            if ($ownsTransaction) {
                $this->db->commit();
            }
            return ['success' => true, 'invoice_id' => $invoiceId];

        } catch (Exception $e) {
            if ($ownsTransaction) {
                $this->db->rollBack();
            }
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Confirma el pago de una factura y activa el servicio.
     */
    public function confirmPayment(int $invoice_id, int $verified_by): array
    {
        $invoice = $this->findInvoiceById($invoice_id);
        if (!$invoice) {
            return ['success' => false, 'error' => 'Factura no encontrada'];
        }

        $ownsTransaction = false;
        if (!$this->db->inTransaction()) {
            $this->db->beginTransaction();
            $ownsTransaction = true;
        }

        try {
            // Get total pending amounts in receipts
            $amount_paid_now = $this->invoiceRepo->getPendingPaymentReceiptsSum($invoice_id);

            // 🚀 Event Sourcing (E11-013)
            $finOps = new FinOpsService();
            $finOps->recordEvent($invoice_id, 'APPLY_PAYMENT', $amount_paid_now, [
                'batch_confirmation' => true,
                'verified_by' => $verified_by
            ], $verified_by);

            // Proyectar el estado actualizado basado en eventos
            $finOps->syncInvoiceProjection($invoice_id);
            $balance = $finOps->calculateBalance($invoice_id);

            $is_fully_paid = $balance['is_fully_paid'];
            $new_status = $balance['is_void'] ? 'void' : ($is_fully_paid ? 'paid' : 'partial');

            // 2. Actualizar estado del comprobante
            $this->invoiceRepo->verifyPendingReceipts($invoice_id, $verified_by);

            // 3. Obtener detalles de la factura para crear/verificar Servicio Activo
            $inv = $this->invoiceRepo->getInvoiceWithBudgetDetails($invoice_id);
            $plan_id = $this->invoiceRepo->getServicePlanIdByTicket($inv['ticket_id']);

            // 4. Verificar si ya existe un Servicio Activo para esta factura (evitar duplicados)
            $existingService = $this->invoiceRepo->hasActiveServiceForInvoice($invoice_id);

            if (!$existingService) {
                // 5. Crear Servicio Activo (primer pago: parcial o total)
                $this->invoiceRepo->createActiveService([
                    'client_id' => $inv['client_id'],
                    'ticket_id' => $inv['ticket_id'],
                    'invoice_id' => $invoice_id,
                    'service_plan_id' => $plan_id,
                    'name' => $inv['budget_title'],
                    'activated_by' => $verified_by
                ]);

                // 6. Cerrar el Ticket de Pre-Venta al activar el servicio
                $this->invoiceRepo->updateTicketStatus($inv['ticket_id'], 'closed');

                AuditService::log('service_activated', [
                    'invoice_id' => $invoice_id,
                    'client_id' => $inv['client_id'],
                    'partial_pay' => !$is_fully_paid
                ], 'INFO');

                // Notificar al Cliente: mensaje adaptado según tipo de pago
                $payMsg = $is_fully_paid
                    ? "¡Tu servicio '{$inv['budget_title']}' ha sido activado con pago completo!"
                    : "¡Tu servicio '{$inv['budget_title']}' ha sido activado con un pago inicial. Tu Workspace ya está disponible.";
                Notification::send($inv['client_id'], 'service_activated', 'Servicio Activado', $payMsg, "/project/workspace");

                // Dispatch Event (Evolution 2.0)
                \Core\EventDispatcher::dispatch(new \App\Events\ProjectStarted([
                    'invoice_id' => $invoice_id,
                    'client_id' => $inv['client_id'],
                    'plan_id' => $plan_id
                ]));
            } else {
                // El servicio ya existe (pago parcial posterior): solo notificar el abono recibido
                Notification::send(
                    $inv['client_id'],
                    'payment_verified',
                    'Pago Recibido',
                    "Hemos verificado un pago por $" . number_format($amount_paid_now, 2) . " para la factura #" . $invoice['invoice_number'] . ".",
                    "/invoice/show/" . $invoice_id
                );
            }

            if ($is_fully_paid) {
                \Core\SecurityLogger::log('INVOICE_PAID_FULL', [
                    'invoice_id' => $invoice_id,
                    'amount' => $amount_paid_now
                ], 'WARN');
            } else {
                \Core\SecurityLogger::log('INVOICE_PARTIAL_PAYMENT', [
                    'invoice_id' => $invoice_id,
                    'amount' => $amount_paid_now,
                    'verified_by' => $verified_by
                ], 'WARN');
            }

            if ($ownsTransaction) {
                $this->db->commit();
            }
            return ['success' => true];

        } catch (Exception $e) {
            if ($ownsTransaction) {
                $this->db->rollBack();
            }
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    public function getInvoices(array $user)
    {
        $clientId = \Core\Auth::isClient() ? $user['id'] : null;
        return $this->invoiceRepo->getInvoices($clientId);
    }

    public function getInvoiceDetails(int $id)
    {
        $invoice = $this->invoiceRepo->getInvoiceWithFullDetails($id);
        if (!$invoice) return null;

        $receipt = $this->invoiceRepo->getLatestReceipt($id);

        return [
            'invoice' => $invoice,
            'receipt' => $receipt
        ];
    }

    public function handlePaymentReceipt(int $invoiceId, array $file, float $userAmount, int $userId)
    {
        $invoice = $this->invoiceRepo->findInvoiceById($invoiceId);
        if (!$invoice) throw new Exception('Factura no encontrada.');

        $errors = \Core\Validator::validateFile($file, 5 * 1024 * 1024, ['jpg', 'jpeg', 'png', 'pdf']);
        if (!empty($errors)) throw new Exception(implode(' ', $errors));

        $upload_dir = BASE_PATH . '/public/uploads/receipts/';
        if (!is_dir($upload_dir)) mkdir($upload_dir, 0755, true);

        $filename = \Core\Validator::generateSecureFileName($file['name']);
        $filepath = 'uploads/receipts/' . $filename;
        
        if (!move_uploaded_file($file['tmp_name'], $upload_dir . $filename)) {
            throw new Exception('Error al mover el archivo al servidor.');
        }

        $pending = $invoice['total'] - $invoice['paid_amount'];
        $amt = ($userAmount <= 0 || $userAmount > $pending) ? $pending : $userAmount;

        $this->db->beginTransaction();
        try {
            $this->invoiceRepo->createPaymentReceipt([
                'invoice_id' => $invoiceId,
                'uploaded_by' => $userId,
                'filename' => $filename,
                'filepath' => $filepath,
                'amount' => $amt
            ]);

            $this->invoiceRepo->updateInvoiceStatus($invoiceId, 'processing');
            
            \Core\SecurityLogger::log('payment_receipt_uploaded', [
                'invoice_id' => $invoiceId,
                'filename' => $filename
            ]);

            // Notify Staff/Admin (Phase 11.5.0 Refactor)
            $staff = $this->db->query("SELECT id FROM users WHERE role IN ('admin', 'staff')")->fetchAll();
            foreach ($staff as $s) {
                Notification::send($s['id'], 'payment_upload', 'Comprobante de Pago', 
                    "Un cliente ha subido un comprobante para la factura #$invoiceId", 
                    '/invoice/show/' . $invoiceId);
            }

            $this->db->commit();
            return true;

        } catch (Exception $e) {
            $this->db->rollBack();
            throw $e;
        }
    }

    public function createMpPreference(int $invoiceId, float $amount, array $user)
    {
        $invoice = $this->invoiceRepo->findInvoiceById($invoiceId);
        if (!$invoice || $invoice['client_id'] != $user['id']) {
            throw new Exception('Factura no válida.');
        }

        $pending = $invoice['total'] - $invoice['paid_amount'];
        if ($amount <= 0 || $amount > $pending) throw new Exception('Monto de pago inválido.');

        $mpToken = trim(\Core\Config::get('payment.mp_access_token'));
        if (empty($mpToken)) throw new Exception('Pasarela de pago no configurada.');

        $appUrl = rtrim(\Core\Config::get('app.url') ?? 'http://localhost/datawyrd', '/');
        
        // Multi-currency logic
        $invoiceCurrency = $invoice['currency'] ?? 'USD';
        $mpCurrency = \Core\Config::get('payment.mp_currency_id') ?: 'ARS';
        $amountToPayMP = $amount;
        $exchangeRate = 1;

        if ($invoiceCurrency !== $mpCurrency) {
            $exchangeRate = (float) \Core\Config::get('payment.exchange_rate') ?: 1;
            $amountToPayMP = round($amount * $exchangeRate, 2);
        }

        $preferenceData = [
            'items' => [[
                'title' => 'Pago Factura #' . $invoice['invoice_number'],
                'quantity' => 1,
                'unit_price' => (float) $amountToPayMP,
                'currency_id' => $mpCurrency
            ]],
            'external_reference' => (string) $invoiceId,
            'back_urls' => [
                'success' => $appUrl . '/invoice/show/' . $invoiceId,
                'failure' => $appUrl . '/invoice/show/' . $invoiceId,
                'pending' => $appUrl . '/invoice/show/' . $invoiceId,
            ],
            'auto_return' => 'approved',
            'notification_url' => $appUrl . '/webhook/mercadopago',
            'metadata' => [
                'invoice_id' => $invoiceId,
                'original_amount' => $amount,
                'exchange_rate' => $exchangeRate
            ]
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
            return $result['init_point'];
        }

        throw new Exception('Error al conectar con MercadoPago.');
    }

    private function findInvoiceById(int $id): ?array
    {
        return $this->invoiceRepo->findInvoiceById($id);
    }
}

