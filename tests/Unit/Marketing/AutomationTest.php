<?php
namespace Tests\Unit\Marketing;

use Core\Database;
use Core\Config;
use App\Repositories\MarketingRepository;
use App\Services\Marketing\AutomationService;
use App\Services\Marketing\CampaignService;

class AutomationTest extends \Tests\TestCase
{
    private $db;
    private $repo;
    private $automationService;
    private $testListId = 9999;
    private $testTemplateId = 9999;
    private $testAutomationId = 9999;

    protected function setUp(): void
    {
        parent::setUp();
        $this->db = Database::getInstance()->getConnection();
        $this->repo = new MarketingRepository($this->db);
        $this->automationService = new AutomationService();

        $this->cleanUp();

        // 1. Create a test list
        $this->db->prepare("INSERT INTO mktg_lists (id, tenant_id, name, created_by) VALUES (?, 1, 'Automation Test List', 1)")
            ->execute([$this->testListId]);

        // 2. Create a test template
        $this->db->prepare("INSERT INTO mktg_templates (id, tenant_id, name, subject, html_body, text_body, created_by) VALUES (?, 1, 'Auto Template', 'Hola {{first_name}}!', 'Body', 'Text', 1)")
            ->execute([$this->testTemplateId]);

        // 3. Create a test automation rule (signup trigger for list 9999)
        $triggerData = json_encode(['list_id' => $this->testListId]);
        $this->db->prepare("INSERT INTO mktg_automations (id, tenant_id, name, trigger_type, trigger_data, status, created_by) VALUES (?, 1, 'Test Welcome Flow', 'signup', ?, 'active', 1)")
            ->execute([$this->testAutomationId, $triggerData]);

        // 4. Create automation steps
        // Step 1: Send Email
        $configEmail = json_encode(['template_id' => $this->testTemplateId]);
        $this->db->prepare("INSERT INTO mktg_automation_steps (automation_id, step_order, step_type, step_config) VALUES (?, 1, 'send_email', ?)")
            ->execute([$this->testAutomationId, $configEmail]);

        // Step 2: Assign tag 'welcome_completed'
        $configTag = json_encode(['tag_name' => 'welcome_completed', 'action' => 'add']);
        $this->db->prepare("INSERT INTO mktg_automation_steps (automation_id, step_order, step_type, step_config) VALUES (?, 2, 'tag', ?)")
            ->execute([$this->testAutomationId, $configTag]);
    }

    protected function tearDown(): void
    {
        $this->cleanUp();
        parent::tearDown();
    }

    private function cleanUp(): void
    {
        $this->db->exec("DELETE FROM mktg_automation_steps WHERE automation_id = 9999");
        $this->db->exec("DELETE FROM mktg_automations WHERE id = 9999");
        $this->db->exec("DELETE FROM mktg_templates WHERE id = 9999");
        $this->db->exec("DELETE FROM mktg_contacts WHERE list_id = 9999");
        $this->db->exec("DELETE FROM mktg_lists WHERE id = 9999");
        $this->db->exec("DELETE FROM email_logs WHERE subject = 'Hola {{first_name}}!' OR subject = 'Auto Template'");
    }

    public function test_signup_trigger_without_double_opt_in(): void
    {
        // 1. Force double_opt_in = false
        $original = Config::get('marketing.compliance.double_opt_in');
        Config::set('marketing.compliance.double_opt_in', false);

        $unsubToken = 'unsub-9999-no-doi';
        $contactData = [
            'list_id'           => $this->testListId,
            'email'             => 'signup_no_doi@test.com',
            'first_name'        => 'Carlos',
            'status'            => 'subscribed',
            'unsubscribe_token' => $unsubToken,
        ];

        // 2. Register contact manually (simulates double_opt_in = false creation)
        $contactId = $this->repo->createContact($contactData);

        // 3. Trigger signup event
        $this->automationService->trigger('signup', [
            'contact_id' => $contactId,
            'list_id'    => $this->testListId,
            'tenant_id'  => 1
        ]);

        // 4. Assert contact has the tag welcome_completed (assigned by Step 2)
        $stmt = $this->db->prepare("SELECT * FROM mktg_contacts WHERE id = ?");
        $stmt->execute([$contactId]);
        $contact = $stmt->fetch();

        $this->assertEquals('welcome_completed', $contact['tags']);

        // 5. Restore config
        Config::set('marketing.compliance.double_opt_in', $original);
    }

    public function test_signup_trigger_with_double_opt_in_pending_to_subscribed(): void
    {
        // 1. Force double_opt_in = true
        $original = Config::get('marketing.compliance.double_opt_in');
        Config::set('marketing.compliance.double_opt_in', true);

        $unsubToken = 'unsub-9999-doi';
        $contactData = [
            'list_id'           => $this->testListId,
            'email'             => 'signup_doi@test.com',
            'first_name'        => 'Carlos',
            'status'            => 'pending',
            'unsubscribe_token' => $unsubToken,
        ];

        // 2. Register contact in pending status
        $contactId = $this->repo->createContact($contactData);

        // 3. Trigger signup event - should NOT execute steps because status is 'pending'
        $this->automationService->trigger('signup', [
            'contact_id' => $contactId,
            'list_id'    => $this->testListId,
            'tenant_id'  => 1
        ]);

        $stmt = $this->db->prepare("SELECT * FROM mktg_contacts WHERE id = ?");
        $stmt->execute([$contactId]);
        $contactPending = $stmt->fetch();

        $this->assertNull($contactPending['tags']);
        $this->assertEquals('pending', $contactPending['status']);

        // 4. Simulate confirmOptIn action (update status, IP and trigger automation)
        $ipRaw = '127.0.0.1';
        $this->db->prepare("UPDATE mktg_contacts SET status = 'subscribed', consent_given = 1, consent_ip = ?, consent_at = NOW() WHERE id = ?")
            ->execute([$ipRaw, $contactId]);

        // Trigger again since confirmOptIn calls trigger('signup')
        $this->automationService->trigger('signup', [
            'contact_id' => $contactId,
            'list_id'    => $this->testListId,
            'tenant_id'  => 1
        ]);

        // 5. Assert contact status is updated, tags assigned
        $stmt->execute([$contactId]);
        $contactConfirmed = $stmt->fetch();

        $this->assertEquals('subscribed', $contactConfirmed['status']);
        $this->assertEquals(1, $contactConfirmed['consent_given']);
        $this->assertEquals($ipRaw, $contactConfirmed['consent_ip']);
        $this->assertEquals('welcome_completed', $contactConfirmed['tags']);

        // 6. Restore config
        Config::set('marketing.compliance.double_opt_in', $original);
    }
}
