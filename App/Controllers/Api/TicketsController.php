<?php
namespace App\Controllers\Api;

use App\Services\TicketService;
use Core\JWT;
use Core\SecurityLogger;

/**
 * TicketsController - RESTful API for Ticket Management
 */
class TicketsController extends ApiController
{
    private TicketService $ticketService;

    public function __construct(JWT $jwt, TicketService $ticketService)
    {
        parent::__construct($jwt);
        $this->ticketService = $ticketService;
    }

    /**
     * GET /api/v1/tickets
     * List all tickets for the authenticated user
     */
    public function index(): void
    {
        $payload = $this->authenticate();
        
        try {
            $tickets = $this->ticketService->getTicketsForUser($payload);
            
            $this->json([
                'success' => true,
                'count' => count($tickets),
                'data' => $tickets
            ]);
        } catch (\Exception $e) {
            SecurityLogger::log('API_TICKETS_ERROR', $e->getMessage(), 'ERROR');
            $this->error("Failed to fetch tickets: " . $e->getMessage(), 500);
        }
    }

    /**
     * POST /api/v1/tickets/store
     * Create a new ticket (Mobile/Public API)
     */
    public function store(): void
    {
        // For public/non-auth store, we might need a different bypass or app-key
        // For now, let's keep it under JWT for consistency with mobile app requirement
        $payload = $this->authenticate();
        
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (!$data || !isset($data['subject'], $data['description'])) {
            $this->error("Missing required fields: subject, description", 400);
        }

        // Add user context from JWT
        $data['email'] = $payload['email'];
        $data['name'] = $payload['name'];
        $data['service_plan_id'] = $data['service_plan_id'] ?? 1; // Default basic plan for now

        $result = $this->ticketService->createTicket($data);

        if ($result) {
            $this->json([
                'success' => true,
                'message' => 'Ticket created successfully',
                'data' => $result
            ], 201);
        } else {
            $this->error("Failed to create ticket", 500);
        }
    }
}
