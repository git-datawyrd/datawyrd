<?php
namespace App\Controllers\Admin;

use Core\Controller;
use Core\Auth;
use Core\Database;

class LogController extends Controller
{
    public function __construct()
    {
        if (!Auth::can('view_logs')) {
            \Core\Session::flash('error', 'Acceso denegado. Se requieren permisos de Auditoría.');
            $this->redirect('/dashboard');
        }
    }

    /**
     * Show Audit Logs
     */
    public function index()
    {
        $db = Database::getInstance()->getConnection();

        $level = $_GET['level'] ?? null;
        $user_id = $_GET['user_id'] ?? null;

        $sql = "SELECT * FROM audit_logs";
        $params = [];
        $where = [];

        if ($level) {
            $where[] = "level = ?";
            $params[] = $level;
        }

        if ($user_id) {
            $where[] = "user_id = ?";
            $params[] = $user_id;
        }

        if ($where) {
            $sql .= " WHERE " . implode(' AND ', $where);
        }

        $sql .= " ORDER BY created_at DESC LIMIT 500";

        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        $logs = $stmt->fetchAll();

        $this->viewLayout('admin/logs/index', 'admin', [
            'title' => 'Logs de Auditoría | Data Wyrd',
            'logs' => $logs
        ]);
    }
}
