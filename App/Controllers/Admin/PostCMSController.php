<?php
namespace App\Controllers\Admin;

use Core\Controller;
use Core\View;
use Core\Session;
use Core\Auth;
use Core\Validator;

class PostCMSController extends Controller
{
    public function getMiddlewares(): array
    {
        return [
            ['name' => 'auth', 'params' => [], 'only' => [], 'except' => []],
            ['name' => 'role', 'params' => ['admin'], 'only' => [], 'except' => []]
        ];
    }

    public function index()
    {
        $this->viewLayout('admin/posts/index', 'admin', [
            'title' => 'Post en RRSS'
        ]);
    }

    /**
     * Handle image upload (not strictly necessary if we do it via JS for preview,
     * but useful for permanent storage if requested later).
     */
    public function upload()
    {
        // For now, the MVP handles everything in client-side JS canvas.
        // This is a placeholder for future backend-integrated features.
        header('Content-Type: application/json');
        echo json_encode(['status' => 'success', 'message' => 'Ready for canvas processing']);
        exit;
    }
}
