<?php
namespace Core\Marketing;

/**
 * Servicio encargado de validar la salud del dominio (SPF y DKIM).
 * Potencia la entregabilidad (Deliverability) evitando caer en SPAM.
 */
class DnsValidator
{
    /**
     * Valida el registro SPF del dominio.
     * Retorna array con estado, mensaje y raw data.
     */
    public function checkSPF(string $domain): array
    {
        if (empty($domain)) {
            return ['status' => false, 'message' => 'Dominio no proporcionado.', 'raw' => null];
        }

        // Consultar registros TXT
        $records = @dns_get_record($domain, DNS_TXT);
        
        if ($records === false) {
            return ['status' => false, 'message' => 'Error al consultar DNS o dominio inexistente.', 'raw' => null];
        }

        $spfRecord = null;
        foreach ($records as $record) {
            if (isset($record['txt']) && stripos($record['txt'], 'v=spf1') === 0) {
                $spfRecord = $record['txt'];
                break;
            }
        }

        if ($spfRecord) {
            return [
                'status' => true,
                'message' => 'Registro SPF encontrado y válido.',
                'raw' => $spfRecord
            ];
        }

        return [
            'status' => false,
            'message' => 'No se encontró un registro SPF (v=spf1) en el dominio.',
            'raw' => null
        ];
    }

    /**
     * Valida el registro DKIM del dominio utilizando el selector indicado.
     * Si no se provee selector, puede retornar falso a menos que intente default.
     */
    public function checkDKIM(string $domain, string $selector): array
    {
        if (empty($domain) || empty($selector)) {
            return ['status' => false, 'message' => 'Dominio o Selector DKIM no proporcionados.', 'raw' => null];
        }

        $dkimDomain = $selector . '._domainkey.' . $domain;
        
        $records = @dns_get_record($dkimDomain, DNS_TXT);

        if ($records === false || empty($records)) {
            return ['status' => false, 'message' => "No se encontraron registros para {$dkimDomain}.", 'raw' => null];
        }

        $dkimRecord = null;
        foreach ($records as $record) {
            if (isset($record['txt']) && (stripos($record['txt'], 'v=DKIM1') !== false || stripos($record['txt'], 'p=') !== false)) {
                $dkimRecord = $record['txt'];
                break;
            }
        }

        if ($dkimRecord) {
            return [
                'status' => true,
                'message' => 'Registro DKIM encontrado.',
                'raw' => $dkimRecord
            ];
        }

        return [
            'status' => false,
            'message' => 'El registro TXT no parece ser un DKIM válido.',
            'raw' => null
        ];
    }
}
