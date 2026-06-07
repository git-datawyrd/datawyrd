<?php
namespace App\Jobs;

class SendEmailJob
{
    /**
     * Executes the job logic.
     * Expects $payload array with 'to', 'subject', 'body'
     *
     * @param array $payload
     * @return void
     * @throws \Exception
     */
    public function handle(array $payload)
    {
        $to = $payload['to'] ?? null;
        $subject = $payload['subject'] ?? null;
        $body = $payload['body'] ?? null;

        if (!$to || !$subject || !$body) {
            throw new \Exception("Missing email parameters in payload");
        }

        // We bypass the global send() which might re-queue it.
        if (!\Core\Config::get('mail_enabled', false)) {
            // Simulated Success if mail is disabled
            return;
        }

        try {
            $mailConfig = \Core\Config::get('mail') ?: [];

            // Use centralized mailer factory — throws RuntimeException if MAIL_HOST missing
            $mail = \Core\Mail::createMailer();

            // Recipients
            $fromName  = $mailConfig['from_name']    ?: \Core\Config::get('business.company_name', 'Data Wyrd');
            $fromEmail = $mailConfig['from_address']  ?? '';
            $mail->setFrom($fromEmail, $fromName);
            $mail->addAddress($to);

            // Content
            $mail->isHTML(true);
            $mail->Subject = $subject;
            $mail->Body    = $body;

            $mail->send();

            \Core\SecurityLogger::log('email_sent', [
                'to' => $to,
                'subject' => $subject
            ], 'INFO');
        } catch (\Exception $e) {
            \Core\SecurityLogger::log('email_failed', [
                'to' => $to,
                'subject' => $subject,
                'error' => $mail->ErrorInfo
            ], 'ERROR');
            throw new \Exception("Failed to send email via PHPMailer: " . $mail->ErrorInfo);
        }
    }
}
