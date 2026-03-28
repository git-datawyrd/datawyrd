<?php
namespace Tests\Unit;

use Tests\TestCase;
use App\Services\TicketService;
use App\Repositories\TicketRepository;
use App\Services\AIService;
use App\Services\CRM\IntelligenceService;
use App\Services\CRM\LeadService;

class TicketServiceTest extends TestCase
{
    private $ticketService;
    private $repositoryMock;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->repositoryMock = $this->createMock(TicketRepository::class);
        $aiServiceMock = $this->createMock(AIService::class);
        $intelligenceMock = $this->createMock(IntelligenceService::class);
        $leadServiceMock = $this->createMock(LeadService::class);

        $this->ticketService = new TicketService(
            $this->repositoryMock,
            $aiServiceMock,
            $intelligenceMock,
            $leadServiceMock
        );
    }

    public function test_get_tickets_for_user_calls_repository()
    {
        $user = ['id' => 1, 'role' => 'client'];
        
        $this->repositoryMock->expects($this->once())
            ->method('all')
            ->with($this->equalTo(1))
            ->willReturn([]);

        $result = $this->ticketService->getTicketsForUser($user);
        $this->assertIsArray($result);
    }

    public function test_get_tickets_for_admin_calls_repository_with_null_id()
    {
        $user = ['id' => 1, 'role' => 'admin'];
        
        $this->repositoryMock->expects($this->once())
            ->method('all')
            ->with($this->isNull())
            ->willReturn([]);

        $result = $this->ticketService->getTicketsForUser($user);
        $this->assertIsArray($result);
    }
}
