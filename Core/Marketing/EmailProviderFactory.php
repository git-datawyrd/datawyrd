<?php
namespace Core\Marketing;

use Core\Config;

/**
 * EmailProviderFactory
 *
 * Resuelve e instancia el proveedor de email activo según la variable
 * MARKETING_PROVIDER del entorno. Centraliza el punto de cambio de
 * proveedor — cero hardcodeo en los servicios consumidores.
 *
 * Uso:
 *   $provider = EmailProviderFactory::make();
 *   $result   = $provider->send([...]);
 *
 * @package Core\Marketing
 */
class EmailProviderFactory
{
    private static ?EmailProviderInterface $instance = null;

    /**
     * Retorna la instancia singleton del proveedor activo.
     * Se puede forzar refresh pasando $fresh = true (útil en tests).
     *
     * @param bool $fresh
     * @return EmailProviderInterface
     * @throws \RuntimeException si el proveedor configurado no existe
     */
    public static function make(bool $fresh = false): EmailProviderInterface
    {
        if (!$fresh && self::$instance !== null) {
            return self::$instance;
        }

        $provider = strtolower(Config::get('marketing.provider', 'smtp'));

        self::$instance = match ($provider) {
            'zepto'     => new ZeptoMailProvider(),
            'smtp'      => new SmtpMarketingProvider(),
            default     => throw new \RuntimeException(
                "Proveedor de marketing '{$provider}' no soportado. "
                . "Opciones válidas: zepto, smtp"
            ),
        };

        return self::$instance;
    }
}
