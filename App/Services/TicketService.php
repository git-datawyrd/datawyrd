<?php
namespace App\Services;

use App\Domain\Ticket\TicketStatus;
use App\Policies\TicketPolicy;
use App\Validators\TicketValidator;
use Core\Database;
use Core\Mail;
use Core\Session;

/**
 * Ticket Service
 * Orquesta la lógica de negocio de tickets
 */
class TicketService
{
    private $db;
    private $validator;
    private $ticketRepo;
    private $auditService;

    public function __construct(\App\Repositories\TicketRepository $ticketRepo, \PDO $db, \App\Services\AuditService $auditService)
    {
        $this->ticketRepo = $ticketRepo;
        $this->db = $db;
        $this->auditService = $auditService;
        $this->validator = new \App\Validators\TicketValidator();
    }

    /**
     * Crea un nuevo ticket
     */
    public function create(array $data, ?array $user = null): array
    {
        // Validar datos
        if (!$this->validator->validateCreate($data)) {
            return [
                'success' => false,
                'errors' => $this->validator->errors()
            ];
        }

        try {
            $this->db->beginTransaction();

            // Si no hay usuario autenticado, crear o buscar cliente
            if (!$user) {
                $clientId = $this->getOrCreateClient($data);
            } else {
                $clientId = $user['id'];
            }

            // Generar número de ticket
            $ticketNumber = $this->generateTicketNumber();

            // Crear ticket
            $sql = "INSERT INTO tickets (ticket_number, client_id, service_plan_id, subject, description, priority, status, created_at) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

            $stmt = $this->db->prepare($sql);
            $stmt->execute([
                $ticketNumber,
                $clientId,
                $data['service_plan_id'],
                $data['subject'],
                $data['description'],
                $data['priority'] ?? 'normal',
                TicketStatus::OPEN
            ]);

            $ticketId = $this->db->lastInsertId();

            // Registrar en auditoría
            $this->auditService->log('ticket_created', [
                'ticket_id' => $ticketId,
                'ticket_number' => $ticketNumber,
                'client_id' => $clientId
            ]);

            // Dispatch Event (Evolution 2.0) handles notification via Listener
            \Core\EventDispatcher::dispatch(new \App\Events\LeadCreated([
                'ticket_id' => $ticketId,
                'client_id' => $clientId,
                'email' => $data['email'] ?? null
            ]));

            $this->db->commit();

            return [
                'success' => true,
                'ticket_id' => $ticketId,
                'ticket_number' => $ticketNumber
            ];

        } catch (\Exception $e) {
            $this->db->rollBack();

            return [
                'success' => false,
                'errors' => ['general' => [$e->getMessage()]]
            ];
        }
    }

    /**
     * Cambia el estado de un ticket
     */
    public function changeStatus(int $ticketId, string $newStatus, array $user): array
    {
        // Obtener ticket
        $ticket = $this->getTicket($ticketId);

        if (!$ticket) {
            return [
                'success' => false,
                'errors' => ['general' => ['Ticket no encontrado']]
            ];
        }

        // Verificar autorización
        if (!TicketPolicy::canChangeStatus($user, $ticket, $newStatus)) {
            return [
                'success' => false,
                'errors' => ['general' => ['No tienes permisos para cambiar el estado']]
            ];
        }

        // Validar transición de estado
        try {
            $currentStatus = TicketStatus::fromString($ticket['status']);
            $targetStatus = TicketStatus::fromString($newStatus);

            if (!$currentStatus->canTransitionTo($targetStatus)) {
                return [
                    'success' => false,
                    'errors' => ['general' => ['Transición de estado no válida']]
                ];
            }

            // Actualizar estado
            $sql = "UPDATE tickets SET status = ?, updated_at = NOW() WHERE id = ?";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([$newStatus, $ticketId]);

            // Registrar en auditoría
            $this->auditService->log('ticket_status_changed', [
                'ticket_id' => $ticketId,
                'old_status' => $ticket['status'],
                'new_status' => $newStatus,
                'changed_by' => $user['id']
            ]);

            // Enviar notificación
            $this->sendStatusChangeNotification($ticketId, $newStatus);

            return [
                'success' => true,
                'message' => 'Estado actualizado correctamente'
            ];

        } catch (\Exception $e) {
            return [
                'success' => false,
                'errors' => ['general' => [$e->getMessage()]]
            ];
        }
    }

