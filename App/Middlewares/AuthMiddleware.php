<?php
namespace App\Middlewares;

use Core\Middleware;
use Core\Auth;
use Core\Session;

/**
 * Validates that a user is authenticated
 */
class AuthMiddleware implements Middleware
{
    public function handle($params = [])
    {
        if (!Auth::check()) {
            Session::flash('error', 'Debes iniciar sesión para acceder a esta sección.');
            header('Location: ' . url('auth/login'));
            exit;
        }
    }
}
