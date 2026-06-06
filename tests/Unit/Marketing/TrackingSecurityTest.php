<?php
namespace Tests\Unit\Marketing;

use App\Controllers\MarketingTrackingController;
use App\Repositories\MarketingRepository;
use App\Services\Marketing\BounceResolver;
use Core\Database;
use Core\Config;
use PHPUnit\Framework\TestCase;

class TrackingSecurityTest extends \Tests\TestCase
{
    private $db;
    private $repo;
    private $resolver;
    private $controller;
    private $testListId = 7777;
    private $testCampaignId = 7777;
    private $testEmail = 'track-security-test@datawyrd.com';
    private $testToken = 'security-test-token-123';
    private $testUnsubToken = 'security-unsub-token-123';

    protected function setUp(): void
    {
        parent::setUp();

        $this->db = Database::getInstance()->getConnection();
        $this->repo = new MarketingRepository($this->db);
        $this->resolver = new BounceResolver($this->repo);
        $this->controller = new MarketingTrackingController($this->repo, $this->resolver);

        $this->cleanUp();

        // 1. Create a list
        $this->db->prepare("INSERT INTO mktg_lists (id, tenant_id, name, created_by) VALUES (?, 1, 'Security Test List', 1)")
            ->execute([$this->testListId]);

        // 2. Create a contact
        $this->db->prepare("INSERT INTO mktg_contacts (id, tenant_id, list_id, email, status, unsubscribe_token) VALUES (7777, 1, ?, ?, 'subscribed', ?)")
            ->execute([$this->testListId, $this->testEmail, $this->testUnsubToken]);

        // 3. Create a campaign
        $this->db->prepare("INSERT INTO mktg_campaigns (id, tenant_id, name, subject, created_by, status) VALUES (?, 1, 'Security Test Campaign', 'Subject', 1, 'sent')")
            ->execute([$this->testCampaignId]);

        // 4. Create a send log
        $this->db->prepare("INSERT INTO mktg_send_log (id, campaign_id, contact_id, email, status, tracking_token, unsubscribe_token) VALUES (7777, ?, 7777, ?, 'sent', ?, ?)")
            ->execute([$this->testCampaignId, $this->testEmail, $this->testToken, $this->testUnsubToken]);
    }

    protected function tearDown(): void
    {
        $this->cleanUp();
        parent::tearDown();
    }

    private function cleanUp(): void
    {
        $this->db->exec("DELETE FROM mktg_events WHERE campaign_id = 7777 OR contact_id = 7777");
        $this->db->exec("DELETE FROM mktg_send_log WHERE id = 7777 OR campaign_id = 7777");
        $this->db->exec("DELETE FROM mktg_contacts WHERE id = 7777 OR email = '{$this->testEmail}'");
        $this->db->exec("DELETE FROM mktg_campaigns WHERE id = 7777");
        $this->db->exec("DELETE FROM mktg_lists WHERE id = 7777");
    }

    public function test_register_tracking_event_hashes_ip_for_gdpr_privacy()
    {
        // Mock remote address and app key
        $_SERVER['REMOTE_ADDR'] = '192.168.4.45';
        $_SERVER['HTTP_USER_AGENT'] = 'TestBrowser/1.0';
        Config::set('app_key', 'super-secret-salt-key');

        // Access the private method via Reflection
        $reflection = new \ReflectionClass(MarketingTrackingController::class);
        $method = $reflection->getMethod('registerTrackingEvent');
        $method->setAccessible(true);

        $method->invokeArgs($this->controller, [$this->testToken, 'open']);

        // Retrieve event from DB
        $stmt = $this->db->prepare("SELECT * FROM mktg_events WHERE send_log_id = 7777 LIMIT 1");
        $stmt->execute();
        $event = $stmt->fetch();

        $this->assertNotEmpty($event);
        $this->assertEquals('open', $event['event_type']);
        
        // Expected hash
        $expectedHash = hash('sha256', '192.168.4.45' . 'super-secret-salt-key');
        $this->assertEquals($expectedHash, $event['ip_address']);
        $this->assertEquals('TestBrowser/1.0', $event['user_agent']);
    }

    public function test_sanitize_redirect_url_prevents_open_redirect()
    {
        Config::set('base_url', 'http://localhost/datawyrd');
        Config::set('marketing.reputation.custom_domain', 'trusted.com');

        $reflection = new \ReflectionClass(MarketingTrackingController::class);
        $method = $reflection->getMethod('sanitizeRedirectUrl');
        $method->setAccessible(true);

        // Case 1: Allowed base_url domain
        $url1 = 'http://localhost/datawyrd/dashboard';
        $res1 = $method->invokeArgs($this->controller, [$url1]);
        $this->assertEquals('http://localhost/datawyrd/dashboard', $res1);

        // Case 2: Allowed custom reputation domain
        $url2 = 'https://trusted.com/landing?promo=1';
        $res2 = $method->invokeArgs($this->controller, [$url2]);
        $this->assertEquals('https://trusted.com/landing?promo=1', $res2);

        // Case 3: Untrusted domain (should return null to block redirect)
        $url3 = 'https://malicious-site.com/phishing';
        $res3 = $method->invokeArgs($this->controller, [$url3]);
        $this->assertNull($res3);

        // Case 4: Invalid URL formats
        $url4 = 'not-a-valid-url';
        $res4 = $method->invokeArgs($this->controller, [$url4]);
        $this->assertNull($res4);
    }
}
