<?php
namespace App\Controllers\Api;

use Core\Config;
use Core\JWT;
use App\Repositories\MarketingRepository;
use App\Services\Marketing\AutomationService;

/**
 * MarketingController
 *
 * Controlador API público para el módulo de Email Marketing.
 * Expone la ruta POST /api/v1/marketing/subscribe
 */
class MarketingController extends ApiController
{
    private MarketingRepository $repo;

    public function __construct(JWT $jwt, MarketingRepository $repo)
    {
        parent::__construct($jwt);
        $this->repo = $repo;
    }

    /**
     * POST /api/v1/marketing/subscribe
     *
     * Permite a formularios externos registrar una suscripción.
     */
    public function subscribe(): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->error("Método no permitido. Utilizar POST.", 405);
        }

        $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;

        $email  = trim($input['email'] ?? '');
        $listId = isset($input['list_id']) ? (int)$input['list_id'] : null;

        if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $this->error("El correo electrónico proporcionado no es válido.", 400);
        }

        if (empty($listId)) {
            $this->error("El parámetro list_id es obligatorio.", 400);
        }

        // Verificar que la lista existe
        $list = $this->repo->findList($listId);
        if (!$list) {
            $this->error("La lista de contactos especificada no existe.", 404);
        }

        // Validar GDPR Consent
        $gdprRequired = Config::get('marketing.compliance.gdpr_consent_required', false);
        $consentGiven = !empty($input['consent_given']);

        if ($gdprRequired && !$consentGiven) {
            $this->error("Se requiere el consentimiento explícito GDPR para registrar la suscripción.", 400);
        }

        // Verificar si el contacto ya existe en esta lista
        $existing = $this->repo->findContactByEmail($email, $listId);
        if ($existing) {
            $this->json(['success' => true, 'message' => 'El contacto ya se encuentra registrado en la lista.']);
            return;
        }

        // Generar tokens y definir estado según Double Opt-In
        $doubleOptIn = Config::get('marketing.compliance.double_opt_in', false);
        $status      = $doubleOptIn ? 'pending' : 'subscribed';
        $unsubToken  = 'unsub-' . uniqid() . '-' . bin2hex(random_bytes(8));
        
        $ipRaw = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? '';

        $data = [
            'list_id'           => $listId,
            'email'             => $email,
            'first_name'        => trim($input['first_name'] ?? ''),
            'last_name'         => trim($input['last_name'] ?? ''),
            'phone'             => trim($input['phone'] ?? ''),
            'company'           => trim($input['company'] ?? ''),
            'country'           => trim($input['country'] ?? ''),
            'industry'          => trim($input['industry'] ?? ''),
            'tags'              => trim($input['tags'] ?? ''),
            'status'            => $status,
            'source'            => trim($input['source'] ?? 'api'),
            'consent_given'     => $consentGiven ? 1 : 0,
            'consent_ip'        => $consentGiven ? $ipRaw : null,
            'consent_at'        => $consentGiven ? date('Y-m-d H:i:s') : null,
            'unsubscribe_token' => $unsubToken,
        ];

        $contactId = $this->repo->createContact($data);

        if ($doubleOptIn) {
            // Enviar email de confirmación (Double Opt-In)
            $automationService = new AutomationService();
            $automationService->sendDoubleOptInEmail($email, $unsubToken, $data['first_name']);
            
            $this->json([
                'success' => true,
                'message' => 'Suscripción registrada. Correo de confirmación enviado (Double Opt-In).',
                'status'  => 'pending',
            ]);
        } else {
            // Trigger del flujo de bienvenida / signup inmediatamente
            $automationService = new AutomationService();
            $automationService->trigger('signup', [
                'contact_id' => $contactId,
                'email'      => $email,
                'tenant_id'  => Config::get('current_tenant_id', 1),
            ]);

            $this->json([
                'success' => true,
                'message' => 'Suscripción registrada con éxito.',
                'status'  => 'subscribed',
            ]);
        }
    }
}
