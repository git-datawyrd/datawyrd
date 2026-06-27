<?php
namespace Tests\Unit;

use Tests\TestCase;
use Core\Captcha;
use Core\Config;
use Core\Session;

class CaptchaTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        // Initialize mock session array for CLI tests
        $_SESSION = [];
    }

    public function test_generate_math_question_sets_session_and_returns_question()
    {
        $question = Captcha::generateMathQuestion();
        
        $this->assertStringContainsString('+', $question);
        $this->assertTrue(Session::has('captcha_result'));
        $this->assertIsInt(Session::get('captcha_result'));
    }

    public function test_verify_local_captcha_success()
    {
        Session::set('captcha_result', 15);

        $data = [
            'captcha_response' => '15',
            'website_extra' => '' // Honeypot empty
        ];

        $result = Captcha::verify($data);

        $this->assertTrue($result);
        $this->assertFalse(Session::has('captcha_result')); // Should clear result on check
    }

    public function test_verify_local_captcha_incorrect_value()
    {
        Session::set('captcha_result', 15);

        $data = [
            'captcha_response' => '12',
            'website_extra' => ''
        ];

        $result = Captcha::verify($data);

        $this->assertFalse($result);
        $this->assertFalse(Session::has('captcha_result')); // Should clear result on check
    }

    public function test_verify_honeypot_triggered_fails_immediately()
    {
        Session::set('captcha_result', 15);

        $data = [
            'captcha_response' => '15',
            'website_extra' => 'http://spam-link.com' // Bot filled honeypot
        ];

        $result = Captcha::verify($data);

        $this->assertFalse($result);
        // Note: when honeypot fails, it returns false before even checking local/remote captcha,
        // but session result might still exist or be untouched depending on verification order.
    }

    public function test_render_local_html()
    {
        // Mock captcha provider config to local
        // (Config::get uses getenv internally or is loaded statically, but by default it is local)
        $html = Captcha::render();
        
        $this->assertStringContainsString('captcha-container', $html);
        $this->assertStringContainsString('name="captcha_response"', $html);
    }

    public function test_render_honeypot_html()
    {
        $html = Captcha::renderHoneypot();
        
        $this->assertStringContainsString('style="display:none !important;"', $html);
        $this->assertStringContainsString('name="website_extra"', $html);
    }
}
