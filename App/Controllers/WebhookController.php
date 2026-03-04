<?php
namespace App\Controllers;

use Core\Controller;
use Core\Database;
use App\Services\InvoiceService;
use Core\Config;
use PDO;

/**
 * Webhook Controller
 * Receives server-to-server notifications from external APIs (like MercadoPago)
 */
class WebhookController extends Controller
{
    /**
     * Disable CSRF validation for webhook endpoints
     */
    public function __construct()
    {
        // Webhooks should not check for CSRF or Auth
        // Ensure that index.php router CSRF check is bypassed for /webhook 
        // This is handled if CSRF is only checked on POST form submissions which include CSRF token,
        // but if global CSRF on POST is active, we might need to bypass it or configure index.php.
    }

    /**
     * MercadoPago Webhook Listener
     * URL: POST /webhook/mercadopago
     */
    public function mercadopago()
    {
        // MP sometimes sends GET for ping, return 200
        if ($_SERVER['REQUEST_METHOD'] === 'GET') {
            http_response_code(200);
            echo "OK";
            return;
        }

        // Leer payload
        $json = file_get_contents('php://input');
        $payload = json_decode($json, true);

        if (!$payload) {
            http_response_code(400);
            echo "Bad Request";
            return;
        }

        // Webhook Format: topic/action and id (or type and data.id in V1 webhooks)
        $topic = $_GET['topic'] ?? $payload['type'] ?? $payload['action'] ?? null;
        $id = $_GET['id'] ?? $payload['data']['id'] ?? null;

        if ($topic === 'payment' || $topic === 'payment.created' || $topic === 'payment.updated') {
            if ($id) {
                // Fetch the actual payment details from MercadoPago API securely
                $this->processMercadoPagoPayment($id);
            }
        }

        // Always reply 200 OK to acknowledge the webhook, otherwise MP keeps sending it
        http_response_code(200);
        echo "OK";
    }

    /**
     * Consult the MercadoPago API to verify payment state securely.
     */
    private function processMercadoPagoPayment($payment_id)
    {
        $accessToken = Config::get('mercadopago.access_token');
        if (!$accessToken) {
            error_log("MP_ACCESS_TOKEN not configured in environment.");
            return;
        }

        $url = "https://api.mercadopago.com/v1/payments/" . $payment_id;

        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Authorization: Bearer " . $accessToken,
            "Content-Type: application/json"
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode === 200 && $response) {
            $data = json_decode($response, true);

            // Check if securely approved
            if (isset($data['status']) && $data['status'] === 'approved') {
                $externalReference = $data['external_reference'] ?? null;
                $amount = $data['transaction_amount'] ?? 0;

                if ($externalReference) {
                    // external_reference should contain the invoice_id format "INV-{id}" or just the ID
                    $invoice_id = (int) str_replace(['INV-'], '', $externalReference);

                    $db = Database::getInstance()->getConnection();

                    // Verify if it's already processed to prevent duplicates
                    $stmt = $db->prepare("SELECT id FROM payment_receipts WHERE mp_payment_id = ?");
                    $stmt->execute([$payment_id]);
                    if ($stmt->fetch()) {
                        return; // Already processed
                    }

                    $invoiceIdCheck = $db->prepare("SELECT client_id, total, status FROM invoices WHERE id = ?");
                    $invoiceIdCheck->execute([$invoice_id]);
                    $invoice = $invoiceIdCheck->fetch();

                    if ($invoice && in_array($invoice['status'], ['unpaid', 'pending', 'partial'])) {

                        $db->beginTransaction();

                        try {
                            // Insert auto-receipt
                            $insertReceipt = $db->prepare("INSERT INTO payment_receipts (invoice_id, amount, status, mp_payment_id, verified_by, uploaded_by) VALUES (?, ?, 'verified', ?, 1, ?)");
                            // Since it's automated, we assign uploaded_by = client_id and verified_by = 1 (System/Admin) 
                            $insertReceipt->execute([
                                $invoice_id,
                                $amount,
                                $payment_id,
                                $invoice['client_id']
                            ]);

                            // Delegate to InvoiceService to confirm and activate service
                            $invoiceService = new InvoiceService();

                            // commit here because confirmPayment might start its own transaction depending on its implementation.
                            // Actually confirmPayment checks if it's in a transaction and respects it.
                            $result = $invoiceService->confirmPayment($invoice_id, 1);

                            if ($result['success']) {
                                $db->commit();
                                \Core\SecurityLogger::log('mp_payment_webhook', "Pago autogestionado acreditado vía MP ID: $payment_id para Invoice: {$invoice_id}");
                            } else {
                                $db->rollBack();
                                error_log("Failed to confirm webhook payment: " . $result['error']);
                            }
                        } catch (\Exception $e) {
                            $db->rollBack();
                            error_log("Exception processing webhook: " . $e->getMessage());
                        }
                    }
                }
            }
        }
    }
}
