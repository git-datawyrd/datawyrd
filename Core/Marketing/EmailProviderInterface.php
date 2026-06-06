<?php
namespace Core\Marketing;

/**
 * Interface EmailProviderInterface
 *
 * Contrato que todo proveedor de envío masivo debe implementar.
 * Permite intercambiar proveedores (ZeptoMail, SMTP, SendGrid, etc.)
 * únicamente cambiando la variable MARKETING_PROVIDER en .env, sin
 * modificar ninguna lógica de negocio.
 *
 * @package Core\Marketing
 */
interface EmailProviderInterface
{
    /**
     * Envía un email de marketing a un destinatario.
     *
     * @param array $message {
     *   @type string $to              Dirección de correo del destinatario
     *   @type string $to_name         Nombre del destinatario (opcional)
     *   @type string $from            Dirección del remitente (override)
     *   @type string $from_name       Nombre del remitente (override)
     *   @type string $reply_to        Dirección de reply-to (opcional)
     *   @type string $subject         Asunto del email
     *   @type string $html_body       Cuerpo HTML
     *   @type string $text_body       Cuerpo texto plano (fallback)
     *   @type array  $headers         Headers HTTP adicionales (List-Unsubscribe, etc.)
     *   @type string $campaign_id     ID de campaña para correlación en logs
     *   @type string $send_log_id     ID del registro en mktg_send_log para actualizar estado
     * }
     * @return array{
     *   success: bool,
     *   provider_message_id: string|null,
     *   error: string|null
     * }
     */
    public function send(array $message): array;

    /**
     * Verifica que las credenciales del proveedor sean válidas.
     * Útil para validación desde el panel de configuración.
     *
     * @return bool
     */
    public function validateCredentials(): bool;

    /**
     * Retorna el nombre legible del proveedor activo.
     *
     * @return string  Ejemplo: 'ZeptoMail', 'SMTP', 'SendGrid'
     */
    public function getProviderName(): string;
}
