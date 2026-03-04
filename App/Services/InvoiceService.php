<?php
namespace App\Services;

use App\Domain\Invoice\InvoiceStatus;
use App\Policies\InvoicePolicy;
use App\Services\AuditService;
use App\Models\Notification;
use Core\Database;
use Exception;

/**
 * Invoice Service
 */
class InvoiceService
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Crea una factura a partir de un presupuesto aprobado.
     */
    public function createFromBudget(int $budget_id, int $created_by): array
    {
        // Obtener presupuesto
        $stmt = $this->db->prepare("SELECT * FROM budgets WHERE id = ? AND status = 'approved'");
        $stmt->execute([$budget_id]);
        $budget = $stmt->fetch();

        if (!$budget) {
            return ['success' => false, 'error' => 'Presupuesto no encontrado o no aprobado'];
        }

        // Verificar si ya existe factura
        $stmt = $this->db->prepare("SELECT id FROM invoices WHERE budget_id = ?");
        $stmt->execute([$budget_id]);
        if ($stmt->fetch()) {
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
            $stmtTicket = $this->db->prepare("SELECT client_id FROM tickets WHERE id = ?");
            $stmtTicket->execute([$budget['ticket_id']]);
            $client_id = $stmtTicket->fetchColumn();

            $sql = "INSERT INTO invoices (invoice_number, client_id, budget_id, issue_date, due_date, subtotal, tax_amount, total, status, created_by) 
                    VALUES (?, ?, ?, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), ?, ?, ?, 'unpaid', ?)";
            $stmt = $this->db->prepare($sql);

            $stmt->execute([
                $invoice_number,
                $client_id,
                $budget_id,
                $budget['subtotal'],
                $budget['tax_amount'],
                $budget['total'],
                $created_by
            ]);
            $invoice_id = $this->db->lastInsertId();

            // Actualizar estado del ticket a 'invoiced'
            $this->db->prepare("UPDATE tickets SET status = 'invoiced', updated_at = NOW() WHERE id = ?")->execute([$budget['ticket_id']]);

            AuditService::log('invoice_generated', [
                'invoice_id' => $invoice_id,
                'budget_id' => $budget_id
            ], 'INFO');

            // Notificar al Cliente
            Notification::send($client_id, 'invoice_generated', 'Factura Generada', "Se ha generado automáticamente la factura $invoice_number para tu servicio.", "/invoice/show/" . $invoice_id);

            // Dispatch Event (Evolution 2.0)
            \Core\EventDispatcher::dispatch(new \App\Events\InvoiceIssued([
                'invoice_id' => $invoice_id,
                'client_id' => $client_id,
                'amount' => $budget['total']
            ]));

            if ($ownsTransaction) {
                $this->db->commit();
            }
            return ['success' => true, 'invoice_id' => $invoice_id];

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
            $stmtMonto = $this->db->prepare("SELECT SUM(amount) FROM payment_receipts WHERE invoice_id = ? AND status = 'pending'");
            $stmtMonto->execute([$invoice_id]);
            $amount_paid_now = (float) $stmtMonto->fetchColumn();

            $new_paid_amount = $invoice['paid_amount'] + $amount_paid_now;

            // Check if fully paid
            $is_fully_paid = $new_paid_amount >= $invoice['total'];
            $new_status = $is_fully_paid ? 'paid' : 'partial';
            $paid_at_sql = $is_fully_paid ? 'NOW()' : 'NULL';

            // 1. Actualizar estado y pago de la factura
            $this->db->prepare("UPDATE invoices SET status = ?, paid_amount = ?, paid_at = $paid_at_sql WHERE id = ?")
                ->execute([$new_status, $new_paid_amount, $invoice_id]);

            // 2. Actualizar estado del comprobante
            $this->db->prepare("UPDATE payment_receipts SET status = 'verified', verified_by = ?, verified_at = NOW() WHERE invoice_id = ? AND status = 'pending'")
                ->execute([$verified_by, $invoice_id]);

            // 3. Obtener detalles de la factura para crear/verificar Servicio Activo
            $stmt = $this->db->prepare("SELECT i.*, b.ticket_id, b.title as budget_title FROM invoices i JOIN budgets b ON i.budget_id = b.id WHERE i.id = ?");
            $stmt->execute([$invoice_id]);
            $inv = $stmt->fetch();

            $stmtTicket = $this->db->prepare("SELECT service_plan_id FROM tickets WHERE id = ?");
            $stmtTicket->execute([$inv['ticket_id']]);
            $plan_id = $stmtTicket->fetchColumn();

            // 4. Verificar si ya existe un Servicio Activo para esta factura (evitar duplicados)
            $stmtCheck = $this->db->prepare("SELECT id FROM active_services WHERE invoice_id = ? LIMIT 1");
            $stmtCheck->execute([$invoice_id]);
            $existingService = $stmtCheck->fetchColumn();

            if (!$existingService) {
                // 5. Crear Servicio Activo (primer pago: parcial o total)
                $sql = "INSERT INTO active_services (client_id, ticket_id, invoice_id, service_plan_id, name, start_date, activated_by, status) 
                        VALUES (?, ?, ?, ?, ?, CURDATE(), ?, 'active')";
                $this->db->prepare($sql)->execute([
                    $inv['client_id'],
                    $inv['ticket_id'],
                    $invoice_id,
                    $plan_id,
                    $inv['budget_title'],
                    $verified_by
                ]);

                // 6. Cerrar el Ticket de Pre-Venta al activar el servicio
                $this->db->prepare("UPDATE tickets SET status = 'closed', updated_at = NOW() WHERE id = ?")
                    ->execute([$inv['ticket_id']]);

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
                AuditService::log('invoice_paid', ['invoice_id' => $invoice_id], 'INFO');
            } else {
                AuditService::log('invoice_partial_payment', ['invoice_id' => $invoice_id, 'amount' => $amount_paid_now], 'INFO');
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

    /**
     * Registra un pago y actualiza el estado de la factura (Simplificado).
     */
    public function markAsPaid(int $invoiceId, array $currentUser): array
    {
        $invoice = $this->findInvoiceById($invoiceId);
        if (!$invoice)
            return ['success' => false, 'error' => 'Factura no encontrada'];

        // 1. Autorización
        if (!InvoicePolicy::canVerifyPayment($currentUser, $invoice)) {
            AuditService::log('unauthorized_payment_verification_attempt', ['invoice_id' => $invoiceId], 'WARN');
            return ['success' => false, 'error' => 'No autorizado'];
        }

        // 2. Transición
        $status = InvoiceStatus::fromString($invoice['status']);
        $newStatus = InvoiceStatus::paid();

        if (!$status->canTransitionTo($newStatus)) {
            return ['success' => false, 'error' => 'No se puede marcar como pagada desde el estado actual'];
        }

        return $this->confirmPayment($invoiceId, $currentUser['id']);
    }

    private function findInvoiceById(int $id): ?array
    {
        $stmt = $this->db->prepare("SELECT * FROM invoices WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->fetch() ?: null;
    }
}
