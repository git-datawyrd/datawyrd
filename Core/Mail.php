<?php
namespace Core;

class Mail
{
    /**
     * Send an email by pushing it to the asynchronous Queue
     * 
     * @param string $to Recipient email
     * @param string $subject Email subject
     * @param string $body Email content (HTML)
     * @return bool
     */
    public static function send($to, $subject, $body)
    {
        if (!\Core\Config::get('mail_enabled', false)) {
            return true; // Mail disabled globally, silently skip
        }

        $useQueue = getenv('MAIL_QUEUE') !== 'false';

        if ($useQueue) {
            // Async mode: push to DB queue (needs worker.php running)
            \Core\SecurityLogger::log('email_queued', ['to' => $to, 'subject' => $subject], 'INFO');
            try {
                \Core\Queue::push('App\Jobs\SendEmailJob', [
                    'to' => $to,
                    'subject' => $subject,
                    'body' => $body
                ]);
                return true;
            } catch (\Exception $e) {
                \Core\SecurityLogger::log('email_queue_failed', [
                    'to' => $to,
                    'subject' => $subject,
                    'error' => $e->getMessage()
                ], 'ERROR');
                return false;
            }
        }

        // Sync mode: send directly via PHPMailer (no worker needed — best for shared hosting)
        $mailConfig = \Core\Config::get('mail');
        if (empty($mailConfig['host'])) {
            \Core\SecurityLogger::log('email_failed', ['to' => $to, 'error' => 'MAIL_HOST not set'], 'ERROR');
            return false;
        }

        $mail = new \PHPMailer\PHPMailer\PHPMailer(true);
        try {
            $mail->isSMTP();
            $mail->Host = $mailConfig['host'];
            $mail->SMTPAuth = true;
            $mail->Username = $mailConfig['user'];
            $mail->Password = $mailConfig['pass'];
            $mail->SMTPSecure = strtolower($mailConfig['enc']) === 'tls'
                ? \PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS
                : \PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_SMTPS;
            $mail->Port = $mailConfig['port'] ?: 587;
            $mail->CharSet = 'UTF-8';

            $mail->setFrom($mailConfig['from_address'], $mailConfig['from_name'] ?: 'Data Wyrd');
            $mail->addAddress($to);

            $mail->isHTML(true);
            $mail->Subject = $subject;
            $mail->Body = $body;

            $mail->send();

            \Core\SecurityLogger::log('email_sent', ['to' => $to, 'subject' => $subject], 'INFO');
            return true;
        } catch (\Exception $e) {
            \Core\SecurityLogger::log('email_failed', [
                'to' => $to,
                'subject' => $subject,
                'error' => $mail->ErrorInfo
            ], 'ERROR');
            return false;
        }
    }

    /**
     * Log email content
     */
    private static function log($to, $subject, $body)
    {
        $logPath = BASE_PATH . '/storage/logs/mail.log';
        $timestamp = date('Y-m-d H:i:s');
        $logEntry = "[$timestamp] TO: $to | SUBJECT: $subject\nBODY:\n$body\n" . str_repeat('-', 50) . "\n";

        @file_put_contents($logPath, $logEntry, FILE_APPEND);
    }

    /**
     * Send Welcome Email
     */
    public static function sendWelcome($to, $name, $password)
    {
        $appUrl = rtrim(Config::get('base_url', 'http://localhost/datawyrd'), '/');
        $companyName = Config::get('business.company_name', 'Data Wyrd');
        
        $subject = __('emails.welcome_subject', ['company' => $companyName, 'name' => $name]);
        $body = "
            <div style='font-family: Arial; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;'>
                <h1 style='text-align: center; margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;'>$companyName</h1>
                <p>" . __('emails.welcome_hello', ['name' => $name]) . "</p>
                <p>" . __('emails.welcome_body') . "</p>
                
                <div style='background: #111; padding: 20px; border-radius: 8px; margin: 20px 0; border: 1px solid #D4AF37;'>
                    <p style='margin-top: 0;'><strong>" . __('emails.credentials') . "</strong></p>
                    <p>" . __('emails.username') . ": <span style='color: #30C5FF;'>$to</span></p>
                    <p>" . __('emails.temp_password') . ": <span style='color: #D4AF37;'>$password</span></p>
                </div>

                <div style='text-align: center; margin: 30px 0;'>
                    <a href='{$appUrl}/profile/settings#change-password' style='background: #D4AF37; color: black; padding: 14px 28px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;'>" . __('emails.change_password') . "</a>
                </div>

                <p style='color: #888; font-size: 13px;'>" . __('emails.password_notice') . "</p>
                <hr style='border: 0; border-top: 1px solid #333; margin: 30px 0;'>
                <p style='text-align: center; color: #666;'>" . __('emails.team_signature', ['company' => $companyName]) . "</p>
            </div>
        ";
        return self::send($to, $subject, $body);
    }

    /**
     * Send Ticket Status Update
     */
    public static function sendTicketUpdate($to, $ticketNumber, $status)
    {
        $appUrl = rtrim(Config::get('base_url', 'http://localhost/datawyrd'), '/');
        $subject = __('emails.update_subject', ['number' => $ticketNumber]);
        $body = "
            <div style='font-family: Arial; background: #0A0A0A; color: white; padding: 40px;'>
                <h2 style='margin: 0 0 20px 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;'>" . __('emails.update_title') . "</h2>
                <p>" . __('emails.update_body', ['number' => $ticketNumber, 'status' => $status]) . "</p>
                <p>" . __('emails.check_platform') . "</p>
                <a href='{$appUrl}/dashboard' style='background: #D4AF37; color: black; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-weight: bold;'>" . __('emails.view_ticket') . "</a>
            </div>
        ";
        return self::send($to, $subject, $body);
    }