    /**
     * Asigna un ticket a un staff
     */
    public function assign(int $ticketId, int $staffId, array $user): array
    {
        $ticket = $this->getTicket($ticketId);

        if (!$ticket) {
            return [
                'success' => false,
                'errors' => ['general' => ['Ticket no encontrado']]
            ];
        }

        // Verificar autorización
        if (!TicketPolicy::canAssign($user, $ticket)) {
            return [
                'success' => false,
                'errors' => ['general' => ['No tienes permisos para asignar tickets']]
            ];
        }

        try {
            $sql = "UPDATE tickets SET assigned_to = ?, updated_at = NOW() WHERE id = ?";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([$staffId, $ticketId]);

            // Registrar en auditoría
            $this->auditService->log('ticket_assigned', [
                'ticket_id' => $ticketId,
                'assigned_to' => $staffId,
                'assigned_by' => $user['id']
            ]);

            return [
                'success' => true,
                'message' => 'Ticket asignado correctamente'
            ];

        } catch (\Exception $e) {
            return [
                'success' => false,
                'errors' => ['general' => [$e->getMessage()]]
            ];
        }
    }

    /**
     * Obtiene un ticket por ID
     */
    private function getTicket(int $ticketId): ?array
    {
        $sql = "SELECT * FROM tickets WHERE id = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$ticketId]);
        $ticket = $stmt->fetch();

        return $ticket ?: null;
    }

    /**
     * Genera un número único de ticket
     */
    private function generateTicketNumber(): string
    {
        return 'TKT-' . strtoupper(bin2hex(random_bytes(4)));
    }

    /**
     * Obtiene o crea un cliente
     */
    private function getOrCreateClient(array $data): int
    {
        // Buscar cliente existente
        $sql = "SELECT id FROM users WHERE email = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$data['email']]);
        $client = $stmt->fetch();

        if ($client) {
            return $client['id'];
        }

        // Crear nuevo cliente
        $sql = "INSERT INTO users (uuid, name, email, phone, company, password, role, is_active, created_at) 
                VALUES (?, ?, ?, ?, ?, ?, 'client', 1, NOW())";

        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            bin2hex(random_bytes(16)),
            $data['name'],
            $data['email'],
            $data['phone'] ?? null,
            $data['company'] ?? null,
            \Core\Auth::hashPassword(bin2hex(random_bytes(8)))
        ]);

        return $this->db->lastInsertId();
    }

    /**
     * Envía notificación de creación de ticket
     */
    private function sendCreationNotification(int $ticketId, int $clientId): void
    {
        $sql = "SELECT u.email, u.name, t.ticket_number, t.subject 
                FROM tickets t 
                JOIN users u ON t.client_id = u.id 
                WHERE t.id = ?";

        $stmt = $this->db->prepare($sql);
        $stmt->execute([$ticketId]);
        $data = $stmt->fetch();

        if ($data) {
            Mail::send(
                $data['email'],
                "Ticket Creado: {$data['ticket_number']}",
                "Hola {$data['name']}, tu ticket '{$data['subject']}' ha sido creado exitosamente."
            );
        }
    }

    /**
     * Envía notificación de cambio de estado
     */
    private function sendStatusChangeNotification(int $ticketId, string $newStatus): void
    {
        $sql = "SELECT u.email, t.ticket_number 
                FROM tickets t 
                JOIN users u ON t.client_id = u.id 
                WHERE t.id = ?";

        $stmt = $this->db->prepare($sql);
        $stmt->execute([$ticketId]);
        $data = $stmt->fetch();

        if ($data) {
            $status = TicketStatus::fromString($newStatus);
            Mail::sendTicketUpdate($data['email'], $data['ticket_number'], $status->getLabel());
        }
    }
}
