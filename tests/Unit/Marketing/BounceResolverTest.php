<?php
namespace Tests\Unit\Marketing;

use App\Services\Marketing\BounceResolver;
use App\Repositories\MarketingRepository;
use Core\Database;
use PHPUnit\Framework\TestCase;

class BounceResolverTest extends \Tests\TestCase
{
    private $db;
    private $repo;
    private $resolver;
    private $testEmail = 'bounce-test@datawyrd.com';
    private $testListId = 9999;
    private $testCampaignId = 9999;
    private $testSendLogId = 9999;
    private $testToken = 'test-unsub-token-12345';

    protected function setUp(): void
    {
        parent::setUp();
        $this->db = Database::getInstance()->getConnection();
        $this->repo = new MarketingRepository($this->db);
        $this->resolver = new BounceResolver($this->repo);

        $this->cleanUp();

        // 1. Create a mock list
        $this->db->prepare("INSERT INTO mktg_lists (id, tenant_id, name, created_by) VALUES (?, 1, 'Test List', 1)")
            ->execute([$this->testListId]);

        // 2. Create a mock contact
        $this->db->prepare("INSERT INTO mktg_contacts (id, tenant_id, list_id, email, status, unsubscribe_token) VALUES (9999, 1, ?, ?, 'subscribed', ?)")
            ->execute([$this->testListId, $this->testEmail, $this->testToken]);

        // 3. Create a mock campaign
        $this->db->prepare("INSERT INTO mktg_campaigns (id, tenant_id, name, subject, created_by, status) VALUES (?, 1, 'Test Campaign', 'Subject', 1, 'sent')")
            ->execute([$this->testCampaignId]);

        // 4. Create a mock send log
        $this->db->prepare("INSERT INTO mktg_send_log (id, campaign_id, contact_id, email, status, provider_message_id, unsubscribe_token) VALUES (?, ?, 9999, ?, 'sent', 'provider-msg-id-123', ?)")
            ->execute([$this->testSendLogId, $this->testCampaignId, $this->testEmail, $this->testToken]);
    }

    protected function tearDown(): void
    {
        $this->cleanUp();
        parent::tearDown();
    }

    private function cleanUp(): void
    {
        $this->db->exec("DELETE FROM mktg_events WHERE send_log_id = 9999 OR contact_id = 9999");
        $this->db->exec("DELETE FROM mktg_send_log WHERE id = 9999 OR campaign_id = 9999");
        $this->db->exec("DELETE FROM mktg_contacts WHERE id = 9999 OR email = '{$this->testEmail}'");
        $this->db->exec("DELETE FROM mktg_campaigns WHERE id = 9999");
        $this->db->exec("DELETE FROM mktg_lists WHERE id = 9999");
    }

    public function test_hard_bounce_suppresses_contact_and_updates_send_log()
    {
        $result = $this->resolver->handle($this->testEmail, 'hard', 'Permanent failure', 'provider-msg-id-123');

        $this->assertTrue($result['resolved']);
        $this->assertEquals('suppressed_and_blacklisted', $result['action']);

        // Check contact status in DB
        $stmt = $this->db->prepare("SELECT status, suppression_reason FROM mktg_contacts WHERE id = 9999");
        $stmt->execute();
        $contact = $stmt->fetch();
        $this->assertEquals('suppressed', $contact['status']);
        $this->assertStringContainsString('hard: Permanent failure', $contact['suppression_reason']);

        // Check send log status
        $stmt = $this->db->prepare("SELECT status, error_message FROM mktg_send_log WHERE id = 9999");
        $stmt->execute();
        $sendLog = $stmt->fetch();
        $this->assertEquals('bounced', $sendLog['status']);
        $this->assertEquals('Permanent failure', $sendLog['error_message']);
    }

    public function test_complaint_suppresses_contact_and_updates_send_log()
    {
        $result = $this->resolver->handle($this->testEmail, 'complaint', 'Spam report', 'provider-msg-id-123');

        $this->assertTrue($result['resolved']);
        $this->assertEquals('suppressed_and_blacklisted', $result['action']);

        // Check contact status in DB
        $stmt = $this->db->prepare("SELECT status FROM mktg_contacts WHERE id = 9999");
        $stmt->execute();
        $status = $stmt->fetchColumn();
        $this->assertEquals('suppressed', $status);
    }

    public function test_soft_bounce_does_not_suppress_contact_but_updates_send_log()
    {
        $result = $this->resolver->handle($this->testEmail, 'soft', 'Quota exceeded', 'provider-msg-id-123');

        $this->assertTrue($result['resolved']);
        $this->assertEquals('soft_bounce_logged', $result['action']);

        // Check contact status in DB (should still be subscribed)
        $stmt = $this->db->prepare("SELECT status FROM mktg_contacts WHERE id = 9999");
        $stmt->execute();
        $status = $stmt->fetchColumn();
        $this->assertEquals('subscribed', $status);

        // Check send log status (should be soft_bounced)
        $stmt = $this->db->prepare("SELECT status, error_message FROM mktg_send_log WHERE id = 9999");
        $stmt->execute();
        $sendLog = $stmt->fetch();
        $this->assertEquals('soft_bounced', $sendLog['status']);
        $this->assertEquals('Quota exceeded', $sendLog['error_message']);
    }

    public function test_unsubscribe_by_token()
    {
        $result = $this->resolver->handleUnsubscribe($this->testToken);

        $this->assertTrue($result['resolved']);
        $this->assertEquals('unsubscribed', $result['action']);

        // Check contact status in DB
        $stmt = $this->db->prepare("SELECT status, unsubscribed_at FROM mktg_contacts WHERE id = 9999");
        $stmt->execute();
        $contact = $stmt->fetch();
        $this->assertEquals('unsubscribed', $contact['status']);
        $this->assertNotNull($contact['unsubscribed_at']);
    }

    public function test_unsubscribe_with_invalid_token()
    {
        $result = $this->resolver->handleUnsubscribe('non-existent-token');

        $this->assertFalse($result['resolved']);
        $this->assertEquals('token_not_found', $result['action']);
    }
}
