<?php
namespace App\Controllers;

use Core\Controller;
use Core\SecurityLogger;
use App\Services\InvoiceService;

/**
 * WebhookController - Entry point for external notifications (mercadopago, stripe, etc.)
 */
class WebhookController extends Controller
{

    /**
     * Handle MercadoPago payment notifications
     */
    public function mercadopago()
    {
        // MercadoPago sends JSON data for events
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        if (!$data) {
            http_response_code(400);
            return;
        }

        // 1. Log the incoming notification for audit trail
        SecurityLogger::log('webhook_mercadopago_received', [
            'type' => $data['type'] ?? 'unknown',
            'action' => $data['action'] ?? 'unknown',
            'resource_id' => $data['data']['id'] ?? 'unknown'
        ]);

        // 2. Process only payment events
        if (isset($data['type']) && $data['type'] === 'payment') {
            $paymentId = $data['data']['id'] ?? null;

            // Note: Here you should call MercadoPago API to verify payment status
            // using the Payment ID and your Access Token.
            // Example status check:
            // $paymentInfo = $this->mpService->getPayment($paymentId);
            // if ($paymentInfo['status'] === 'approved') { ... }

            SecurityLogger::log('webhook_payment_processing', ['id' => $paymentId]);
        }

        // Response 200/201 is required by MP to acknowledge receipt
        http_response_code(200);
        echo json_encode(['status' => 'received']);
    }

    /**
     * Test / Debug endpoint
     */
    public function test()
    {
        echo "Webhook endpoint active and CSRF-exempt.";
    }
}