    /**
     * Send Request Confirmation (PRD v1.0)
     */
    public static function sendRequestConfirmation($to, $name, $ticketNumber, $subject_text)
    {
        $appUrl = rtrim(Config::get('base_url', 'http://localhost/datawyrd'), '/');
        $companyName = Config::get('business.company_name', 'Data Wyrd');
        $slogan = Config::get('business.company_slogan', 'Data Engineering Solutions');
        $subject = __('emails.request_conf_subject', ['number' => $ticketNumber]);
        $body = "
            <div style='font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;'>
                <div style='text-align: center; margin-bottom: 30px;'>
                    <h1 style='margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;'>$companyName</h1>
                    <p style='color: #888; font-size: 14px; text-transform: uppercase; letter-spacing: 2px;'>$slogan</p>
                </div>
                
                <h2 style='color: #30C5FF; text-align: center;'>" . __('emails.request_received') . "</h2>
                <p>" . __('emails.welcome_hello', ['name' => $name]) . "</p>
                <p>" . __('emails.request_body', ['subject' => $subject_text]) . "</p>
                
                <div style='background: #111; padding: 25px; border-radius: 12px; border: 1px solid #333; margin: 30px 0;'>
                    <h4 style='color: #D4AF37; margin-top: 0;'>" . __('emails.what_next') . "</h4>
                    <ul style='padding-left: 20px; color: #ccc; font-size: 14px; line-height: 1.6;'>
                        <li style='margin-bottom: 10px;'>" . __('emails.step_review') . "</li>
                        <li style='margin-bottom: 10px;'>" . __('emails.step_proposal') . "</li>
                        <li style='margin-bottom: 10px;'>" . __('emails.step_activation') . "</li>
                    </ul>
                </div>

                <div style='text-align: center; margin: 40px 0;'>
                    <a href='{$appUrl}/dashboard' style='background: #D4AF37; color: black; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;'>" . __('emails.go_dashboard') . "</a>
                </div>

                <p style='color: #666; font-size: 12px; text-align: center; border-top: 1px solid #222; padding-top: 30px;'>
                    " . __('emails.footer_auto') . "
                </p>
            </div>
        ";
        return self::send($to, $subject, $body);
    }

    /**
     * Send Budget Available
     */
    public static function sendBudgetAvailable($to, $name, $budgetNumber, $budgetId)
    {
        $appUrl = rtrim(Config::get('base_url', 'http://localhost/datawyrd'), '/');
        $companyName = Config::get('business.company_name', 'Data Wyrd');
        $slogan = Config::get('business.company_slogan', 'Data Engineering Solutions');
        $subject = __('emails.budget_subject', ['number' => $budgetNumber]);
        $body = "
            <div style='font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;'>
                <div style='text-align: center; margin-bottom: 30px;'>
                    <h1 style='margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;'>$companyName</h1>
                    <p style='color: #888; font-size: 14px; text-transform: uppercase; letter-spacing: 2px;'>$slogan</p>
                </div>
                
                <h2 style='color: #30C5FF; text-align: center;'>" . __('emails.budget_title') . "</h2>
                <p>" . __('emails.welcome_hello', ['name' => $name]) . "</p>
                <p>" . __('emails.budget_body', ['number' => $budgetNumber]) . "</p>
                
                <div style='background: #111; padding: 25px; border-radius: 12px; border: 1px solid #333; margin: 30px 0; text-align: center;'>
                    <p style='color: #ccc; font-size: 15px; margin-bottom: 20px;'>" . __('emails.budget_desc') . "</p>
                    <a href='{$appUrl}/budget/show/{$budgetId}' style='background: #D4AF37; color: black; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;'>" . __('emails.view_proposal') . "</a>
                </div>

                <p style='color: #666; font-size: 12px; text-align: center; border-top: 1px solid #222; padding-top: 30px;'>
                    " . __('emails.budget_footer') . "
                </p>
            </div>
        ";
        return self::send($to, $subject, $body);
    }

    /**
     * Send Urgent Support Notification
     */
    public static function sendUrgentSupport($to, $clientName, $clientEmail, $ticketId)
    {
        $appUrl = rtrim(Config::get('base_url', 'http://localhost/datawyrd'), '/');
        $subject = __('emails.urgent_subject', ['name' => $clientName]);
        $body = "
            <div style='font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #D4AF37;'>
                <h2 style='color: #FF5555; text-align: center;'>" . __('emails.urgent_title') . "</h2>
                <p>" . __('emails.urgent_body', ['name' => $clientName, 'email' => $clientEmail]) . "</p>
                
                <div style='background: #111; padding: 20px; border-radius: 8px; border: 1px solid #333; margin: 20px 0;'>
                    <p><strong>" . __('emails.related_ticket') . "</strong> #$ticketId</p>
                    <p><strong>" . __('emails.urgent_status') . "</strong></p>
                </div>

                <div style='text-align: center; margin: 30px 0;'>
                    <a href='{$appUrl}/ticket/detail/$ticketId' style='background: #30C5FF; color: black; padding: 14px 28px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;'>" . __('emails.attend_request') . "</a>
                </div>
            </div>
        ";
        return self::send($to, $subject, $body);
    }
}
