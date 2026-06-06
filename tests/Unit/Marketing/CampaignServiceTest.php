<?php
namespace Tests\Unit\Marketing;

use App\Services\Marketing\CampaignService;
use App\Repositories\MarketingRepository;
use Core\Database;
use Core\Config;
use PHPUnit\Framework\TestCase;

class CampaignServiceTest extends \Tests\TestCase
{
    private $db;
    private $repo;
    private $service;
    private $testListId = 8888;
    private $testTemplateId = 8888;
    private $testCampaignId = 8888;

    protected function setUp(): void
    {
        parent::setUp();
        $this->db = Database::getInstance()->getConnection();
        $this->repo = new MarketingRepository($this->db);
        $this->service = new CampaignService($this->repo);

        $this->cleanUp();

        // 1. Create a list
        $this->db->prepare("INSERT INTO mktg_lists (id, tenant_id, name, created_by) VALUES (?, 1, 'Service Test List', 1)")
            ->execute([$this->testListId]);

        // 2. Create a template
        $this->db->prepare("INSERT INTO mktg_templates (id, tenant_id, name, subject, html_body, text_body, created_by) VALUES (?, 1, 'Test Template', 'Email Subject', 'Hello {{first_name}}! Welcome to datawyrd.', 'Text body', 1)")
            ->execute([$this->testTemplateId]);

        // 3. Create contacts in the list
        $this->repo->createContact(['list_id' => $this->testListId, 'email' => 'user1@test.com', 'first_name' => 'John', 'last_name' => 'Doe', 'status' => 'subscribed']);
        $this->repo->createContact(['list_id' => $this->testListId, 'email' => 'user2@test.com', 'first_name' => 'Jane', 'last_name' => 'Smith', 'status' => 'unsubscribed']);
        $this->repo->createContact(['list_id' => $this->testListId, 'email' => 'user3@test.com', 'first_name' => 'Spam', 'last_name' => 'User', 'status' => 'suppressed']);
    }

    protected function tearDown(): void
    {
        $this->cleanUp();
        parent::tearDown();
    }

    private function cleanUp(): void
    {
        $this->db->exec("DELETE FROM mktg_events WHERE campaign_id = 8888");
        $this->db->exec("DELETE FROM mktg_send_log WHERE campaign_id = 8888");
        $this->db->exec("DELETE FROM mktg_campaigns WHERE id = 8888");
        $this->db->exec("DELETE FROM mktg_contacts WHERE list_id = 8888");
        $this->db->exec("DELETE FROM mktg_templates WHERE id = 8888");
        $this->db->exec("DELETE FROM mktg_lists WHERE id = 8888");
    }

    public function test_create_campaign()
    {
        $campaignData = [
            'name' => 'New Product Launch',
            'subject' => 'Check out our new products!',
            'template_id' => $this->testTemplateId,
            'list_id' => $this->testListId,
            'type' => 'one_time'
        ];

        $campaignId = $this->service->createCampaign($campaignData, 1);
        $this->assertGreaterThan(0, $campaignId);

        $campaign = $this->repo->findCampaign($campaignId);
        $this->assertNotNull($campaign);
        $this->assertEquals('New Product Launch', $campaign['name']);
        $this->assertEquals('draft', $campaign['status']);

        // Clean up created campaign
        $this->db->exec("DELETE FROM mktg_campaigns WHERE id = $campaignId");
    }

    public function test_schedule_campaign_hydrates_only_subscribed_contacts()
    {
        // 1. Create a draft campaign
        $this->db->prepare("INSERT INTO mktg_campaigns (id, tenant_id, name, subject, template_id, list_id, status, created_by) VALUES (?, 1, 'Campaign', 'Subject', ?, ?, 'draft', 1)")
            ->execute([$this->testCampaignId, $this->testTemplateId, $this->testListId]);

        // 2. Schedule the campaign
        $result = $this->service->scheduleCampaign($this->testCampaignId);

        $this->assertTrue($result['success']);
        $this->assertEquals('sending', $result['status']);
        $this->assertEquals(1, $result['queued']); // Only 1 contact is 'subscribed'

        // Check send log
        $stmt = $this->db->prepare("SELECT * FROM mktg_send_log WHERE campaign_id = ?");
        $stmt->execute([$this->testCampaignId]);
        $logs = $stmt->fetchAll();
        $this->assertCount(1, $logs);
        $this->assertEquals('user1@test.com', $logs[0]['email']);
        $this->assertEquals('queued', $logs[0]['status']);
    }

    public function test_template_rendering_replaces_placeholders_and_embeds_pixel()
    {
        // Set tracking config
        Config::set('marketing.tracking', [
            'base_url' => 'https://dw.test',
            'pixel_path' => '/track/open',
            'pixel_enabled' => true
        ]);

        // We can inspect rendering by calling renderTemplate via Reflection
        $campaign = [
            'template_id' => $this->testTemplateId,
            'subject' => 'Email Subject'
        ];
        $log = [
            'email' => 'user1@test.com',
            'first_name' => 'John',
            'last_name' => 'Doe',
            'tracking_token' => 'xyz-token-abc'
        ];

        $reflection = new \ReflectionClass(CampaignService::class);
        $method = $reflection->getMethod('renderTemplate');
        $method->setAccessible(true);

        $testService = new CampaignService($this->repo);
        $html = $method->invokeArgs($testService, [$campaign, $log]);

        $this->assertStringContainsString('Hello John!', $html);
        $this->assertStringContainsString('<img src="https://dw.test/track/open?t=xyz-token-abc"', $html);
    }

    public function test_build_compliance_headers()
    {
        // Set compliance config
        Config::set('marketing.compliance', [
            'list_unsubscribe_header' => true
        ]);
        Config::set('marketing.tracking', [
            'base_url' => 'https://dw.test',
            'unsubscribe_path' => '/track/unsubscribe'
        ]);

        $campaign = [
            'id' => $this->testCampaignId
        ];
        $log = [
            'tracking_token' => 'xyz-token-abc',
            'unsubscribe_token' => 'unsub-token-abc'
        ];

        $reflection = new \ReflectionClass(CampaignService::class);
        $method = $reflection->getMethod('buildComplianceHeaders');
        $method->setAccessible(true);

        $testService = new CampaignService($this->repo);
        $headers = $method->invokeArgs($testService, [$campaign, $log]);

        $this->assertArrayHasKey('X-Campaign-ID', $headers);
        $this->assertEquals((string)$this->testCampaignId, $headers['X-Campaign-ID']);
        $this->assertArrayHasKey('List-Unsubscribe', $headers);
        $this->assertArrayHasKey('List-Unsubscribe-Post', $headers);
        $this->assertStringContainsString('https://dw.test/track/unsubscribe?t=unsub-token-abc', $headers['List-Unsubscribe']);
        $this->assertEquals('List-Unsubscribe=One-Click', $headers['List-Unsubscribe-Post']);
    }
}
