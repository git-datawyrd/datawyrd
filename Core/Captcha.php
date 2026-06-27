<?php
namespace Core;

/**
 * Captcha Service - Handles local math challenge and remote integrations (Turnstile/reCAPTCHA)
 */
class Captcha
{
    /**
     * Generate local math question and save its result in the session
     * 
     * @return string The question text
     */
    public static function generateMathQuestion(): string
    {
        $num1 = rand(1, 10);
        $num2 = rand(1, 10);
        Session::set('captcha_result', $num1 + $num2);
        return "{$num1} + {$num2}";
    }

    /**
     * Render the captcha field according to configuration
     * 
     * @return string HTML content
     */
    public static function render(): string
    {
        $provider = Config::get('captcha.provider', 'local');
        $siteKey = Config::get('captcha.site_key', '');

        if ($provider === 'turnstile' && !empty($siteKey)) {
            return '<div class="cf-turnstile my-3" data-sitekey="' . htmlspecialchars($siteKey) . '"></div>';
        }

        if ($provider === 'recaptcha' && !empty($siteKey)) {
            return '<div class="g-recaptcha my-3" data-sitekey="' . htmlspecialchars($siteKey) . '"></div>';
        }

        // Local math challenge fallback
        $question = self::generateMathQuestion();
        return '
        <div class="mb-3 captcha-container">
            <label class="text-white-50 x-small mb-2 text-uppercase tracking-widest fw-bold d-block">Por seguridad, ¿cuánto es ' . $question . '?</label>
            <input type="number" name="captcha_response" class="form-control p-3 small text-white bg-midnight border-white-10" placeholder="Tu respuesta" required>
        </div>';
    }

    /**
     * Render the honeypot field (hidden from users)
     * 
     * @return string HTML content
     */
    public static function renderHoneypot(): string
    {
        $name = Config::get('captcha.honeypot_name', 'website_extra');
        return '<div style="display:none !important;" aria-hidden="true">
            <input type="text" name="' . htmlspecialchars($name) . '" tabindex="-1" autocomplete="off" value="">
        </div>';
    }

    /**
     * Render the script tag required for Turnstile or reCAPTCHA
     * 
     * @return string HTML script tag
     */
    public static function renderScript(): string
    {
        $provider = Config::get('captcha.provider', 'local');
        $siteKey = Config::get('captcha.site_key', '');

        if (empty($siteKey)) {
            return '';
        }

        if ($provider === 'turnstile') {
            return '<script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>';
        }
        if ($provider === 'recaptcha') {
            return '<script src="https://www.google.com/recaptcha/api.js" async defer></script>';
        }
        return '';
    }

    /**
     * Verify the captcha response and honeypot
     * 
     * @param array $data Typically $_POST
     * @return bool True if valid, false if block/error
     */
    public static function verify(array $data): bool
    {
        // 1. Check Honeypot
        $honeypotName = Config::get('captcha.honeypot_name', 'website_extra');
        if (!empty($data[$honeypotName])) {
            SecurityLogger::log('captcha_failed', [
                'reason' => 'honeypot_triggered',
                'field_value' => $data[$honeypotName]
            ]);
            return false;
        }

        $provider = Config::get('captcha.provider', 'local');

        // 2. Local verification
        if ($provider === 'local') {
            $expected = Session::get('captcha_result');
            $actual = isset($data['captcha_response']) ? (int)$data['captcha_response'] : null;
            
            // Clean up session immediately to prevent replay/re-use
            Session::remove('captcha_result');

            if ($expected === null || $actual !== $expected) {
                SecurityLogger::log('captcha_failed', [
                    'reason' => 'incorrect_math_answer',
                    'expected' => $expected,
                    'actual' => $actual
                ]);
                return false;
            }
            return true;
        }

        // 3. Remote verification
        $secretKey = Config::get('captcha.secret_key', '');
        if (empty($secretKey)) {
            // Fallback to local math if key is missing to prevent breaking page
            error_log("Captcha error: secret key not configured for provider {$provider}");
            return true; 
        }

        if ($provider === 'turnstile') {
            $token = $data['cf-turnstile-response'] ?? '';
            return self::verifyRemote('https://challenges.cloudflare.com/turnstile/v0/siteverify', $secretKey, $token);
        }

        if ($provider === 'recaptcha') {
            $token = $data['g-recaptcha-response'] ?? '';
            return self::verifyRemote('https://www.google.com/recaptcha/api/siteverify', $secretKey, $token);
        }

        return false;
    }

    /**
     * Make remote siteverify post request
     */
    private static function verifyRemote(string $url, string $secret, string $token): bool
    {
        if (empty($token)) {
            SecurityLogger::log('captcha_failed', [
                'reason' => 'remote_token_empty'
            ]);
            return false;
        }

        $ip = $_SERVER['REMOTE_ADDR'] ?? '';
        $postParams = [
            'secret' => $secret,
            'response' => $token,
            'remoteip' => $ip
        ];

        try {
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($postParams));
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_TIMEOUT, 10);
            
            $response = curl_exec($ch);
            $err = curl_error($ch);
            curl_close($ch);

            if ($err) {
                error_log("Curl error during captcha verification: " . $err);
                return false;
            }

            $resData = json_decode($response, true);
            if (isset($resData['success']) && $resData['success'] === true) {
                return true;
            }

            SecurityLogger::log('captcha_failed', [
                'reason' => 'remote_validation_failed',
                'errors' => $resData['error-codes'] ?? []
            ]);
            return false;
        } catch (\Throwable $e) {
            error_log("Exception during captcha verification: " . $e->getMessage());
            return false;
        }
    }
}
