<?php
namespace Tests\Integration;

use App\Services\AIService;
use PHPUnit\Framework\TestCase;

/**
 * AIService Integration Test
 * Focuses on provider switching and response parsing stability.
 */
class AIServiceTest extends \Tests\TestCase
{
    private $aiService;

    protected function setUp(): void
    {
        parent::setUp();
        // Forzar entorno de prueba si es necesario para evitar llamadas reales durante el test
        $_ENV['AI_API_KEY'] = 'test_key_123';
        $this->aiService = new AIService();
    }

    /**
     * Test that the service correctly identifies if it's enabled.
     */
    public function test_service_is_enabled_with_key()
    {
        $this->assertTrue($this->aiService->isEnabled());
        
        // Temporarily disable
        $oldKey = $_ENV['AI_API_KEY'];
        unset($_ENV['AI_API_KEY']);
        $disabledService = new AIService();
        $this->assertFalse($disabledService->isEnabled());
        
        $_ENV['AI_API_KEY'] = $oldKey;
    }

    /**
     * Test provider endpoint resolution.
     */
    public function test_provider_endpoint_resolution()
    {
        // Test Groq
        $_ENV['AI_PROVIDER'] = 'groq';
        $groqService = new AIService();
        $reflector = new \ReflectionClass($groqService);
        $endpointProp = $reflector->getProperty('endpoint');
        $endpointProp->setAccessible(true);
        
        $this->assertStringContainsString('groq.com', $endpointProp->getValue($groqService));

        // Test OpenAI (default)
        unset($_ENV['AI_PROVIDER']);
        $openAiService = new AIService();
        $this->assertStringContainsString('openai.com', $endpointProp->getValue($openAiService));
    }

    /**
     * Test action items extraction logic (regex and JSON parsing).
     * This simulates a common LLM failure where it wraps JSON in markdown blocks.
     */
    public function test_extract_action_items_handling_markdown_wrapping()
    {
        $aiService = $this->getMockBuilder(AIService::class)
            ->onlyMethods(['query'])
            ->getMock();

        // Simulate LLM returning JSON inside markdown blocks
        $mockResponse = "```json\n[\"Task 1\", \"Task 2\", \"Task 3\"]\n```";
        
        $aiService->expects($this->once())
            ->method('query')
            ->willReturn($mockResponse);

        $items = $aiService->extractActionItems("Please create a project plan.");
        
        $this->assertIsArray($items);
        $this->assertCount(3, $items);
        $this->assertEquals('Task 1', $items[0]);
    }

    /**
     * Test summary generation structure requirements.
     */
    public function test_generate_ticket_summary_logic()
    {
        $aiService = $this->getMockBuilder(AIService::class)
            ->onlyMethods(['query'])
            ->getMock();

        $mockSummary = "**Problema**: Database connection error\n**Acciones Tomadas**: Checked logs\n**Pendientes**: Restart service";
        
        $aiService->expects($this->once())
            ->method('query')
            ->willReturn($mockSummary);

        $messages = [
            ['is_admin' => 0, 'message' => 'Help, I cannot connect', 'created_at' => '2026-03-01'],
            ['is_admin' => 1, 'message' => 'Wait, we are checking', 'created_at' => '2026-03-01']
        ];

        $summary = $aiService->generateTicketSummary($messages);
        
        $this->assertStringContainsString('**Problema**', $summary);
        $this->assertStringContainsString('**Pendientes**', $summary);
    }
}
