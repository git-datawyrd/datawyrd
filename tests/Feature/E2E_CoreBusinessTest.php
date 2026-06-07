<?php
namespace Tests\Feature;

use PHPUnit\Framework\TestCase;
use Core\Database;
use App\Models\User;

class E2E_CoreBusinessTest extends TestCase
{
    private $db;
    private $testEmail = 'e2e_test_client@datawyrd.com';

    protected function setUp(): void
    {
        // Require bootstrap to initialize app core
        require_once __DIR__ . '/../../Core/bootstrap.php';
        $this->db = Database::getInstance()->getConnection();
        
        // Clean up previous runs
        $this->db->exec("DELETE FROM tickets WHERE client_id IN (SELECT id FROM users WHERE email = '{$this->testEmail}')");
        $this->db->exec("DELETE FROM users WHERE email = '{$this->testEmail}'");
    }

    public function testCoreBusinessFlow()
    {
        // 1. Create User (Lead -> Client)
        $userModel = new \App\Models\User();
        $userId = $userModel->create([
            'name' => 'Test E2E Client',
            'email' => $this->testEmail,
            'password' => password_hash('Secret123!', PASSWORD_ARGON2ID),
            'role' => 'client',
            'phone' => '123456789',
            'company' => 'E2E Corp'
        ]);

        $this->assertNotEmpty($userId, "User creation failed");

        // 2. Create Ticket
        $ticketRepo = new \App\Repositories\TicketRepository($this->db);
        $ticketId = $ticketRepo->create([
            'client_id' => $userId,
            'subject' => 'E2E Validation Service',
            'description' => 'We need an automated data pipeline.',
            'priority' => 'high',
            'service_plan_id' => 1 // Assuming 1 exists
        ]);

        $this->assertNotEmpty($ticketId, "Ticket creation failed");
        
        // Ensure ticket exists
        $ticket = $ticketRepo->find($ticketId);
        $this->assertEquals('open', $ticket['status']);

        // 3. Create Budget
        $budgetRepo = new \App\Repositories\BudgetRepository($this->db);
        $budgetId = $budgetRepo->create([
            'ticket_id' => $ticketId,
            'title' => 'E2E Pipeline Budget',
            'subtotal' => 1000,
            'tax_amount' => 210,
            'total' => 1210,
            'status' => 'approved', // Skip pending for E2E
            'created_by' => 1 // Admin
        ]);

        $this->assertNotEmpty($budgetId, "Budget creation failed");

        // Update ticket to budget_approved
        $ticketRepo->updateStatus($ticketId, 'budget_approved');
        $updatedTicket = $ticketRepo->find($ticketId);
        $this->assertEquals('budget_approved', $updatedTicket['status']);

        // 4. Create Invoice
        $invoiceRepo = new \App\Repositories\InvoiceRepository($this->db);
        $invoiceId = $invoiceRepo->create([
            'budget_id' => $budgetId,
            'client_id' => $userId,
            'subtotal' => 1000,
            'tax_amount' => 210,
            'total' => 1210,
            'status' => 'pending'
        ]);

        $this->assertNotEmpty($invoiceId, "Invoice creation failed");

        // 5. Create Payment Receipt
        $receiptId = $invoiceRepo->uploadPaymentReceipt($invoiceId, $userId, 'fake_receipt.pdf', 'fake/path.pdf');
        $this->assertNotEmpty($receiptId, "Receipt upload failed");

        // 6. Verify Payment (Admin action)
        $invoiceRepo->verifyPayment($invoiceId, 1);
        $invoice = $invoiceRepo->find($invoiceId);
        $this->assertEquals('paid', $invoice['status']);

        // 7. Check Active Service generated
        // Assuming ProjectStarted event or DashboardService does this
        // For E2E we simulate the service creation
        $activeServiceId = \App\Models\Service::activateForClient($userId, $invoiceId, $ticketId, 1);
        $this->assertNotEmpty($activeServiceId, "Active service creation failed");

        // Clean up
        $this->db->exec("DELETE FROM active_services WHERE id = $activeServiceId");
        $this->db->exec("DELETE FROM payment_receipts WHERE id = $receiptId");
        $this->db->exec("DELETE FROM invoices WHERE id = $invoiceId");
        $this->db->exec("DELETE FROM budgets WHERE id = $budgetId");
        $this->db->exec("DELETE FROM tickets WHERE id = $ticketId");
        $this->db->exec("DELETE FROM users WHERE id = $userId");
    }
}
