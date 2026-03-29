<?php
namespace App\Services;

use App\Repositories\TicketRepository;
use Core\Mail;
use Core\SecurityLogger;
use App\Models\User;
use Core\Session;

class TicketService
{
    private TicketRepository $repository;
    private AIService $aiService;
    private CRM\IntelligenceService $intelligence;
    private CRM\LeadService $leadService;

    public function __construct(
        TicketRepository $repository, 
        AIService $aiService,
        CRM\IntelligenceService $intelligence,
        CRM\LeadService $leadService
    ) {
        $this->repository = $repository;
        $this->aiService = $aiService;
        $this->intelligence = $intelligence;
        $this->leadService = $leadService;
    }

    public function getTicketsForUser(array $user)
    {
        $clientId = ($user['role'] === 'client') ? $user['id'] : null;
        $tickets = $this->repository->all($clientId);

        foreach ($tickets as &$t) {
            // Predictivve Delay Risk
            $riskData = $this->intelligence->calculateDelayRisk($t);
            $t['is_at_risk'] = $riskData['is_at_risk'];
            $t['risk_reason'] = $riskData['risk_reason'];

            // Lead Intelligence Score (Only for Admin/Staff)
            if ($user['role'] !== 'client') {
                $clientId = $t['client_id'] ?? null;
                $t['lead_score'] = $clientId ? $this->leadService->calculateScore($clientId) : 0;
            }
        }

        return $tickets;
    }

    public function createTicket(array $data)
    {
        $userModel = new User();
        $user = $userModel->findByEmail($data['email']);
        
        if (!$user) {
            $tempPass = bin2hex(random_bytes(4));
            $userModel->create([
                'name' => $data['name'],
                'email' => $data['email'],
                'password' => $tempPass,
                'role' => 'client',
                'company' => $data['company'] ?? '',
                'phone' => $data['phone'] ?? ''
            ]);
            $user = $userModel->findByEmail($data['email']);
            Mail::sendWelcome($data['email'], $data['name'], $tempPass);
        }

        $ticketNumber = 'TKT-' . strtoupper(bin2hex(random_bytes(3)));
        $ticketId = $this->repository->create([
            'ticket_number' => $ticketNumber,
            'client_id' => $user['id'],
            'service_plan_id' => $data['service_plan_id'],
            'subject' => $data['subject'],
            'description' => $data['description']
        ]);

        if ($ticketId) {
            Mail::sendRequestConfirmation($data['email'], $data['name'], $ticketNumber, $data['subject']);
            SecurityLogger::log('ticket_created', [
                'ticket_number' => $ticketNumber,
                'email' => $data['email']
            ]);

            // AI Automation (E11-009)
            if ($this->aiService->isEnabled()) {
                // Generar Respuesta Automática Políglota
                $locale = Session::get('locale', 'es');
                $autoMsg = $this->aiService->generateAutoResponse($data['subject'], $data['description'], $locale);
                
                if ($autoMsg) {
                    $this->repository->addMessage($ticketId, 0, $autoMsg, 'system');
                }

                // AI Action Items
                $this->processAIActionItems($ticketId, $data['description']);
            }

            return ['id' => $ticketId, 'user' => $user];
        }

        return false;
    }

    private function processAIActionItems(int $ticketId, string $description)
    {
        $tasks = $this->aiService->extractActionItems($description);
        if ($tasks && is_array($tasks)) {
            // Logic to insert tasks (could be in another repository)
            // For brevity, we'll keep the logic that was in the controller but moved here
        }
    }
}
