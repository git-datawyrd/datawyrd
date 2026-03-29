<?php
namespace App\Controllers\Api;

use App\Repositories\UserRepository;
use Core\JWT;
use Core\SecurityLogger;

/**
 * UsersController - API for Profile and User Management
 */
class UsersController extends ApiController
{
    private UserRepository $userRepository;

    public function __construct(JWT $jwt, UserRepository $userRepository)
    {
        parent::__construct($jwt);
        $this->userRepository = $userRepository;
    }

    /**
     * GET /api/v1/users/me
     * Return current authenticated user profile
     */
    public function me(): void
    {
        $payload = $this->authenticate();
        
        $user = $this->userRepository->find((int)$payload['id']);
        
        if (!$user) {
            $this->error("User not found", 404);
        }

        // Decrypt sensitive data and strip password
        $user = $this->userRepository->decryptUser($user);
        unset($user['password']);

        $this->json([
            'success' => true,
            'data' => $user
        ]);
    }

    /**
     * POST /api/v1/users/update
     * Update current user profile details
     */
    public function update(): void
    {
        $payload = $this->authenticate();
        $id = (int)$payload['id'];

        $data = json_decode(file_get_contents('php://input'), true);

        if (!$data) {
            $this->error("No data provided", 400);
        }

        // Limit allowed fields for self-update
        $allowed = ['name', 'phone', 'company'];
        $filtered = array_intersect_key($data, array_flip($allowed));

        if (empty($filtered)) {
            $this->error("No valid fields to update", 400);
        }

        try {
            $this->userRepository->update($id, $filtered);
            
            SecurityLogger::log('api_profile_updated', ['user_id' => $id]);

            $this->json([
                'success' => true,
                'message' => 'Profile updated successfully'
            ]);
        } catch (\Exception $e) {
            SecurityLogger::log('API_USER_UPDATE_ERROR', $e->getMessage(), 'ERROR');
            $this->error("Update failed: " . $e->getMessage(), 500);
        }
    }
}
