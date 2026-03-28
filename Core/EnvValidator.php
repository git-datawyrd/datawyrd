<?php
namespace Core;

/**
 * Validador de Seguridad de Entorno
 */
class EnvValidator
{
    private static $placeholders = [
        'generar_clave_32_caracteres',
        'super-secret-token-change-this',
        'datawyrd-default-secret',
        'tu-access-token-aqui',
        'tu-public-key-aqui'
    ];

    /**
     * Valida que las claves críticas no sean placeholders ni estén vacías en entornos sensibles.
     */
    public static function validate()
    {
        $env = Config::get('ENVIRONMENT');
        
        // En producción y demo somos estrictos
        $strict = in_array($env, ['production', 'demo']);
        
        $criticalKeys = [
            'app_key' => 'APP_KEY',
            'security.jwt_secret' => 'JWT_SECRET'
        ];

        foreach ($criticalKeys as $configKey => $envName) {
            $value = Config::get($configKey);
            
            if (empty($value)) {
                self::fail("La variable de entorno {$envName} está vacía.");
            }

            if (in_array($value, self::$placeholders)) {
                self::fail("La variable de entorno {$envName} utiliza un valor por defecto inseguro (placeholder).");
            }
        }

        // Si es producción, validar también pasarelas
        if ($env === 'production') {
            if (in_array(Config::get('payment.mp_access_token'), self::$placeholders)) {
                self::fail("MERCADOPAGO_ACCESS_TOKEN no configurado para producción.");
            }
        }
    }

    private static function fail($message)
    {
        $env = Config::get('ENVIRONMENT');
        $html = "
        <div style='font-family: sans-serif; padding: 20px; border: 2px solid #ff4444; background: #fff1f1; border-radius: 8px; margin: 20px;'>
            <h2 style='color: #cc0000; margin-top: 0;'>🚨 Error de Seguridad de Entorno</h2>
            <p><strong>Entorno detectado:</strong> {$env}</p>
            <p style='font-size: 1.1em;'>{$message}</p>
            <hr style='border: 0; border-top: 1px solid #ffcccc; margin: 20px 0;'>
            <p style='font-size: 0.9em; color: #666;'>Por razones de seguridad, el sistema no arrancará hasta que se configuren claves únicas y seguras en el archivo .env.</p>
        </div>";
        
        if (php_sapi_name() === 'cli') {
            die("\nERROR DE SEGURIDAD: {$message}\n\n");
        }
        
        die($html);
    }
}
