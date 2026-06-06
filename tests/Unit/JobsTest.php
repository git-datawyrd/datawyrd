<?php
namespace Tests\Unit;

use Tests\TestCase;
use App\Models\Candidate;
use App\Models\JobApplication;
use Core\Database;

class JobsTest extends TestCase
{
    private $db;
    private $candidateModel;
    private $jobAppModel;
    private $testEmail = 'candidate.test@example.com';
    private $testCandidateId;
    private $testJobAppId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->db = Database::getInstance()->getConnection();
        $this->candidateModel = new Candidate();
        $this->jobAppModel = new JobApplication();

        // Clean up any potential leftover data
        $this->db->exec("DELETE FROM candidate_update_tokens WHERE candidate_id IN (SELECT id FROM candidates WHERE email = '{$this->testEmail}')");
        $this->db->exec("DELETE FROM job_application_status_logs WHERE application_id IN (SELECT id FROM job_applications WHERE candidate_id IN (SELECT id FROM candidates WHERE email = '{$this->testEmail}'))");
        $this->db->exec("DELETE FROM job_applications WHERE candidate_id IN (SELECT id FROM candidates WHERE email = '{$this->testEmail}')");
        $this->db->exec("DELETE FROM candidates WHERE email = '{$this->testEmail}'");
    }

    protected function tearDown(): void
    {
        // Clean up test data
        $this->db->exec("DELETE FROM candidate_update_tokens WHERE candidate_id IN (SELECT id FROM candidates WHERE email = '{$this->testEmail}')");
        $this->db->exec("DELETE FROM job_application_status_logs WHERE application_id IN (SELECT id FROM job_applications WHERE candidate_id IN (SELECT id FROM candidates WHERE email = '{$this->testEmail}'))");
        $this->db->exec("DELETE FROM job_applications WHERE candidate_id IN (SELECT id FROM candidates WHERE email = '{$this->testEmail}')");
        $this->db->exec("DELETE FROM candidates WHERE email = '{$this->testEmail}'");
        parent::tearDown();
    }

    public function test_candidate_creation_and_lookup()
    {
        $candidateData = [
            'first_name' => 'John',
            'last_name' => 'Doe',
            'email' => $this->testEmail,
            'phone' => '123456789',
            'linkedin_url' => 'https://linkedin.com/in/johndoe',
            'country' => 'Argentina',
            'city' => 'Buenos Aires',
            'address' => 'Av. Corrientes 1234'
        ];

        $candidateId = $this->candidateModel->create($candidateData);
        $this->assertNotEmpty($candidateId);
        $this->testCandidateId = $candidateId;

        // Verify lookup by email
        $found = $this->candidateModel->findByEmail($this->testEmail);
        $this->assertNotFalse($found);
        $this->assertEquals('John', $found['first_name']);
        $this->assertEquals('Argentina', $found['country']);
        $this->assertEquals('Buenos Aires', $found['city']);

        // Verify lookup by id
        $foundById = $this->candidateModel->findById($candidateId);
        $this->assertNotFalse($foundById);
        $this->assertEquals('Doe', $foundById['last_name']);
    }

    public function test_job_application_creation_and_status_history()
    {
        // First create candidate
        $candidateData = [
            'first_name' => 'John',
            'last_name' => 'Doe',
            'email' => $this->testEmail,
            'phone' => '123456789',
            'linkedin_url' => 'https://linkedin.com/in/johndoe',
            'country' => 'Argentina',
            'city' => 'Buenos Aires',
            'address' => 'Av. Corrientes 1234'
        ];
        $candidateId = $this->candidateModel->create($candidateData);

        $appData = [
            'candidate_id' => $candidateId,
            'vacancy_name' => 'Junior Developer',
            'skills' => ['PHP', 'MySQL', 'JavaScript'],
            'presentation_letter' => 'Hello team, I would love to join.',
            'cv_path' => 'cv_johndoe.pdf'
        ];

        $appId = $this->jobAppModel->create($appData);
        $this->assertNotEmpty($appId);

        // Find application by ID
        $app = $this->jobAppModel->findById($appId);
        $this->assertNotFalse($app);
        $this->assertEquals('Junior Developer', $app['vacancy_name']);
        $this->assertEquals('new', $app['status']);
        $this->assertContains('PHP', $app['skills']);

        // Update status and verify logs
        $this->jobAppModel->updateStatus($appId, 'contacted');
        $updatedApp = $this->jobAppModel->findById($appId);
        $this->assertEquals('contacted', $updatedApp['status']);

        $logs = $this->jobAppModel->getStatusLogs($appId);
        $this->assertCount(1, $logs);
        $this->assertEquals('new', $logs[0]['old_status']);
        $this->assertEquals('contacted', $logs[0]['new_status']);
    }

    public function test_otp_token_lifecycle()
    {
        // Create candidate
        $candidateData = [
            'first_name' => 'John',
            'last_name' => 'Doe',
            'email' => $this->testEmail,
            'phone' => '123456789',
            'linkedin_url' => 'https://linkedin.com/in/johndoe',
            'country' => 'Argentina',
            'city' => 'Buenos Aires',
            'address' => 'Av. Corrientes 1234'
        ];
        $candidateId = $this->candidateModel->create($candidateData);

        // Create token
        $token = $this->candidateModel->createUpdateToken($candidateId);
        $this->assertEquals(6, strlen($token));

        // Verify with invalid token
        $invalidVerify = $this->candidateModel->verifyUpdateToken($candidateId, '000000');
        $this->assertFalse($invalidVerify);

        // Verify with correct token
        $validVerify = $this->candidateModel->verifyUpdateToken($candidateId, $token);
        $this->assertTrue($validVerify);

        // Token should not be usable twice
        $doubleVerify = $this->candidateModel->verifyUpdateToken($candidateId, $token);
        $this->assertFalse($doubleVerify);
    }

    public function test_update_profile_and_multiple_applications()
    {
        // Create candidate
        $candidateData = [
            'first_name' => 'John',
            'last_name' => 'Doe',
            'email' => $this->testEmail,
            'phone' => '123456789',
            'linkedin_url' => 'https://linkedin.com/in/johndoe',
            'country' => 'Argentina',
            'city' => 'Buenos Aires',
            'address' => 'Av. Corrientes 1234'
        ];
        $candidateId = $this->candidateModel->create($candidateData);

        // Update profile
        $updatedData = [
            'country' => 'Uruguay',
            'city' => 'Montevideo',
            'address' => 'Av. Italia 9999'
        ];
        $this->candidateModel->updateProfile($candidateId, $updatedData);

        $found = $this->candidateModel->findById($candidateId);
        $this->assertEquals('Uruguay', $found['country']);
        $this->assertEquals('Montevideo', $found['city']);
        $this->assertEquals('Av. Italia 9999', $found['address']);

        // Create application 1
        $app1Data = [
            'candidate_id' => $candidateId,
            'vacancy_name' => 'Frontend Dev',
            'cv_path' => 'cv.pdf'
        ];
        $this->jobAppModel->create($app1Data);

        // Create application 2
        $app2Data = [
            'candidate_id' => $candidateId,
            'vacancy_name' => 'Backend Dev',
            'cv_path' => 'cv.pdf'
        ];
        $this->jobAppModel->create($app2Data);

        // Verify history has both applications
        $history = $this->jobAppModel->getCandidateHistory($candidateId);
        $this->assertCount(2, $history);
        $this->assertEquals('Backend Dev', $history[0]['vacancy_name']);
        $this->assertEquals('Frontend Dev', $history[1]['vacancy_name']);
    }
}
