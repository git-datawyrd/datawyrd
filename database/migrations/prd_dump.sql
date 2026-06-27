-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 07-06-2026 a las 16:44:51
-- Versión del servidor: 11.8.6-MariaDB-log
-- Versión de PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `u375689977_datawyrd`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `active_services`
--

CREATE TABLE `active_services` (
  `id` int(10) UNSIGNED NOT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `ticket_id` int(10) UNSIGNED NOT NULL,
  `invoice_id` int(10) UNSIGNED NOT NULL,
  `service_plan_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('active','pending','in_progress','on_hold','completed','cancelled') DEFAULT 'active',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `renewal_date` date DEFAULT NULL,
  `activated_by` int(10) UNSIGNED NOT NULL,
  `total_deliverables` int(10) UNSIGNED DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `tenant_id` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Representa proyectos o servicios en ejecución (antiguo projects)';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `request_id` char(16) DEFAULT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `user_email` varchar(255) NOT NULL COMMENT 'Email del usuario o "guest"',
  `user_role` varchar(50) NOT NULL COMMENT 'Rol del usuario',
  `action` varchar(100) NOT NULL COMMENT 'Nombre de la acción realizada',
  `details` text DEFAULT NULL COMMENT 'Detalles adicionales en JSON',
  `level` enum('INFO','WARN','ERROR') NOT NULL DEFAULT 'INFO' COMMENT 'Nivel de log',
  `ip_address` varchar(45) NOT NULL COMMENT 'Dirección IP del usuario',
  `user_agent` varchar(255) DEFAULT NULL COMMENT 'User agent del navegador',
  `request_uri` varchar(255) DEFAULT NULL COMMENT 'URI de la petición',
  `request_method` varchar(10) DEFAULT NULL COMMENT 'Método HTTP (GET, POST, etc.)',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `signature_hash` varchar(255) DEFAULT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de auditoría de acciones críticas';

--
-- Volcado de datos para la tabla `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `request_id`, `user_id`, `user_email`, `user_role`, `action`, `details`, `level`, `ip_address`, `user_agent`, `request_uri`, `request_method`, `created_at`, `signature_hash`, `tenant_id`) VALUES
(1, NULL, 1, 'admin@datawyrd.com', 'admin', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-18 01:17:27', NULL, 1),
(2, NULL, 1, 'admin@datawyrd.com', 'admin', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-18 01:21:05', NULL, 1),
(3, NULL, 1, 'admin@datawyrd.com', 'admin', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-18 01:24:38', NULL, 1),
(4, NULL, 1, 'admin@datawyrd.com', 'admin', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-18 01:24:51', NULL, 1),
(5, NULL, NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-0EA203\",\"email\":\"yurysmith77@gmail.com\",\"subject\":\"Solicitud: Data Pipeline Pro - B\\u00e1sico\"}', 'INFO', '2800:2260:4000:49:a451:55d4:5b2a:ce02', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '/demo/datawyrd/ticket/submit', 'POST', '2026-02-19 18:52:04', NULL, 1),
(6, NULL, NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-F55193\",\"email\":\"yurysmith77@gmail.com\",\"subject\":\"quiero una\"}', 'INFO', '2800:2260:4000:49:a451:55d4:5b2a:ce02', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '/demo/datawyrd/ticket/submit', 'POST', '2026-02-19 19:01:55', NULL, 1),
(7, NULL, NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '190.19.217.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-19 19:13:52', NULL, 1),
(8, NULL, NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-6CE0D8\",\"email\":\"yurysmith77@gmail.com\",\"subject\":\"quiero una\"}', 'INFO', '190.19.217.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '/demo/datawyrd/ticket/submit', 'POST', '2026-02-19 19:15:13', NULL, 1),
(9, NULL, NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '190.19.217.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-19 19:15:31', NULL, 1),
(10, NULL, NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '190.19.217.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-19 19:15:50', NULL, 1),
(11, NULL, 1, 'admin@datawyrd.com', 'admin', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 16:07:47', NULL, 1),
(12, NULL, 1, 'admin@datawyrd.com', 'admin', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 17:00:59', NULL, 1),
(13, NULL, 1, 'admin@datawyrd.com', 'admin', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 17:04:41', NULL, 1),
(14, NULL, 4, 'yurysmith77@gmail.com', 'client', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 18:00:42', NULL, 1),
(15, NULL, 4, 'yurysmith77@gmail.com', 'client', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 18:01:02', NULL, 1),
(16, NULL, 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '{\"message\":\"Administrador elimin\\u00f3 permanentemente al usuario ID: 4\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/admin/users/destroy/4', 'GET', '2026-02-21 18:01:10', NULL, 1),
(17, NULL, NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-CE8223\",\"email\":\"yurysmith@yahoo.com\",\"subject\":\"Quiero servicio\"}', 'INFO', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/ticket/submit', 'POST', '2026-02-21 18:03:37', NULL, 1),
(18, NULL, 5, 'yurysmith@yahoo.com', 'client', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 18:19:26', NULL, 1),
(19, NULL, 1, 'admin@datawyrd.com', 'admin', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 20:41:48', NULL, 1),
(20, NULL, NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-D08990\",\"email\":\"hboadar@gmail.com\",\"subject\":\"Solicitud: Sistemas Web Complejos - B\\u00e1sico\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/ticket/submit', 'POST', '2026-02-21 20:42:49', NULL, 1),
(21, NULL, 6, 'hboadar@gmail.com', 'client', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 20:47:06', NULL, 1),
(22, NULL, 1, 'admin@datawyrd.com', 'admin', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 20:47:21', NULL, 1),
(23, NULL, 1, 'admin@datawyrd.com', 'admin', 'ticket_status_changed', '{\"ticket_id\":\"5\",\"ticket_number\":\"TKT-D08990\",\"new_status\":\"budget_sent\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/ticket/updateStatus', 'POST', '2026-02-21 20:48:55', NULL, 1),
(24, NULL, 1, 'admin@datawyrd.com', 'admin', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 20:49:11', NULL, 1),
(25, NULL, NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"hboadar@gmail.com\"}', 'WARN', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 20:50:27', NULL, 1),
(26, NULL, 6, 'hboadar@gmail.com', 'client', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 20:50:47', NULL, 1),
(27, NULL, 6, 'hboadar@gmail.com', 'client', 'password_changed', '{\"message\":\"Usuario actualiz\\u00f3 su contrase\\u00f1a.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/profile/updatePassword', 'POST', '2026-02-21 20:51:15', NULL, 1),
(28, NULL, 6, 'hboadar@gmail.com', 'client', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 20:55:59', NULL, 1),
(29, NULL, 1, 'admin@datawyrd.com', 'admin', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 20:56:12', NULL, 1),
(30, NULL, NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"yurysmith@yahoo.com\"}', 'WARN', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 20:58:34', NULL, 1),
(31, NULL, NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"yurysmith@yahoo.com\"}', 'WARN', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 20:58:57', NULL, 1),
(32, NULL, NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"yurysmith@yahoo.com\"}', 'WARN', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 20:59:22', NULL, 1),
(33, NULL, 5, 'yurysmith@yahoo.com', 'client', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 20:59:42', NULL, 1),
(34, NULL, 5, 'yurysmith@yahoo.com', 'client', 'invoice_generated', '{\"invoice_id\":\"1\",\"budget_id\":6}', 'INFO', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/budget/decision', 'POST', '2026-02-21 21:01:17', NULL, 1),
(35, NULL, 5, 'yurysmith@yahoo.com', 'client', 'payment_receipt_uploaded', '{\"invoice_id\":\"1\",\"filename\":\"45ac0204afae64fcd59a70de1f269ee3_1771707727.pdf\"}', 'INFO', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/invoice/pay', 'POST', '2026-02-21 21:02:07', NULL, 1),
(36, NULL, 1, 'admin@datawyrd.com', 'admin', 'ticket_status_changed', '{\"ticket_id\":\"4\",\"ticket_number\":\"TKT-CE8223\",\"new_status\":\"budget_approved\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/ticket/updateStatus', 'POST', '2026-02-21 21:03:12', NULL, 1),
(37, NULL, 1, 'admin@datawyrd.com', 'admin', 'invoice_partial_payment', '{\"invoice_id\":1,\"amount\":100}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/invoice/confirm/1', 'GET', '2026-02-21 21:03:54', NULL, 1),
(38, NULL, 5, 'yurysmith@yahoo.com', 'client', '2fa_enabled', '{\"message\":\"Usuario activ\\u00f3 la autenticaci\\u00f3n de dos factores.\"}', 'INFO', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd//profile/confirm2FA', 'POST', '2026-02-21 21:10:13', NULL, 1),
(39, NULL, 5, 'yurysmith@yahoo.com', 'client', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 21:10:29', NULL, 1),
(40, NULL, 5, 'yurysmith@yahoo.com', 'client', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:79e1:d2db:8c92:332e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/demo/datawyrd/auth/verify2FA', 'POST', '2026-02-21 21:11:07', NULL, 1),
(41, NULL, 1, 'admin@datawyrd.com', 'admin', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 21:28:59', NULL, 1),
(42, NULL, 6, 'hboadar@gmail.com', 'client', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 21:29:08', NULL, 1),
(43, NULL, 6, 'hboadar@gmail.com', 'client', 'invoice_generated', '{\"invoice_id\":\"2\",\"budget_id\":7}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/budget/decision', 'POST', '2026-02-21 21:29:57', NULL, 1),
(44, NULL, 6, 'hboadar@gmail.com', 'client', 'payment_receipt_uploaded', '{\"invoice_id\":\"2\",\"filename\":\"de1215a74571e9ae97367128c74595a1_1771709433.png\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/invoice/pay', 'POST', '2026-02-21 21:30:33', NULL, 1),
(45, NULL, 6, 'hboadar@gmail.com', 'client', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 21:30:56', NULL, 1),
(46, NULL, 6, 'hboadar@gmail.com', 'client', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 21:31:08', NULL, 1),
(47, NULL, 6, 'hboadar@gmail.com', 'client', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 21:31:26', NULL, 1),
(48, NULL, 1, 'admin@datawyrd.com', 'admin', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 21:31:37', NULL, 1),
(49, NULL, 1, 'admin@datawyrd.com', 'admin', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 22:34:23', NULL, 1),
(50, NULL, NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 22:37:47', NULL, 1),
(51, NULL, 1, 'admin@datawyrd.com', 'admin', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 22:37:54', NULL, 1),
(52, NULL, 1, 'admin@datawyrd.com', 'admin', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 22:39:07', NULL, 1),
(53, NULL, 6, 'hboadar@gmail.com', 'client', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-21 23:52:42', NULL, 1),
(54, NULL, 6, 'hboadar@gmail.com', 'client', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-21 23:53:23', NULL, 1),
(55, NULL, NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"hboadar@gmail.com\"}', 'WARN', '201.216.219.154', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-22 02:04:41', NULL, 1),
(56, NULL, 6, 'hboadar@gmail.com', 'client', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '201.216.219.154', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-22 02:04:53', NULL, 1),
(57, NULL, 1, 'admin@datawyrd.com', 'admin', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-22 11:56:40', NULL, 1),
(58, NULL, 1, 'admin@datawyrd.com', 'admin', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-22 11:59:39', NULL, 1),
(59, NULL, 1, 'admin@datawyrd.com', 'admin', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-22 12:07:12', NULL, 1),
(60, NULL, 1, 'admin@datawyrd.com', 'admin', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-22 12:46:57', NULL, 1),
(61, NULL, 1, 'admin@datawyrd.com', 'admin', 'login_success', '{\"message\":\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-22 12:48:15', NULL, 1),
(62, NULL, 1, 'admin@datawyrd.com', 'admin', 'logout', '{\"message\":\"Usuario cerr\\u00f3 sesi\\u00f3n.\"}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-22 12:49:00', NULL, 1),
(63, '94a929c60fb5d7e8', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-22 23:34:33', NULL, 1),
(64, '6039fae93698df83', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-22 23:35:31', NULL, 1),
(65, '4bc5a8f8eb401582', 6, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-22 23:35:42', NULL, 1),
(66, '2b7d6736b39e0151', 6, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-22 23:36:28', NULL, 1),
(67, '6fad152553ac4cd6', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-22 23:36:36', NULL, 1),
(68, 'fbe1f49f32f49fe9', 1, 'admin@datawyrd.com', 'admin', 'invoice_partial_payment', '{\"invoice_id\":2,\"amount\":1668}', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/invoice/confirm/2', 'GET', '2026-02-22 23:37:21', NULL, 1),
(69, '1978570c6c1b6b7b', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:e843:74a8:b527:3845', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-22 23:38:02', NULL, 1),
(70, 'b093f44e5143970d', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-28 14:56:18', NULL, 1),
(71, '565247ab136d7f1e', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-02-28 14:56:56', NULL, 1),
(72, 'bbd147dc500224bc', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-28 15:54:14', NULL, 1),
(73, '22fbc189a64ca5f2', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-02-28 22:34:54', NULL, 1),
(74, '21cefc828e3321be', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-03-01 01:24:03', NULL, 1),
(75, 'c370be3b670bcfd9', 6, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.210.32.221', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-01 01:48:58', NULL, 1),
(76, '50ca56157e61cef7', 6, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '190.210.32.221', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/auth/logout', 'GET', '2026-03-01 01:49:14', NULL, 1),
(77, 'a954885302926e09', 6, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-01 17:26:01', NULL, 1),
(78, 'b1696e50cd769ce6', 6, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-03-01 17:46:32', NULL, 1),
(79, 'bde5d70837a7dc5f', 6, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-01 17:46:47', NULL, 1),
(80, '28827a1b45c35c75', 6, 'hboadar@gmail.com', 'client', 'payment_receipt_uploaded', '{\"invoice_id\":\"2\",\"filename\":\"133083359232f625d5402aedb6feface_1772387267.png\"}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/invoice/pay', 'POST', '2026-03-01 17:47:47', NULL, 1),
(81, '127447e465ba7aa6', 6, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-03-01 17:47:56', NULL, 1),
(82, '45f1e3ea837e65e4', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-01 17:48:04', NULL, 1),
(83, '376195264bfef2f3', 1, 'admin@datawyrd.com', 'admin', 'service_activated', '{\"invoice_id\":2,\"client_id\":6,\"partial_pay\":false}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/invoice/confirm/2', 'GET', '2026-03-01 17:48:22', NULL, 1),
(84, '376195264bfef2f3', 1, 'admin@datawyrd.com', 'admin', 'event_dispatched', '{\"event\":\"App\\\\Events\\\\ProjectStarted\",\"timestamp\":1772387302.634823}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/invoice/confirm/2', 'GET', '2026-03-01 17:48:22', NULL, 1),
(85, '376195264bfef2f3', 1, 'admin@datawyrd.com', 'admin', 'invoice_paid', '{\"invoice_id\":2}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/invoice/confirm/2', 'GET', '2026-03-01 17:48:22', NULL, 1),
(86, '3b1815dd80eb049d', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-03-01 17:49:18', NULL, 1),
(87, '38b346e535ff6a72', 6, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-01 17:49:26', NULL, 1),
(88, '1e2d3be761a95c99', 6, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-03-01 17:51:47', NULL, 1),
(89, 'fa5a652f47a74db8', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-01 17:51:57', NULL, 1),
(90, '1595984713975546', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-03-01 21:13:04', NULL, 1),
(91, '7f51010fb579c234', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-01 21:14:21', NULL, 1),
(92, '806fe05b94b9a45c', 6, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '186.157.102.16', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-02 20:45:05', NULL, 1),
(93, '27fc8e97af80f78a', 6, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '186.157.102.16', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/auth/logout', 'GET', '2026-03-02 20:45:56', NULL, 1),
(94, '26231d07d6e9f647', NULL, 'guest', 'guest', 'email_queued', '{\"to\":\"culerias@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Humberto Boada!\"}', 'INFO', '181.239.21.134', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/ticket/submit', 'POST', '2026-03-03 10:06:30', NULL, 1),
(95, '26231d07d6e9f647', NULL, 'guest', 'guest', 'email_queued', '{\"to\":\"culerias@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-152AAB\"}', 'INFO', '181.239.21.134', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/ticket/submit', 'POST', '2026-03-03 10:06:30', NULL, 1),
(96, '26231d07d6e9f647', NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-152AAB\",\"email\":\"culerias@gmail.com\",\"subject\":\"Solicitud: Dashboard Enterprise - Medio\"}', 'INFO', '181.239.21.134', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/ticket/submit', 'POST', '2026-03-03 10:06:30', NULL, 1),
(97, '090b64147b6ff70d', 7, 'culerias@gmail.com', 'client', 'password_changed', '\"Usuario actualiz\\u00f3 su contrase\\u00f1a.\"', 'INFO', '181.239.21.134', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/profile/updatePassword', 'POST', '2026-03-03 10:07:49', NULL, 1),
(98, 'b7e5569e0d4cb23b', 7, 'culerias@gmail.com', 'client', 'email_queued', '{\"to\":\"contacto@datawyrd.com\",\"subject\":\"[URGENTE] Soporte Prioritario: Humberto Boada\"}', 'INFO', '181.239.21.134', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/dashboard/urgentSupport', 'GET', '2026-03-03 10:08:07', NULL, 1),
(99, '67abc8f4b21380c6', 7, 'culerias@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '181.239.21.134', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/auth/logout', 'GET', '2026-03-03 10:15:19', NULL, 1),
(100, 'fcbf4339ed8614de', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '181.239.21.134', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-03 10:15:35', NULL, 1),
(101, '72d7fb9a1da5b875', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '181.239.21.134', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-03 10:15:50', NULL, 1),
(102, '8606e0b34d2f8c07', 6, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-03 23:23:16', NULL, 1),
(103, '04c15ba9ec51ec03', 6, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-03-03 23:23:22', NULL, 1),
(104, 'f0ccd5c494ea1d52', 6, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-03 23:50:28', NULL, 1),
(105, 'c0acfa5d3b7e0b97', 6, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-03 23:51:22', NULL, 1),
(106, '03b9119575d668c6', 6, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-03 23:57:38', NULL, 1),
(107, '554b037e24ad2e3a', 6, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-03 23:57:43', NULL, 1),
(108, '0922bc948fedbcee', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-04 00:14:42', NULL, 1),
(109, '92f5597a64a94509', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-04 00:20:34', NULL, 1),
(110, '68310214a8d5acd7', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-04 00:36:56', NULL, 1),
(111, '92e4f88d0afb4c3c', NULL, 'guest', 'guest', 'email_queued', '{\"to\":\"yurysmith77@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Yury Luther Smith Tellez!\"}', 'INFO', '2800:2260:4000:49:c050:e58:c168:e1b5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/ticket/submit', 'POST', '2026-03-04 00:38:44', NULL, 1),
(112, '92e4f88d0afb4c3c', NULL, 'guest', 'guest', 'email_queued', '{\"to\":\"yurysmith77@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-513F09\"}', 'INFO', '2800:2260:4000:49:c050:e58:c168:e1b5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/ticket/submit', 'POST', '2026-03-04 00:38:44', NULL, 1),
(113, '92e4f88d0afb4c3c', NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-513F09\",\"email\":\"yurysmith77@gmail.com\",\"subject\":\"Solicitud: Dashboard Enterprise - Medio\"}', 'INFO', '2800:2260:4000:49:c050:e58:c168:e1b5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/ticket/submit', 'POST', '2026-03-04 00:38:44', NULL, 1),
(114, 'e26acbf8c2c992f7', 8, 'yurysmith77@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:2260:4000:49:c050:e58:c168:e1b5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/auth/logout', 'GET', '2026-03-04 00:46:42', NULL, 1),
(115, '27c4cf5d78f0175c', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"luther.smith@datawyrd.com\"}', 'WARN', '2800:2260:4000:49:c050:e58:c168:e1b5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/auth/doLogin', 'POST', '2026-03-04 00:50:05', NULL, 1),
(116, '5f68ba44b8dd6bfd', 3, 'luther.smith@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.19.217.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/auth/doLogin', 'POST', '2026-03-04 00:51:33', NULL, 1),
(117, '391e56dd96b4ac8c', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-04 00:53:09', NULL, 1),
(118, '598fc080788b1404', 3, 'luther.smith@datawyrd.com', 'admin', 'email_queued', '{\"to\":\"yurysmith77@gmail.com\",\"subject\":\"Presupuesto Disponible: DW-B2026-1D0B\"}', 'INFO', '2800:2260:4000:49:c050:e58:c168:e1b5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/budget/store', 'POST', '2026-03-04 01:03:18', NULL, 1),
(119, 'ef970327db21bbd1', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"yurysmith77@gmail.com\"}', 'WARN', '190.19.217.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-04 01:04:46', NULL, 1),
(120, '58bc8fcb7f5ebfa0', NULL, 'guest', 'guest', 'email_queued', '{\"to\":\"yurysmith@yahoo.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-ECED57\"}', 'INFO', '190.19.217.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/ticket/submit', 'POST', '2026-03-04 01:09:47', NULL, 1),
(121, '58bc8fcb7f5ebfa0', NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-ECED57\",\"email\":\"yurysmith@yahoo.com\",\"subject\":\"Solicitud: Data Pipeline Pro - Medio\"}', 'INFO', '190.19.217.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/ticket/submit', 'POST', '2026-03-04 01:09:47', NULL, 1),
(122, '0e0cac37a05862db', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-04 01:10:47', NULL, 1),
(123, 'c87e90b9bfe5a84c', 1, 'admin@datawyrd.com', 'admin', 'email_queued', '{\"to\":\"culerias@gmail.com\",\"subject\":\"Presupuesto Disponible: DW-B2026-08CE\"}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/budget/store', 'POST', '2026-03-04 01:13:39', NULL, 1),
(124, 'f67859157ce654c6', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-03-04 01:14:39', NULL, 1),
(125, '251b625c7986746a', 6, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-04 12:27:33', NULL, 1),
(126, '63243687033f917e', 6, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-04 12:27:46', NULL, 1),
(127, 'fa1feb816ac1ec75', 7, 'culerias@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-04 12:28:00', NULL, 1),
(128, '61e5810b4bbb5acc', 7, 'culerias@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-04 12:29:06', NULL, 1),
(129, 'e10f8b31065cb1e8', 7, 'culerias@gmail.com', 'client', 'invoice_generated', '{\"invoice_id\":\"7\",\"budget_id\":9}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/budget/decision', 'POST', '2026-03-04 09:50:00', '35bafc7262c9162c3926a578dd1cc02875094da67aeb17dc5dece22beda81ceb', 1),
(130, 'e10f8b31065cb1e8', 7, 'culerias@gmail.com', 'client', 'event_dispatched', '{\"event\":\"App\\\\Events\\\\InvoiceIssued\",\"timestamp\":1772628600.216499}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/budget/decision', 'POST', '2026-03-04 12:50:00', NULL, 1),
(131, '019ae2aa0ffcdef5', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '190.210.32.221', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/145.0.7632.113 Mobile Safari/537.36 Instagram 418.0.0.51.77 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789;', '/auth/doLogin', 'POST', '2026-03-04 13:00:44', NULL, 1),
(132, '52cb0a4e20dc9239', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.210.32.221', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/145.0.7632.113 Mobile Safari/537.36 Instagram 418.0.0.51.77 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789;', '/auth/doLogin', 'POST', '2026-03-04 13:01:00', NULL, 1),
(133, '8597b0111a1b576c', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '190.210.32.221', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/145.0.7632.113 Mobile Safari/537.36 Instagram 418.0.0.51.77 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789;', '/auth/logout', 'GET', '2026-03-04 15:03:30', NULL, 1),
(134, '99b4a27f7c5ae375', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.210.32.221', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/145.0.7632.113 Mobile Safari/537.36 Instagram 418.0.0.51.77 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789;', '/auth/doLogin', 'POST', '2026-03-04 15:18:17', NULL, 1),
(135, '93347d6446d19e73', 7, 'culerias@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-04 17:47:19', NULL, 1);
INSERT INTO `audit_logs` (`id`, `request_id`, `user_id`, `user_email`, `user_role`, `action`, `details`, `level`, `ip_address`, `user_agent`, `request_uri`, `request_method`, `created_at`, `signature_hash`, `tenant_id`) VALUES
(136, 'c38fe43d6e22ae86', 7, 'culerias@gmail.com', 'client', 'payment_receipt_uploaded', '{\"invoice_id\":\"7\",\"filename\":\"2e30c5a1582ed0fe05cebbae4cd9efa9_1772646494.png\"}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/invoice/pay', 'POST', '2026-03-04 17:48:14', NULL, 1),
(137, '351310243b357f96', 7, 'culerias@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-04 17:48:27', NULL, 1),
(138, '4c5dde1d9e51bc9f', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-04 17:48:37', NULL, 1),
(139, '7bf890e74724edb7', 1, 'admin@datawyrd.com', 'admin', 'service_activated', '{\"invoice_id\":7,\"client_id\":7,\"partial_pay\":false}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/invoice/confirm/7', 'GET', '2026-03-04 14:49:09', 'b01d7dc51278c46e6d3f0d7a182b2edccbf389fcc4d0b5bf1a40633490f97268', 1),
(140, '7bf890e74724edb7', 1, 'admin@datawyrd.com', 'admin', 'event_dispatched', '{\"event\":\"App\\\\Events\\\\ProjectStarted\",\"timestamp\":1772646549.008613}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/invoice/confirm/7', 'GET', '2026-03-04 17:49:09', NULL, 1),
(141, '7bf890e74724edb7', 1, 'admin@datawyrd.com', 'admin', 'invoice_paid', '{\"invoice_id\":7}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/invoice/confirm/7', 'GET', '2026-03-04 14:49:09', '52cb0b8ea0de087f874867fb87e96f869e1060225afc694dff4cd5a1bb4f7ed5', 1),
(142, '778c0c60bbaa7ca9', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-04 17:49:53', NULL, 1),
(143, 'bd2caf51d584e1e0', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-04 17:50:34', NULL, 1),
(144, 'bab6dd3f80af4da6', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-03-04 17:51:00', NULL, 1),
(145, '0c74862bb2a48b02', 7, 'culerias@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/doLogin', 'POST', '2026-03-04 17:51:10', NULL, 1),
(146, '9cd8ddb6d0e8f7c9', 7, 'culerias@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/demo/datawyrd/auth/logout', 'GET', '2026-03-04 17:51:36', NULL, 1),
(147, '343909d286d4b120', 6, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-04 19:17:30', NULL, 1),
(148, '4fcf29db6e73aae5', 6, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-04 16:53:46', 'c2807996b17e9ed668d6489551e86dd26b688370780e3411e21bf3fbc7706ec5', 1),
(149, '943169ac6799f677', 7, 'culerias@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-04 16:54:21', '5327c66f1876c7313d001010ef544b19bcae493b401588c5d17b7ed9402ff597', 1),
(150, '6fdf5a2e346f2dfa', 7, 'culerias@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-04 16:55:10', '2bc26f12e5c3350672ff1a6be69b214050da0bced98f9a7da232ee483e502fdd', 1),
(151, '8427a16769781779', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-04 16:55:20', '06f7c9442c9d73dbdcf94c491a4bd8c7e559666aa4feb6104836cf88c59d381f', 1),
(152, '70a77bae470c07f8', 1, 'admin@datawyrd.com', 'admin', 'email_queued', '{\"to\":\"yurysmith@yahoo.com\",\"subject\":\"Presupuesto Disponible: DW-B2026-C3AB\"}', 'INFO', '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/budget/store', 'POST', '2026-03-04 17:28:19', 'c801183f259498ac164c59429ae1f5bfdd5c610b68f30d074fadc57d6da9c1ec', 1),
(153, 'd993689ebe951395', NULL, 'guest', 'guest', 'email_queued', '{\"to\":\"yurysmith77@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-5646BF\"}', 'INFO', '2800:2260:4000:49:7cf0:19a7:e86f:b68b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/ticket/submit', 'POST', '2026-03-05 12:11:07', '7ad75c3e393e0e2e1cbd05ed3a206696fad45aff43e86a6b157a71734f56e557', 1),
(154, 'd993689ebe951395', NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-5646BF\",\"email\":\"yurysmith77@gmail.com\",\"subject\":\"Solicitud: Data Pipeline Pro - Medio\"}', 'INFO', '2800:2260:4000:49:7cf0:19a7:e86f:b68b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/ticket/submit', 'POST', '2026-03-05 12:11:07', 'dfa3cceee0d26bf4d3ac2cf1d9679213991d306d551eb6fdfd96ea18178eb0f4', 1),
(155, '8528e5e2d39f54cf', NULL, 'guest', 'guest', 'email_queued', '{\"to\":\"laurence.herrod@hotmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Laurence Herrod!\"}', 'INFO', '217.79.116.205', 'Mozilla/5.0 (Linux x86_64; rv:114.0) Gecko/20100101 Firefox/114.0', '/ticket/submit', 'POST', '2026-03-06 07:05:19', '3b706e9233657d5e98c35b50e879b89e7059ae4dbb939deb6b1c3ea538b84b8d', 1),
(156, '8528e5e2d39f54cf', NULL, 'guest', 'guest', 'email_queued', '{\"to\":\"laurence.herrod@hotmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-6BD2E8\"}', 'INFO', '217.79.116.205', 'Mozilla/5.0 (Linux x86_64; rv:114.0) Gecko/20100101 Firefox/114.0', '/ticket/submit', 'POST', '2026-03-06 07:05:19', 'a89bee6fb05903d927591134f5b7fe3de196a205ff971c39f4c3c6ecae7f387a', 1),
(157, '8528e5e2d39f54cf', NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-6BD2E8\",\"email\":\"laurence.herrod@hotmail.com\",\"subject\":\"Hi datawyrd.com Administrator!\"}', 'INFO', '217.79.116.205', 'Mozilla/5.0 (Linux x86_64; rv:114.0) Gecko/20100101 Firefox/114.0', '/ticket/submit', 'POST', '2026-03-06 07:05:19', '256cf79535fccb5d1d7a1b32aef4964d5c30c9a1a3f24007da9bda5cc7052659', 1),
(158, 'a070eb1fd8013d60', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"\"}', 'WARN', '52.167.144.21', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '/auth/doLogin', 'GET', '2026-03-07 07:11:19', 'd335a5bf403815e8ff3b836bcb8261c4ce68ef05a8a61668f30d425a7528b3de', 1),
(159, '6911fb5173a1970f', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-07 12:48:59', '85283bc14a58cf4dc167c26b5cf6e985f3e9da14c2d7905220e74233b4edf6f8', 1),
(160, '5d2f6dd9fc77c80a', 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '\"Administrador elimin\\u00f3 permanentemente al usuario ID: 7\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/admin/users/destroy/7', 'GET', '2026-03-07 13:07:42', '71171fcfec56500fc06e0f64f888484a1e7e431e8200139b23ad5450a9858559', 1),
(161, 'e48a43c66afecff3', 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '\"Administrador elimin\\u00f3 permanentemente al usuario ID: 6\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/admin/users/destroy/6', 'GET', '2026-03-07 13:07:50', '34bf3da4b79a93f34dd034215b59be352540a949ae14850bd74f4086e8d61967', 1),
(162, '0c6a9b9b19505bee', 1, 'admin@datawyrd.com', 'admin', 'email_queued', '{\"to\":\"laurence.herrod@hotmail.com\",\"subject\":\"Actualizaci\\u00f3n de Ticket: TKT-6BD2E8\"}', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/ticket/updateStatus', 'POST', '2026-03-07 13:22:26', 'c3b596a687bc62c85e83d6277e140460ba9e982509710885c432dd27587d3d19', 1),
(163, '0c6a9b9b19505bee', 1, 'admin@datawyrd.com', 'admin', 'ticket_status_changed', '{\"ticket_id\":\"10\",\"ticket_number\":\"TKT-6BD2E8\",\"new_status\":\"void\"}', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/ticket/updateStatus', 'POST', '2026-03-07 13:22:26', 'd84888db7d201e7e571a20c76f0b124d8273cba60871261196ad37f36e23f2f1', 1),
(164, 'aa9d3a174f0e5b98', 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '\"Administrador elimin\\u00f3 permanentemente al usuario ID: 5\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/admin/users/destroy/5', 'GET', '2026-03-07 13:56:47', 'c024f2f0617e6da97b9f7b246eb8e7d59ab774fb614afc839fa1e58cdd3130e9', 1),
(165, '94ea8100e63a6b99', 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '\"Administrador elimin\\u00f3 permanentemente al usuario ID: 8\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/admin/users/destroy/8', 'GET', '2026-03-07 13:56:53', 'c56094601440df67073cd5b11f2166ba27223668a6b943a9aeeab65147b57101', 1),
(166, 'e61e68800700b8f2', NULL, 'guest', 'guest', 'email_queued', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Humberto Boada!\"}', 'INFO', '2800:40:3a:bd0d:dc9c:ac32:f681:30a', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/ticket/submit', 'POST', '2026-03-07 14:31:55', '481acbf46ce4554914b0cd6434982f5c05f163369e05717ce5d4ac25917161f1', 1),
(167, 'e61e68800700b8f2', NULL, 'guest', 'guest', 'email_queued', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-E6CF54\"}', 'INFO', '2800:40:3a:bd0d:dc9c:ac32:f681:30a', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/ticket/submit', 'POST', '2026-03-07 14:31:55', 'b4ebbab7e08134283c1479d4896df9a1ec7b8492e45568794edf7e87fdd1827f', 1),
(168, 'e61e68800700b8f2', NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-E6CF54\",\"email\":\"hboadar@gmail.com\",\"subject\":\"Solicitud: Landing Pages - Plan Inicial\"}', 'INFO', '2800:40:3a:bd0d:dc9c:ac32:f681:30a', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/ticket/submit', 'POST', '2026-03-07 14:31:55', '323ddf37349abeb9f0050b0432543177d58d96179600314134fb8c4a6da6a00b', 1),
(169, '3b258ed869cdf066', 10, 'hboadar@gmail.com', 'client', 'password_changed', '\"Usuario actualiz\\u00f3 su contrase\\u00f1a.\"', 'INFO', '2800:40:3a:bd0d:dc9c:ac32:f681:30a', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/profile/updatePassword', 'POST', '2026-03-07 14:32:32', '1a9a95d65a5e9599d476989bafc8cc6637cd152c753cbca97e06ea035e2eb28f', 1),
(170, '4581db8f961c83c5', 10, 'hboadar@gmail.com', 'client', 'email_queued', '{\"to\":\"contacto@datawyrd.com\",\"subject\":\"[URGENTE] Soporte Prioritario: Humberto Boada\"}', 'INFO', '2800:40:3a:bd0d:dc9c:ac32:f681:30a', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/dashboard/urgentSupport', 'GET', '2026-03-07 14:33:36', 'f499fa54d17406057fa33b2f228571e5afea235e461efa52ccfe7f95f9492f1b', 1),
(171, 'd5bdcf3b01aa0580', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-07 18:35:01', 'e732959df064c330d34731b2b18fd5cd4c63c9578e2081d172d89bcf624e1d55', 1),
(172, '3abe6f1127f5095b', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-07 18:35:14', '86d45fa10287658b6ea7051dbac0ee2df1d61118d03496532a0e74662d5bb66a', 1),
(173, 'baa6a8ce38159d51', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-07 18:35:30', '2d4e7f92b401f02b32c89e2d9639afe6a90fe2f3d548dadbc529a9434046cd30', 1),
(174, 'c35a7878517311a9', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-07 18:35:45', '06313f5132482cdb31dfbc396c807482255fc95ebd176dee2f9303aa827168f0', 1),
(175, 'f8c9517ac31aee5a', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-07 18:35:55', '241e392e86e45d517bc0b4611f851a8cbfea420e267b4f95f68e260b6ba596ff', 1),
(176, '66b2d5c6494351c7', 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '\"Administrador elimin\\u00f3 permanentemente al usuario ID: 10\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/admin/users/destroy/10', 'GET', '2026-03-07 18:48:16', 'ecd03f8a8ae89423a6973bf261e2f1a692afc520cdb156fc6c55ef4f84e78475', 1),
(177, 'cb17ca6d7c4e99dd', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-08E76A\"}', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/ticket/submit', 'POST', '2026-03-07 18:50:06', 'd2769e5af9dcd2f9cbd0d4fa67f7e981c5548590d0289e2e7085908297709ee6', 1),
(178, 'cb17ca6d7c4e99dd', NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-08E76A\",\"email\":\"hboadar@gmail.com\",\"subject\":\"Solicitud: Landing Pages - Plan Inicial\"}', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/ticket/submit', 'POST', '2026-03-07 18:50:06', 'ac5b31dee4c252b13f689e1b9f97a44ba2b997d225c32c7d7bc214d003686b84', 1),
(179, '130d64d500d09e48', 11, 'hboadar@gmail.com', 'client', 'password_changed', '\"Usuario actualiz\\u00f3 su contrase\\u00f1a.\"', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/profile/updatePassword', 'POST', '2026-03-07 18:57:12', '2cfb3b35b881f3786e5b77b44c9a12a63f8a7bc78db6d20ca3e933423adf785e', 1),
(180, 'dc500859d329e92c', 1, 'admin@datawyrd.com', 'admin', 'password_changed', '\"Usuario actualiz\\u00f3 su contrase\\u00f1a.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/profile/updatePassword', 'POST', '2026-03-07 18:58:16', '0902a6512fb405e46c32e96b5fb0dc933d23abe82ef1752cb6d89c6d6fdaccec', 1),
(181, '99bd569680b8b166', 1, 'admin@datawyrd.com', 'admin', '2fa_enabled', '\"Usuario activ\\u00f3 la autenticaci\\u00f3n de dos factores.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '//profile/confirm2FA', 'POST', '2026-03-07 19:03:23', 'cb6c43921ac376c329bda9528dc74add3782a44384f5031da484bea329e7f4d8', 1),
(182, '99e940e36b486fe3', 11, 'hboadar@gmail.com', 'client', 'email_sent', '{\"to\":\"contacto@datawyrd.com\",\"subject\":\"[URGENTE] Soporte Prioritario: Humberto Boada\"}', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/dashboard/urgentSupport', 'GET', '2026-03-07 19:06:29', '128b44315e00f68877fed8d17f9d69458f540e75ca6ae7669cb99b189de4d180', 1),
(183, 'e273150dd1509e09', 11, 'hboadar@gmail.com', 'client', 'email_sent', '{\"to\":\"contacto@datawyrd.com\",\"subject\":\"[URGENTE] Soporte Prioritario: Humberto Boada\"}', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/dashboard/urgentSupport', 'GET', '2026-03-07 19:06:30', '41b8c344bf0aff863126e2feeb6576899a390554dca11831cc9b46e54efd36e5', 1),
(184, 'a72c37004cfe0dc9', 1, 'admin@datawyrd.com', 'admin', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"Presupuesto Disponible: DW-B2026-5244\"}', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/budget/store', 'POST', '2026-03-07 19:14:35', '423ad9d89c13c2b9e16185ab976590513885e3178a526cee307e21e3af883a1d', 1),
(185, '13cac03ff11fcaa4', 11, 'hboadar@gmail.com', 'client', 'email_sent', '{\"to\":\"contacto@datawyrd.com\",\"subject\":\"[URGENTE] Soporte Prioritario: Humberto Boada\"}', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/dashboard/urgentSupport', 'GET', '2026-03-07 19:28:39', 'a7a10e6ca5e7c515d6ba49f51693ed559f4da7fa9c48a7e79ce5f52485526bdf', 1),
(186, '71893c6da1c5b4cb', 11, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-03-07 19:28:56', '39225d6a99995ecbc538fcfdc92d42b3aed6432c3cbba84a911ce7f890b006f4', 1),
(187, '7e1abc1610a7e5e5', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"hboadar@gmail.com\"}', 'WARN', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-07 19:29:06', '1a072bc9254a8aaa51983c91ba0ac33e18aaf367b0a51a30203227c0013b11de', 1),
(188, '7e830cbe49b1ce06', 11, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-07 19:29:17', '44deeffe862500cc0f3ab8cc24bbb589d5c4c53da60ba980ec6cece8acc0b4a7', 1),
(189, '3d406cb094620618', 11, 'hboadar@gmail.com', 'client', 'email_sent', '{\"to\":\"contacto@datawyrd.com\",\"subject\":\"[URGENTE] Soporte Prioritario: Humberto Boada\"}', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/dashboard/urgentSupport', 'GET', '2026-03-07 19:29:53', 'aa7b01283aee6eacde61ca9ed51b80d53f83abfe1b855ee15edafa467fbb1b3d', 1),
(190, 'bee20d6e98a3c900', 11, 'hboadar@gmail.com', 'client', 'email_sent', '{\"to\":\"contacto@datawyrd.com\",\"subject\":\"[URGENTE] Soporte Prioritario: Humberto Boada\"}', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/dashboard/urgentSupport', 'GET', '2026-03-07 19:38:10', 'a159f947356e112ac50fe9eaccfe6380b0f71b3cae49f74be734ce86176bb20b', 1),
(191, 'f132b5378bccd49e', 11, 'hboadar@gmail.com', 'client', 'invoice_generated', '{\"invoice_id\":\"8\",\"budget_id\":11}', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/budget/decision', 'POST', '2026-03-07 19:44:19', '5885e7dc6156cf178daee0d4d9dbaf9e99a075e905006a8e9cb2e6944f3a5a55', 1),
(192, 'f132b5378bccd49e', 11, 'hboadar@gmail.com', 'client', 'event_dispatched', '{\"event\":\"App\\\\Events\\\\InvoiceIssued\",\"timestamp\":1772923459.525113}', 'INFO', '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/budget/decision', 'POST', '2026-03-07 19:44:19', '66ee6a3fca5cdfee349c02b4d207180d33fae6b0e5c6f159347aa14546fec983', 1),
(193, '45543b07aafe1555', 11, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '186.157.51.246', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-03-07 20:23:01', 'baab3d520b62eadca0efbdece7fafb86763bb3904d112b7bfb01426fd9cabd8b', 1),
(194, '414d1382f7dbaef7', NULL, 'guest', 'guest', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '190.13.226.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-03-07 20:23:06', 'd025dd97457a21641a2acf3185e29e62c328a8390f53c523045c1908423b29dc', 1),
(195, '650585769b5442b0', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '186.157.51.246', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-07 20:23:44', '4e83cd88eca869a3a88d7452e9c8633bb2918009a60bbc4dc34876c97823f6b0', 1),
(196, 'b9adb55eaf998695', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '186.157.51.246', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/verify2FA', 'POST', '2026-03-07 20:24:52', '6e8ec5e4d216d85e619783029acc1383b9d186cc6a4edfa223795ba55ee6fbb0', 1),
(197, '38659431aebf8973', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-08 15:17:03', '5c451d6ec3bc0638b1d80e0223db63c3e1ef5a878dbcdcbda0510210ed481c4d', 1),
(198, '3de65fcc9a5bf1e8', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-08 15:17:13', '0170ff6a4d3a6397c66e39529454d079d16897923187f1c7767f037f5d7b5eaa', 1),
(199, 'ce89dd9f5e65c5ea', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-08 15:17:22', '004e83588049590c55d6b9018132bcd63e6a471316facae968c4a07bbdfd395b', 1),
(200, '0664af61181b0dcb', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-08 15:17:36', '402dd871456355e29489e97fb89449dc5a30459196c2a0d4200019d55238f5a2', 1),
(201, '8196c7d3e70bdfb4', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/verify2FA', 'POST', '2026-03-08 15:18:08', '93fa07606d5412129644771199e1ade9caaa3828653779e2c05ff38dfa3ed658', 1),
(202, '7cfd21bcce04e667', 1, 'admin@datawyrd.com', 'admin', '2fa_disabled', '\"Usuario desactiv\\u00f3 la autenticaci\\u00f3n de dos factores.\"', 'WARN', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/profile/disable2FA', 'GET', '2026-03-08 15:18:16', '0cc0dbc6f55e41309c53d3c3e73b4be2820d3e1297eabc3202d35f1569ae9f5b', 1),
(203, '01e99bac4e0dcd2c', 3, 'luther.smith@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:2260:4000:49:d985:662e:2b1a:95a0', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/auth/doLogin', 'POST', '2026-03-08 15:21:40', '095e2338aa46143653c99bdc7b954ea71af7073e9712ac36e01e77d2b8e0a28c', 1),
(204, '8ec2ca35a6788a88', 11, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e487:a4fc:d9bf:f217', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-08 15:22:38', '0c9c7207ea877016bb44deb2c7161af99f8d8e08028497036aea3228dd53d579', 1),
(205, 'a32011b8e454bab0', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"\"}', 'WARN', '201.217.246.228', 'Mozilla/5.0 (Linux; Android 15; moto g15) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'GET', '2026-03-08 15:22:42', '434ff6a3bf340de27e83dab2cb3c19be7e0f43906cb9cb75fc23554b985c351e', 1),
(206, 'f597ce7619d3b434', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-08 16:11:41', 'd8474c84ea82129a87874dde6ef2288bae174177bf4086ef11c34a8af2b4da2b', 1),
(207, 'e8ec7dbcea2a2623', 11, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-08 16:11:53', 'f1b7c7fe8118e3dfc4bf253cd53a3b4c25a9764885eb82c267265f7bbae6177f', 1),
(208, '7d86fd18ed84a9c4', 11, 'hboadar@gmail.com', 'client', 'mp_preference_error', '{\"response\":{\"message\":\"auto_return invalid. back_url.success must be defined\",\"error\":\"invalid_auto_return\",\"status\":400,\"cause\":null}}', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/invoice/payMp', 'POST', '2026-03-08 16:12:13', 'ce97c10e2c718afb3d06893fa294b2ba03d07d3e3d4def4788f65e0f041179f5', 1),
(209, 'ba97eedbd89dbdcf', 11, 'hboadar@gmail.com', 'client', 'mp_preference_error', '{\"response\":{\"message\":\"auto_return invalid. back_url.success must be defined\",\"error\":\"invalid_auto_return\",\"status\":400,\"cause\":null}}', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/invoice/payMp', 'POST', '2026-03-08 16:12:36', '631e6bfecdd257a83740ad2c1096a15492c07b3ea43a5c19410a7ae4e1b5a7f0', 1),
(210, '7c6f011286e92b88', 11, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-08 16:15:04', 'ca5901d210437e7c4b8e3c4f44c4e3ed0d9a7d9bd39629311fdb035a3e954772', 1),
(211, 'ebfd90bb3f84ac67', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-08 16:15:36', '48949450467d5252dbedbcaa19f33bd60e6a96219b0fde0cf9b565ad181dd808', 1),
(212, '31dfdbf5c6552b33', 11, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e08e:4403:f59d:a161', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-08 16:40:44', '95fcbb4dbc9e87242db1260e92a1c570a50687dece0b5c377693e0cb0d95b7c7', 1),
(213, 'abfcbb7c26c406d6', 11, 'hboadar@gmail.com', 'client', 'mp_preference_error', '{\"response\":{\"message\":\"auto_return invalid. back_url.success must be defined\",\"error\":\"invalid_auto_return\",\"status\":400,\"cause\":null}}', 'INFO', '2800:40:3a:bd0d:e08e:4403:f59d:a161', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/invoice/payMp', 'POST', '2026-03-08 16:41:13', 'dc28f7ce1930f92a5829403c77b6261313105da888b79d8a3657c20c0f07f58c', 1),
(214, '0aba981f187fe343', 11, 'hboadar@gmail.com', 'client', 'mp_preference_error', '{\"response\":{\"message\":\"auto_return invalid. back_url.success must be defined\",\"error\":\"invalid_auto_return\",\"status\":400,\"cause\":null}}', 'INFO', '2800:40:3a:bd0d:e08e:4403:f59d:a161', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/invoice/payMp', 'POST', '2026-03-08 16:52:22', '6210c65d7d4a83cfb53432d57a46c0334bdb766b3c0c0618ed951e09f039d6de', 1),
(215, 'f22a64f8346350c5', 11, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:e08e:4403:f59d:a161', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-03-08 16:52:28', 'bcf2e3e9aa5dcd5cb347ffec7e759f30e79b0236768e97f0767bf729183118e9', 1),
(216, 'f2de391f2302381e', 11, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e08e:4403:f59d:a161', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-08 16:52:45', 'ebfad499f935a6d2d7b0c7b225401d620de13fea5fb484d8aa6813872b46985e', 1),
(217, '6030c3b73b6a1ddb', 11, 'hboadar@gmail.com', 'client', 'mp_preference_error', '{\"response\":{\"message\":\"auto_return invalid. back_url.success must be defined\",\"error\":\"invalid_auto_return\",\"status\":400,\"cause\":null}}', 'INFO', '2800:40:3a:bd0d:e08e:4403:f59d:a161', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/invoice/payMp', 'POST', '2026-03-08 16:53:00', '8f4f8df334772b1c49d6c517dd8bb83722188a020bc12708089390dc1c8b0200', 1),
(218, '58aa429436d31e39', NULL, 'guest', 'guest', 'webhook_mercadopago_received', '{\"type\":\"unknown\",\"action\":\"unknown\",\"resource_id\":\"unknown\"}', 'INFO', '18.215.140.160', 'MercadoPago Feed v2.0 merchant_order', '/webhook/mercadopago?id=38883114702&topic=merchant_order', 'POST', '2026-03-08 17:03:56', 'c274fd7768727cb469ddd3089d29b5664133b93f017c2542f1140148e039630e', 1),
(219, 'b7a9fd45a00b08ed', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-08 18:26:16', '7693b1080ef785724589bc0ccfd8f6130a88da47e816bd6da40be392562d6b21', 1),
(220, '533f21f4dec81a2e', 11, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-08 18:26:27', '7b7c35d53b9bcb926008f840cd81d8f635712fea98e84007d341de4d5acdeb92', 1),
(221, '06339647c1738c7f', 11, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-08 18:27:35', 'db5a0d0b5c3f9bb1a50a7c290b2ea8d2d87b9a3a677df9600b3e594a624f727d', 1),
(222, '3ad10f5cfad6c4a8', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-08 18:27:47', '7b6de125758b8b4a4dc470b67af3911d1181cf3991eac305c53931aada4b5def', 1),
(223, '922e96e8bc281d5e', 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '\"Administrador elimin\\u00f3 permanentemente al usuario ID: 11\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/admin/users/destroy/11', 'GET', '2026-03-08 20:02:36', '7dda2ce923bdb8a1c4f8be2f19e8a71bf339e0cc2970c5cceff67455d9f373c1', 1),
(224, '897cd0bd94ea06f3', 11, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:e003:235b:a497:5a24', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-03-08 20:08:11', '412a70638e510a4dd051ed78872d77942b1fbf3c874a70297525f46577840118', 1),
(225, '7548b8b6961bdaf9', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-332034\"}', 'INFO', '2800:40:3a:bd0d:e003:235b:a497:5a24', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/ticket/submit', 'POST', '2026-03-08 20:08:54', 'ad7c31801fceafd65a5293be5a52ed99b949ba2f52d15dfcc97242eae2d561f3', 1),
(226, '7548b8b6961bdaf9', NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-332034\",\"email\":\"hboadar@gmail.com\",\"subject\":\"Solicitud: Landing Pages - Plan Inicial\"}', 'INFO', '2800:40:3a:bd0d:e003:235b:a497:5a24', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/ticket/submit', 'POST', '2026-03-08 20:08:54', '3dcbcae47e8f3597e6a0f35c8eab16d03e746e1ac307843127549e6b854a1159', 1),
(227, 'ad81274c6f48183b', 12, 'hboadar@gmail.com', 'client', 'password_changed', '\"Usuario actualiz\\u00f3 su contrase\\u00f1a.\"', 'INFO', '2800:40:3a:bd0d:e003:235b:a497:5a24', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/profile/updatePassword', 'POST', '2026-03-08 20:09:56', '6db72328a0998dd7e43b0b6fd28209f52d4d35b59a1853979b60eeefa1220ff7', 1),
(228, 'ef518463b8f0641b', 12, 'hboadar@gmail.com', 'client', 'email_sent', '{\"to\":\"contacto@datawyrd.com\",\"subject\":\"[URGENTE] Soporte Prioritario: Humberto Boada\"}', 'INFO', '2800:40:3a:bd0d:e003:235b:a497:5a24', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/dashboard/urgentSupport', 'GET', '2026-03-08 20:10:13', '1c54ebfbfded8cc15e3df7c2c98e2656c91d76928c05911fabcfd60022f917ae', 1),
(229, '695c758bb8412a70', 1, 'admin@datawyrd.com', 'admin', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"Presupuesto Disponible: DW-B2026-D479\"}', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/budget/store', 'POST', '2026-03-08 20:14:24', 'f98de79562143c1572e0f010b4552b0e5abee8af4c24fbb41cafb5875683e309', 1),
(230, 'cf692a27c2a85144', 12, 'hboadar@gmail.com', 'client', 'invoice_generated', '{\"invoice_id\":\"9\",\"budget_id\":12}', 'INFO', '2800:40:3a:bd0d:e003:235b:a497:5a24', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/budget/decision', 'POST', '2026-03-08 20:19:14', 'e8f6826a923e39a636694cf13cc349c5c81e7c2724c7ec503cd9fb7bfd5f007e', 1),
(231, 'cf692a27c2a85144', 12, 'hboadar@gmail.com', 'client', 'event_dispatched', '{\"event\":\"App\\\\Events\\\\InvoiceIssued\",\"timestamp\":1773011954.146994}', 'INFO', '2800:40:3a:bd0d:e003:235b:a497:5a24', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/budget/decision', 'POST', '2026-03-08 20:19:14', 'b3e9217dc41eb1d234f1a81cd9506e9b301eadb080b6c41b8ee8ac93f0da535b', 1),
(232, 'b6195047c55a67d0', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-08 21:49:19', 'db387208ff32656c2985d1fb9c3b3108920f65d0c63d3680aa552e9fbf44747d', 1),
(233, 'a7d6a9bea51537d7', 2, 'staff@datawyrd.com', 'staff', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-08 21:49:29', '53a6c5ef620288304a54a7c2a4d2ab9c776d5a2c082969952d96d9b4a7cdd9d5', 1),
(234, 'e0de32701b4e9924', 2, 'staff@datawyrd.com', 'staff', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/logout', 'GET', '2026-03-08 21:50:43', '51a244840649aaa3a9796ee41a9f7ae4dd131491c22863cd69641638a066cb3c', 1),
(235, '06d519acebb91bd1', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-08 21:50:54', '0ea1143fd6072ee69ca1df5a71136e511953e26eaf79369947d34c5398fc7936', 1),
(236, 'b2c3e5b16dc3f757', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-08 21:51:02', '212b154fc6aef1ac54be31f936330dc8c45f0ad0fe888ab7857ff9fc32b3c083', 1),
(237, '8436fc22a5a98e2b', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '190.210.32.221', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-03-08 22:06:48', '73770774f4933ea9ade54e1b372a22263c90459bce5c283fea4bf152dbfe18ef', 1),
(238, 'c61600f8710a352b', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.210.32.221', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-08 22:07:03', 'a426fa1614592dbf2f3765bf73498e08d73072255752f447105af4cb96153f5c', 1),
(239, '830de6c25b59d87f', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '190.210.32.221', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-03-08 22:07:37', 'a1323c0143c981fb97f6a4d740497b91f156a83ef2c9d5bf5bdda48a356fb4d0', 1),
(240, 'f430e9c12971436c', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"\"}', 'WARN', '52.167.144.147', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '/auth/doLogin', 'GET', '2026-03-09 01:45:00', 'a934b90636af68d1e77ee351aa7d764d4aa94cfb4c687fc64ef8f096908d581f', 1),
(241, '496efc223d47a99c', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.210.32.221', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-09 06:47:10', '9d68f9d65ec7b6fd654d443a42c71ad0c3ec110d5420d2365dfc48369e8e6db0', 1),
(242, 'ce0fddee684bc0b7', NULL, 'guest', 'guest', 'webhook_mercadopago_received', '{\"type\":\"unknown\",\"action\":\"unknown\",\"resource_id\":\"unknown\"}', 'INFO', '18.206.34.84', 'MercadoPago Feed v2.0 merchant_order', '/webhook/mercadopago?id=38895545910&topic=merchant_order', 'POST', '2026-03-09 06:47:43', '51ae116d986306c99e656be17632d7329b7461ab53d37cf6549cfef48c2c65f9', 1),
(243, 'ea6946610b64cdab', NULL, 'guest', 'guest', 'webhook_mercadopago_received', '{\"type\":\"unknown\",\"action\":\"unknown\",\"resource_id\":\"unknown\"}', 'INFO', '18.206.34.84', 'MercadoPago Feed v2.0 merchant_order', '/webhook/mercadopago?id=38868187173&topic=merchant_order', 'POST', '2026-03-09 06:48:26', '3fcac0a75b3e9bf63500950650498dc1fe23f7a727583f5e89f1549158b88a5a', 1),
(244, '924044780e9f5e9b', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '200.49.93.243', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/auth/doLogin', 'POST', '2026-03-10 09:52:19', '88b06a817132f0f1d70761f90988a61781a8601e41b2df80b011c45775c40747', 1),
(245, 'c06e99ff98e1c913', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '200.49.93.243', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/auth/doLogin', 'POST', '2026-03-10 09:52:27', '58a975b1866af284a141e2ae2f388ca43881111df89b28d65f5113f7f207b04e', 1),
(246, 'e80f913d4ede288c', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '200.49.93.243', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/auth/logout', 'GET', '2026-03-10 09:53:22', '5473b3e26fa5010384e175affdff1262126a287c5980dc2a25727e4b17f05263', 1),
(247, 'f6ee73bad07ac5c1', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"\"}', 'WARN', '40.77.167.59', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '/auth/doLogin', 'GET', '2026-03-10 17:12:14', 'c63f52796d62ec22a7bf60ff2d8e81389853aefdbb8f88a74c4051ea1290738b', 1),
(248, '4c10ea62d7f6de4a', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '190.210.32.151', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-11 05:50:30', '46c0c519cc2c0d0b5b0f3417ddd50ece40441c1e58707e90565a47ae64398a5f', 1),
(249, 'f3a67321a3439242', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '190.210.32.151', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-11 05:50:44', 'b36c168d32878098b2ecacb9f331127530cac3e71994b037461393f28a53d3fa', 1),
(250, '855898780054b515', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '190.210.32.151', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-11 05:50:54', '346b6f1b74f3cc9eb40462cb3fe434b333b13b84d0adc32982fcd84ea33749c9', 1),
(251, 'cca9de15def9a2ba', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '190.210.32.151', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-11 05:51:17', '745ea03899423c2f6954b8910c06c18c3ce53a4c408bc8dc2d0602e2b57c45c1', 1),
(252, 'e54ca20fc890b296', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '190.210.32.151', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-11 05:51:30', '735f603c57b516b9a050ee80ea1781ee6dadf130f3eb5fda29337b9401ec6926', 1),
(253, '3458224b1196f610', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.210.32.151', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-11 05:52:13', '82de62f5b5c86eb2fe52e6ae44d9d262e18073866e136f3c90dbedaaa2a8a8e3', 1),
(254, 'bf378b59d92c0118', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '190.210.32.151', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-03-11 05:52:52', '806d706b1cb253cadcc94ec71de5dd19686fb6b47a64a8b1496ac870e1e0035a', 1);
INSERT INTO `audit_logs` (`id`, `request_id`, `user_id`, `user_email`, `user_role`, `action`, `details`, `level`, `ip_address`, `user_agent`, `request_uri`, `request_method`, `created_at`, `signature_hash`, `tenant_id`) VALUES
(255, '6fe1664affbc5a81', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:7922:529c:a8be:b67e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '/auth/doLogin', 'POST', '2026-03-14 14:23:10', '7d23f2542849e09cddf8a6c8e68bcf9c9a826bb7db08db0c3d276206c15e66a1', 1),
(256, '9f448d095f74143b', 3, 'luther.smith@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:21ea:1abf:b846:62a1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-14 14:26:57', '4dfbe7f8bec3e2a8fda203182862fb671b3e7f1e87a4c085dd368ef0e507ed58', 1),
(257, '285c22345d7c2797', 3, 'luther.smith@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:21ea:1abf:b846:62a1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-03-14 14:27:20', '00005424bbb02f27736bdefc70b0be090a56a603c1369afd0fcd96bdc0f3dc7b', 1),
(258, 'c0e448df34b8fed3', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:21ea:1abf:b846:62a1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-14 14:29:31', '31f73954821f382e25547ad66d08fef1cf41e18f2418719849cdb8e91ce51d34', 1),
(259, '38e53018ad9bb80b', NULL, 'guest', 'guest', 'webhook_mercadopago_received', '{\"type\":\"unknown\",\"action\":\"unknown\",\"resource_id\":\"unknown\"}', 'INFO', '18.206.34.84', 'MercadoPago Feed v2.0 merchant_order', '/webhook/mercadopago?id=39062024098&topic=merchant_order', 'POST', '2026-03-14 14:30:23', '306f63ded333e1bbb1cc0a31c6d8ffeafd07dcf4617a0aebdbe35e1869017aed', 1),
(260, 'cb3d2f728a118841', NULL, 'guest', 'guest', 'webhook_mercadopago_received', '{\"type\":\"payment\",\"action\":\"payment.created\",\"resource_id\":\"150354160742\"}', 'INFO', '18.206.34.84', 'MercadoPago WebHook v1.0 payment', '/webhook/mercadopago?data.id=150354160742&type=payment', 'POST', '2026-03-14 14:30:51', '1f4feb4a9c81cffb3657e41c371df705c6d2e85321b4d79466d18ef2fb58c5df', 1),
(261, 'ed9c15dbfe3924a1', NULL, 'guest', 'guest', 'webhook_mercadopago_received', '{\"type\":\"unknown\",\"action\":\"unknown\",\"resource_id\":\"unknown\"}', 'INFO', '18.213.114.129', 'MercadoPago Feed v2.0 payment', '/webhook/mercadopago?id=150354160742&topic=payment', 'POST', '2026-03-14 14:30:51', '64f7c640f3438bfb5f7be293fd0f063e2e2dc3b7fb45f9002e64a619df2bb125', 1),
(262, 'f84b6710f07a50ba', NULL, 'guest', 'guest', 'webhook_mercadopago_received', '{\"type\":\"unknown\",\"action\":\"unknown\",\"resource_id\":\"unknown\"}', 'INFO', '18.213.114.129', 'MercadoPago Feed v2.0 merchant_order', '/webhook/mercadopago?id=39062024098&topic=merchant_order', 'POST', '2026-03-14 14:30:51', '334a0d51f4bf1d452343822dc28ef34ea6a36a9859c4e780238a70559ddd2312', 1),
(263, 'cb3d2f728a118841', NULL, 'guest', 'guest', 'service_activated', '{\"invoice_id\":9,\"client_id\":12,\"partial_pay\":false}', 'INFO', '18.206.34.84', 'MercadoPago WebHook v1.0 payment', '/webhook/mercadopago?data.id=150354160742&type=payment', 'POST', '2026-03-14 14:30:51', 'bb1e1d5497580887eb83f51aee5f02b56b7dff9a2660c1ce791210dfa9a511b3', 1),
(264, 'cb3d2f728a118841', NULL, 'guest', 'guest', 'event_dispatched', '{\"event\":\"App\\\\Events\\\\ProjectStarted\",\"timestamp\":1773509451.576101}', 'INFO', '18.206.34.84', 'MercadoPago WebHook v1.0 payment', '/webhook/mercadopago?data.id=150354160742&type=payment', 'POST', '2026-03-14 14:30:51', 'cb5b5e74d502533e819a31722a6115375f829996486347cc809bcf5f3ed08684', 1),
(265, 'cb3d2f728a118841', NULL, 'guest', 'guest', 'invoice_paid', '{\"invoice_id\":9}', 'INFO', '18.206.34.84', 'MercadoPago WebHook v1.0 payment', '/webhook/mercadopago?data.id=150354160742&type=payment', 'POST', '2026-03-14 14:30:51', '9e5c69e9e2ee05fd1d4c6cc00e792677a7f0de82bef17d2267a3e9078b2e6666', 1),
(266, 'cb3d2f728a118841', NULL, 'guest', 'guest', 'webhook_payment_processing', '{\"id\":\"150354160742\"}', 'INFO', '18.206.34.84', 'MercadoPago WebHook v1.0 payment', '/webhook/mercadopago?data.id=150354160742&type=payment', 'POST', '2026-03-14 14:30:51', '802b18e9fcde8b2f9d50d6c698c50ff467a88f5e94147f2cbd251cab5b026f23', 1),
(267, 'cd10d1f3312f6e2d', 3, 'luther.smith@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:84bd:a2bb:83e3:c086', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '/auth/doLogin', 'POST', '2026-03-14 16:53:54', '480bb8ba6387ab890ec11c51cb654c223673a8e81c94eee1aeff3cc7046d1369', 1),
(268, 'c48ef46b5e7cb671', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-15 12:46:55', 'ddb0f4478959b8ec886d441763dd4b1cae5636d0b6a1fc8d84f3ea4a47d6e335', 1),
(269, '8ad7c862c07082c6', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.210.32.129', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-15 14:15:39', 'c298eba5f2720ba5804d30015b4c284cb915249c15cf8d2c1d7b84c7fd30ebad', 1),
(270, '9f05cf3730b2d07f', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-15 15:05:36', 'ad60ae726d0a85f05ef0795dccb7c190a811fb9981d21d447ce1a7eaed990ff0', 1),
(271, '54d47f7dec9c4fd0', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-15 15:05:45', 'be7fdf2fc0c937829e6bb708bc4acf470cfbff9de0d31550d48e84cc1cc5467d', 1),
(272, '647fad33fcd6ae22', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-15 15:10:15', '1c9cff6dc48c0789b62d038e8ec8314c2cc568e8fc1312e3114ae38f194bcf31', 1),
(273, 'd4bd52b2f4b42fb5', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-15 15:10:26', '5f4353d578661fe5405b2a5c280d2932a46948e7cf60cb97e1c10c719a1f08fb', 1),
(274, '43f090273e1e466c', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-15 15:10:35', 'f1b9d824bb4a40b03205665efae4f35f9143260bc427ade38d4476a70e5ba527', 1),
(275, '3f158210f9621a60', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-15 15:15:36', '175f514883c77ad57276fc9f9e84524e95e241e976251f3aee65c29267438aa5', 1),
(276, '72cce61574e8540b', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-15 15:15:44', 'f0035349a579df32f547f1502b8a5099506be269732425314b9cea610c949557', 1),
(277, 'eff85ab93cdb04b6', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-15 15:20:15', '4925f63672df0de3029afa2a1fecd6b6599b0b8f750bb134c28622ef6dad4777', 1),
(278, 'a35cfe75c543d340', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-15 15:22:28', '499288737849c0951140ed07158f9d5fe5c3a618660ce34056394f540e8b5cf3', 1),
(279, '291818912d706288', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-15 15:24:45', 'c76e36bca0982c0d9bdd0140d10ed999443134e91774a57a67d2b7458b96ae37', 1),
(280, 'a642689ea1b95e06', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-15 15:24:58', '42581958a3f68aeb68535d963dba701f6f266c23afb131a685356c3a9000dd4d', 1),
(281, '98e3e7436e74caef', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-15 15:25:11', '78521d89e55a8a4b02545698d2f02ba602c77024563519be5a4d22f527da8cff', 1),
(282, 'b10a42acdedbeaee', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-15 15:28:54', 'accf9ead2e1e0c1f830a143d5869091ab51dcb474f980d7ae4f8aad0797d4a88', 1),
(283, 'bf9533fc64a9d409', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-15 15:29:07', '2aba1de65153a8023be23fe0ac9380194762ed58c477104df4b3cfe425270d79', 1),
(284, '6e919cf934225e7c', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-15 15:31:39', 'db7a8a64d5f90788bd5b51ecfa075c50f34f2d4d07593ae21a046405315e21d2', 1),
(285, 'a08007403a3b5dba', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-15 15:31:49', '3faac9d0fc4f1beef06561f3c1da15a6115cdc9b4aaa93cb81a5561d1fa65fbf', 1),
(286, 'bc7a18b9885dd3b0', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-15 15:31:58', '0020a9ffa4e1895040ab5e3ea63ffb8425a5e057bf7ca4709070ede67da65c05', 1),
(287, '71dd7c4e75bbbec0', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-15 16:05:34', 'f93ee76920ad2f3c866ef250bd7a6fb727b31cf6110c613a7fc077e0facaca46', 1),
(288, '41ffdd5873388be5', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e82a:afab:6db7:952b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-16 19:26:19', '0d14a274044bdc626b3747b4a8c1acedc341d4058af8a3d07432bd1097a22e20', 1),
(289, 'a29f7861e9c45d31', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:e82a:afab:6db7:952b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-16 19:26:31', '1c4675779f9c218f13a131fff75402eda7073fe7fb76f0baf9064e449cb1da41', 1),
(290, 'dcc98e9412f2124f', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e82a:afab:6db7:952b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-16 19:26:43', '72e84ccff2a552dd758e7dce7b28727212b3c59c03a1b726c6522ebe20dbe1ed', 1),
(291, '8f2f5bd2d96dab68', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:e82a:afab:6db7:952b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-16 19:27:23', '9a5ef55b6ee70fe93ba64488e03add06a82adfb5234210aa853ed6260eac2332', 1),
(292, 'dc3ab0a5a473c7dd', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"\"}', 'WARN', '198.244.168.147', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)', '/auth/doLogin', 'GET', '2026-03-20 07:02:18', '329a76d36d567259f0588e331dd3ff7012fb98a109084ba4be6deaaf51ed5534', 1),
(293, 'ba5fd2e1ba664f4c', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"\\u00a1Gracias por postularte a Data Wyrd!\"}', 'INFO', '2800:40:3a:bd0d:e82a:afab:6db7:952b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/jobs/postulate', 'POST', '2026-03-21 19:48:51', '4a71671f5e20f5f58c8245228fb82cabdff045ce347662c872647d1e4439acfe', 1),
(294, 'f5809bb45432075a', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e82a:afab:6db7:952b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-21 21:16:21', 'a88caf526ebf3d5e7a97050298f3f2032e9bdfb412426b1be9f14c40f26f0503', 1),
(295, '75f82a9db6e98f59', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:b6c2:9181:e833:1508', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-22 03:30:54', '7fe578cd37a7022bf3a2605aa8178980cad2a6518b560397242b2bb9e4efea67', 1),
(296, '77159d5272ae4ac3', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"jazmin.rivas003@gmail.com\",\"subject\":\"\\u00a1Gracias por postularte a Data Wyrd!\"}', 'INFO', '190.194.199.72', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/412.0.882869339 Mobile/15E148 Safari/604.1', '/jobs/postulate', 'POST', '2026-03-22 14:20:03', '886d225611b65a81b1b61193416dd6065308d99dd114f62e1f26e69b8fe4ba9a', 1),
(297, 'b52265d163f1aed9', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"jazmin.rivas003@gmail.com\",\"subject\":\"\\u00a1Gracias por postularte a Data Wyrd!\"}', 'INFO', '190.194.199.72', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/412.0.882869339 Mobile/15E148 Safari/604.1', '/jobs/postulate', 'POST', '2026-03-22 14:20:08', '5957537f9e96b1c329f9c0c08011d07c49111f9c753534b15deb8d153cf33484', 1),
(298, 'b922093ee3ab4ec4', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"mayrabelenemiliani@gmail.com\",\"subject\":\"\\u00a1Gracias por postularte a Data Wyrd!\"}', 'INFO', '190.228.215.167', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 [LinkedInApp]/9.31.9253', '/jobs/postulate', 'POST', '2026-03-22 14:26:08', '34f566c831f1dbb737bfe2e75f337d3a907992941084b5c7e42e2187b256bad0', 1),
(299, '448a44dfc3484a31', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"nicolasarina9@gmail.com\",\"subject\":\"\\u00a1Gracias por postularte a Data Wyrd!\"}', 'INFO', '179.42.183.66', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '/jobs/postulate', 'POST', '2026-03-22 14:31:17', 'c4918514a4b26ffa912a370bc2c4dfc37f25fc898008b1cf50e54b81a7f5bbc1', 1),
(300, '384fe05be2f8c9fc', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.146 Mobile Safari/537.36 Instagram 421.0.0.51.66 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789;', '/auth/doLogin', 'POST', '2026-03-23 01:36:29', '178c2a828d22eb8b65753e2dc96c45742e54f096c5e049621f8ce514ccc9ba10', 1),
(301, '96a8f7fdc9aaad8b', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.146 Mobile Safari/537.36 Instagram 421.0.0.51.66 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789;', '/auth/doLogin', 'POST', '2026-03-23 01:36:45', 'ae909505b7a1eccd8724ddd1c9af93651b3c82caf31a1a7e818f99ca91e2967f', 1),
(302, 'eabfdd9c41f5e020', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-23 01:38:39', 'a36bc053cd4b01f6e310b5225419c2c71609be2b0bb7b7109dc612614e4a7a12', 1),
(303, '0cd1e19363d99385', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-23 01:38:51', '673313c1bd2aabad3d1838533e3ac467a6e06fbc6dd624f030d8f8eba3fa5bab', 1),
(304, '407191eb7e0080e4', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-23 23:17:50', '8d42e1ed473475a2ee31e5eaf863be0e338291b40c8188564ff5d53fbeb8a3ea', 1),
(305, 'a5972570090ea4fd', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-23 23:18:08', '57c706f734db6b85a8706b8abb0fc014e483cd3b934cc725d70f3bb0334ba2a5', 1),
(306, 'a2f620d1052368f1', NULL, 'guest', 'guest', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-24 20:54:20', '12a4e581e03eb92ef5e7bb37c7a3fc5fc6df20d20f795300827767291abfde35', 1),
(307, 'e27209ec9e38e968', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-24 20:54:33', 'ffd236cf7ef86f3e8e03cdf859e0be96d2d96d60a2a9a67c8d3ec8ff6061bd07', 1),
(308, '792372809bb208e0', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-24 21:31:10', 'dab9d29910a600626192c49e75419d4b19873f4ac8bfb3d327cb356e4f740727', 1),
(309, 'f9f6b48e50e08848', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"C\\u00f3digo de verificaci\\u00f3n para actualizar tus datos | Data Wyrd\"}', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/jobs/requestUpdateCode', 'POST', '2026-03-24 22:38:06', '41f0ae641fa75eeed285e9f4887f453c49b345ec3d4be84dd13dc29218d4e8b6', 1),
(310, 'd95603f75a7c52e2', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-24 22:41:14', '182cbc0e6512b07a22ac1eb9c341fe9226a44c4530243a5c39a4b508fd642744', 1),
(311, '68709c73eddc55f3', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-24 23:00:44', '366996f1807dec4c3233e5da19cc920772df9dec505adb6a57a32520f17b05e1', 1),
(312, '46a1b731c2442108', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"C\\u00f3digo de verificaci\\u00f3n para actualizar tus datos | Data Wyrd\"}', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/jobs/requestUpdateCode', 'POST', '2026-03-24 23:02:07', '1a29f253a07ee82501c365990c4a19850f4916d747aceff3fddf9aef494d0cae', 1),
(313, 'c59c56e6b85b4324', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"C\\u00f3digo de verificaci\\u00f3n para actualizar tus datos | Data Wyrd\"}', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/jobs/requestUpdateCode', 'POST', '2026-03-24 23:17:56', '68a03163e1cef9799e08da3577fcdf902b70add52f6ff6a4cf8db1a2fd04957e', 1),
(314, '2a6a253522b0cb6e', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:188e:3478:a138:2f79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-24 23:18:52', 'cdd785e7b926daa031fd3ceebb4815b3ce88ee60e26cf735e68434cea5f4f6c7', 1),
(315, 'cca7759a99dabc89', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"\"}', 'WARN', '157.55.39.52', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '/auth/doLogin', 'GET', '2026-03-25 11:24:00', '232063c36737c20ef0787a7f50098a2125a7a9d53098ca035cfab5c50ffd5dcd', 1),
(316, '7cc0fe1c4df1a25d', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"jpgaray.ing@gmail.com\",\"subject\":\"\\u00a1Gracias por postularte a Data Wyrd!\"}', 'INFO', '190.230.12.27', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '/jobs/postulate', 'POST', '2026-03-26 03:27:04', '4c12a40dcd220e20f25210b4491435792c7c3df40d441e6eb369c59fa05b69c1', 1),
(317, 'e7c405ab57f7728f', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '181.238.114.163', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-27 20:44:31', '9c2feaea642fbc9ba64e9e9045a196448f1354c72819bfca05d79cc8acbc617f', 1),
(318, 'e81652937d3e8bff', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '181.238.114.163', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-27 20:44:43', 'aa4b8fa5562664eceec5406c42514f7f5278ff597e514d2d8262008ee1cb4dc3', 1),
(319, '1f100fe88efc347a', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:499b:642a:6b31:c6b2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-28 23:57:24', 'd26c4baa99f2c3ef5168bc18e682c4da5fe68abb6dd2a0167a6ce4ff34520c77', 1),
(320, '41dd0e6978731afd', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:499b:642a:6b31:c6b2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-29 00:13:41', '0286a913f4646a0096b8c90432689fb3d0f42b7d6dfa5a273480b3edb5437300', 1),
(321, '9f35e6c7cadc95d0', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-29 01:31:31', '9decd0d7cbd8fd8d6c0a03d031eb7b423aa1b0dd80908f7690a9685e014a34cd', 1),
(322, '2d8eddb0fce3b41a', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"vezetaelea@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-7026CC\"}', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/ticket/submit', 'POST', '2026-03-29 01:33:50', 'a7121b4cde9a9be78a4803e39afe401a6b28a8eb72ee78d29361b4808a23654b', 1),
(323, '2d8eddb0fce3b41a', NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-7026CC\",\"email\":\"vezetaelea@gmail.com\"}', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/ticket/submit', 'POST', '2026-03-29 01:33:50', 'f23377d721f0d35f1b26c5db271b1103445732002ba3fd59cca433d49fad1ae7', 1),
(324, 'cb592e2e92e80df6', 1, 'admin@datawyrd.com', 'admin', 'email_sent', '{\"to\":\"vezetaelea@gmail.com\",\"subject\":\"Presupuesto Disponible: DW-B2026-C803\"}', 'INFO', '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/budget/store', 'POST', '2026-03-29 01:39:57', '8467c0b8eb144f46a0663fda894f596f178e43bc3f2be56ace91ade49858dceb', 1),
(325, '46de3c8079465a65', 13, 'vezetaelea@gmail.com', 'client', 'invoice_generated', '{\"invoice_id\":10,\"invoice_number\":\"DW-INV-20260328-20AD\",\"total\":\"138.04\",\"client_id\":13}', 'WARN', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/budget/decision', 'POST', '2026-03-29 01:41:31', 'b626840e24ec6cb0dc0348404e1bc5ed173a5f74101510cfabc704f6b8cd74e9', 1),
(326, '46de3c8079465a65', 13, 'vezetaelea@gmail.com', 'client', 'event_dispatched', '{\"event\":\"App\\\\Events\\\\InvoiceIssued\",\"timestamp\":1774748491.476088}', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/budget/decision', 'POST', '2026-03-29 01:41:31', '5338c54935eb92851c0d38451ff6f252328bc13c4983a4894ab642e9d61f9ce6', 1),
(327, '8eabe66f8da0e290', 13, 'vezetaelea@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-03-29 01:42:14', 'bbac031917c847a6dfa062885a021260cf8b4044101e8ac45c75455bbf6ddfaf', 1),
(328, 'dd1c1c45b07ce3de', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-29 01:42:27', 'b308fd1012d30d0719f5b9ce4445a2036ed5533b0882326d1b4db79987f962a6', 1),
(329, '37eda04ea80d2f42', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-29 01:55:15', '3ae0621f871e2d5626e932c14ecb828c472c8a0548ed7654d6b7c0e66a238000', 1),
(330, '3614b4016f844cc1', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-03-29 01:55:20', '579b91c7d67fd5989f95d11a1a917ccbdb8c0bbcd6b839448b38d6c7c0d262e1', 1),
(331, 'a750b5d91949bb6b', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.157 Mobile Safari/537.36 Instagram 422.0.0.44.64 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789;', '/auth/doLogin', 'POST', '2026-03-29 01:56:41', 'a8fe08839c237a91a57727a5556493497200e0d08265b571342fe1e40e450376', 1),
(332, '7fb81b9bce28ef9d', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.157 Mobile Safari/537.36 Instagram 422.0.0.44.64 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789;', '/auth/logout', 'GET', '2026-03-29 01:56:48', '32eb62c6e715661b385a9cb26457ad15f43191853f17740707e503dad60503e4', 1),
(333, 'f5657c8cf4828647', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.157 Mobile Safari/537.36 Instagram 422.0.0.44.64 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789;', '/auth/doLogin', 'POST', '2026-03-29 01:59:11', 'f9239c43a58d533cce49bc735cb195a163e02be987599be1775564f1eb719448', 1),
(334, '4a814b1d0235c969', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.157 Mobile Safari/537.36 Instagram 422.0.0.44.64 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789;', '/auth/logout', 'GET', '2026-03-29 01:59:24', 'f18e4cd15ebf601f8fd516c060903e93ce5c332d4aa8be86352b55853c8ae887', 1),
(335, 'b6fa575434601cb5', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-29 02:01:08', '9f3d0d3297062359bfea0867f530f9eae5b1585376ce3d1b6b9418374e69820b', 1),
(336, '88afb678beca150e', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-29 02:01:14', '920c312fcc45037f9e0be851b1276ac971599b6cf59589dcced7e057080bbeb8', 1),
(337, '4cb903f9b1240803', 12, 'hboadar@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-03-29 02:01:27', '7432d478cb022a7913442237bbe0528a62b4aa9074e84f10dddf35a8697b6fa9', 1),
(338, '12714b7673941817', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-03-29 02:01:30', '05039056e8a44e14c4b47d12b2bc1b27a2f00639a14843b18c061343b2352230', 1),
(339, 'ea5bb3a5f1a42dca', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"vezetaelea@gmail.com\"}', 'WARN', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-29 02:02:04', 'b933ba54bc1ed56f030b4fdd64169ff5e3c57eb3e71eb801c037ef4029971599', 1),
(340, '015ec6c2f382d1b5', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"vezetaelea@gmail.com\"}', 'WARN', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-29 02:02:17', '4d398addcfb95931b555777bdb00ca7ddf2d21b81cb1b6b9176e3249e59a97bd', 1),
(341, '7f0fd465561389e1', 13, 'vezetaelea@gmail.com', 'client', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-03-29 02:02:56', '51b473b7511ec9869632bb6b41139d35da07d54604dc53b42bfdd8577c4a320b', 1),
(342, 'ce41ba4cda1e2dec', 13, 'vezetaelea@gmail.com', 'client', 'password_changed', '\"Usuario actualiz\\u00f3 su contrase\\u00f1a.\"', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/profile/updatePassword', 'POST', '2026-03-29 02:03:13', 'e22c5f11428b07fe0a8b021095eb4bcddcb606e8ab2402a97b383e6b6a043923', 1),
(343, 'cf975d17a3e26bb3', 13, 'vezetaelea@gmail.com', 'client', 'email_sent', '{\"to\":\"contacto@datawyrd.com\",\"subject\":\"[URGENTE] Soporte Prioritario: Humberto Boada\"}', 'INFO', '201.216.219.92', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/dashboard/urgentSupport', 'GET', '2026-03-29 02:03:26', '58944a6b42e7c7a49d9d042fa83746ad993a2b47edca3d60e38c474afbb92b7a', 1),
(344, 'd75843065f32c190', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"sizwemondlane20044@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, DanielVup!\"}', 'INFO', '196.196.53.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.66 Safari/537.36', '/ticket/submit', 'POST', '2026-03-29 20:21:29', '795ac1000a439ec73a3db0d9f090f0a1cdcafa5b38b8b7a64e2a16562c56cd84', 1),
(345, '5f760d8fc479b096', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '201.216.219.113', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-04-01 11:15:58', '595fac872e66de441239774adf57ff44e6167c82e99863ef7a7dcd339fd73702', 1),
(346, 'a0485153487d8cda', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '201.216.219.113', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-04-01 11:20:19', 'fe70b46ccda8bf1ee6f21e72c2f5cefeaa359859a67ca804db621121848524d9', 1),
(347, 'ca56a8995aa7ebf1', NULL, 'guest', 'guest', 'webhook_mercadopago_received', '{\"type\":\"payment\",\"action\":\"payment.updated\",\"resource_id\":\"150354160742\"}', 'INFO', '54.88.218.97', 'MercadoPago WebHook v1.0 payment', '/webhook/mercadopago?data.id=150354160742&type=payment', 'POST', '2026-04-01 16:36:04', '3814e8376298fcc077f6f310b88dfe8df3ecf753f6bec5a5ffeef4d61db05895', 1),
(348, '4b09106f5c497df4', NULL, 'guest', 'guest', 'webhook_mercadopago_received', '{\"type\":\"unknown\",\"action\":\"unknown\",\"resource_id\":\"unknown\"}', 'INFO', '18.213.114.129', 'MercadoPago Feed v2.0 payment', '/webhook/mercadopago?id=150354160742&topic=payment', 'POST', '2026-04-01 16:36:04', '15615abf796565c270fdead09e6150a9f5bef810da68a4c80934fe9fa3adc67a', 1),
(349, 'ca56a8995aa7ebf1', NULL, 'guest', 'guest', 'invoice_partial_payment', '{\"invoice_id\":9,\"amount\":1,\"verified_by\":1}', 'WARN', '54.88.218.97', 'MercadoPago WebHook v1.0 payment', '/webhook/mercadopago?data.id=150354160742&type=payment', 'POST', '2026-04-01 16:36:05', '81fb5e5aa207835f2b50fd252869e9ee1167530bbb5c683d182f7846e227cdec', 1),
(350, 'ca56a8995aa7ebf1', NULL, 'guest', 'guest', 'webhook_payment_processing', '{\"id\":\"150354160742\"}', 'INFO', '54.88.218.97', 'MercadoPago WebHook v1.0 payment', '/webhook/mercadopago?data.id=150354160742&type=payment', 'POST', '2026-04-01 16:36:05', '9fe5444858633867ffb5945053875850eb595b7773f68dc1cf257dff822e4280', 1),
(351, '1b289f0ebf7f32b8', NULL, 'guest', 'guest', 'webhook_mercadopago_received', '{\"type\":\"unknown\",\"action\":\"unknown\",\"resource_id\":\"unknown\"}', 'INFO', '18.206.34.84', 'MercadoPago Feed v2.0 merchant_order', '/webhook/mercadopago?id=39062024098&topic=merchant_order', 'POST', '2026-04-01 16:36:06', '753ecc329d8f14dd2991d947ec3e243173d3321ff363d670b277512f81815fbf', 1),
(352, 'adcf0e72164b5bc5', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"rjharron@hotmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, DanielVup!\"}', 'INFO', '165.231.182.46', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36', '/ticket/submit', 'POST', '2026-04-02 07:34:17', 'fec2bf68e26c61633ed470423f08a69e9412ffc6e693feeddc3781772750dd96', 1),
(353, '57ae3d9b526cc713', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-04-02 18:02:57', '69be8323ed8c1d9cb68a5a5d4d976744fb00d255603c9c909a65494c2a76e45c', 1),
(354, '2a91198f4fea0503', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"salomongonzalo8@gmail.com\",\"subject\":\"\\u00a1Gracias por postularte a Data Wyrd!\"}', 'INFO', '181.29.111.253', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '/jobs/postulate', 'POST', '2026-04-02 20:05:49', '217157b248f62a7d5803e8c4467673c3a348bd3f199a784d513f9837389cc1d5', 1),
(355, '8476372c80ba7ad8', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"\"}', 'WARN', '51.89.129.117', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)', '/auth/doLogin', 'GET', '2026-04-03 21:00:50', 'fd0ebe6ad1b4544768841d63064b2a32b3cbe0c4ffc4a391f217497e222e161c', 1),
(356, '5b3184bff7234d94', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-FAAFA5\"}', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/ticket/submit', 'POST', '2026-04-05 20:30:10', 'aa89ca5f82c12efa5e9d6122804e20034e6bb7a78a7437dbc2e542627e653745', 1),
(357, '5b3184bff7234d94', NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-FAAFA5\",\"email\":\"hboadar@gmail.com\"}', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/ticket/submit', 'POST', '2026-04-05 20:30:10', 'c2ae86c1f31118425faed8a30fb19bcdd3e291529459cd5806d8f81ee1eba867', 1),
(358, '57d57a0cc0445bd5', 12, 'hboadar@gmail.com', 'client', 'password_changed', '\"Usuario actualiz\\u00f3 su contrase\\u00f1a.\"', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/profile/updatePassword', 'POST', '2026-04-05 20:30:24', '136179ad8951c6b764b735fa37d7e4e7d8d1149b92abd41b8b98a44df34dc64d', 1),
(359, '83d4454896df5c7f', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:df33:dc31:b01d:729e', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-04-05 20:31:06', 'a4d7522b34eaafefbf509d830b1d295ea1eafe529988eb3f7245df84cb2feb69', 1),
(360, 'c43ee67216ea5095', 1, 'admin@datawyrd.com', 'admin', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"Presupuesto Disponible: DW-B2026-3C3A\"}', 'INFO', '2800:40:3a:bd0d:df33:dc31:b01d:729e', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/budget/store', 'POST', '2026-04-05 20:31:44', 'eb1a2b1f3794d260a85b79d8b7b8988d93b9e4b64ee9036099225fa227a3987d', 1),
(361, '3e4a4d38679c07d5', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:df33:dc31:b01d:729e', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-04-05 20:33:27', '30d78ca9b27b30033dac22cd8ad8c62117fd228076c08400c40791920f6e3698', 1),
(362, '39da751f6c853f31', 12, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-04-05 20:33:40', '057a4b7623aff069ef495dc90c1739f075bf3c76b50393c9a4d5bb15ebce2ea0', 1),
(363, 'ee3f6028dde4e0e0', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-04-05 20:34:15', 'c25d6a44a26a51fad4f4331500d8065a8af47a10d4bb03213e9e7c81cd01df8f', 1),
(364, '19dd6108065592ef', 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '\"Administrador elimin\\u00f3 permanentemente al usuario ID: 13\"', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/admin/users/destroy/13', 'GET', '2026-04-05 20:34:42', 'ec2ff24e154a4940d5f677497c0e69960a8122a3fd0373b66606c8d09bb2b8c3', 1),
(365, 'f4fa6ee50817c416', 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '\"Administrador elimin\\u00f3 permanentemente al usuario ID: 12\"', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/admin/users/destroy/12', 'GET', '2026-04-05 20:34:53', '68b9ab3e6f1efe41afdc5f8b7eb48c65779cdc63c51e945e9e1b3f2db9f16be0', 1),
(366, '9d265cc95faaedf9', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-04-05 20:48:17', 'b4b555d783b78d1011ce2ee01db7120540ef2e796f14a95e47d5cee2f53a2c59', 1),
(367, '4849075ee4d55d0c', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Humberto Boada!\"}', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/ticket/submit', 'POST', '2026-04-05 20:49:05', '8be8b49422ca8e251b50214c79547f5946819174e1c6785695104f18573285de', 1),
(368, '4849075ee4d55d0c', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-F8C6E1\"}', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/ticket/submit', 'POST', '2026-04-05 20:49:08', 'e03612d19071328a2cc6a5fbac15eba1d4f7fc780fcbd315ae409e85239bbbe4', 1),
(369, '4849075ee4d55d0c', NULL, 'guest', 'guest', 'ticket_created', '{\"ticket_number\":\"TKT-F8C6E1\",\"email\":\"hboadar@gmail.com\"}', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/ticket/submit', 'POST', '2026-04-05 20:49:08', '3f3eece39ddb6b9db26daf34893575e834def7941a2ef36b266dbef18f1d2a4a', 1),
(370, 'a6e377fa4c91ac24', 16, 'hboadar@gmail.com', 'client', 'password_changed', '\"Usuario actualiz\\u00f3 su contrase\\u00f1a.\"', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/profile/updatePassword', 'POST', '2026-04-05 20:49:22', 'ed6daafe2cf42113efad509c60a1f12f5ddfd41d66b569c3aa77db1fc5fee08e', 1),
(371, '8a4ecb11193ed403', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@vezetaelea.com\"}', 'WARN', '2800:40:3a:bd0d:df33:dc31:b01d:729e', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-04-05 20:49:51', 'd26fe824e752ae4aab5352354f48801aa255858580714d4c0ac497679c6f8a4b', 1),
(372, '0e9f958fc64e885e', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:df33:dc31:b01d:729e', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-04-05 20:50:19', 'c6944780186a7262db151001f18c83d01b05b80eeee02b5358d88a61cc96f537', 1),
(373, '0dbf32885effff98', 1, 'admin@datawyrd.com', 'admin', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"Presupuesto Disponible: DW-B2026-591B\"}', 'INFO', '2800:40:3a:bd0d:df33:dc31:b01d:729e', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '/budget/store', 'POST', '2026-04-05 20:51:33', 'e83cd69e17f3c9900c6c6c1fe05488f7d330e8bd42b9ff17785493cee46a0222', 1);
INSERT INTO `audit_logs` (`id`, `request_id`, `user_id`, `user_email`, `user_role`, `action`, `details`, `level`, `ip_address`, `user_agent`, `request_uri`, `request_method`, `created_at`, `signature_hash`, `tenant_id`) VALUES
(374, '06fcffce8a399374', 16, 'hboadar@gmail.com', 'client', 'invoice_generated', '{\"invoice_id\":11,\"invoice_number\":\"DW-INV-20260405-096B\",\"total\":\"138.04\",\"client_id\":16}', 'WARN', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/budget/decision', 'POST', '2026-04-05 20:51:58', 'ecc77768ae15538b2e665e493f99ea65d6fbf13637af1febc8fc052c9b9c07cc', 1),
(375, '06fcffce8a399374', 16, 'hboadar@gmail.com', 'client', 'event_dispatched', '{\"event\":\"App\\\\Events\\\\InvoiceIssued\",\"timestamp\":1775422318.140596}', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/budget/decision', 'POST', '2026-04-05 20:51:58', 'aa7f35f7e3d51c421d068e96494180ab4b01083917856c4a4d386f1eaabe4457', 1),
(376, '83bf4c5611c3d6c7', 16, 'hboadar@gmail.com', 'client', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-04-05 22:06:32', '7a7baa8b61e54af10f95bd14cdd3a0ec79fc287e9ddc378ed967877f562a0479', 1),
(377, '9988451a970d979e', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-04-05 22:07:17', 'a0a6137160307760d304c65b6832bbeb05e8e60a4ebef507939bbbf3235b976d', 1),
(378, 'ed997d28ea81e95b', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"sardodata@gmail.com\",\"subject\":\"\\u00a1Gracias por postularte a Data Wyrd!\"}', 'INFO', '186.124.84.64', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '/jobs/postulate', 'POST', '2026-04-06 14:19:07', '934d7d77451cd50dbf9875511647cd10322aca5b845f0f32a988d19300dee3d1', 1),
(379, 'b276a6a18069fac3', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.104.205.132', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-04-07 13:05:26', '7388df927df939096ffce245cebf0931f7b111dce8cb1ca543f8ee4512ed4d6f', 1),
(380, '395e90085851f447', 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '\"Administrador elimin\\u00f3 permanentemente al usuario ID: 15\"', 'INFO', '190.104.205.132', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/admin/users/destroy/15', 'GET', '2026-04-07 13:26:17', '8a33354afad18bd19e55c0c9b3f4ec947655ea6f9948a3ccc5c49f77750d3b15', 1),
(381, '20b2cf237513a0df', 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '\"Administrador elimin\\u00f3 permanentemente al usuario ID: 14\"', 'INFO', '190.104.205.132', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/admin/users/destroy/14', 'GET', '2026-04-07 13:26:23', '7aab2993bf2118588f71bf58dadd0dc06877401fb4103f50d3b949e851b5f80e', 1),
(382, 'a99713b4469225c7', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '190.104.205.132', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/logout', 'GET', '2026-04-07 13:32:10', '1965071447fbabe6a961d5f7cece9a2493a2d281dd5f3b133ffe848643760ad7', 1),
(383, 'b853215076b0d182', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:4cd1:5399:e56c:5dd9', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '/auth/doLogin', 'POST', '2026-04-12 14:50:58', '2c7e6d63a1f1cc045488b91592618c61559afed8466b64692ab8ca1c02c81c62', 1),
(384, '7fd3b175c7653cad', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:4cd1:5399:e56c:5dd9', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '/auth/doLogin', 'POST', '2026-04-12 19:25:43', 'c53e8333802af84dc181b593becfe410d39c275c06268f6f7a206c0ac6559929', 1),
(385, '42d9d74590e34578', 1, 'admin@datawyrd.com', 'admin', 'user_deleted_permanently', '\"Administrador elimin\\u00f3 permanentemente al usuario ID: 16\"', 'INFO', '2800:40:3a:bd0d:4cd1:5399:e56c:5dd9', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '/admin/users/destroy/16', 'GET', '2026-04-12 19:26:04', 'cc95d0d6f11151cdcd4e3cf1df529f477982823ec4d6ab0c1be4d4d0234db291', 1),
(386, '2255d223640c1ae2', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.104.205.132', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-04-13 11:49:11', '92c37e8507e2b3809479363c1b1eda62d273dd8c8554d3ad0baf5e80be5dac6b', 1),
(387, '534fa2a80568bcf4', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"jacksrenome@gmx.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, MichaelAcawn!\"}', 'INFO', '165.231.182.110', 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.53 Safari/537.36', '/ticket/submit', 'POST', '2026-04-15 05:28:52', '630729f2973a35bab8ba723d840a4e5e924098240d23891beb6f2c12a49576c9', 1),
(388, '90fa95b0d78f1d44', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '201.216.219.193', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '/auth/doLogin', 'POST', '2026-04-15 20:33:44', '7426426f3f850faee81ea7838e95f99580f610797f9592f17fe1085eab6c32e8', 1),
(389, '9acb95302cf0510d', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:4c13:6295:2adf:5698', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '/auth/doLogin', 'POST', '2026-04-18 18:39:49', '2415e8d7bd701305be37ee9e5d576af29f7e7890cbc9ffd42c7264d0e2cc4689', 1),
(390, '4cd36352427aadab', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"\"}', 'WARN', '40.77.167.24', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '/auth/doLogin', 'GET', '2026-04-23 19:20:36', 'd45ccceed740db6b20c41708ce3ed1a5820a866115dbe959b371e900a90e69ed', 1),
(391, '0e1b0310f71be9dd', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"davidwilliams28798@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, David Williams!\"}', 'INFO', '223.233.76.70', 'Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0', '/ticket/submit', 'POST', '2026-04-25 21:51:05', '68e04ec0163e4434a74f5fc32f4b400c500ee5f862eb51421bdfe147c29c3f2d', 1),
(392, '276a88f0c73a15cf', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '181.238.22.180', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-04-27 10:55:29', '70cd9c53252d6df5e6339d420f9d6190e9114abdf6be0921472722d3bfa16188', 1),
(393, '009f1e823519f571', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '181.238.22.180', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-04-27 10:56:46', 'af8c0545a48dfa8709db5074cef9e19478357af82667f03aba7d716a0325d26b', 1),
(394, 'de1396966a405506', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.210.32.25', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-04-30 20:05:04', 'd3cabbde467206219b1abd0b809629fc57f89ac1306078e8ce937ec24323d368', 1),
(395, 'd7e0d02d5a2fc73c', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:3d12:4775:75e6:fa12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '/auth/doLogin', 'POST', '2026-04-30 20:14:23', 'dfad99af44ee8fdb5bfdc0b62512741cb3681f49f00183eeadbe1a85128bb40d', 1),
(396, 'c41143002c9923be', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.210.32.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '/auth/doLogin', 'POST', '2026-05-01 15:45:41', 'f0900c759f48e13dbb9d2581a2d7022f07a7acb64c939510b88e55b9119c85d1', 1),
(397, '185d587bba058a19', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:3d12:4775:75e6:fa12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '/auth/doLogin', 'POST', '2026-05-01 21:01:42', '8c7e091abdfdc140e62bf05b80e4141d1255acba669cf82496d895eb87c5fd6f', 1),
(398, 'ef836aa8b3223d9b', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:3d12:4775:75e6:fa12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '/auth/logout', 'GET', '2026-05-01 21:08:28', 'd9fbe3366ee5a370fed594ec53dee2c5aba1834f3c7b1d0d8ee19790764ab5c1', 1),
(399, '3a92a440b51b4c69', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"no.reply.ArthurJanssens@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, DavidStert!\"}', 'INFO', '158.173.154.9', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Avast/131.0.0.0', '/ticket/submit', 'POST', '2026-05-03 15:10:43', '90464e43bc8950f3259a7114b3dfb2120fe836f435bd73ff419522582c633379', 1),
(400, 'ad7c2b2ed1182490', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.210.32.193', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '/auth/doLogin', 'POST', '2026-05-06 15:19:37', '4941cce4f5de543bc4a75307e9f9489f7f30b37f22fc58bb5d78714a1197e4bb', 1),
(401, '30352a5f8ac15fce', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '190.210.32.193', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '/auth/doLogin', 'POST', '2026-05-07 14:42:57', 'a927aef9a4d501378adfec047c63cc4df67b6ba63c9cca98a07841f14844aac4', 1),
(402, '1536536de9e59a86', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:9ce4:ec18:b499:59b5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '/auth/doLogin', 'POST', '2026-05-16 22:54:47', 'c31b5cf75f866817ecce2c74e3ae9e1e2020a70c369c5a040f2c89f8a0bcbc89', 1),
(403, '980cbee3b7f618ed', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"thirteenonionsreboot@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, WilliamtwedS!\"}', 'INFO', '158.173.241.246', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36', '/ticket/submit', 'POST', '2026-05-19 18:34:16', '7cd59fa032055175e3c5a74f8f901aa8349d263106dfb2c740f7cce9b1b68b55', 1),
(404, '97a9770888f0a01e', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '201.216.219.236', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-05-20 16:37:48', '2b863d9bfc02977cee184e9b29fa39b2dd16ff68f8c377ebfd8c533aebfe6146', 1),
(405, 'a582894bc18c9888', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '201.216.219.236', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-05-20 16:38:36', '62619fff22b28a8591690e8478a533da777dcb4bc81b6d9beb201db6e5bbccb7', 1),
(406, '65bc62ed87824e22', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"joepain911@outlook.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, WilliamtwedS!\"}', 'INFO', '158.173.241.171', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36', '/ticket/submit', 'POST', '2026-05-22 00:00:09', 'b80a6ffafc0cfc27d9b11f141d030e362d74dfe5236ed93a2e1c1ef7d73b1df5', 1),
(407, 'ebedbd3ca3eae3d1', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"ashton.wolfgang@outlook.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Ashton Wolfgang!\"}', 'INFO', '217.79.116.223', 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:114.0) Gecko/20100101 Firefox/114.0', '/ticket/submit', 'POST', '2026-05-24 07:23:06', '5df563a841e8b713b5da41137ea5a6b78358b8d57b8369fb0aaf06db03cfa73e', 1),
(408, 'f8509d399eef3f3a', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"ella.bryan@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Ella Bryan!\"}', 'INFO', '217.79.116.205', 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Vivaldi/5.3.2679.68', '/ticket/submit', 'POST', '2026-05-25 20:41:47', '353909db881e9c7c8ddec30f2eda3d0cc091a79226e3aec43b53226d151c906e', 1),
(409, '944ba9cfeaab0353', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"exchangebureau@yahoo.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Director Alexander!\"}', 'INFO', '158.173.156.16', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/ticket/submit', 'POST', '2026-05-26 15:03:29', '4a65d56c102b04abf0459da83f3a6fdaf6ae996a51beed0b9eca1ea24fdab436', 1),
(410, '8d276d41fed60094', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"avtosalon-tm@mail.ru\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, WilliamHanda!\"}', 'INFO', '158.173.241.27', 'Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36', '/ticket/submit', 'POST', '2026-05-26 19:05:50', 'c3d9eb42c947879fa32d797c962cb963f70249f9d6045bc2d7647af3c5d0b118', 1),
(411, '1bf6a67a9898f282', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"noel.auld@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Noel Auld!\"}', 'INFO', '103.107.197.164', 'Mozilla/5.0 (X11; Linux i686; rv:114.0) Gecko/20100101 Firefox/114.0', '/ticket/submit', 'POST', '2026-05-26 20:05:11', 'ba40168062bf86b0020cde08c2dd504c4e4b8f9f111dca80d2592563a62dcb73', 1),
(412, '715d5f2e274156fc', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:65c9:450:1c1e:d19e', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-05-30 23:12:39', '74073512cf5b6b915f2dad393b4456a54b89e85a973e114ea0297d47122654cc', 1),
(413, '1bf9f98f28d5f6ca', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '190.210.32.173', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-05-30 23:15:54', 'a6c53cf2508b3a354e2f9e3aa3ecff842fce18f517a944971f0114908df1921e', 1),
(414, 'a58387a5eb758f0e', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"\"}', 'WARN', '40.77.167.53', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '/auth/doLogin', 'GET', '2026-05-31 13:52:13', 'b41d46f61c6ea62212d6c5016217120930e5071bf6ca25bbaf699f7a0c654467', 1),
(415, '939444c61bb2c873', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '200.49.93.243', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '/auth/doLogin', 'POST', '2026-06-02 16:03:33', '62cbdbe1e9776361411a2ed490fe90ae53aeec513ddedcce0ee29eba6d907778', 1),
(416, '2ccbbaf1d8f7220d', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '200.49.93.243', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '/auth/logout', 'GET', '2026-06-02 16:05:23', 'b16f5db5e80238f178ff66b7d5352ac05e1a7486cce351264d0eabc7af7cfc00', 1),
(417, '51b44d15848108ce', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"fennellfinancialgroup1@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Mohammad Abdallah!\"}', 'INFO', '181.214.206.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 CCleaner/130.0.0.0', '/ticket/submit', 'POST', '2026-06-02 16:18:10', 'b5b50fee9d176d3e46c93c56feb7659c81e24dab21fe4dbe247f3402d6ccba69', 1),
(418, 'e0ef113dcfc63bf4', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '/auth/doLogin', 'POST', '2026-06-06 17:17:52', '1d3713122fcada03fcd1e842ea75d5392a979d1baf6cf1997d91891d8513d8e1', 1),
(419, 'f85879bf2ab9922a', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '186.157.75.113', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-06-06 19:57:25', '043299f6630313122cf03207ba6db92a48c39283c6ba89d0a6f082b9f97ff168', 1),
(420, 'e12288fd3d63af0e', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '186.157.75.113', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-06-06 19:57:58', '0a62f9268410d6f693d94931f134b6af4dd707452e2d21c0d57c818628420653', 1),
(421, '613ac6ec74304929', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"admin@datawyrd.com\"}', 'WARN', '181.239.159.14', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-06-06 20:55:13', '59f87bd54dfb2be9fbb37ab960de1d60dcbaae4d7b67cd963eead1a2b44f1560', 1),
(422, 'f338c4827261f87e', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '181.239.159.14', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-06-06 20:55:25', '39241607a7872e5127b936a3561074092e90f274a0f53ecc881173b1c64b2d3e', 1),
(423, '25405196755cbb65', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '181.239.159.14', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '/auth/logout', 'GET', '2026-06-06 20:56:11', 'ab6b8d25bb035b4eb7c373452a386aa44605a6d24f8ceb6e09c05c4d37beb2b7', 1),
(424, 'd0e039c905a43b03', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '/auth/doLogin', 'POST', '2026-06-07 00:09:12', '479f671460c4e13985959b144df20bc81d9f2752e1391733e8d90689412e4609', 1),
(425, 'eb7377e993f112d4', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '/auth/logout', 'GET', '2026-06-07 00:09:39', '2d1a9de7b9f592002910b244c08530e196ff47198629be6b65faebbffd9d8d29', 1),
(426, 'b76283443043add4', NULL, 'guest', 'guest', 'login_failed', '{\"email\":\"hboadar@gmail.com\"}', 'WARN', '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '/auth/doLogin', 'POST', '2026-06-07 13:27:55', 'de25437f5212c30d46cefa6a9a3c87a27fc48298a8f7d167ea31295c3703a56f', 1),
(427, '550a3511197f36d4', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '/auth/doLogin', 'POST', '2026-06-07 13:28:09', 'ca27fbcb89c717a6f04bd41a6f730772b108b63c2d0272bc73ff9d7a6e237e44', 1),
(428, 'd0db17804c587883', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '/auth/logout', 'GET', '2026-06-07 13:29:25', 'beb0f0f6a49974362260eb6173f958c95935f5a6c7014b9afac864e434ae35e2', 1),
(429, '2d23049a2bb9db8d', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '/auth/doLogin', 'POST', '2026-06-07 14:11:29', 'b42fd90ffaa913b1d4666e30d6b96f3e80b156cd73b7fe08d5c45635462e4619', 1),
(430, '3031e6daf8e5ca7b', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '186.157.74.86', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '/auth/doLogin', 'POST', '2026-06-07 14:40:42', '56209c6ebe29978e76f357184ad61db28b9d5c53dd7a22f68a307c0f12f835aa', 1),
(431, 'ec18983bf477a241', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '/auth/logout', 'GET', '2026-06-07 15:26:18', '5eb5805d3c78eafb85880c2293f71b296e71df01a44e4dac99e42247cee91813', 1),
(432, '97d98cc808846277', NULL, 'guest', 'guest', 'email_sent', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Humberto Boada!\"}', 'INFO', '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '/ticket/submit', 'POST', '2026-06-07 15:27:40', 'fb6f9dfe8632f8689771ce00c9a0f45334ead78735173f4d1ba1d8b06ef604b8', 1),
(433, '4d4200611305315b', 1, 'admin@datawyrd.com', 'admin', 'login_success', '\"Usuario inici\\u00f3 sesi\\u00f3n correctamente.\"', 'INFO', '201.216.219.226', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '/auth/doLogin', 'POST', '2026-06-07 16:30:30', 'a5066adf3d6a73d915bc956315c8a69f32f594370898cfcffd06bdfde1dd1133', 1),
(434, 'd82228ec61d615dd', 1, 'admin@datawyrd.com', 'admin', 'logout', '\"Usuario cerr\\u00f3 sesi\\u00f3n.\"', 'INFO', '201.216.219.226', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '/auth/logout', 'GET', '2026-06-07 16:30:39', '25ea476dd4ebc6618d6d6a4fd0c457c444c118c36a877501ed0e4e94080361d1', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `automation_logs`
--

CREATE TABLE `automation_logs` (
  `id` int(11) NOT NULL,
  `rule_id` int(11) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `status` enum('success','failed') NOT NULL,
  `result` text DEFAULT NULL,
  `executed_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `automation_rules`
--

CREATE TABLE `automation_rules` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `event_trigger` varchar(100) NOT NULL,
  `conditions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`conditions`)),
  `actions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`actions`)),
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `automation_rules`
--

INSERT INTO `automation_rules` (`id`, `name`, `description`, `event_trigger`, `conditions`, `actions`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Ticket Idle Warning', 'Notifica al staff si un ticket lleva más de 48h sin respuesta.', 'ticket_idle', '{\"idle_hours\": 48}', '[{\"action_class\": \"App\\Automation\\Actions\\NotifyStaff\", \"params\": {\"template\": \"idle_alert\"}}]', 1, '2026-03-08 23:56:55', '2026-03-08 23:56:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `blacklist`
--

CREATE TABLE `blacklist` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(190) NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lista negra global para evitar envíos a correos desuscritos o rebotados';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `blog_categories`
--

CREATE TABLE `blog_categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `color` varchar(7) DEFAULT '#3B82F6',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `blog_categories`
--

INSERT INTO `blog_categories` (`id`, `name`, `slug`, `description`, `color`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Engineering', 'engineering', 'Artículos técnicos sobre ingeniería de datos y desarrollo de software.', '#3B82F6', 1, '2026-02-08 22:53:41', '2026-02-08 22:53:41'),
(2, 'Business Intelligence', 'business-intelligence', 'Tendencias y mejores prácticas en BI y visualización de datos.', '#8B5CF6', 1, '2026-02-08 22:53:41', '2026-02-08 22:53:41'),
(3, 'AI & Machine Learning', 'ai-machine-learning', 'Inteligencia artificial, machine learning y automatización.', '#EC4899', 1, '2026-02-08 22:53:41', '2026-02-08 22:53:41'),
(4, 'Business Strategy', 'business-strategy', 'Estrategia empresarial y optimización de procesos.', '#F59E0B', 1, '2026-02-08 22:53:41', '2026-02-08 22:53:41'),
(5, 'Tutoriales', 'tutoriales', 'Guías paso a paso y tutoriales prácticos.', '#10B981', 1, '2026-02-08 22:53:41', '2026-02-08 22:53:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `blog_posts`
--

CREATE TABLE `blog_posts` (
  `id` int(10) UNSIGNED NOT NULL,
  `author_id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `excerpt` varchar(500) DEFAULT NULL,
  `content` longtext NOT NULL,
  `featured_image` varchar(255) DEFAULT NULL,
  `status` enum('draft','scheduled','published') NOT NULL DEFAULT 'draft',
  `published_at` timestamp NULL DEFAULT NULL,
  `views_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `allow_comments` tinyint(1) NOT NULL DEFAULT 1,
  `meta_title` varchar(100) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `blog_posts`
--

INSERT INTO `blog_posts` (`id`, `author_id`, `category_id`, `title`, `slug`, `excerpt`, `content`, `featured_image`, `status`, `published_at`, `views_count`, `allow_comments`, `meta_title`, `meta_description`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 'El Entramado de la Inteligencia de Negocios: Cómo Data Wyrd Redefine la Ingeniería de Datos', 'el-entramado-de-la-inteligencia-de-negocios-c-mo-data-wyrd-redefine-la-ingenier-a-de-datos', 'En la era de la información, el verdadero reto de las empresas no es la falta de datos, sino el caos que estos generan cuando carecen de estructura. Bajo la premisa de que \"los datos aislados son ruido, pero conectados son destino\", la firma Data Wyrd ha consolidado un flujo comercial y operativo que transforma la complejidad técnica en claridad estratégica para la toma de decisiones.', 'En la era de la información, el verdadero reto de las empresas no es la falta de datos, sino el caos que estos generan cuando carecen de estructura. Bajo la premisa de que \"los datos aislados son ruido, pero conectados son destino\", la firma Data Wyrd ha consolidado un flujo comercial y operativo que transforma la complejidad técnica en claridad estratégica para la toma de decisiones.\r\n<br><br>\r\nFase 1: La Ingeniería del Propósito<br>\r\nTodo proyecto en Data Wyrd comienza con una Configuración de la Solución meticulosa. A diferencia de las implementaciones genéricas, este flujo parte de la selección de un Pilar Estratégico:\r\n<li>\r\n  Aplicaciones y Web Apps: Creación de ecosistemas fluidos que conectan cada punto de interacción con el cliente.\r\n<li>\r\n  Business Intelligence & Analytics: Interpretación de hilos de información para trazar el camino más corto hacia los objetivos comerciales.\r\n<li>\r\n  Arquitectura y Gobierno de Datos: Construcción de bases sólidas capaces de resistir el paso del tiempo y la escala de la demanda.\r\n<li>\r\n  Automatización Operativa: Eliminación de procesos manuales para permitir un flujo de negocio constante y evolutivo.\r\n<br><br>\r\nUna vez definido el pilar, la empresa utiliza Formularios Inteligentes con pre-poblado automático, agilizando la carga de información del proyecto y garantizando que la inteligencia de datos se aplique desde el primer contacto.\r\n<br><br>\r\nFase 2: El Modelo de Entrega Data Wyrd™\r\n<br>\r\nLa ejecución se rige por un modelo de entrega iterativo que busca eliminar el riesgo estructural y generar un impacto medible desde el primer sprint. Este proceso se divide en tres etapas críticas:\r\n<li>\r\n  Diagnóstico y Arquitectura: Se realiza un análisis profundo de la infraestructura actual para diseñar una solución técnica escalable que actúe como la columna vertebral de la inteligencia de negocio.\r\n<li>\r\n  Implementación por Sprints: El desarrollo se basa en releases pequeños pero completos. Esta metodología permite realizar ajustes de rendimiento y escalabilidad de forma continua, acompañando el crecimiento de la empresa.\r\n<li>\r\n  Seguimiento en Tiempo Real: La transparencia es el eje central. A través de un Portal de Seguimiento Propio, los clientes tienen acceso exclusivo para monitorear el progreso de sus proyectos, gestionar tickets y comunicarse directamente con el equipo de soporte.\r\n<br><br>\r\nLa Seguridad como Cimiento\r\n<br>\r\nFinalmente, toda esta estructura descansa sobre un blindaje de Seguridad Enterprise. Desde criptografía de última generación (Argon2id) hasta auditorías forenses inmutables mediante hash chaining, Data Wyrd asegura que el viaje hacia la inteligencia sea tan seguro como eficiente.\r\nCon este enfoque end-to-end, Data Wyrd no solo entrega software, sino que construye el entramado invisible que permite a las empresas líderes dominar su operación diaria y anticipar el futuro de su mercado.', 'assets/images/post/6a9f7679cf72acdbd947ccfa9e288b75_1776030341.jpg', 'published', NULL, 67, 1, NULL, NULL, '2026-04-12 21:43:52', '2026-06-07 12:23:43'),
(2, 1, 3, '¿Tu IA es un motor de negocio o solo una \"Demo\" brillante?', '-tu-ia-es-un-motor-de-negocio-o-solo-una-demo-brillante-', 'Vivimos en la era de la gratificación instantánea tecnológica. Hoy, crear un prototipo de Inteligencia Artificial que impresione en una reunión es, sorprendentemente, sencillo. Basta un buen prompt y una interfaz amigable para generar ese efecto \"wow\". Pero aquí es donde surge la pregunta que separa a los entusiastas de los profesionales: ¿Qué sucede cuando apagamos las luces de la presentación y dejamos que la IA se enfrente sola al mundo real?\r\n<br>\r\nEn Data Wyrd, hemos bautizado este fenómeno', 'Vivimos en la era de la gratificación instantánea tecnológica. Hoy, crear un prototipo de Inteligencia Artificial que impresione en una reunión es, sorprendentemente, sencillo. Basta un buen prompt y una interfaz amigable para generar ese efecto \"wow\". Pero aquí es donde surge la pregunta que separa a los entusiastas de los profesionales: ¿Qué sucede cuando apagamos las luces de la presentación y dejamos que la IA se enfrente sola al mundo real?\r\n<br>\r\nEn Data Wyrd, hemos bautizado este fenómeno como \"La Trampa del Prototipo\". Es ese espacio gris donde una aplicación funciona bien bajo supervisión, pero carece de la estructura necesaria para operar con la precisión, seguridad y escala que tu empresa exige.\r\n<br>\r\nSuperando el \"Modo Demo\"\r\nPasar de un experimento a una solución de producción no es una cuestión de estética, sino de ingeniería. Para que una IA sea verdaderamente útil, debe dejar de ser una \"caja negra\" y convertirse en un sistema profesional basado en tres pilares:\r\n<br>\r\n1.- La Ilusión de la Velocidad vs. La Realidad de la Escala: Un prototipo rápido no siempre es un prototipo escalable. ¿Tu sistema actual puede manejar diez mil consultas simultáneas con la misma fidelidad que maneja una sola?\r\n<br>\r\n2.- Observabilidad: ¿Duermes tranquilo? En el software tradicional, sabemos por qué algo falla. En la IA, si no construyes sistemas \"observables\", estás operando a ciegas. La pregunta no es si fallará, sino si te enterarás antes que tu cliente.\r\n<br>\r\n3.- Seguridad y Ética por Diseño: Llevar una IA a producción significa confiarle tus datos y tu reputación. ¿Está tu sistema blindado contra alucinaciones o filtraciones, o solo estás esperando que \"se comporte bien\"?\r\n<br>\r\nUna reflexión para el liderazgo técnico\r\nLa verdadera innovación no es el prototipo que construiste ayer; es la plataforma resiliente que seguirá funcionando mañana. En nuestro ecosistema, no nos conformamos con el \"parece que funciona\". Aplicamos rigor, metodología y una hoja de ruta clara para eliminar la fricción entre la idea y el despliegue final.\r\n<br>\r\nQueremos abrir el debate: Si hoy tuvieras que poner tu proceso más crítico en manos de tu actual prototipo de IA, sin supervisión humana... ¿lo harías?\r\n<br>\r\nNos encantaría conocer tus dudas en los comentarios. ¿Cuál ha sido tu mayor desafío al intentar llevar la IA más allá de la simple demo? Si sientes que es momento de profesionalizar tu visión y construir con garantías, estamos aquí para acompañarte en ese flujo.', 'assets/images/post/5695f71213cb639484dc19047504873c_1777669490.png', 'published', '2026-05-01 21:04:50', 31, 1, NULL, NULL, '2026-05-01 21:04:50', '2026-06-06 22:03:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `budgets`
--

CREATE TABLE `budgets` (
  `id` int(10) UNSIGNED NOT NULL,
  `budget_number` varchar(20) NOT NULL,
  `ticket_id` int(10) UNSIGNED NOT NULL,
  `version` int(11) NOT NULL DEFAULT 1,
  `title` varchar(200) NOT NULL,
  `service_reference` varchar(255) DEFAULT NULL,
  `scope` text DEFAULT NULL,
  `timeline_weeks` int(11) DEFAULT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `tax_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `tax_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `currency` char(3) NOT NULL DEFAULT 'USD',
  `valid_days` int(11) NOT NULL DEFAULT 30,
  `status` enum('draft','sent','approved','rejected') NOT NULL DEFAULT 'draft',
  `notes` text DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_by` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `tenant_id` int(10) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `budget_items`
--

CREATE TABLE `budget_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `budget_id` int(10) UNSIGNED NOT NULL,
  `description` varchar(255) NOT NULL,
  `type` enum('service','license','infrastructure','other') NOT NULL DEFAULT 'service',
  `quantity` decimal(10,2) NOT NULL DEFAULT 1.00,
  `unit_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `order_position` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `candidates`
--

CREATE TABLE `candidates` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `linkedin_url` varchar(255) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `candidates`
--

INSERT INTO `candidates` (`id`, `first_name`, `last_name`, `email`, `phone`, `linkedin_url`, `country`, `city`, `address`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 'Humberto', 'Boada', 'hboadar@gmail.com', '1170215822', 'https://www.linkedin.com/in/hboadar/', '', '', '', NULL, '2026-03-21 22:48:46', '2026-03-24 22:38:53'),
(2, 'Jazmin', 'Rivas', 'jazmin.rivas003@gmail.com', '1122465897', 'https://www.linkedin.com/in/jazm%C3%ADn-rivas-a48ab9245?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app', 'Argentina', 'Buenos Aires', 'San Fernando', NULL, '2026-03-22 14:19:57', '2026-03-29 00:05:01'),
(3, 'Mayra', 'Emiliani', 'mayrabelenemiliani@gmail.com', '+543464590089', 'https://www.linkedin.com/in/mayraemiliani', 'Argentina', 'Rosario, Santa Fe', '', NULL, '2026-03-22 14:26:04', '2026-03-29 00:03:06'),
(4, 'Nicolas', 'Arina', 'nicolasarina9@gmail.com', '2325 42-4836', '', 'Argentina', 'Buenos Aires', 'San Andres De Giles', NULL, '2026-03-22 14:31:13', '2026-03-29 00:07:01'),
(5, 'Juan', 'Garay', 'jpgaray.ing@gmail.com', '542613385813', 'https://www.linkedin.com/in/juan-pablo-garay-ing-industrial-mza/', 'Argentina', '', '', NULL, '2026-03-26 03:26:58', '2026-03-29 00:10:19'),
(6, 'Gonzalo', 'Salomon', 'salomongonzalo8@gmail.com', '02494013433', 'https://www.linkedin.com/in/gonsalomon', 'Argentina', 'Tandil', '', NULL, '2026-04-02 20:05:44', '2026-04-05 20:48:03'),
(7, 'Facundo Ariel', 'Sardo', 'sardodata@gmail.com', '03413096000', 'https://www.linkedin.com/in/sardofacundoariel/', 'Argentina', 'Rosario', '', NULL, '2026-04-06 14:19:04', '2026-04-07 13:27:23');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `candidate_update_tokens`
--

CREATE TABLE `candidate_update_tokens` (
  `id` int(11) NOT NULL,
  `candidate_id` int(11) NOT NULL,
  `token` varchar(6) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `candidate_update_tokens`
--

INSERT INTO `candidate_update_tokens` (`id`, `candidate_id`, `token`, `expires_at`, `used_at`, `created_at`) VALUES
(1, 1, '558935', '2026-03-24 19:52:59', '2026-03-24 19:38:38', '2026-03-24 22:37:59'),
(2, 1, '088388', '2026-03-24 20:17:03', '2026-03-24 20:02:43', '2026-03-24 23:02:03'),
(3, 1, '182648', '2026-03-24 20:32:50', '2026-03-24 20:18:23', '2026-03-24 23:17:50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `chat_messages`
--

CREATE TABLE `chat_messages` (
  `id` int(10) UNSIGNED NOT NULL,
  `ticket_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `message` text NOT NULL,
  `message_type` enum('text','file','system') NOT NULL DEFAULT 'text',
  `attachment_path` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `tenant_id` int(10) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `chat_messages`
--

INSERT INTO `chat_messages` (`id`, `ticket_id`, `user_id`, `message`, `message_type`, `attachment_path`, `is_read`, `created_at`, `tenant_id`) VALUES
(9, 10, 1, 'Hello Laurence, a pleasure to greet you. Thank you very much for the offer, we will keep it in mind in case we end up needing your services.', 'text', NULL, 0, '2026-03-07 15:55:21', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comments`
--

CREATE TABLE `comments` (
  `id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `author_name` varchar(100) NOT NULL,
  `author_email` varchar(150) NOT NULL,
  `content` text NOT NULL,
  `status` enum('pending','approved','spam','deleted') NOT NULL DEFAULT 'pending',
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `email_logs`
--

CREATE TABLE `email_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `to_email` varchar(150) NOT NULL,
  `to_name` varchar(100) DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `status` enum('sent','failed') NOT NULL DEFAULT 'sent',
  `error_message` text DEFAULT NULL,
  `related_type` varchar(50) DEFAULT NULL COMMENT 'ticket, invoice, budget, etc.',
  `related_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `invoices`
--

CREATE TABLE `invoices` (
  `id` int(10) UNSIGNED NOT NULL,
  `invoice_number` varchar(20) NOT NULL,
  `budget_id` int(10) UNSIGNED NOT NULL,
  `service_reference` varchar(255) DEFAULT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `issue_date` date NOT NULL,
  `due_date` date NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `tax_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `tax_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `paid_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `currency` char(3) NOT NULL DEFAULT 'USD',
  `status` enum('draft','unpaid','processing','partial','paid','overdue') NOT NULL DEFAULT 'unpaid',
  `mp_preference_id` varchar(255) DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `tenant_id` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `invoice_events`
--

CREATE TABLE `invoice_events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `invoice_id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `event_type` enum('CREATE','APPLY_PAYMENT','VOID','DISCOUNT','REFUND') NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `created_by` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `invoice_events`
--

INSERT INTO `invoice_events` (`id`, `invoice_id`, `tenant_id`, `event_type`, `amount`, `payload`, `created_by`, `created_at`) VALUES
(1, 9, 1, 'CREATE', 578.84, '{\"initial_total\": 578.84}', 12, '2026-03-08 23:19:14'),
(2, 9, 1, 'APPLY_PAYMENT', 1.00, '{\"legacy_payment\": true}', 12, '2026-03-14 17:30:51'),
(3, 10, 1, 'CREATE', 138.04, '{\"budget_id\":13,\"subtotal\":\"119.00\",\"tax_amount\":\"19.04\"}', 13, '2026-03-29 01:41:31'),
(4, 9, 1, 'APPLY_PAYMENT', 1.00, '{\"batch_confirmation\":true,\"verified_by\":1}', 1, '2026-04-01 16:36:05'),
(5, 11, 1, 'CREATE', 138.04, '{\"budget_id\":15,\"subtotal\":\"119.00\",\"tax_amount\":\"19.04\"}', 16, '2026-04-05 20:51:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `job_class` varchar(255) NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`payload`)),
  `attempts` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `status` enum('pending','processing','failed') NOT NULL DEFAULT 'pending',
  `error_message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `jobs`
--

INSERT INTO `jobs` (`id`, `job_class`, `payload`, `attempts`, `status`, `error_message`, `created_at`, `updated_at`) VALUES
(1, 'App\\Jobs\\SendEmailJob', '{\"to\":\"culerias@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Humberto Boada!\",\"body\":\"\\r\\n            <div style=\'font-family: Arial; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\r\\n                <h1 style=\'text-align: center; margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\r\\n                <p>Hola <strong>Humberto Boada<\\/strong>,<\\/p>\\r\\n                <p>Tu cuenta ha sido creada exitosamente para procesar tu solicitud de servicio.<\\/p>\\r\\n                \\r\\n                <div style=\'background: #111; padding: 20px; border-radius: 8px; margin: 20px 0; border: 1px solid #D4AF37;\'>\\r\\n                    <p style=\'margin-top: 0;\'><strong>Tus credenciales de acceso:<\\/strong><\\/p>\\r\\n                    <p>Usuario: <span style=\'color: #30C5FF;\'>culerias@gmail.com<\\/span><\\/p>\\r\\n                    <p>Contrase\\u00f1a Temporal: <span style=\'color: #D4AF37;\'>d6ed8d6d<\\/span><\\/p>\\r\\n                <\\/div>\\r\\n\\r\\n                <div style=\'text-align: center; margin: 30px 0;\'>\\r\\n                    <a href=\'https:\\/\\/vezetaelea.com\\/demo\\/datawyrd\\/auth\\/login\' style=\'background: #D4AF37; color: black; padding: 14px 28px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;\'>Acceder al Dashboard<\\/a>\\r\\n                <\\/div>\\r\\n\\r\\n                <p style=\'color: #888; font-size: 13px;\'>Nota: Por seguridad, te recomendamos cambiar tu contrase\\u00f1a una vez que inicies sesi\\u00f3n.<\\/p>\\r\\n                <hr style=\'border: 0; border-top: 1px solid #333; margin: 30px 0;\'>\\r\\n                <p style=\'text-align: center; color: #666;\'>Equipo de Ingenier\\u00eda - Data Wyrd<\\/p>\\r\\n            <\\/div>\\r\\n        \"}', 0, 'pending', NULL, '2026-03-03 10:06:30', NULL),
(2, 'App\\Jobs\\SendEmailJob', '{\"to\":\"culerias@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-152AAB\",\"body\":\"\\r\\n            <div style=\'font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\r\\n                <div style=\'text-align: center; margin-bottom: 30px;\'>\\r\\n                    <h1 style=\'margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\r\\n                    <p style=\'color: #888; font-size: 14px; text-transform: uppercase; letter-spacing: 2px;\'>Ingenier\\u00eda de Datos de Vanguardia<\\/p>\\r\\n                <\\/div>\\r\\n                \\r\\n                <h2 style=\'color: #30C5FF; text-align: center;\'>\\u00a1Solicitud Recibida!<\\/h2>\\r\\n                <p>Hola <strong>Humberto Boada<\\/strong>,<\\/p>\\r\\n                <p>Hemos recibido correctamente tu solicitud: <strong>\\\"Solicitud: Dashboard Enterprise - Medio\\\"<\\/strong>.<\\/p>\\r\\n                \\r\\n                <div style=\'background: #111; padding: 25px; border-radius: 12px; border: 1px solid #333; margin: 30px 0;\'>\\r\\n                    <h4 style=\'color: #D4AF37; margin-top: 0;\'>\\u00bfQu\\u00e9 sigue ahora?<\\/h4>\\r\\n                    <ol style=\'padding-left: 20px; color: #ccc; font-size: 14px; line-height: 1.6;\'>\\r\\n                        <li style=\'margin-bottom: 10px;\'><strong>Revisi\\u00f3n T\\u00e9cnica:<\\/strong> Un especialista analizar\\u00e1 tu requerimiento.<\\/li>\\r\\n                        <li style=\'margin-bottom: 10px;\'><strong>Propuesta Comercial:<\\/strong> Recibir\\u00e1s un presupuesto en tu dashboard.<\\/li>\\r\\n                        <li style=\'margin-bottom: 10px;\'><strong>Activaci\\u00f3n:<\\/strong> Una vez aprobado, iniciaremos la ejecuci\\u00f3n iterativa.<\\/li>\\r\\n                    <\\/ol>\\r\\n                <\\/div>\\r\\n\\r\\n                <div style=\'text-align: center; margin: 40px 0;\'>\\r\\n                    <a href=\'https:\\/\\/vezetaelea.com\\/demo\\/datawyrd\\/dashboard\' style=\'background: #D4AF37; color: black; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;\'>Acceder a mi Dashboard<\\/a>\\r\\n                <\\/div>\\r\\n\\r\\n                <p style=\'color: #666; font-size: 12px; text-align: center; border-top: 1px solid #222; padding-top: 30px;\'>\\r\\n                    Este es un correo autom\\u00e1tico, por favor no respondas directamente. Si tienes dudas, cont\\u00e1ctanos a trav\\u00e9s del chat de la plataforma.\\r\\n                <\\/p>\\r\\n            <\\/div>\\r\\n        \"}', 0, 'pending', NULL, '2026-03-03 10:06:30', NULL),
(3, 'App\\Jobs\\SendEmailJob', '{\"to\":\"contacto@datawyrd.com\",\"subject\":\"[URGENTE] Soporte Prioritario: Humberto Boada\",\"body\":\"\\r\\n            <div style=\'font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #D4AF37;\'>\\r\\n                <h2 style=\'color: #FF5555; text-align: center;\'>\\u26a0\\ufe0f ATENCI\\u00d3N INMEDIATA SOLICITADA<\\/h2>\\r\\n                <p>El cliente <strong>Humberto Boada<\\/strong> (culerias@gmail.com) ha solicitado soporte prioritario.<\\/p>\\r\\n                \\r\\n                <div style=\'background: #111; padding: 20px; border-radius: 8px; border: 1px solid #333; margin: 20px 0;\'>\\r\\n                    <p><strong>Ticket Relacionado:<\\/strong> #6<\\/p>\\r\\n                    <p><strong>Estado:<\\/strong> Urgente<\\/p>\\r\\n                <\\/div>\\r\\n\\r\\n                <div style=\'text-align: center; margin: 30px 0;\'>\\r\\n                    <a href=\'https:\\/\\/vezetaelea.com\\/demo\\/datawyrd\\/ticket\\/detail\\/6\' style=\'background: #30C5FF; color: black; padding: 14px 28px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;\'>Atender Requerimiento<\\/a>\\r\\n                <\\/div>\\r\\n            <\\/div>\\r\\n        \"}', 0, 'pending', NULL, '2026-03-03 10:08:07', NULL),
(4, 'App\\Jobs\\SendEmailJob', '{\"to\":\"yurysmith77@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Yury Luther Smith Tellez!\",\"body\":\"\\r\\n            <div style=\'font-family: Arial; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\r\\n                <h1 style=\'text-align: center; margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\r\\n                <p>Hola <strong>Yury Luther Smith Tellez<\\/strong>,<\\/p>\\r\\n                <p>Tu cuenta ha sido creada exitosamente para procesar tu solicitud de servicio.<\\/p>\\r\\n                \\r\\n                <div style=\'background: #111; padding: 20px; border-radius: 8px; margin: 20px 0; border: 1px solid #D4AF37;\'>\\r\\n                    <p style=\'margin-top: 0;\'><strong>Tus credenciales de acceso:<\\/strong><\\/p>\\r\\n                    <p>Usuario: <span style=\'color: #30C5FF;\'>yurysmith77@gmail.com<\\/span><\\/p>\\r\\n                    <p>Contrase\\u00f1a Temporal: <span style=\'color: #D4AF37;\'>736a6537<\\/span><\\/p>\\r\\n                <\\/div>\\r\\n\\r\\n                <div style=\'text-align: center; margin: 30px 0;\'>\\r\\n                    <a href=\'https:\\/\\/datawyrd.com\\/auth\\/login\' style=\'background: #D4AF37; color: black; padding: 14px 28px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;\'>Acceder al Dashboard<\\/a>\\r\\n                <\\/div>\\r\\n\\r\\n                <p style=\'color: #888; font-size: 13px;\'>Nota: Por seguridad, te recomendamos cambiar tu contrase\\u00f1a una vez que inicies sesi\\u00f3n.<\\/p>\\r\\n                <hr style=\'border: 0; border-top: 1px solid #333; margin: 30px 0;\'>\\r\\n                <p style=\'text-align: center; color: #666;\'>Equipo de Ingenier\\u00eda - Data Wyrd<\\/p>\\r\\n            <\\/div>\\r\\n        \"}', 0, 'pending', NULL, '2026-03-04 00:38:44', NULL),
(5, 'App\\Jobs\\SendEmailJob', '{\"to\":\"yurysmith77@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-513F09\",\"body\":\"\\r\\n            <div style=\'font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\r\\n                <div style=\'text-align: center; margin-bottom: 30px;\'>\\r\\n                    <h1 style=\'margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\r\\n                    <p style=\'color: #888; font-size: 14px; text-transform: uppercase; letter-spacing: 2px;\'>Ingenier\\u00eda de Datos de Vanguardia<\\/p>\\r\\n                <\\/div>\\r\\n                \\r\\n                <h2 style=\'color: #30C5FF; text-align: center;\'>\\u00a1Solicitud Recibida!<\\/h2>\\r\\n                <p>Hola <strong>Yury Luther Smith Tellez<\\/strong>,<\\/p>\\r\\n                <p>Hemos recibido correctamente tu solicitud: <strong>\\\"Solicitud: Dashboard Enterprise - Medio\\\"<\\/strong>.<\\/p>\\r\\n                \\r\\n                <div style=\'background: #111; padding: 25px; border-radius: 12px; border: 1px solid #333; margin: 30px 0;\'>\\r\\n                    <h4 style=\'color: #D4AF37; margin-top: 0;\'>\\u00bfQu\\u00e9 sigue ahora?<\\/h4>\\r\\n                    <ol style=\'padding-left: 20px; color: #ccc; font-size: 14px; line-height: 1.6;\'>\\r\\n                        <li style=\'margin-bottom: 10px;\'><strong>Revisi\\u00f3n T\\u00e9cnica:<\\/strong> Un especialista analizar\\u00e1 tu requerimiento.<\\/li>\\r\\n                        <li style=\'margin-bottom: 10px;\'><strong>Propuesta Comercial:<\\/strong> Recibir\\u00e1s un presupuesto en tu dashboard.<\\/li>\\r\\n                        <li style=\'margin-bottom: 10px;\'><strong>Activaci\\u00f3n:<\\/strong> Una vez aprobado, iniciaremos la ejecuci\\u00f3n iterativa.<\\/li>\\r\\n                    <\\/ol>\\r\\n                <\\/div>\\r\\n\\r\\n                <div style=\'text-align: center; margin: 40px 0;\'>\\r\\n                    <a href=\'https:\\/\\/datawyrd.com\\/dashboard\' style=\'background: #D4AF37; color: black; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;\'>Acceder a mi Dashboard<\\/a>\\r\\n                <\\/div>\\r\\n\\r\\n                <p style=\'color: #666; font-size: 12px; text-align: center; border-top: 1px solid #222; padding-top: 30px;\'>\\r\\n                    Este es un correo autom\\u00e1tico, por favor no respondas directamente. Si tienes dudas, cont\\u00e1ctanos a trav\\u00e9s del chat de la plataforma.\\r\\n                <\\/p>\\r\\n            <\\/div>\\r\\n        \"}', 0, 'pending', NULL, '2026-03-04 00:38:44', NULL),
(6, 'App\\Jobs\\SendEmailJob', '{\"to\":\"yurysmith77@gmail.com\",\"subject\":\"Presupuesto Disponible: DW-B2026-1D0B\",\"body\":\"\\r\\n            <div style=\'font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\r\\n                <div style=\'text-align: center; margin-bottom: 30px;\'>\\r\\n                    <h1 style=\'margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\r\\n                    <p style=\'color: #888; font-size: 14px; text-transform: uppercase; letter-spacing: 2px;\'>Ingenier\\u00eda de Datos de Vanguardia<\\/p>\\r\\n                <\\/div>\\r\\n                \\r\\n                <h2 style=\'color: #30C5FF; text-align: center;\'>Propuesta Comercial Lista<\\/h2>\\r\\n                <p>Hola <strong>Yury Luther Smith Tellez<\\/strong>,<\\/p>\\r\\n                <p>Hemos generado el presupuesto <strong>DW-B2026-1D0B<\\/strong> para tu solicitud.<\\/p>\\r\\n                \\r\\n                <div style=\'background: #111; padding: 25px; border-radius: 12px; border: 1px solid #333; margin: 30px 0; text-align: center;\'>\\r\\n                    <p style=\'color: #ccc; font-size: 15px; margin-bottom: 20px;\'>Puedes revisar los detalles de inversi\\u00f3n, alcances t\\u00e9cnicos y aprobar la propuesta directamente en nuestra plataforma.<\\/p>\\r\\n                    <a href=\'https:\\/\\/datawyrd.com\\/budget\\/show\\/8\' style=\'background: #D4AF37; color: black; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;\'>Ver Propuesta Comercial<\\/a>\\r\\n                <\\/div>\\r\\n\\r\\n                <p style=\'color: #666; font-size: 12px; text-align: center; border-top: 1px solid #222; padding-top: 30px;\'>\\r\\n                    Este es un correo autom\\u00e1tico. Si tienes alguna observaci\\u00f3n sobre el presupuesto, usa el panel de discusi\\u00f3n en el detalle de la propuesta.\\r\\n                <\\/p>\\r\\n            <\\/div>\\r\\n        \"}', 0, 'pending', NULL, '2026-03-04 01:03:18', NULL),
(7, 'App\\Jobs\\SendEmailJob', '{\"to\":\"yurysmith@yahoo.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-ECED57\",\"body\":\"\\r\\n            <div style=\'font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\r\\n                <div style=\'text-align: center; margin-bottom: 30px;\'>\\r\\n                    <h1 style=\'margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\r\\n                    <p style=\'color: #888; font-size: 14px; text-transform: uppercase; letter-spacing: 2px;\'>Ingenier\\u00eda de Datos de Vanguardia<\\/p>\\r\\n                <\\/div>\\r\\n                \\r\\n                <h2 style=\'color: #30C5FF; text-align: center;\'>\\u00a1Solicitud Recibida!<\\/h2>\\r\\n                <p>Hola <strong>Luther Smith<\\/strong>,<\\/p>\\r\\n                <p>Hemos recibido correctamente tu solicitud: <strong>\\\"Solicitud: Data Pipeline Pro - Medio\\\"<\\/strong>.<\\/p>\\r\\n                \\r\\n                <div style=\'background: #111; padding: 25px; border-radius: 12px; border: 1px solid #333; margin: 30px 0;\'>\\r\\n                    <h4 style=\'color: #D4AF37; margin-top: 0;\'>\\u00bfQu\\u00e9 sigue ahora?<\\/h4>\\r\\n                    <ol style=\'padding-left: 20px; color: #ccc; font-size: 14px; line-height: 1.6;\'>\\r\\n                        <li style=\'margin-bottom: 10px;\'><strong>Revisi\\u00f3n T\\u00e9cnica:<\\/strong> Un especialista analizar\\u00e1 tu requerimiento.<\\/li>\\r\\n                        <li style=\'margin-bottom: 10px;\'><strong>Propuesta Comercial:<\\/strong> Recibir\\u00e1s un presupuesto en tu dashboard.<\\/li>\\r\\n                        <li style=\'margin-bottom: 10px;\'><strong>Activaci\\u00f3n:<\\/strong> Una vez aprobado, iniciaremos la ejecuci\\u00f3n iterativa.<\\/li>\\r\\n                    <\\/ol>\\r\\n                <\\/div>\\r\\n\\r\\n                <div style=\'text-align: center; margin: 40px 0;\'>\\r\\n                    <a href=\'https:\\/\\/datawyrd.com\\/dashboard\' style=\'background: #D4AF37; color: black; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;\'>Acceder a mi Dashboard<\\/a>\\r\\n                <\\/div>\\r\\n\\r\\n                <p style=\'color: #666; font-size: 12px; text-align: center; border-top: 1px solid #222; padding-top: 30px;\'>\\r\\n                    Este es un correo autom\\u00e1tico, por favor no respondas directamente. Si tienes dudas, cont\\u00e1ctanos a trav\\u00e9s del chat de la plataforma.\\r\\n                <\\/p>\\r\\n            <\\/div>\\r\\n        \"}', 0, 'pending', NULL, '2026-03-04 01:09:47', NULL),
(8, 'App\\Jobs\\SendEmailJob', '{\"to\":\"culerias@gmail.com\",\"subject\":\"Presupuesto Disponible: DW-B2026-08CE\",\"body\":\"\\r\\n            <div style=\'font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\r\\n                <div style=\'text-align: center; margin-bottom: 30px;\'>\\r\\n                    <h1 style=\'margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\r\\n                    <p style=\'color: #888; font-size: 14px; text-transform: uppercase; letter-spacing: 2px;\'>Ingenier\\u00eda de Datos de Vanguardia<\\/p>\\r\\n                <\\/div>\\r\\n                \\r\\n                <h2 style=\'color: #30C5FF; text-align: center;\'>Propuesta Comercial Lista<\\/h2>\\r\\n                <p>Hola <strong>Humberto Boada<\\/strong>,<\\/p>\\r\\n                <p>Hemos generado el presupuesto <strong>DW-B2026-08CE<\\/strong> para tu solicitud.<\\/p>\\r\\n                \\r\\n                <div style=\'background: #111; padding: 25px; border-radius: 12px; border: 1px solid #333; margin: 30px 0; text-align: center;\'>\\r\\n                    <p style=\'color: #ccc; font-size: 15px; margin-bottom: 20px;\'>Puedes revisar los detalles de inversi\\u00f3n, alcances t\\u00e9cnicos y aprobar la propuesta directamente en nuestra plataforma.<\\/p>\\r\\n                    <a href=\'https:\\/\\/vezetaelea.com\\/demo\\/datawyrd\\/budget\\/show\\/9\' style=\'background: #D4AF37; color: black; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;\'>Ver Propuesta Comercial<\\/a>\\r\\n                <\\/div>\\r\\n\\r\\n                <p style=\'color: #666; font-size: 12px; text-align: center; border-top: 1px solid #222; padding-top: 30px;\'>\\r\\n                    Este es un correo autom\\u00e1tico. Si tienes alguna observaci\\u00f3n sobre el presupuesto, usa el panel de discusi\\u00f3n en el detalle de la propuesta.\\r\\n                <\\/p>\\r\\n            <\\/div>\\r\\n        \"}', 0, 'pending', NULL, '2026-03-04 01:13:39', NULL),
(9, 'App\\Jobs\\SendEmailJob', '{\"to\":\"yurysmith@yahoo.com\",\"subject\":\"Presupuesto Disponible: DW-B2026-C3AB\",\"body\":\"\\n            <div style=\'font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\n                <div style=\'text-align: center; margin-bottom: 30px;\'>\\n                    <h1 style=\'margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\n                    <p style=\'color: #888; font-size: 14px; text-transform: uppercase; letter-spacing: 2px;\'>Ingenier\\u00eda de Datos de Vanguardia<\\/p>\\n                <\\/div>\\n                \\n                <h2 style=\'color: #30C5FF; text-align: center;\'>Propuesta Comercial Lista<\\/h2>\\n                <p>Hola <strong>Luther<\\/strong>,<\\/p>\\n                <p>Hemos generado el presupuesto <strong>DW-B2026-C3AB<\\/strong> para tu solicitud.<\\/p>\\n                \\n                <div style=\'background: #111; padding: 25px; border-radius: 12px; border: 1px solid #333; margin: 30px 0; text-align: center;\'>\\n                    <p style=\'color: #ccc; font-size: 15px; margin-bottom: 20px;\'>Puedes revisar los detalles de inversi\\u00f3n, alcances t\\u00e9cnicos y aprobar la propuesta directamente en nuestra plataforma.<\\/p>\\n                    <a href=\'https:\\/\\/datawyrd.com\\/budget\\/show\\/10\' style=\'background: #D4AF37; color: black; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;\'>Ver Propuesta Comercial<\\/a>\\n                <\\/div>\\n\\n                <p style=\'color: #666; font-size: 12px; text-align: center; border-top: 1px solid #222; padding-top: 30px;\'>\\n                    Este es un correo autom\\u00e1tico. Si tienes alguna observaci\\u00f3n sobre el presupuesto, usa el panel de discusi\\u00f3n en el detalle de la propuesta.\\n                <\\/p>\\n            <\\/div>\\n        \"}', 0, 'pending', NULL, '2026-03-04 20:28:19', NULL),
(10, 'App\\Jobs\\SendEmailJob', '{\"to\":\"yurysmith77@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-5646BF\",\"body\":\"\\n            <div style=\'font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\n                <div style=\'text-align: center; margin-bottom: 30px;\'>\\n                    <h1 style=\'margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\n                    <p style=\'color: #888; font-size: 14px; text-transform: uppercase; letter-spacing: 2px;\'>Ingenier\\u00eda de Datos de Vanguardia<\\/p>\\n                <\\/div>\\n                \\n                <h2 style=\'color: #30C5FF; text-align: center;\'>\\u00a1Solicitud Recibida!<\\/h2>\\n                <p>Hola <strong>Pedro Perez<\\/strong>,<\\/p>\\n                <p>Hemos recibido correctamente tu solicitud: <strong>\\\"Solicitud: Data Pipeline Pro - Medio\\\"<\\/strong>.<\\/p>\\n                \\n                <div style=\'background: #111; padding: 25px; border-radius: 12px; border: 1px solid #333; margin: 30px 0;\'>\\n                    <h4 style=\'color: #D4AF37; margin-top: 0;\'>\\u00bfQu\\u00e9 sigue ahora?<\\/h4>\\n                    <ol style=\'padding-left: 20px; color: #ccc; font-size: 14px; line-height: 1.6;\'>\\n                        <li style=\'margin-bottom: 10px;\'><strong>Revisi\\u00f3n T\\u00e9cnica:<\\/strong> Un especialista analizar\\u00e1 tu requerimiento.<\\/li>\\n                        <li style=\'margin-bottom: 10px;\'><strong>Propuesta Comercial:<\\/strong> Recibir\\u00e1s un presupuesto en tu dashboard.<\\/li>\\n                        <li style=\'margin-bottom: 10px;\'><strong>Activaci\\u00f3n:<\\/strong> Una vez aprobado, iniciaremos la ejecuci\\u00f3n iterativa.<\\/li>\\n                    <\\/ol>\\n                <\\/div>\\n\\n                <div style=\'text-align: center; margin: 40px 0;\'>\\n                    <a href=\'https:\\/\\/datawyrd.com\\/dashboard\' style=\'background: #D4AF37; color: black; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;\'>Acceder a mi Dashboard<\\/a>\\n                <\\/div>\\n\\n                <p style=\'color: #666; font-size: 12px; text-align: center; border-top: 1px solid #222; padding-top: 30px;\'>\\n                    Este es un correo autom\\u00e1tico, por favor no respondas directamente. Si tienes dudas, cont\\u00e1ctanos a trav\\u00e9s del chat de la plataforma.\\n                <\\/p>\\n            <\\/div>\\n        \"}', 0, 'pending', NULL, '2026-03-05 15:11:07', NULL),
(11, 'App\\Jobs\\SendEmailJob', '{\"to\":\"laurence.herrod@hotmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Laurence Herrod!\",\"body\":\"\\n            <div style=\'font-family: Arial; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\n                <h1 style=\'text-align: center; margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\n                <p>Hola <strong>Laurence Herrod<\\/strong>,<\\/p>\\n                <p>Tu cuenta ha sido creada exitosamente para procesar tu solicitud de servicio.<\\/p>\\n                \\n                <div style=\'background: #111; padding: 20px; border-radius: 8px; margin: 20px 0; border: 1px solid #D4AF37;\'>\\n                    <p style=\'margin-top: 0;\'><strong>Tus credenciales de acceso:<\\/strong><\\/p>\\n                    <p>Usuario: <span style=\'color: #30C5FF;\'>laurence.herrod@hotmail.com<\\/span><\\/p>\\n                    <p>Contrase\\u00f1a Temporal: <span style=\'color: #D4AF37;\'>92c122e5<\\/span><\\/p>\\n                <\\/div>\\n\\n                <div style=\'text-align: center; margin: 30px 0;\'>\\n                    <a href=\'https:\\/\\/datawyrd.com\\/auth\\/login\' style=\'background: #D4AF37; color: black; padding: 14px 28px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;\'>Acceder al Dashboard<\\/a>\\n                <\\/div>\\n\\n                <p style=\'color: #888; font-size: 13px;\'>Nota: Por seguridad, te recomendamos cambiar tu contrase\\u00f1a una vez que inicies sesi\\u00f3n.<\\/p>\\n                <hr style=\'border: 0; border-top: 1px solid #333; margin: 30px 0;\'>\\n                <p style=\'text-align: center; color: #666;\'>Equipo de Ingenier\\u00eda - Data Wyrd<\\/p>\\n            <\\/div>\\n        \"}', 0, 'pending', NULL, '2026-03-06 10:05:19', NULL),
(12, 'App\\Jobs\\SendEmailJob', '{\"to\":\"laurence.herrod@hotmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-6BD2E8\",\"body\":\"\\n            <div style=\'font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\n                <div style=\'text-align: center; margin-bottom: 30px;\'>\\n                    <h1 style=\'margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\n                    <p style=\'color: #888; font-size: 14px; text-transform: uppercase; letter-spacing: 2px;\'>Ingenier\\u00eda de Datos de Vanguardia<\\/p>\\n                <\\/div>\\n                \\n                <h2 style=\'color: #30C5FF; text-align: center;\'>\\u00a1Solicitud Recibida!<\\/h2>\\n                <p>Hola <strong>Laurence Herrod<\\/strong>,<\\/p>\\n                <p>Hemos recibido correctamente tu solicitud: <strong>\\\"Hi datawyrd.com Administrator!\\\"<\\/strong>.<\\/p>\\n                \\n                <div style=\'background: #111; padding: 25px; border-radius: 12px; border: 1px solid #333; margin: 30px 0;\'>\\n                    <h4 style=\'color: #D4AF37; margin-top: 0;\'>\\u00bfQu\\u00e9 sigue ahora?<\\/h4>\\n                    <ol style=\'padding-left: 20px; color: #ccc; font-size: 14px; line-height: 1.6;\'>\\n                        <li style=\'margin-bottom: 10px;\'><strong>Revisi\\u00f3n T\\u00e9cnica:<\\/strong> Un especialista analizar\\u00e1 tu requerimiento.<\\/li>\\n                        <li style=\'margin-bottom: 10px;\'><strong>Propuesta Comercial:<\\/strong> Recibir\\u00e1s un presupuesto en tu dashboard.<\\/li>\\n                        <li style=\'margin-bottom: 10px;\'><strong>Activaci\\u00f3n:<\\/strong> Una vez aprobado, iniciaremos la ejecuci\\u00f3n iterativa.<\\/li>\\n                    <\\/ol>\\n                <\\/div>\\n\\n                <div style=\'text-align: center; margin: 40px 0;\'>\\n                    <a href=\'https:\\/\\/datawyrd.com\\/dashboard\' style=\'background: #D4AF37; color: black; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;\'>Acceder a mi Dashboard<\\/a>\\n                <\\/div>\\n\\n                <p style=\'color: #666; font-size: 12px; text-align: center; border-top: 1px solid #222; padding-top: 30px;\'>\\n                    Este es un correo autom\\u00e1tico, por favor no respondas directamente. Si tienes dudas, cont\\u00e1ctanos a trav\\u00e9s del chat de la plataforma.\\n                <\\/p>\\n            <\\/div>\\n        \"}', 0, 'pending', NULL, '2026-03-06 10:05:19', NULL),
(13, 'App\\Jobs\\SendEmailJob', '{\"to\":\"laurence.herrod@hotmail.com\",\"subject\":\"Actualizaci\\u00f3n de Ticket: TKT-6BD2E8\",\"body\":\"\\n            <div style=\'font-family: Arial; background: #0A0A0A; color: white; padding: 40px;\'>\\n                <h2 style=\'margin: 0 0 20px 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Actualizaci\\u00f3n de Estado<\\/h2>\\n                <p>Tu ticket <strong>TKT-6BD2E8<\\/strong> ha cambiado su estado a: <span style=\'color: #30C5FF;\'>void<\\/span>.<\\/p>\\n                <p>Revisa los detalles en la plataforma.<\\/p>\\n                <a href=\'https:\\/\\/datawyrd.com\\/dashboard\' style=\'background: #D4AF37; color: black; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-weight: bold;\'>Ver Ticket<\\/a>\\n            <\\/div>\\n        \"}', 0, 'pending', NULL, '2026-03-07 16:22:26', NULL),
(14, 'App\\Jobs\\SendEmailJob', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"\\u00a1Bienvenido a Data Wyrd, Humberto Boada!\",\"body\":\"\\n            <div style=\'font-family: Arial; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\n                <h1 style=\'text-align: center; margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\n                <p>Hola <strong>Humberto Boada<\\/strong>,<\\/p>\\n                <p>Tu cuenta ha sido creada exitosamente para procesar tu solicitud de servicio.<\\/p>\\n                \\n                <div style=\'background: #111; padding: 20px; border-radius: 8px; margin: 20px 0; border: 1px solid #D4AF37;\'>\\n                    <p style=\'margin-top: 0;\'><strong>Tus credenciales de acceso:<\\/strong><\\/p>\\n                    <p>Usuario: <span style=\'color: #30C5FF;\'>hboadar@gmail.com<\\/span><\\/p>\\n                    <p>Contrase\\u00f1a Temporal: <span style=\'color: #D4AF37;\'>33d7fdad<\\/span><\\/p>\\n                <\\/div>\\n\\n                <div style=\'text-align: center; margin: 30px 0;\'>\\n                    <a href=\'https:\\/\\/datawyrd.com\\/auth\\/login\' style=\'background: #D4AF37; color: black; padding: 14px 28px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;\'>Acceder al Dashboard<\\/a>\\n                <\\/div>\\n\\n                <p style=\'color: #888; font-size: 13px;\'>Nota: Por seguridad, te recomendamos cambiar tu contrase\\u00f1a una vez que inicies sesi\\u00f3n.<\\/p>\\n                <hr style=\'border: 0; border-top: 1px solid #333; margin: 30px 0;\'>\\n                <p style=\'text-align: center; color: #666;\'>Equipo de Ingenier\\u00eda - Data Wyrd<\\/p>\\n            <\\/div>\\n        \"}', 0, 'pending', NULL, '2026-03-07 17:31:55', NULL),
(15, 'App\\Jobs\\SendEmailJob', '{\"to\":\"hboadar@gmail.com\",\"subject\":\"Confirmaci\\u00f3n de Solicitud: TKT-E6CF54\",\"body\":\"\\n            <div style=\'font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #333;\'>\\n                <div style=\'text-align: center; margin-bottom: 30px;\'>\\n                    <h1 style=\'margin: 0; background: linear-gradient(to right, #D4AF37, #30C5FF); -webkit-background-clip: text; color: transparent;\'>Data Wyrd<\\/h1>\\n                    <p style=\'color: #888; font-size: 14px; text-transform: uppercase; letter-spacing: 2px;\'>Ingenier\\u00eda de Datos de Vanguardia<\\/p>\\n                <\\/div>\\n                \\n                <h2 style=\'color: #30C5FF; text-align: center;\'>\\u00a1Solicitud Recibida!<\\/h2>\\n                <p>Hola <strong>Humberto Boada<\\/strong>,<\\/p>\\n                <p>Hemos recibido correctamente tu solicitud: <strong>\\\"Solicitud: Landing Pages - Plan Inicial\\\"<\\/strong>.<\\/p>\\n                \\n                <div style=\'background: #111; padding: 25px; border-radius: 12px; border: 1px solid #333; margin: 30px 0;\'>\\n                    <h4 style=\'color: #D4AF37; margin-top: 0;\'>\\u00bfQu\\u00e9 sigue ahora?<\\/h4>\\n                    <ol style=\'padding-left: 20px; color: #ccc; font-size: 14px; line-height: 1.6;\'>\\n                        <li style=\'margin-bottom: 10px;\'><strong>Revisi\\u00f3n T\\u00e9cnica:<\\/strong> Un especialista analizar\\u00e1 tu requerimiento.<\\/li>\\n                        <li style=\'margin-bottom: 10px;\'><strong>Propuesta Comercial:<\\/strong> Recibir\\u00e1s un presupuesto en tu dashboard.<\\/li>\\n                        <li style=\'margin-bottom: 10px;\'><strong>Activaci\\u00f3n:<\\/strong> Una vez aprobado, iniciaremos la ejecuci\\u00f3n iterativa.<\\/li>\\n                    <\\/ol>\\n                <\\/div>\\n\\n                <div style=\'text-align: center; margin: 40px 0;\'>\\n                    <a href=\'https:\\/\\/datawyrd.com\\/dashboard\' style=\'background: #D4AF37; color: black; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;\'>Acceder a mi Dashboard<\\/a>\\n                <\\/div>\\n\\n                <p style=\'color: #666; font-size: 12px; text-align: center; border-top: 1px solid #222; padding-top: 30px;\'>\\n                    Este es un correo autom\\u00e1tico, por favor no respondas directamente. Si tienes dudas, cont\\u00e1ctanos a trav\\u00e9s del chat de la plataforma.\\n                <\\/p>\\n            <\\/div>\\n        \"}', 0, 'pending', NULL, '2026-03-07 17:31:55', NULL),
(16, 'App\\Jobs\\SendEmailJob', '{\"to\":\"contacto@datawyrd.com\",\"subject\":\"[URGENTE] Soporte Prioritario: Humberto Boada\",\"body\":\"\\n            <div style=\'font-family: Arial, sans-serif; background: #0A0A0A; color: white; padding: 40px; max-width: 600px; margin: auto; border: 1px solid #D4AF37;\'>\\n                <h2 style=\'color: #FF5555; text-align: center;\'>\\u26a0\\ufe0f ATENCI\\u00d3N INMEDIATA SOLICITADA<\\/h2>\\n                <p>El cliente <strong>Humberto Boada<\\/strong> (hboadar@gmail.com) ha solicitado soporte prioritario.<\\/p>\\n                \\n                <div style=\'background: #111; padding: 20px; border-radius: 8px; border: 1px solid #333; margin: 20px 0;\'>\\n                    <p><strong>Ticket Relacionado:<\\/strong> #11<\\/p>\\n                    <p><strong>Estado:<\\/strong> Urgente<\\/p>\\n                <\\/div>\\n\\n                <div style=\'text-align: center; margin: 30px 0;\'>\\n                    <a href=\'https:\\/\\/datawyrd.com\\/ticket\\/detail\\/11\' style=\'background: #30C5FF; color: black; padding: 14px 28px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;\'>Atender Requerimiento<\\/a>\\n                <\\/div>\\n            <\\/div>\\n        \"}', 0, 'pending', NULL, '2026-03-07 17:33:36', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `job_applications`
--

CREATE TABLE `job_applications` (
  `id` int(11) NOT NULL,
  `candidate_id` int(11) NOT NULL,
  `vacancy_name` varchar(150) DEFAULT NULL,
  `skills` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`skills`)),
  `presentation_letter` text DEFAULT NULL,
  `cv_path` varchar(255) NOT NULL,
  `status` enum('new','reviewed','contacted','unreachable','scheduled','technical_interview','shortlisted','rejected','hired') DEFAULT 'new',
  `status_updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `job_applications`
--

INSERT INTO `job_applications` (`id`, `candidate_id`, `vacancy_name`, `skills`, `presentation_letter`, `cv_path`, `status`, `status_updated_at`, `created_at`, `updated_at`) VALUES
(2, 2, 'Candidato Web :  Jr', '[\"Data Engineering\",\"Machine Learning\",\"Business Intelligence\"]', '', '978ab6ec28d00e3140fa_1774189197.pdf', 'reviewed', '2026-03-29 00:11:10', '2026-03-22 14:19:57', '2026-03-29 00:11:10'),
(5, 3, 'Candidato Web : perfil Analista de Datos Jr', '[\"Data Analysis\"]', '', 'a81442268e9fecf19aa5_1774189564.pdf', 'reviewed', '2026-03-29 00:11:24', '2026-03-22 14:26:04', '2026-03-29 00:11:24'),
(6, 4, 'Candidato Web :  Jr', '[\"Data Analysis\"]', 'Estimado equipo de Data Wyrd\r\nMe postulo para la posición de Analista de Datos, motivado por la oportunidad de desarrollarme en un entorno innovador enfocado en BI, analítica y soluciones de inteligencia artificial.\r\nActualmente me encuentro cursando la Tecnicatura en Administración de Recursos Humanos, lo que me ha permitido comprender en profundidad los procesos organizacionales y la importancia de la toma de decisiones basada en información. A lo largo de mi experiencia laboral, he trabajado en tareas de control, verificación y gestión de pedidos, donde el manejo preciso de datos, la organización y la atención al detalle fueron fundamentales para garantizar la eficiencia operativa.\r\nCuento con conocimientos en Excel a nivel básico-intermedio y me encuentro en proceso de seguir formándome en herramientas de análisis de datos, con especial interés en BI, SQL y nuevas tecnologías aplicadas al negocio. Me destaco por mi proactividad, capacidad de aprendizaje y habilidades para trabajar en equipo, así como por mi compromiso con la mejora continua.\r\nMe interesa especialmente esta oportunidad porque combina análisis de datos con impacto real en decisiones estratégicas, en un entorno colaborativo donde puedo seguir desarrollando mis habilidades técnicas y aportar desde mi experiencia en procesos y gestión.\r\nQuedo a disposición para ampliar mi perfil en una entrevista. Muchas gracias por su tiempo y consideración.\r\nSaludos cordiales,\r\nNicolás Gastón Arina', 'b57b58417f8765d17cd4_1774189873.pdf', 'reviewed', '2026-03-29 00:11:36', '2026-03-22 14:31:13', '2026-03-29 00:11:36'),
(9, 5, 'Candidato Web: Analista de Datos Jr/Ssr', '[\"Data Engineering\",\"Data Analysis\",\"Business Intelligence\"]', 'Estimados,\r\n\r\nMe gustaría postularme a la posición de Analista de Datos en Data Wyrd.\r\n\r\nSoy Ingeniero Industrial con experiencia en análisis de datos y Business Intelligence, enfocado en transformar información en insights accionables para la toma de decisiones. A lo largo de mi experiencia, he trabajado en el desarrollo de dashboards en Power BI, análisis de indicadores de negocio y mejora de procesos, colaborando con distintos equipos para generar impacto real en la operación.\r\n\r\nMe siento especialmente identificado con la propuesta de valor de Data Wyrd, donde se combinan analítica, innovación y trabajo colaborativo. Además, cuento con conocimientos en herramientas como Power BI, SQL y Python, y un fuerte interés en seguir desarrollándome en áreas como Data y soluciones de IA aplicadas al negocio.\r\n\r\nConsidero que mi perfil analítico, mi capacidad para comunicar resultados de manera clara y mi orientación a la mejora continua pueden aportar valor al equipo.\r\n\r\nAdjunto mi CV y quedo a disposición para ampliar cualquier información o coordinar una entrevista.\r\n\r\nMuchas gracias por su tiempo.\r\n\r\nSaludos cordiales,\r\nJuan Pablo Garay\r\n📧 jpgaray.ing@gmail.com\r\n📱 542613385813', 'b5aa7fe77db34e702dcd_1774495618.pdf', 'reviewed', '2026-03-29 00:10:53', '2026-03-26 03:26:58', '2026-03-29 00:10:53'),
(10, 6, 'Candidato Web', '[\"Data Engineering\",\"Data Analysis\",\"Web Development\",\"Cloud Architecture\",\"Business Intelligence\"]', 'Reconozco que fui irresponsable en mi trabajo anterior, que era el primero... Y me gustaría tener la oportunidad de redimirme y ser un activo valioso para la empresa que me dé trabajo. Desearía dar lo mejor, si a alguien le sirve un Data Engineer con ganas de hacer carrera, puede contar conmigo', '48603f01d529bc84db5b_1775160344.pdf', 'reviewed', '2026-04-05 20:43:07', '2026-04-02 20:05:44', '2026-04-05 20:43:07'),
(11, 7, 'Candidato Web: perfil Analista de Datos Ssr', '[\"Data Analysis\"]', 'Me motiva unirme a Data Wyrd porque me interesa trabajar en entornos donde los datos realmente impactan decisiones de negocio. Disfruto transformar datos en insights accionables y comunicar resultados de forma clara.\r\n\r\nMe atrae especialmente su enfoque en BI, data y soluciones de IA, así como la posibilidad de seguir aprendiendo y creciendo en tecnologías modernas junto a un equipo colaborativo.\r\n\r\nCreo que mi experiencia con SQL, Python y herramientas de visualización, junto con mi mentalidad analítica y proactiva, pueden aportar valor al equipo.', '4acd654a4a9487abb065_1775485144.pdf', 'reviewed', '2026-04-07 13:31:41', '2026-04-06 14:19:04', '2026-04-07 13:31:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `job_application_status_logs`
--

CREATE TABLE `job_application_status_logs` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `old_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `job_application_status_logs`
--

INSERT INTO `job_application_status_logs` (`id`, `application_id`, `old_status`, `new_status`, `created_at`) VALUES
(1, 1, 'new', 'reviewed', '2026-03-22 00:16:39'),
(2, 1, 'reviewed', 'scheduled', '2026-03-22 00:18:02'),
(3, 2, 'new', 'reviewed', '2026-03-23 01:37:43'),
(4, 4, 'new', 'reviewed', '2026-03-23 01:39:01'),
(5, 5, 'new', 'reviewed', '2026-03-23 01:40:44'),
(6, 6, 'new', 'reviewed', '2026-03-23 01:41:35'),
(7, 3, 'new', 'reviewed', '2026-03-23 01:43:18'),
(8, 8, 'new', 'reviewed', '2026-03-24 23:20:56'),
(9, 9, 'new', 'reviewed', '2026-03-27 20:45:24'),
(10, 1, 'scheduled', 'rejected', '2026-03-28 23:58:48'),
(11, 10, 'new', 'reviewed', '2026-04-05 20:43:07'),
(12, 11, 'new', 'reviewed', '2026-04-07 13:26:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jwt_refresh_tokens`
--

CREATE TABLE `jwt_refresh_tokens` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `login_logs`
--

CREATE TABLE `login_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) NOT NULL,
  `email_attempted` varchar(255) NOT NULL,
  `success` tinyint(1) NOT NULL DEFAULT 0,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `login_logs`
--

INSERT INTO `login_logs` (`id`, `user_id`, `ip_address`, `email_attempted`, `success`, `user_agent`, `created_at`) VALUES
(1, NULL, '201.216.219.154', 'hboadar@gmail.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-02-22 02:04:41'),
(2, 6, '201.216.219.154', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-02-22 02:04:53'),
(3, 1, '2800:40:3a:bd0d:e843:74a8:b527:3845', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-22 11:56:40'),
(4, 1, '2800:40:3a:bd0d:e843:74a8:b527:3845', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-22 12:07:12'),
(5, 1, '2800:40:3a:bd0d:e843:74a8:b527:3845', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-22 12:48:15'),
(6, 1, '2800:40:3a:bd0d:e843:74a8:b527:3845', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-22 23:34:33'),
(7, 6, '2800:40:3a:bd0d:e843:74a8:b527:3845', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-22 23:35:42'),
(8, 1, '2800:40:3a:bd0d:e843:74a8:b527:3845', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-22 23:36:36'),
(9, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 14:56:18'),
(10, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 15:54:14'),
(11, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 22:34:54'),
(12, 6, '190.210.32.221', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-01 01:48:58'),
(13, 6, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-01 17:26:01'),
(14, 6, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-01 17:46:47'),
(15, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-01 17:48:04'),
(16, 6, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-01 17:49:26'),
(17, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-01 17:51:57'),
(18, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-01 21:14:21'),
(19, 6, '186.157.102.16', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-02 20:45:05'),
(20, NULL, '181.239.21.134', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-03 10:15:35'),
(21, 1, '181.239.21.134', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-03 10:15:50'),
(22, 6, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-03 23:23:16'),
(23, 6, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-03 23:50:28'),
(24, 6, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-03 23:57:38'),
(25, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 00:14:42'),
(26, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 00:36:56'),
(27, NULL, '2800:2260:4000:49:c050:e58:c168:e1b5', 'luther.smith@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-04 00:50:05'),
(28, 3, '190.19.217.91', 'luther.smith@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-04 00:51:33'),
(29, NULL, '190.19.217.91', 'yurysmith77@gmail.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 01:04:46'),
(30, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 01:10:47'),
(31, 6, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 12:27:33'),
(32, 7, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'culerias@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 12:28:00'),
(33, 7, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'culerias@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 12:29:06'),
(34, NULL, '190.210.32.221', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/145.0.7632.113 Mobile Safari/537.36 Instagram 418.0.0.51.77 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 891072510; IABMV/1)', '2026-03-04 13:00:44'),
(35, 1, '190.210.32.221', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/145.0.7632.113 Mobile Safari/537.36 Instagram 418.0.0.51.77 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 891072510; IABMV/1)', '2026-03-04 13:01:00'),
(36, 1, '190.210.32.221', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/145.0.7632.113 Mobile Safari/537.36 Instagram 418.0.0.51.77 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 891072510; IABMV/1)', '2026-03-04 15:18:17'),
(37, 7, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'culerias@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 17:47:19'),
(38, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 17:48:37'),
(39, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 17:50:34'),
(40, 7, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'culerias@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 17:51:10'),
(41, 6, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 19:17:30'),
(42, 7, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'culerias@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 19:54:21'),
(43, 1, '2800:40:3a:bd0d:b5f8:ffd2:4646:239f', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-04 19:55:20'),
(44, NULL, '52.167.144.21', '', 0, 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '2026-03-07 10:11:19'),
(45, 1, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-07 15:48:59'),
(46, NULL, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-07 21:35:01'),
(47, NULL, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-07 21:35:14'),
(48, NULL, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-07 21:35:30'),
(49, NULL, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-07 21:35:45'),
(50, 1, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-07 21:35:55'),
(51, NULL, '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'hboadar@gmail.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-07 22:29:06'),
(52, 11, '2800:40:3a:bd0d:eaff:d95c:8a6:6857', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-07 22:29:17'),
(53, NULL, '186.157.51.246', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-07 23:23:44'),
(54, 1, '186.157.51.246', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-07 23:24:11'),
(55, NULL, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-08 18:17:03'),
(56, NULL, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-08 18:17:13'),
(57, NULL, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-08 18:17:22'),
(58, NULL, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-08 18:17:36'),
(59, 1, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-08 18:17:46'),
(60, 3, '2800:2260:4000:49:d985:662e:2b1a:95a0', 'luther.smith@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-08 18:21:40'),
(61, 11, '2800:40:3a:bd0d:e487:a4fc:d9bf:f217', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-08 18:22:38'),
(62, NULL, '201.217.246.228', '', 0, 'Mozilla/5.0 (Linux; Android 15; moto g15) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-08 18:22:42'),
(63, 11, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-08 19:11:53'),
(64, 1, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-08 19:15:36'),
(65, 11, '2800:40:3a:bd0d:e08e:4403:f59d:a161', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-08 19:40:44'),
(66, 11, '2800:40:3a:bd0d:e08e:4403:f59d:a161', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-08 19:52:45'),
(67, 11, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-08 21:26:27'),
(68, 1, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-08 21:27:47'),
(69, 2, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'staff@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-09 00:49:29'),
(70, NULL, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-09 00:50:54'),
(71, 1, '2800:40:3a:bd0d:5d43:19f7:546a:2940', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-09 00:51:02'),
(72, 1, '190.210.32.221', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-09 01:07:03'),
(73, NULL, '52.167.144.147', '', 0, 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '2026-03-09 04:45:00'),
(74, 12, '190.210.32.221', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-09 09:47:10'),
(75, NULL, '200.49.93.243', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 12:52:19'),
(76, 1, '200.49.93.243', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 12:52:27'),
(77, NULL, '40.77.167.59', '', 0, 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '2026-03-10 20:12:14'),
(78, NULL, '190.210.32.151', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-11 08:50:30'),
(79, NULL, '190.210.32.151', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-11 08:50:44'),
(80, NULL, '190.210.32.151', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-11 08:50:54'),
(81, NULL, '190.210.32.151', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-11 08:51:17'),
(82, NULL, '190.210.32.151', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-11 08:51:30'),
(83, NULL, '190.210.32.151', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-11 08:51:54'),
(84, 12, '190.210.32.151', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-11 08:52:13'),
(85, NULL, '190.210.32.151', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-11 08:53:05'),
(86, 1, '2800:40:3a:bd0d:7922:529c:a8be:b67e', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-14 17:23:10'),
(87, 3, '2800:40:3a:bd0d:21ea:1abf:b846:62a1', 'luther.smith@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-14 17:26:57'),
(88, 12, '2800:40:3a:bd0d:21ea:1abf:b846:62a1', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-14 17:29:31'),
(89, 3, '2800:40:3a:bd0d:84bd:a2bb:83e3:c086', 'luther.smith@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-14 19:53:54'),
(90, 1, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 15:46:55'),
(91, 1, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 16:45:00'),
(92, 12, '190.210.32.129', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-15 17:15:39'),
(93, 12, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 18:05:45'),
(94, NULL, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 18:10:26'),
(95, 1, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 18:10:35'),
(96, 12, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 18:15:44'),
(97, 12, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 18:22:28'),
(98, NULL, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 18:24:58'),
(99, 1, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 18:25:11'),
(100, 12, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 18:29:07'),
(101, NULL, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 18:31:49'),
(102, 1, '2800:40:3a:bd0d:78ce:10b8:bae4:97dd', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-15 18:31:58'),
(103, 12, '2800:40:3a:bd0d:e82a:afab:6db7:952b', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-16 22:26:19'),
(104, 1, '2800:40:3a:bd0d:e82a:afab:6db7:952b', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-16 22:26:43'),
(105, NULL, '198.244.168.147', '', 0, 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)', '2026-03-20 10:02:18'),
(106, 1, '2800:40:3a:bd0d:e82a:afab:6db7:952b', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-22 00:16:21'),
(107, 1, '2800:40:3a:bd0d:b6c2:9181:e833:1508', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-22 03:30:54'),
(108, NULL, '201.216.219.92', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.146 Mobile Safari/537.36 Instagram 421.0.0.51.66 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 909555821; IABMV/1)', '2026-03-23 01:36:29'),
(109, 1, '201.216.219.92', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.146 Mobile Safari/537.36 Instagram 421.0.0.51.66 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 909555821; IABMV/1)', '2026-03-23 01:36:45'),
(110, NULL, '201.216.219.92', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-23 01:38:39'),
(111, 1, '201.216.219.92', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-23 01:38:51'),
(112, NULL, '2800:40:3a:bd0d:188e:3478:a138:2f79', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-23 23:17:50'),
(113, 1, '2800:40:3a:bd0d:188e:3478:a138:2f79', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-23 23:18:08'),
(114, 1, '2800:40:3a:bd0d:188e:3478:a138:2f79', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-24 20:54:33'),
(115, 1, '2800:40:3a:bd0d:188e:3478:a138:2f79', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-24 22:41:14'),
(116, 1, '2800:40:3a:bd0d:188e:3478:a138:2f79', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-24 23:18:52'),
(117, NULL, '157.55.39.52', '', 0, 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '2026-03-25 11:24:00'),
(118, NULL, '181.238.114.163', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-27 20:44:31'),
(119, 1, '181.238.114.163', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-27 20:44:43'),
(120, 1, '2800:40:3a:bd0d:499b:642a:6b31:c6b2', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-28 23:57:24'),
(121, 1, '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-29 01:31:31'),
(122, 12, '201.216.219.92', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 01:55:15'),
(123, 12, '201.216.219.92', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.157 Mobile Safari/537.36 Instagram 422.0.0.44.64 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 916494010; IABMV/1)', '2026-03-29 01:56:41'),
(124, 1, '201.216.219.92', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.157 Mobile Safari/537.36 Instagram 422.0.0.44.64 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 916494010; IABMV/1)', '2026-03-29 01:59:11'),
(125, 12, '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-29 02:01:08'),
(126, 12, '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'hboadar@gmail.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-29 02:01:27'),
(127, NULL, '201.216.219.92', 'vezetaelea@gmail.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 02:02:04'),
(128, NULL, '201.216.219.92', 'vezetaelea@gmail.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 02:02:17'),
(129, 13, '201.216.219.92', 'vezetaelea@gmail.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 02:02:56'),
(130, 1, '201.216.219.113', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-04-01 11:15:58'),
(131, 1, '2800:40:3a:bd0d:51fb:f55c:31c5:f04b', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-04-02 18:02:57'),
(132, NULL, '51.89.129.117', '', 0, 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)', '2026-04-03 21:00:50'),
(133, 1, '2800:40:3a:bd0d:df33:dc31:b01d:729e', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-04-05 20:31:06'),
(134, 1, '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-04-05 20:34:15'),
(135, NULL, '2800:40:3a:bd0d:df33:dc31:b01d:729e', 'admin@vezetaelea.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-04-05 20:49:51'),
(136, 1, '2800:40:3a:bd0d:df33:dc31:b01d:729e', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-04-05 20:50:19'),
(137, 1, '2800:40:3a:bd0d:f8ea:99f8:180e:277b', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-04-05 22:07:17'),
(138, 1, '190.104.205.132', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-04-07 13:05:26'),
(139, 1, '2800:40:3a:bd0d:4cd1:5399:e56c:5dd9', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-12 14:50:58'),
(140, 1, '2800:40:3a:bd0d:4cd1:5399:e56c:5dd9', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-12 19:25:43'),
(141, 1, '190.104.205.132', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-04-13 11:49:11'),
(142, 1, '201.216.219.193', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-04-15 20:33:44'),
(143, 1, '2800:40:3a:bd0d:4c13:6295:2adf:5698', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-18 18:39:49'),
(144, NULL, '40.77.167.24', '', 0, 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '2026-04-23 19:20:36'),
(145, 1, '181.238.22.180', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-04-27 10:55:29'),
(146, 1, '190.210.32.25', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-04-30 20:05:04'),
(147, 1, '2800:40:3a:bd0d:3d12:4775:75e6:fa12', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 20:14:23'),
(148, 1, '190.210.32.25', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 15:45:41'),
(149, 1, '2800:40:3a:bd0d:3d12:4775:75e6:fa12', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 21:01:42'),
(150, 1, '190.210.32.193', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 15:19:37'),
(151, 1, '190.210.32.193', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 14:42:57'),
(152, 1, '2800:40:3a:bd0d:9ce4:ec18:b499:59b5', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-16 22:54:47'),
(153, 1, '201.216.219.236', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '2026-05-20 16:37:48'),
(154, 1, '2800:40:3a:bd0d:65c9:450:1c1e:d19e', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '2026-05-30 23:12:39'),
(155, NULL, '40.77.167.53', '', 0, 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36', '2026-05-31 13:52:13'),
(156, 1, '200.49.93.243', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-06-02 16:03:33'),
(157, 1, '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-06 17:17:52'),
(158, 1, '186.157.75.113', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '2026-06-06 19:57:25'),
(159, NULL, '181.239.159.14', 'admin@datawyrd.com', 0, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '2026-06-06 20:55:13'),
(160, 1, '181.239.159.14', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '2026-06-06 20:55:25'),
(161, 1, '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-07 00:09:12'),
(162, NULL, '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'hboadar@gmail.com', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-07 13:27:55'),
(163, 1, '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-07 13:28:09'),
(164, 1, '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-07 14:11:29'),
(165, 1, '186.157.74.86', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '2026-06-07 14:40:42'),
(166, 1, '201.216.219.226', 'admin@datawyrd.com', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-07 16:30:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mktg_automations`
--

CREATE TABLE `mktg_automations` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `name` varchar(150) NOT NULL,
  `trigger_type` enum('signup','tag_added','campaign_open','campaign_click','purchase','date_based','manual') NOT NULL DEFAULT 'signup',
  `trigger_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`trigger_data`)),
  `status` enum('active','paused','draft') NOT NULL DEFAULT 'draft',
  `created_by` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Definición de automatizaciones de email';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mktg_automation_steps`
--

CREATE TABLE `mktg_automation_steps` (
  `id` int(10) UNSIGNED NOT NULL,
  `automation_id` int(10) UNSIGNED NOT NULL,
  `step_order` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `step_type` enum('send_email','wait','condition','tag','webhook') NOT NULL DEFAULT 'send_email',
  `step_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`step_config`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pasos individuales de cada automatización';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mktg_campaigns`
--

CREATE TABLE `mktg_campaigns` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `name` varchar(150) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `preview_text` varchar(255) DEFAULT NULL,
  `from_name` varchar(100) DEFAULT NULL,
  `from_email` varchar(190) DEFAULT NULL,
  `reply_to` varchar(190) DEFAULT NULL,
  `template_id` int(10) UNSIGNED DEFAULT NULL,
  `list_id` int(10) UNSIGNED DEFAULT NULL,
  `segment_filters` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`segment_filters`)),
  `type` enum('one_time','recurring','automated') NOT NULL DEFAULT 'one_time',
  `status` enum('draft','scheduled','sending','sent','paused','cancelled') NOT NULL DEFAULT 'draft',
  `paused_reason` varchar(500) DEFAULT NULL,
  `scheduled_at` timestamp NULL DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT NULL,
  `created_by` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Campañas de email marketing';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mktg_contacts`
--

CREATE TABLE `mktg_contacts` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `list_id` int(10) UNSIGNED NOT NULL,
  `email` varchar(190) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `company` varchar(150) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `industry` varchar(100) DEFAULT NULL,
  `tags` varchar(255) DEFAULT NULL,
  `custom_fields` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`custom_fields`)),
  `status` enum('subscribed','unsubscribed','suppressed','pending') NOT NULL DEFAULT 'subscribed',
  `consent_given` tinyint(1) NOT NULL DEFAULT 0,
  `consent_ip` varchar(45) DEFAULT NULL,
  `consent_at` timestamp NULL DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL,
  `crm_contact_id` int(10) UNSIGNED DEFAULT NULL,
  `unsubscribe_token` varchar(64) NOT NULL DEFAULT '',
  `unsubscribed_at` timestamp NULL DEFAULT NULL,
  `suppression_reason` varchar(255) DEFAULT NULL,
  `suppressed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Suscriptores/contactos de listas de marketing';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mktg_conversion_events`
--

CREATE TABLE `mktg_conversion_events` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `campaign_id` int(10) UNSIGNED DEFAULT NULL,
  `contact_id` int(10) UNSIGNED DEFAULT NULL,
  `send_log_id` int(10) UNSIGNED DEFAULT NULL,
  `conversion_type` enum('invoice_paid','signup','upgrade','custom') NOT NULL DEFAULT 'invoice_paid',
  `reference_id` int(10) UNSIGNED DEFAULT NULL,
  `revenue_amount` decimal(12,2) DEFAULT NULL,
  `occurred_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Eventos de conversión atribuidos a campañas (ROI)';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mktg_events`
--

CREATE TABLE `mktg_events` (
  `id` int(10) UNSIGNED NOT NULL,
  `campaign_id` int(10) UNSIGNED DEFAULT NULL,
  `contact_id` int(10) UNSIGNED DEFAULT NULL,
  `send_log_id` int(10) UNSIGNED DEFAULT NULL,
  `event_type` enum('open','click','bounce','complaint','unsub','delivered','conversion') NOT NULL,
  `url_clicked` varchar(2048) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `user_agent` varchar(512) DEFAULT NULL,
  `occurred_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Eventos de interacción con emails de marketing';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mktg_lists`
--

CREATE TABLE `mktg_lists` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `created_by` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Listas de suscriptores del módulo de marketing';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mktg_send_log`
--

CREATE TABLE `mktg_send_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `campaign_id` int(10) UNSIGNED NOT NULL,
  `contact_id` int(10) UNSIGNED DEFAULT NULL,
  `email` varchar(190) NOT NULL,
  `status` enum('queued','processing','sent','failed','soft_bounced','bounced') NOT NULL DEFAULT 'queued',
  `tracking_token` varchar(64) NOT NULL DEFAULT '',
  `unsubscribe_token` varchar(64) NOT NULL DEFAULT '',
  `provider_message_id` varchar(255) DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `queued_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `sent_at` timestamp NULL DEFAULT NULL,
  `opened_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cola de envíos individuales por campaña';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mktg_templates`
--

CREATE TABLE `mktg_templates` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `name` varchar(150) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `preview_text` varchar(255) DEFAULT NULL,
  `html_body` longtext NOT NULL,
  `text_body` text DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `created_by` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Plantillas HTML reutilizables para campañas';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notifications`
--

CREATE TABLE `notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `email_sent` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `type`, `title`, `message`, `link`, `is_read`, `email_sent`, `created_at`) VALUES
(1, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Data Pipeline Pro - Básico de Yury Luther Smith Tellez.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/0', 1, 0, '2026-02-19 18:52:04'),
(2, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Data Pipeline Pro - Básico de Yury Luther Smith Tellez.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/1', 1, 0, '2026-02-19 18:52:04'),
(3, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: quiero una de Yury Luther Smith Tellez.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/0', 1, 0, '2026-02-19 19:01:55'),
(4, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: quiero una de Yury Luther Smith Tellez.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/3', 1, 0, '2026-02-19 19:01:55'),
(5, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: quiero una de Yury Luther Smith Tellez.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/0', 1, 0, '2026-02-19 19:15:13'),
(6, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: quiero una de Yury Luther Smith Tellez.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/5', 1, 0, '2026-02-19 19:15:13'),
(7, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Quiero servicio de Luther.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/0', 1, 0, '2026-02-21 18:03:37'),
(8, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Quiero servicio de Luther.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/7', 1, 0, '2026-02-21 18:03:37'),
(10, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Sistemas Web Complejos - Básico de Humberto Boada.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/0', 1, 0, '2026-02-21 20:42:49'),
(11, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Sistemas Web Complejos - Básico de Humberto Boada.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/10', 1, 0, '2026-02-21 20:42:49'),
(15, 1, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', 'https://vezetaelea.com/demo/datawyrd/budget/show/6', 1, 0, '2026-02-21 21:01:17'),
(16, 2, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', 'https://vezetaelea.com/demo/datawyrd/budget/show/6', 1, 0, '2026-02-21 21:01:17'),
(17, 1, 'payment_upload', 'Comprobante de Pago', 'Un cliente ha subido un comprobante para la factura #1', 'https://vezetaelea.com/demo/datawyrd/invoice/show/1', 1, 0, '2026-02-21 21:02:07'),
(18, 2, 'payment_upload', 'Comprobante de Pago', 'Un cliente ha subido un comprobante para la factura #1', 'https://vezetaelea.com/demo/datawyrd/invoice/show/1', 1, 0, '2026-02-21 21:02:07'),
(22, 1, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', 'https://vezetaelea.com/demo/datawyrd/budget/show/7', 1, 0, '2026-02-21 21:29:57'),
(23, 2, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', 'https://vezetaelea.com/demo/datawyrd/budget/show/7', 1, 0, '2026-02-21 21:29:57'),
(24, 1, 'payment_upload', 'Comprobante de Pago', 'Un cliente ha subido un comprobante para la factura #2', 'https://vezetaelea.com/demo/datawyrd/invoice/show/2', 1, 0, '2026-02-21 21:30:33'),
(25, 2, 'payment_upload', 'Comprobante de Pago', 'Un cliente ha subido un comprobante para la factura #2', 'https://vezetaelea.com/demo/datawyrd/invoice/show/2', 1, 0, '2026-02-21 21:30:33'),
(27, 1, 'payment_upload', 'Comprobante de Pago', 'Un cliente ha subido un comprobante para la factura #2', 'https://vezetaelea.com/demo/datawyrd/invoice/show/2', 1, 0, '2026-03-01 17:47:47'),
(28, 2, 'payment_upload', 'Comprobante de Pago', 'Un cliente ha subido un comprobante para la factura #2', 'https://vezetaelea.com/demo/datawyrd/invoice/show/2', 1, 0, '2026-03-01 17:47:47'),
(31, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Dashboard Enterprise - Medio de Humberto Boada.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/0', 1, 0, '2026-03-03 10:06:30'),
(32, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Dashboard Enterprise - Medio de Humberto Boada.', 'https://vezetaelea.com/demo/datawyrd/ticket/detail/31', 1, 0, '2026-03-03 10:06:30'),
(33, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Dashboard Enterprise - Medio de Yury Luther Smith Tellez.', '/ticket/detail/0', 1, 0, '2026-03-04 00:38:44'),
(34, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Dashboard Enterprise - Medio de Yury Luther Smith Tellez.', '/ticket/detail/33', 1, 0, '2026-03-04 00:38:44'),
(36, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Data Pipeline Pro - Medio de Luther Smith.', '/ticket/detail/0', 1, 0, '2026-03-04 01:09:47'),
(37, 3, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Data Pipeline Pro - Medio de Luther Smith.', '/ticket/detail/36', 0, 0, '2026-03-04 01:09:47'),
(38, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Data Pipeline Pro - Medio de Luther Smith.', '/ticket/detail/37', 1, 0, '2026-03-04 01:09:47'),
(41, 1, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/9', 1, 0, '2026-03-04 12:50:00'),
(42, 3, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/9', 0, 0, '2026-03-04 12:50:00'),
(43, 2, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/9', 1, 0, '2026-03-04 12:50:00'),
(44, 1, 'payment_upload', 'Comprobante de Pago', 'Un cliente ha subido un comprobante para la factura #7', '/invoice/show/7', 1, 0, '2026-03-04 17:48:14'),
(45, 3, 'payment_upload', 'Comprobante de Pago', 'Un cliente ha subido un comprobante para la factura #7', '/invoice/show/7', 0, 0, '2026-03-04 17:48:14'),
(46, 2, 'payment_upload', 'Comprobante de Pago', 'Un cliente ha subido un comprobante para la factura #7', '/invoice/show/7', 1, 0, '2026-03-04 17:48:14'),
(50, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Data Pipeline Pro - Medio de Pedro Perez.', '/ticket/detail/0', 1, 0, '2026-03-05 15:11:07'),
(51, 3, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Data Pipeline Pro - Medio de Pedro Perez.', '/ticket/detail/50', 0, 0, '2026-03-05 15:11:07'),
(52, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Data Pipeline Pro - Medio de Pedro Perez.', '/ticket/detail/51', 1, 0, '2026-03-05 15:11:07'),
(53, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Hi datawyrd.com Administrator! de Laurence Herrod.', '/ticket/detail/0', 1, 0, '2026-03-06 10:05:19'),
(54, 3, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Hi datawyrd.com Administrator! de Laurence Herrod.', '/ticket/detail/53', 0, 0, '2026-03-06 10:05:19'),
(55, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Hi datawyrd.com Administrator! de Laurence Herrod.', '/ticket/detail/54', 1, 0, '2026-03-06 10:05:19'),
(56, 9, 'ticket_update', 'Actualización de Ticket', 'Tu ticket TKT-6BD2E8 ha cambiado a estado: Anulado', '/ticket/detail/10', 0, 0, '2026-03-07 16:22:26'),
(57, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Landing Pages - Plan Inicial de Humberto Boada.', '/ticket/detail/0', 1, 0, '2026-03-07 17:31:55'),
(58, 3, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Landing Pages - Plan Inicial de Humberto Boada.', '/ticket/detail/57', 0, 0, '2026-03-07 17:31:55'),
(59, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Landing Pages - Plan Inicial de Humberto Boada.', '/ticket/detail/58', 1, 0, '2026-03-07 17:31:55'),
(60, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Landing Pages - Plan Inicial de Humberto Boada.', '/ticket/detail/0', 1, 0, '2026-03-07 21:50:06'),
(61, 3, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Landing Pages - Plan Inicial de Humberto Boada.', '/ticket/detail/60', 0, 0, '2026-03-07 21:50:06'),
(62, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Landing Pages - Plan Inicial de Humberto Boada.', '/ticket/detail/61', 1, 0, '2026-03-07 21:50:06'),
(65, 1, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/11', 1, 0, '2026-03-07 22:44:19'),
(66, 3, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/11', 0, 0, '2026-03-07 22:44:19'),
(67, 2, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/11', 1, 0, '2026-03-07 22:44:19'),
(68, 1, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Landing Pages - Plan Inicial de Humberto Boada.', '/ticket/detail/0', 1, 0, '2026-03-08 23:08:54'),
(69, 3, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Landing Pages - Plan Inicial de Humberto Boada.', '/ticket/detail/68', 0, 0, '2026-03-08 23:08:54'),
(70, 2, 'new_ticket', 'Nueva Solicitud', 'Nueva solicitud recibida: Solicitud: Landing Pages - Plan Inicial de Humberto Boada.', '/ticket/detail/69', 1, 0, '2026-03-08 23:08:54'),
(73, 1, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/12', 1, 0, '2026-03-08 23:19:14'),
(74, 3, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/12', 0, 0, '2026-03-08 23:19:14'),
(75, 2, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/12', 1, 0, '2026-03-08 23:19:14'),
(80, 1, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/13', 1, 0, '2026-03-29 01:41:31'),
(81, 3, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/13', 0, 0, '2026-03-29 01:41:31'),
(82, 2, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/13', 0, 0, '2026-03-29 01:41:31'),
(85, 1, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha rechazado el presupuesto.', '/budget/show/14', 1, 0, '2026-04-05 20:32:20'),
(86, 3, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha rechazado el presupuesto.', '/budget/show/14', 0, 0, '2026-04-05 20:32:20'),
(87, 2, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha rechazado el presupuesto.', '/budget/show/14', 0, 0, '2026-04-05 20:32:20'),
(90, 1, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/15', 1, 0, '2026-04-05 20:51:58'),
(91, 3, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/15', 0, 0, '2026-04-05 20:51:58'),
(92, 2, 'budget_decision', 'Decisión de Presupuesto', 'El cliente ha aprobado el presupuesto.', '/budget/show/15', 0, 0, '2026-04-05 20:51:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payment_receipts`
--

CREATE TABLE `payment_receipts` (
  `id` int(10) UNSIGNED NOT NULL,
  `invoice_id` int(10) UNSIGNED NOT NULL,
  `uploaded_by` int(10) UNSIGNED NOT NULL,
  `filename` varchar(255) NOT NULL,
  `filepath` varchar(255) NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `payment_date` date NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `status` enum('pending','verified','rejected') NOT NULL DEFAULT 'pending',
  `mp_payment_id` varchar(255) DEFAULT NULL,
  `verified_by` int(10) UNSIGNED DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `description`) VALUES
(1, 'manage_leads', 'Manage Leads CRM'),
(2, 'manage_projects', 'Project Management'),
(3, 'manage_finance', 'Invoices and Budgets'),
(4, 'manage_services', 'Service Catalog'),
(5, 'manage_cms', 'Blog and Pages'),
(6, 'view_reports', 'View Dashboard Analytics'),
(7, 'manage_users', 'User Administration');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `project_deliverables`
--

CREATE TABLE `project_deliverables` (
  `id` int(10) UNSIGNED NOT NULL,
  `active_service_id` int(10) UNSIGNED NOT NULL,
  `uploaded_by` int(10) UNSIGNED NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `filename` varchar(255) NOT NULL,
  `filepath` varchar(255) NOT NULL,
  `file_type` enum('document','code','data','image','other') NOT NULL DEFAULT 'other',
  `file_size` int(10) NOT NULL DEFAULT 0,
  `version` varchar(20) DEFAULT '1.0',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles_custom`
--

CREATE TABLE `roles_custom` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `services`
--

CREATE TABLE `services` (
  `id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `short_description` varchar(255) DEFAULT NULL,
  `full_description` text DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `order_position` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `tenant_id` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `services`
--

INSERT INTO `services` (`id`, `category_id`, `name`, `slug`, `short_description`, `full_description`, `icon`, `image`, `is_featured`, `is_active`, `order_position`, `created_at`, `updated_at`, `tenant_id`) VALUES
(1, 1, 'Data Pipeline Pro', 'data-pipeline-pro', 'Pipelines ETL de alto rendimiento para transformación de datos empresariales.', 'Diseño e implementación de pipelines ETL robustos utilizando las mejores prácticas de la industria. Integramos múltiples fuentes de datos en un almacén unificado.', 'hub', NULL, 1, 1, 1, '2026-02-08 22:53:41', '2026-02-08 22:53:41', 1),
(2, 1, 'Warehouse Sync', 'warehouse-sync', 'Sincronización en tiempo real entre sistemas de datos heterogéneos.', 'Servicio de sincronización bidireccional entre data warehouses, bases de datos operacionales y sistemas cloud.', 'sync_alt', NULL, 0, 1, 2, '2026-02-08 22:53:41', '2026-02-08 22:53:41', 1),
(3, 1, 'Legacy Migration', 'legacy-migration', 'Migración segura de sistemas legacy a arquitecturas modernas.', 'Migración completa de datos desde sistemas legacy (Oracle, SQL Server, AS400) hacia plataformas modernas cloud o híbridas.', 'history_edu', NULL, 0, 1, 3, '2026-02-08 22:53:41', '2026-02-08 22:53:41', 1),
(5, 2, 'Dashboards Ejecutivos', 'dashboard-enterprise', 'Dashboards ejecutivos con Looker Studio, Power BI y/o Tableau.', 'Diseño y desarrollo de dashboards interactivos para la toma de decisiones estratégicas. Visualización de KPIs clave del negocio.', 'analytics', NULL, 1, 1, 1, '2026-02-08 22:53:41', '2026-03-15 15:51:46', 1),
(6, 1, 'Data Lake Solutions', 'data-lake-solutions', 'Arquitectura de Data Lake para almacenamiento masivo.', 'Diseño e implementación de Data Lakes en Azure, AWS o GCP para almacenamiento y análisis de datos a escala de petabytes.', 'storage', NULL, 0, 1, 2, '2026-02-08 22:53:41', '2026-02-28 16:47:19', 1),
(7, 2, 'Predictive Analytics', 'predictive-analytics', 'Modelos predictivos y machine learning para negocios.', 'Desarrollo de modelos predictivos utilizando Python, R y plataformas cloud para anticipar tendencias de negocio.', 'insights', NULL, 0, 1, 3, '2026-02-08 22:53:41', '2026-02-08 22:53:41', 1),
(8, 3, 'Landing Pages', 'landing-pages', 'Páginas de aterrizaje de alta conversión.', 'Diseño y desarrollo de landing pages optimizadas para SEO y conversión con las últimas tecnologías web.', 'database', NULL, 0, 1, 1, '2026-02-08 22:53:41', '2026-02-28 16:16:36', 1),
(9, 3, 'Sistemas Web Complejos', 'sistemas-web-complejos', 'Desarrollo de sistemas web a medida.', 'Desarrollo full-stack de sistemas web complejos con PHP, Python, Node.js y frameworks modernos.\r\nAcceso a nuestro CRM Data Wyrd OS, totalmente configurable y adaptado a su marca.', 'database', NULL, 1, 1, 2, '2026-02-08 22:53:41', '2026-02-28 23:30:21', 1),
(10, 3, 'Implementación CRM', 'implementacion-crm', 'Implementación de Bitrix24, Dynamics, Odoo.', 'Configuración, personalización e integración de sistemas CRM y ERP para optimizar procesos de negocio.', 'group', NULL, 0, 1, 3, '2026-02-08 22:53:41', '2026-02-08 22:53:41', 1),
(11, 4, 'Consultoría de Procesos', 'consultoria-procesos', 'Análisis y optimización de procesos empresariales.', 'Levantamiento, documentación y optimización de procesos de negocio con metodologías ágiles.', 'trending_up', NULL, 1, 1, 1, '2026-02-08 22:53:41', '2026-02-08 22:53:41', 1),
(12, 4, 'Automatización RPA', 'automatizacion-rpa', 'Automatización robótica de procesos repetitivos.', 'Implementación de bots RPA para automatizar tareas repetitivas y liberar recursos humanos.', 'smart_toy', NULL, 0, 1, 2, '2026-02-08 22:53:41', '2026-02-08 22:53:41', 1),
(13, 4, 'Implementación IA', 'implementacion-ia', 'Integración de inteligencia artificial en procesos.', 'Implementación de soluciones de IA para optimización de procesos, chatbots, análisis de documentos y más.', 'psychology', NULL, 0, 1, 3, '2026-02-08 22:53:41', '2026-02-08 22:53:41', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `service_categories`
--

CREATE TABLE `service_categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL COMMENT 'Material Icon name',
  `image` varchar(255) DEFAULT NULL,
  `order_position` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `service_categories`
--

INSERT INTO `service_categories` (`id`, `name`, `slug`, `description`, `icon`, `image`, `order_position`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Arquitectura y Gobierno de Datos', 'arquitectura-gobierno-datos', 'Diseñamos ecosistemas de datos robustos, escalables y seguros que garantizan calidad, trazabilidad y control total sobre la información crítica del negocio.', 'database', 'assets/images/pillar_arquitectura-gobierno-datos.png', 3, 1, '2026-02-08 22:53:41', '2026-06-07 16:32:30'),
(2, 'Business Intelligence & Analytics', 'business-intelligence', 'Los datos aislados son ruido; conectados son destino. Interpretamos los hilos de información de su empresa para mostrarle el camino más corto hacia sus objetivos.', 'bar_chart', 'assets/images/pillar_business-intelligence.png', 2, 1, '2026-02-08 22:53:41', '2026-03-01 01:01:13'),
(3, 'Aplicaciones y Web Apps', 'web-apps', 'En el tejido digital, cada clic cuenta. Creamos aplicaciones que conectan cada punto de interacción de su cliente, asegurando un ecosistema fluido y coherente.', 'code', 'assets/images/pillar_web-apps.png', 1, 1, '2026-02-08 22:53:41', '2026-03-01 01:00:47'),
(4, 'Automatización y Eficiencia Operativa', 'automatizacion-eficiencia', 'Optimizamos procesos mediante automatización inteligente y modelos algorítmicos que reducen errores, dependencia manual y tiempos improductivos.', 'settings', 'assets/images/pillar_automatizacion-eficiencia.png', 4, 1, '2026-02-08 22:53:41', '2026-06-07 16:32:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `service_plans`
--

CREATE TABLE `service_plans` (
  `id` int(10) UNSIGNED NOT NULL,
  `service_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `level` enum('basic','medium','advanced') NOT NULL DEFAULT 'basic',
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `currency` char(3) NOT NULL DEFAULT 'USD',
  `features` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Lista de características en JSON' CHECK (json_valid(`features`)),
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `order_position` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `tenant_id` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `service_plans`
--

INSERT INTO `service_plans` (`id`, `service_id`, `name`, `level`, `price`, `currency`, `features`, `is_featured`, `is_active`, `order_position`, `created_at`, `updated_at`, `tenant_id`) VALUES
(1, 1, 'Básico', 'basic', 0.00, 'USD', '[\"Hasta 5 fuentes de datos\",\"Sincronizaci\\u00f3n diaria\",\"Soporte por email\",\"Dashboard b\\u00e1sico\"]', 0, 1, 1, '2026-02-08 22:53:41', '2026-03-01 00:17:56', 1),
(2, 1, 'Medio', 'medium', 0.00, 'USD', '[\"Hasta 15 fuentes de datos\",\"Sincronizaci\\u00f3n por hora\",\"Soporte prioritario\",\"Dashboard avanzado\",\"Alertas autom\\u00e1ticas\"]', 1, 1, 2, '2026-02-08 22:53:41', '2026-03-01 00:17:56', 1),
(3, 1, 'Avanzado', 'advanced', 0.00, 'USD', '[\"Fuentes ilimitadas\",\"Sincronizaci\\u00f3n en tiempo real\",\"Soporte 24\\/7\",\"Dashboard personalizado\",\"Alertas y notificaciones\",\"SLA garantizado\"]', 0, 1, 3, '2026-02-08 22:53:41', '2026-03-01 00:17:56', 1),
(4, 5, 'Business Dashboard', 'basic', 119.00, 'USD', '[\"Conexi\\u00f3n a una fuente de datos\",\"Dashboard estilo resumen\",\"Visualizaci\\u00f3n KPI principales\",\"Capacitaci\\u00f3n b\\u00e1sica\"]', 0, 1, 1, '2026-02-08 22:53:41', '2026-03-15 15:52:20', 1),
(5, 5, 'Analytical Dashboards', 'medium', 299.00, 'USD', '[\"3 dashboards\",\"Conexi\\u00f3n a distintas fuentes de datos\",\"Capacitaci\\u00f3n completa\",\"Drill-down interactivo\"]', 1, 1, 2, '2026-02-08 22:53:41', '2026-03-15 15:52:47', 1),
(6, 5, 'Intelligence Platform', 'advanced', 0.00, 'USD', '[\"Dashboards ilimitados\",\"Visualizaciones ilimitadas\",\"Tiempo real\",\"Capacitaci\\u00f3n avanzada\",\"Integraci\\u00f3n API\",\"M\\u00f3vil y tablets\",\"M\\u00faltiples \\u00e1reas de negocio\",\"Roles de usuarios\"]', 0, 1, 3, '2026-02-08 22:53:41', '2026-03-15 15:53:15', 1),
(7, 9, 'Data Wyrd OS Básico', 'basic', 999.00, 'USD', '[\"Hasta 5 m\\u00f3dulos\",\"Data Wyrd OS\",\"Responsive design\",\"Base de datos MySQL\",\"Blog administrable\",\"Integraci\\u00f3n con MercadoPago\"]', 1, 1, 1, '2026-02-08 22:53:41', '2026-03-15 15:49:32', 1),
(8, 9, 'Data Wyrd OS Pro', 'medium', 0.00, 'USD', '[\"Arquitectura SaaS\",\"Dise\\u00f1o UI\\/UX responsive\",\"Arquitectura de microservicios\",\"CI\\/CD\",\"Integraci\\u00f3n con PostgreSQL\",\"Blog autoadministrable\",\"Configuraci\\u00f3n de CMS de servicios\",\"Tracking avanzado de tickets\",\"Dashboard de gesti\\u00f3n\",\"Administraci\\u00f3n de usuarios y roles\",\"Logs de auditor\\u00eda\"]', 0, 1, 2, '2026-02-08 22:53:41', '2026-03-15 15:50:04', 1),
(10, 11, 'Básico', 'basic', 0.00, 'USD', '[\"An\\u00e1lisis de 1 proceso\",\"Documentaci\\u00f3n\",\"Recomendaciones b\\u00e1sicas\"]', 0, 1, 1, '2026-02-08 22:53:41', '2026-03-01 00:17:56', 1),
(11, 11, 'Medio', 'medium', 0.00, 'USD', '[\"An\\u00e1lisis de 5 procesos\",\"Documentaci\\u00f3n BPMN\",\"Plan de mejora\",\"Seguimiento 1 mes\"]', 1, 1, 2, '2026-02-08 22:53:41', '2026-03-01 00:17:56', 1),
(12, 11, 'Avanzado', 'advanced', 0.00, 'USD', '[\"An\\u00e1lisis integral\",\"Documentaci\\u00f3n completa\",\"Implementaci\\u00f3n de mejoras\",\"Seguimiento 3 meses\",\"KPIs de proceso\"]', 0, 1, 3, '2026-02-08 22:53:41', '2026-03-01 00:17:56', 1),
(13, 8, 'Plan Inicial', 'basic', 299.00, 'USD', '[\"1 landing page\",\"Dise\\u00f1o UI\\/UX responsive\",\"Formulario de contacto\",\"Integraci\\u00f3n con RRSS\"]', 0, 1, 1, '2026-02-28 16:16:13', '2026-03-15 15:47:32', 1),
(14, 7, 'Plan Core', 'basic', 0.00, 'USD', '[\"An\\u00e1lisis preliminar\",\"Modelos b\\u00e1sicos o avanzados\",\"Predicci\\u00f3n de tendencias\",\"Reportes interpretables\",\"An\\u00e1lisis de comportamiento\",\"Segmentaci\\u00f3n inteligente\"]', 0, 1, 1, '2026-02-28 17:08:04', '2026-03-15 15:54:07', 1),
(15, 13, 'Plan Inicial', 'basic', 0.00, 'USD', '[\"An\\u00e1lisis preliminar\",\"Configuraci\\u00f3n base\",\"Soporte t\\u00e9cnico\",\"Garant\\u00eda de implementaci\\u00f3n\"]', 1, 1, 1, '2026-02-28 17:10:26', '2026-03-01 21:16:13', 1),
(16, 12, 'Plan Inicial', 'basic', 0.00, 'USD', '[\"An\\u00e1lisis preliminar\",\"Configuraci\\u00f3n base\",\"Soporte t\\u00e9cnico\",\"Garant\\u00eda de implementaci\\u00f3n\"]', 1, 1, 1, '2026-02-28 17:11:15', '2026-02-28 17:11:20', 1),
(17, 6, 'Plan Inicial', 'basic', 0.00, 'USD', '[\"An\\u00e1lisis preliminar\",\"Configuraci\\u00f3n base\",\"Soporte t\\u00e9cnico\",\"Garant\\u00eda de implementaci\\u00f3n\"]', 1, 1, 1, '2026-02-28 17:11:46', '2026-02-28 17:11:54', 1),
(18, 3, 'Plan Inicial', 'basic', 0.00, 'USD', '[\"An\\u00e1lisis preliminar\",\"Configuraci\\u00f3n base\",\"Soporte t\\u00e9cnico\",\"Mapeo de riesgos\",\"Migraci\\u00f3n por m\\u00f3dulos\"]', 1, 1, 1, '2026-02-28 17:12:29', '2026-03-01 21:15:29', 1),
(19, 2, 'Plan Inicial', 'basic', 0.00, 'USD', '[\"An\\u00e1lisis preliminar\",\"Configuraci\\u00f3n base\",\"Soporte t\\u00e9cnico\",\"Garant\\u00eda de implementaci\\u00f3n\"]', 1, 1, 1, '2026-02-28 17:12:38', '2026-02-28 17:12:46', 1),
(20, 10, 'Plan Core', 'basic', 0.00, 'USD', '[\"An\\u00e1lisis preliminar\",\"Configuraci\\u00f3n base\",\"Soporte t\\u00e9cnico\",\"Garant\\u00eda de implementaci\\u00f3n\"]', 1, 1, 1, '2026-02-28 17:13:04', '2026-03-01 21:14:36', 1),
(21, 8, 'Profesional', 'basic', 499.00, 'USD', '[\"Dise\\u00f1o UI\\/UX responsive\",\"M\\u00faltiples secciones y bloques din\\u00e1micos\",\"Integraci\\u00f3n con RRSS\",\"Formulario de contacto\",\"Bot\\u00f3n de Whatsapp\"]', 1, 1, 2, '2026-03-15 15:47:57', '2026-03-15 15:48:20', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(128) NOT NULL COMMENT 'Session ID único',
  `payload` text NOT NULL COMMENT 'Datos de sesión serializados (base64)',
  `last_activity` int(10) UNSIGNED NOT NULL COMMENT 'Timestamp de última actividad',
  `user_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'ID del usuario (si está autenticado)',
  `ip_address` varchar(45) DEFAULT NULL COMMENT 'Dirección IP del cliente',
  `user_agent` text DEFAULT NULL COMMENT 'User-Agent del navegador'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Almacenamiento de sesiones con metadatos de seguridad';

--
-- Volcado de datos para la tabla `sessions`
--

INSERT INTO `sessions` (`id`, `payload`, `last_activity`, `user_id`, `ip_address`, `user_agent`) VALUES
('00ejskqc6i3462pgciapd3lvfl', '', 1778798915, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('025bmtqsumgdda342kbd26pihi', '', 1778798912, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('02fma54tpsdldbqjfglnqfghqi', '', 1780239617, NULL, '74.7.244.19', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('02qquos1dfmgd7p096bgs9kb1e', 'Y3NyZl90b2tlbnxzOjY0OiIzYjQyYjAyMmNkNGNlN2YyMGI4MDBiOGVmODQxZGYyMDNiYzMwYzAzM2I0Mzk4ODJlODFmY2Q4YmMzOTQ3MjVlIjs=', 1779883541, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('04afrla6p3tage3gf6pk3olkvu', '', 1778799104, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('04m9afg0i2qu6nlk9ct1tibhqo', 'Y3NyZl90b2tlbnxzOjY0OiJiYmExZTJjMDJjNzA0NzUwZjc4NThjZjU2OTUyMDNhODA4OWRjZjI4YWQ5NmZhZWRlZTNhZWRjZGQ5MjY4OGE0Ijs=', 1779305327, NULL, '192.71.126.151', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('0530m0bo50nnbsfgl70n4mlotc', '', 1778799465, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('05ni3iqc2kplihj8gnqkapidu0', 'Y3NyZl90b2tlbnxzOjY0OiJiODUyMTg1OGQ2ZmZiNTZmZDc2NWFiMDJiZmFlMWEwOGMyN2JhMmVjNTE0ZGQ3YTc4YmZmN2E5M2EwMTllMDhkIjs=', 1780702626, NULL, '66.249.79.132', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('05q299ucckvqoh75pluj1sp39q', '', 1778799491, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('061i9c976mg8pivlhs2i56d39o', 'Y3NyZl90b2tlbnxzOjY0OiI2MGZmODY1ZmZiMDI4ZmM5NjIzNWRjNTIwYjRlN2NjN2UyNTNjOTliOGYxMzVkZTY2Y2RjNTFhMDNiZThkMWQ0Ijs=', 1779097809, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('06dme1djcjfg43e32p8160c6h3', '', 1778798814, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('06lbag5vfrgltr1thkuvncj49v', '', 1778799322, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('07rnjb9ul1l0gths094l3g838u', '', 1780834896, NULL, '45.38.101.245', 'Exabot'),
('08jln1qlt160515qgl9e61p709', '', 1778798851, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('08ql5gijppn20u6gq96jrgddcv', '', 1778799242, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('08r77ogd93rvk80qfvrbkjv0c1', '', 1778905889, NULL, '2a03:2880:f808:24::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('0958rj51sctr498j91m4in5qnf', 'Y3NyZl90b2tlbnxzOjY0OiI1YmFkNzg4Nzg5ODExZjU2YWNlNWRhMDc1YTNmNjU5MWYyNjkwYzAxNjMyNWY3NDU3MmIyN2UxMGNlNjFjYjYwIjs=', 1779535024, NULL, '2001:4ba0:cafe:b2c::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36 Edg/91.0.864.54'),
('0a9eo7i5oo0ool45teq7bmkodj', '', 1778799435, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0am601ojh9b4goltkp5h0h0uk4', '', 1780310938, NULL, '2a03:2880:3ff:50::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('0b6mc8ikmifb133s2djd4rvj40', '', 1778798922, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0bk9rjoi4q9eacff7lg4ntb6t0', '', 1778799115, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0d2vuj1h7b220pgrhgjc286ium', 'Y3NyZl90b2tlbnxzOjY0OiI1Mzg5OGY1MDhhOGRjZmE4MjM2NGRkNjdiYmU0Yzg5YTlmOTE0NDM2ZWMzMWNiNDZkOWM0MWY3ZTRjNjg4OGI2Ijs=', 1778901053, NULL, '66.249.79.7', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('0d81c8kcspfltfcionrjam1sbm', '', 1778799411, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0fe1ihvni6ov6t6qdlp9s56qb5', '', 1778877896, NULL, '138.246.253.24', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.134 Safari/537.36'),
('0fgskaut8gvckgfquf75grkm6t', '', 1778798973, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0g58nch7vqc3vk8pvchibievns', '', 1780492453, NULL, '66.249.79.132', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('0gqvdsn7im53kse2t6do456erg', '', 1778798673, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0ht0btch3e75e3fhoqsfj57u9u', '', 1778798575, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0id1536j9onmu8f244cjo4e4dd', '', 1778798941, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0imacpa67gubliv950h0r2cffk', '', 1778799074, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0in4fd1e6u114llj9oql825gl0', '', 1778798699, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0jn9pgnr5b84j54ogdo6am29jb', '', 1778799269, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0koo05vts2p08mfch3g3pbj67a', '', 1778868290, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (X11; Linux x86_64; rv:149.0) Gecko/20100101 Firefox/149.0'),
('0kq80c4dk5bks5uvhs0v7719tm', '', 1778799030, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0kt9mv2khp5p9l7t7ajed2rajn', '', 1778798707, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0kununbf7t8bm190rkbt30837r', '', 1778799264, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0lp3c61rkfikjji0u5itta5vff', '', 1779612836, NULL, '40.77.167.181', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('0m46nkqe86nj8pv68284tqbtmb', '', 1780342787, NULL, '52.167.144.55', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('0mgqj3ljbgmedcg201hgcd2j1b', 'Y3NyZl90b2tlbnxzOjY0OiI1ZDRkNWMwODk0NzU4MThkYmQzOWQ1OWI1OTVjOTQ0NTQwMzBhNmFkZGVkNDVmNDk3M2FiZDUyY2EzZjhjMTdiIjs=', 1780783429, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('0mjlop255b7o1ue5k7rje4kiip', 'Y3NyZl90b2tlbnxzOjY0OiJjYmNmNWVlODVlMjE5NjNjY2VmN2M3MjExMDRjNWExM2IyY2NmZDc2ZjMxZjEzZmVhZGY1ZjQ3NzM5NjUyZTBlIjs=', 1779317110, NULL, '2607:a2c0:800::56', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:121.0) Gecko/20100101 Firefox/121.0'),
('0n146te08d7rt8lf6uq512nkhp', '', 1778798875, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0nf5gncblncv941cp64ufndeao', '', 1778799433, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0nfigg23gqtjcaofj04hvf0ed4', '', 1778798558, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0oeb5l9a61g5tr9lbu3qepl834', '', 1778799244, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0p1af63hf7qs542r1of0eql3js', '', 1779051417, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('0p1l26mlkmd0de3kvgdkh8rgng', '', 1778798644, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0pn73b064a1hrtb869rg8jb0fq', '', 1778798829, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0psmpcu7e1vu07k319hirp55vv', '', 1778798820, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0rbaqevpv4j8km037flhpbp3n6', '', 1778799289, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0smf0rpffnr9mqhov59v6a69o4', '', 1778798680, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('0vj01t8sj7ojmn2fnd8h0qdo4k', 'Y3NyZl90b2tlbnxzOjY0OiIxMzE1YTY4NDA5MzcwZWQ2NmRmYzQzYTllMWRhMWFkMWJlMjdmOWM5OTRkYWU0Zjc2OTQwMDRmOTJiNGYxMTUxIjs=', 1780779367, NULL, '181.106.72.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36'),
('1047ljgre7kgd1it8s11mao4pt', 'Y3NyZl90b2tlbnxzOjY0OiI1NzcxNGVhOTViMDU5NmNmZmE4MThmMjRjYWVkZTU3NjUxOTAzNjFlMDc1NjI1NTE3NDcxMjk2NDFmMWFlZjEwIjs=', 1780835023, NULL, '172.120.101.117', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('11gbtr2ijfcio7s6u04jgu9045', 'Y3NyZl90b2tlbnxzOjY0OiJlZGRkOTA0OTY4NThkOTBhYWI0Mjk5Y2FjZDc1ZjA4MWFjOWMyNTc0MDdjMDNhMzc4NjY5NTNiOTA4MGUxNjk2Ijs=', 1780783419, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('12tci48ffn9blssg8ml81d7u73', '', 1778798715, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('133t0in64gmtvbfd0bbl9nef5b', '', 1778798751, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1489607acqomsl14via0tg809t', '', 1778798560, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('14fdvdqrr9uudi7o0drqt6v8re', '', 1780121748, NULL, '104.210.140.128', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('166426v8m5udgb924l4lqb1lb3', 'Y3NyZl90b2tlbnxzOjY0OiI1MDNjMTVkYzJmYzYzMjEyYzg2MGQwNzY2ZGNiNTE1ZDkwNjNkYTNmZDQ0NTRjNTI1NGQyNzdhMzZlMDQ1NGRhIjs=', 1779970394, NULL, '64.227.97.15', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
('1719m5miimqpaovkduqb52j46d', 'Y3NyZl90b2tlbnxzOjY0OiJkMjhhYWFlNTYyODhmN2E1NTk0NjkxZTEzN2I0OTljYWYzOTRjMDBiOTJhMzQzNDI0ZmRkOTZjYjQyOWE3MjYxIjs=', 1779091880, NULL, '54.174.58.240', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/148.0.0.0 Safari/537.36'),
('17k37s5qup182fro7tscv0qume', '', 1778798760, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('17mff58esus61p3dp47r184q37', '', 1778799008, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('18u6qhqbm25a45f4fmqubnimrv', '', 1780142335, NULL, '74.7.244.19', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('196dgnkpid9hgr72b4mcb017fs', '', 1778799187, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('19eblb3kqldklg19sqv9dh81ts', '', 1778799032, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('19fo7cpuepuq0pbhoq2jhpbo64', '', 1778799487, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('19iutpflhooq2o25m9vgka61ev', '', 1780604387, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('1aq92jrcadsg8psd33914k45kr', '', 1778799011, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1bi3gnfm1l705me6qt33dk92hb', '', 1780850571, NULL, '207.46.13.229', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('1bktq0pudd2v0hbcain9m27nqe', '', 1778798603, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1c2602lo0mhhcbn1ffh34rspke', '', 1779252144, NULL, '40.77.167.136', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('1cfd7pklctfrvr7f41m64ok6ng', '', 1778798440, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1cn3af7hhau4aeujfs9kc2794e', '', 1778798712, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1cpflqdp8ml41tuqo0ostvnkiv', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0'),
('1d3stnuvc3nhn3c61jdap16iv6', '', 1779056565, NULL, '74.7.244.44', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('1d692ob4sm7plkevild3ib7pf7', 'Y3NyZl90b2tlbnxzOjY0OiIzM2ZmYmRkMmYzNDAwYjJjODY5YjQxNzM2OGQ3ZTMzYTE1MjJiMzJhNTk0ZTAwZjllZTBiNTBmYWYxMDdjMzYxIjs=', 1780743830, NULL, '93.158.91.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36'),
('1dc8j4duiskf7cl2b26jtall8c', '', 1779861602, NULL, '74.7.175.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('1e1chjgepsv1inf0er8vhqahs8', '', 1778798929, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1egapp664ra1v7h9artc2rpa4k', '', 1778799021, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1gh35sqaatk013pt0holba2706', 'Y3NyZl90b2tlbnxzOjY0OiJkY2FjMzY5Yzc2ZjQ3Yjk3ZWNiMWEwMmE0OGYzMjA3NzFkYWVjNjcwNDkwOWExN2UwZmFkMWZkNDhkZTdiODhkIjs=', 1779188725, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('1gpl81rm5oq5a4dben9bjr6n83', '', 1778798716, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1he5q2274c1l325gjuei5alulq', '', 1778868291, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0'),
('1iindeja5tbuurv3r53i1lskfa', '', 1778798829, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1ij5ov0ct85hb27t1nb9qnpv2e', '', 1778799415, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1kg69s0ivgue70v07vi1m246oj', '', 1778798849, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1kjncaub2me78a9bml9c9cufgn', '', 1778799331, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1lm8rolm64eat2idmi6e48gaiv', '', 1778798671, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1lvmcl88d72gbcr3tfe2gpdffn', '', 1778799204, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1mq9f8qk547stq014o390vnc7q', 'Y3NyZl90b2tlbnxzOjY0OiJjYjgxNTVlOTkwMDVhYjM4OWVhYmJlMDU4ZjYyMmI0MDhkNmVjYzc0ZWE4MDI3MDFkODQ5NDg2NjAzMTA1NDQ4Ijs=', 1780161287, NULL, '190.210.32.173', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.208 Mobile Safari/537.36 Instagram 431.1.0.49.82 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 981604505; IABMV/1) NV/501'),
('1nrmfm1nek7vv1jp4fbbknqfhn', '', 1778798503, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1ohjvtei9vmipcnh8nvh6nm3v2', '', 1779344390, NULL, '2a03:2880:18ff:72::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('1oqe7srico50lje2nta6689as8', '', 1778798595, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1or8ofuhq8a8nak29sbn171l2f', '', 1780793157, NULL, '2a02:4780:27:2004:0:d53:da4a:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('1p813b3ssevk7qdacs2e1qv6qv', '', 1778798694, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1q26lnoov22o9ofm36fn0149qf', 'Y3NyZl90b2tlbnxzOjY0OiI4ZmY5MzVkODcxM2Q4MWMxZmFlZDRlM2I4MTZmMWJiNWZjMzNjNjRhNzZjZTZlNTM1YjBlNjM1ODkzYjg1ZmNmIjs=', 1779989889, NULL, '186.143.138.99', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.166 Mobile/15E148 Safari/604.1'),
('1qdb49bgajtd617hkum6a6bon1', '', 1778798547, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1qdfe1nv7cq1uc1pjjf211i3qi', 'Y3NyZl90b2tlbnxzOjY0OiIzOGE2MzgzNWM4YWEzNDNhYzM1MzY4ZDA3MTRhZTQ4ZWFkMTE0M2YwMmE3MDBlMWIyOWIyYmY0YjA3ZTQ2YWZmIjs=', 1778813928, NULL, '209.209.96.80', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('1rniofpfsg6vsc1g49nqogvh6v', '', 1779093281, NULL, '216.157.42.81', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('1rvukjh73gn20r4gci03q7802d', '', 1778799179, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1sa1ahag1dfiqc822is01rsqoq', '', 1778799101, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1tqg63heog7hev72b5cj8751hn', '', 1778798540, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('1ua94ismrbl062sbq6h5lre0r7', '', 1778868300, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36'),
('1ubdifgbj0hg7qriqphbkclfub', '', 1778799466, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('20586lgpvgb0q3fuafoluirneo', '', 1778799444, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('20lt39v4js26h8smjl2q5apv98', '', 1779068442, NULL, '66.249.79.5', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('21a1kp0vv2c4cfugpb40spdgj9', 'Y3NyZl90b2tlbnxzOjY0OiI3MGUzOTE2NmUxMjk5YWM3N2I0OGE0MzFkNGFkYWNmOWY3MDk4YzliNjQ0Nzk2YmU1NjFiM2RjMmQwNDcyZTk2Ijs=', 1779206127, NULL, '34.41.194.165', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)'),
('21hnb7618cmse8ie9c42eqkf8m', '', 1778799201, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('26bq3h9noutqgstl11oio0lior', '', 1778799470, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('26ffpdasdprpbbtkc3dfnkk45k', 'Y3NyZl90b2tlbnxzOjY0OiJlYmZlMDFjYTRmYjRkMDJkZWQwODgzMmIzYTllZjE1ZDY5YWQ0MTc1MzQ5YmQ5OGZmY2ExMzliODE2NmVmYzNlIjs=', 1780417090, NULL, '181.214.206.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 CCleaner/130.0.0.0'),
('26j1ighfiq2t6veja9j90vlone', '', 1778799094, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('27gaso0v3pjkp7pvlrfca0q6tc', '', 1778798850, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('29pdhqil9ohetlpu06d509c194', '', 1778799267, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('29vhb8avba1kanft85lcssmotq', '', 1778798759, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2a07n5ai2q8ekocio5v7ko0694', '', 1778798704, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2bfu179uf3sun88euqdk3b6efs', '', 1778798869, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2bglekc4k789k3q3mufuedogel', '', 1779159874, NULL, '2a03:2880:f808:3b::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('2bq4ka5sc5b4e4jhsju4fd34hl', '', 1779304136, NULL, '2a03:2880:2ff:4e::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('2bve6ifq892mi7r6harc4b6dbp', '', 1778798650, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2cpg37vii6bufkksq6drbhar3t', '', 1778799177, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2d5tkq4mcds70led5dv94o1sku', '', 1778798569, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2dk56bso5s05s01ccf540479t9', '', 1780793196, NULL, '2a02:4780:27:2004:0:d53:da4a:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('2e0ui0hq4e39jrauob028451gs', 'Y3NyZl90b2tlbnxzOjY0OiJhOTJkYWQ5OTg1NmEzYzcwMzk5N2NiNjExYzI2MzRhNDk3ZGIxMjQ2ODFkNjM1YmQyZGRjYTMyZGNkNDBlOTFjIjs=', 1780017119, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('2est5ankho3q9e11vghagr73c2', 'Y3NyZl90b2tlbnxzOjY0OiI5ZmVkZDg0NmY4ZjcyMmY2NzU0ZjlhYTA5ZGJkZTY3M2VkZmIwMzNhNDc4NDc4OWQxNjllMDFkOTQ5OWE1YWEyIjs=', 1780783432, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('2fb8lk4v2j80jqp9sr5e46q0u4', '', 1778798852, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2fmnjf9clf87jo1e6l21lbt69r', '', 1778798656, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2gijt2vijd23akcj5vfs83r5ao', '', 1778799145, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2j2bjprlkm3fpsasb1tofs5far', 'Y3NyZl90b2tlbnxzOjY0OiI4MDY3NGExZGNiYTI0MDNmNWE0MThkNTBhYmU5ZTk0OWZiODIxYmRiOGFlYzhiYWUzZmE1OTFjY2Q5Mjg3N2U0Ijs=', 1779233616, NULL, '2a02:c207:2324:3159::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0'),
('2jh1gnr09k7gf9qhiaabonrvkd', '', 1780794541, NULL, '17.241.75.99', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)'),
('2jqbgolntib5polrvkr0m7lggs', '', 1778798557, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2jtjm5k13uhu33ujuphkvv52v9', 'Y3NyZl90b2tlbnxzOjY0OiI2MjY4YjI2YmUwYmE5OGRhNDJmNWZjM2QwZDQ1NzQzY2U4MjA4MTBkOWNjNzViYmFiMjUzZTRlOGIyMTVhNzk2Ijs=', 1780696099, NULL, '46.17.174.172', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:98.0) Gecko/20100101 Firefox/98.0'),
('2keob6o29is7mabmrerf74m709', '', 1778798898, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2kjgp72ahe76oifgjoen4bl3l8', 'Y3NyZl90b2tlbnxzOjY0OiJlZDhhMzczNGZjY2NmNDkzYWVkNzkwZTJjZGY4ODk5NGYwODE5YzgwMzVkMmU0OTQ2ODUzOWVmYzA3ODEzYWE2Ijs=', 1778901056, NULL, '66.249.79.5', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('2m0u926iguhpqf46h69oi5m92p', 'Y3NyZl90b2tlbnxzOjY0OiJmMjE5N2NjYjY2YjVhZjE5YWEwZjAyMjQ0YWM4ZTM4NTY4ZDNjNjk3ZTlmYmU2OTY2NDE4MjBmMGEyN2RhZGRjIjs=', 1779295069, NULL, '190.94.160.197', 'Mozilla/5.0 (Linux; Android 13; SM-A035M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36'),
('2nghrusi14u92epp9dvo2ijhn5', '', 1778798535, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2nn6mk62hkfnnsg8ikg49c60v2', '', 1778798806, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2nt0kj1agph2hdi0v1mkeocsv6', 'Y3NyZl90b2tlbnxzOjY0OiI1MGNjMjI5MTg4YzAzNWVhODdhZmM5NmQ1YWFlYjg5YTkxMjE4Yzk4NWRmOGRkYmM0OWQ1ZTVlZTdmNzNhYWRiIjs=', 1780783433, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('2nt3ubk5snea6ku6paive25dob', '', 1780783421, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('2o55lblmgt61eugb0u672a4opc', '', 1779405514, NULL, '35.209.102.135', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
('2opc8qeqlr16hvlo59gc72mggl', '', 1778798533, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2pfhblo682a9g1jvm143hl6ct3', '', 1780779366, NULL, '66.249.85.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('2pov2r440l3jdv2r1novifenr6', '', 1778798722, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2q6cg7d2j8t7860dscmhi1sp07', 'Y3NyZl90b2tlbnxzOjY0OiJlODI1NmQzYzVkMzE3YzVmMzNmZDk4MDk3YTY5MThjNTRmN2QzNDNhZDY2ZmNmYzg5MDNmNWQ2NGZmNGFkYzYyIjs=', 1780389359, NULL, '192.71.12.10', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Viewer/99.9.8853.8'),
('2q6p2oi2qah4q98irdpepgtoo0', '', 1779978253, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('2qebhfful2ichodd6gvhigjmcn', '', 1778798523, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2qmk0pld5gbtr3oq9fpuc4lte6', '', 1778799425, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2qo8krf3und1v8jcheka7290dc', '', 1780198325, NULL, '104.210.140.142', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('2quirqti40kfei29hsjjevdbgc', '', 1778799481, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2r1jmqdgqlke1ml22n52jqe0cu', '', 1778798530, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2r3vrd82okbkks3f2qvtnjd0av', 'Y3NyZl90b2tlbnxzOjY0OiJhNDVjZTBlYmIwNTFjYmM1OTE3Y2U5YzY0YjgxYmVmZWE4ZmI0OTNiYjVmZGNjZGIzOGRkODk4ZTEyMmIxODQ3Ijs=', 1780353864, NULL, '181.239.126.20', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36'),
('2r7upc70s758dmfjef90q1iejf', '', 1778799127, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2r81l3k8991q0umjq599ftrf6l', '', 1778798441, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2t1tc2viiph76js1e4o9hqqs5o', '', 1778799422, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2t2u9a40idpmsbdlg23qdbt41h', '', 1778799222, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2t5pkd5r0qdl90s9tsi4j2qvef', '', 1778799372, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2t9ihnb7eo4f90p1ikgn5m1ckd', '', 1778833236, NULL, '2a03:2880:f808:5::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('2tako38jr9dn21dmjubjn8qnf1', '', 1778798952, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2tgdu8ngld5liksnnkun0lbqo6', '', 1778799308, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2ufkgiaogp5nupdp0pq64akj3u', '', 1778799165, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('2v1udgl3rnckv247o02c1t04h7', '', 1778798649, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('303fc2pouvkd0k6gshptcjr2cd', '', 1778798837, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('30suj1tfe11ctn1r2sap3gjffh', 'Y3NyZl90b2tlbnxzOjY0OiI1ZmFiM2NlMDVhMzZlYWM4Njg2OTZjYzQwZTM0YjFjOGQ5NWFkMTc5ZTU5MDQ3NWJjNGFmOTM2ZTNlYjI1NjZiIjs=', 1779792314, NULL, '40.77.167.42', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('312augvj72i4oid5p1bg6gj3ms', '', 1778798451, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('31ta58j6npogi6eq9fo55gnk05', '', 1778798525, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('31u4fi6pqfuor0es88pmstjlto', '', 1778799186, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('328sunnnd7ortdqmh3175q7u8c', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (X11; Linux x86_64; rv:149.0) Gecko/20100101 Firefox/149.0'),
('32l62mipo11uvtkr0r7ld5aq1p', 'Y3NyZl90b2tlbnxzOjY0OiIzMDdiNmYzYzVkNjhiMTFkNjMzOGZhZmFhMDYxZjg0MTg0YzA4ZTMzNzZmOWMyOWNmNTczMjA5NWJiNDdkZjhjIjs=', 1780829267, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('32lm84pbutqkviv36baf1da8cr', '', 1778799318, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('33a7dtk73d0figvk95i31dulth', '', 1778798501, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('34a5ce99ukec1tupip8h9pg0hq', 'Y3NyZl90b2tlbnxzOjY0OiJhZWQwYjc3MWFiMDNlMGFmOTc1MDdjYzUyMWQyNGY4NDhkNTg0ZjJkNmFhMDVmZWUxNzdiZTZkMzMwNTg0M2VkIjs=', 1779887678, NULL, '2a03:2880:18ff:58::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('35lr8r80i8eg37u2k0osobgfqo', '', 1778799111, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('36073cge3ppeh4l35uie9mb57k', '', 1778799266, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('36hjobmbrnp3nku2np42u7r7db', '', 1779091877, NULL, '54.174.58.251', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('36u9vjafapr9rdiepio0capvm6', '', 1778799393, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('381eckritjovgibgqfbia8118v', '', 1778798902, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('38bjfuq7iga1jko3i8enqa5hrf', '', 1778798773, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('38dpolcgrc00o0q0gk9r08ljjh', '', 1778798892, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('38mdk972jncd2ar5pucqmt4f8j', '', 1778798536, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('397g2l2sb1d6t2v73s0stke7s9', '', 1778798745, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('39qc5i98d5fq5d79fg1n46ocqi', 'Y3NyZl90b2tlbnxzOjY0OiI0NGJjZGQwMmUyMDdmNmNmN2Y4NmU5M2VlYzVhNzRhMzQ1ZjIyYjE2MzBkY2FmNGUxNzI3ODMxZTRkYTUxMDA5Ijs=', 1779825911, NULL, '103.107.197.164', 'Mozilla/5.0 (X11; Linux i686; rv:114.0) Gecko/20100101 Firefox/114.0'),
('3ab20m28f3vjaerblabiptpn35', '', 1778798544, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3bqctjd8t3ro1v80or2s1144vt', 'Y3NyZl90b2tlbnxzOjY0OiJiYzY2Y2VhNDJlYTRhYTk2YzMzOTIzYWUyMmMwNjZjYTJiNGE0Y2ZlMWVjNDU4OTdmZjExZTM3MGVlMDc1Y2QyIjs=', 1779720373, NULL, '2a03:2880:24ff:7::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('3bveuhehl912864sh7t3f1p3mh', '', 1778798831, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3ctp15m4395lenkl50vhk6f3f5', '', 1778799216, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3d17l0ppalremkra8k4a04kpsg', '', 1778798786, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3dbanlijlgdlq69bcfkpvn2vam', '', 1778799277, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3dpfu3vsio04dk4cgv7islpd84', 'Y3NyZl90b2tlbnxzOjY0OiJiNzZhNjRmMjdjMzg4ZTQ4ZjhhMDhjNDc4MmQyYWQ3MDNiMDM5NTJmNmE4ZjgyOGQ2NTNlMTk3MzlmOTc0ZTg4Ijs=', 1779221291, NULL, '199.244.88.226', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36'),
('3eb92ct8o129nvdp4rapeubb87', 'Y3NyZl90b2tlbnxzOjY0OiI1M2QzZDQ5NGU0NzY4ODUyNzA4NjNkOGRkZTAzZjEwMjlmYWU1NzE3Mjg3NTgwZTljYThiZDE0NjgxZjIyYjgxIjs=', 1780821150, NULL, '23.27.145.196', 'Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0'),
('3egguneeultc47fem1is02olbv', '', 1778798466, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3ei72imn17dnc8rcmcf2teg47n', 'Y3NyZl90b2tlbnxzOjY0OiIwZmY5ODE5ZGZkMjdhYTI0OGY4NTlkYWUwYTU5NWU2ZjI2ZjIyYWM1Y2QyYTA3NDdjYjhiNDk5Mzc0N2M4ZDNlIjs=', 1779607386, NULL, '217.79.116.223', 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:114.0) Gecko/20100101 Firefox/114.0'),
('3f7rq4ncho0d4frfd450qp2srt', '', 1778798529, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3fbbuaagottdavh1g8sca50erq', 'Y3NyZl90b2tlbnxzOjY0OiJjM2ZhMzY4YWIzN2UxYWI3MTljYzk3ZDRjMzI3MWFhZWYwZTdhNTE3MDNhZDA3NTk0NjlhODZlZjdkZDIwNGFkIjs=', 1778898561, NULL, '52.167.144.235', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('3flc1o5bcgdtadqsvv9kthopig', 'Y3NyZl90b2tlbnxzOjY0OiI3NmVjZjMyYTExYmE0ZmI3Y2M0Yjk4OTQzZmFkNTRhMTdjZDI4YmFkMjEzZTNkYmE2NjRkNWZkNWY0MTQzMjFiIjs=', 1779755128, NULL, '40.77.167.30', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('3fomfa0i9uhsfqk32vago54upm', '', 1779084971, NULL, '168.144.101.16', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('3g16rscqli0bhas3m5ph6mplas', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0'),
('3h7e2r8qc5mjs34mi4fgp0k9io', '', 1779720243, NULL, '2a03:2880:18ff:1::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('3hu0fdfj1pksn82bgn7kc4i7gg', 'Y3NyZl90b2tlbnxzOjY0OiI2OGNhOWQ1MTExODRhMTUwN2M4NDU1MDVmYWQ1MjBkOTU0MTE4OGZkMjhlZTM5Yzg1YjI3OTA1NzYxNDVkYWQ4Ijs=', 1780702626, NULL, '66.249.79.131', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('3io93l3sajq5k5ki59kcd7pfn8', '', 1778798630, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3jgslb70pgagpb0c95ua7o9hgv', 'Y3NyZl90b2tlbnxzOjY0OiIyNWM0MDRlNGZkYjE2MzU3N2I0YTAxZWQ5MjlmMWI1MGJlMmZiYzhiYmMwMDY3YjAxYzYwNzM2OGY2NGU5ZjNmIjs=', 1779055543, NULL, '66.249.79.5', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('3jk76hndv4rbc5gh1u46u2bgc7', '', 1778799473, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3k9ptdooavm34hlqui4c57ucur', '', 1778799448, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3kfkc88s2c2hvsah4tj7lilojk', 'Y3NyZl90b2tlbnxzOjY0OiIwNjQxNTg2NDhjZmQ0MmE2YWY5ZTM3YTIyYmQ0ODA4ZTg5MWQzYzQxNzhkNzFjY2IwODAzZjgxZDg1Y2ZiMTNmIjs=', 1779205424, NULL, '40.77.167.150', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('3lkupbpn58rjefqqgiccj4fid4', '', 1778798785, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3lo3j0ujflvdb48689epo7eb9q', '', 1780518375, NULL, '2a02:4780:27:1682:0:3458:6c83:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('3ltdr2c8sb9qc0tq6kbr7o2m6r', '', 1778798761, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3mk4pj313idlmve503i95nr8ga', '', 1780612590, NULL, '66.249.79.134', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('3mvtsp23fso6r3sebk5rla2lnp', '', 1778799087, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3nmu3ornuijjr7iva3k6m2h7fp', '', 1779356025, NULL, '74.7.244.44', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('3orp8t8cf6939lmtjod2u49bo9', '', 1778799395, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3r4d17ev4ucjh3g13ooi7bskge', '', 1778932984, NULL, '74.7.241.176', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('3r678bbkvmmdotm8uuc302117m', '', 1778798909, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3rhm38c4i9nqgbfekghub8ah9m', '', 1780518375, NULL, '2a02:4780:27:1682:0:3458:6c83:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('3t3sfc79jqcmsp65l70i6lnf07', '', 1778798719, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3u063veecmsur93jj2defa75io', '', 1778798472, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('3u6iqt36kp0o88rnb5s1ccaof5', 'Y3NyZl90b2tlbnxzOjY0OiIxZmNhMTJhZDE3NzRhNjgxYzRhOWQwMTUxZmEzNzUxMWEzZTI3ODg0ODg1YTUyYzBjNmI1OWE4OWQ5MDE1NGViIjs=', 1780579462, NULL, '192.36.109.86', 'Mozilla/5.0 (Linux; Android 12; SAMSUNG SM-A415F) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/23.0 Chrome/115.0.0.0 Mobile Safari/537.3'),
('3v0356vbuius6rcl79d5tp0k0a', '', 1778868291, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36'),
('40dn634fo326048tujib6iv3fl', 'Y3NyZl90b2tlbnxzOjY0OiIzZDhiNmI5ZTdiZTU2YTgzOWYzYjQ0ZjVmNTgxYTAwMTgyODU3NTUxOTJhNTRjM2MwNjE1MjNkZWZmNGQ0N2E4Ijs=', 1780074834, NULL, '185.12.251.124', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.3'),
('40u47hkr1vagush7u3474meg9g', '', 1778868291, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0'),
('416skd5sgj28ff17837sjuulsi', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Mobile/15E148 Safari/604.1'),
('439h8hvmfs95825uouaroqska9', '', 1779866790, NULL, '74.7.244.19', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('43aaae5cailf6dfgevtj2jqfb6', 'Y3NyZl90b2tlbnxzOjY0OiJjNjJkZGM2NmQzYmEyYThkOGEyMTliYTc1YWIwZDQ1Y2JmMWEzNDM5YzU3OWVlZTRmNDY5NDVkNjI5MWFlZjAwIjs=', 1780074834, NULL, '5.133.192.203', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.3'),
('43pac1buh8j76fvtho78o87pgt', 'Y3NyZl90b2tlbnxzOjY0OiI3YmRhZWRkZDA0ZmFkNDkxNGYxOTZkZTBkZmJjOThlYmE3MWQzNGM4OGU1MGQxZWIwMjdmY2MzZWJmNGE2MzZkIjs=', 1780618763, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('44mli8cif1jb6517vrrheo1qda', '', 1778799445, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('44nva71lj6u9nhgt7mlrlrk54q', '', 1778798584, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('44p7sm57hhsnr9gkl964bc8ltm', '', 1779093181, NULL, '216.157.42.70', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('45md033sbolbdc1d07mf8ttcr9', '', 1780489157, NULL, '2a02:4780:6:1254:0:3166:f11d:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('45s8po35vpsasm1igccpr0kjiv', '', 1778798979, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('468kme2vm8dv2e1679uajb767d', '', 1780424449, NULL, '93.158.127.79', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.3'),
('46o810oc31p333shosann70bme', '', 1778798868, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('473nq8dpgvo750b4u89q5vm67m', '', 1778798882, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4a11ldc939qkese2hkerf54rj0', '', 1778799455, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4bo1mhhonseokkkkth4rheaur8', '', 1778798730, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4bup5dc2d2a6rqi3au1nnlebt8', '', 1780350580, NULL, '20.169.74.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'),
('4crr5cq2veqqvk2rdn6j8f8c25', 'Y3NyZl90b2tlbnxzOjY0OiJjNzA0ZjRjNjFlYjNkZDYxYzQyMzg3M2M3OGE0NjBkNDZmMTVkZWUwM2Q5NzVhODk2Mjg4MzAxZjdjZjJmYzQ5Ijs=', 1780773579, NULL, '139.167.79.64', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'),
('4dasre416f5uupuh84cj60eaag', 'Y3NyZl90b2tlbnxzOjY0OiI5MTJhOGNlZDdkYTAxZWM3Mzk4ODgzYjdjMTFjNWM5MGI5OWY3OTMwMTAzNmY0OWJkODE2NjNjMjU0ZTY1YTFmIjs=', 1779455873, NULL, '40.77.167.54', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('4dkkhdlikj6d3rle40kgvikea3', '', 1778798575, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4dl9f8cpitqvd18dnd7g0647jf', '', 1778799349, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4eahi63sp5avgpq4ea9urskhqa', 'Y3NyZl90b2tlbnxzOjY0OiJmNTk3OTJmMWY4OTYxNzAwM2JjNWQwMzYyYjg3ZjNhYjNmMDU0Y2FjYzIwNDY2NWU0ODg3MzdkZGU0ZGVlOWJkIjs=', 1779671336, NULL, '181.238.69.25', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36'),
('4env83b5dke52taljjg0a5bo25', '', 1778799172, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4es03r5j1a1e6f3pdra3mhfl6g', '', 1778798923, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4etclkiqjv001rerhc2rei6t64', 'Y3NyZl90b2tlbnxzOjY0OiJkODJmMTZkMDc0NDFjMGYwNjhjZjZhMjBjY2UxZGQxNTk4YTc5MTcyZjRhNmU2NjMzMzIxYjRhY2E0NjQwMDQ4Ijs=', 1779023617, NULL, '5.133.192.187', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Mobile/15E148 Safari/604'),
('4f0mi2futocaoo6psfkv15fr6a', 'Y3NyZl90b2tlbnxzOjY0OiIxODEyOTEyM2U1YTYwYjYzNGI1MWJhMjA0YmI0MDEwYTQ2OTZhMjM4MDMzNTNlZDIwZWJlZWUxNzY4OGJlZTc0Ijs=', 1779051347, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('4f0ubvsq0kg9hvietqf6doh0mv', '', 1778799217, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4f793gdk5udfjgoj8bfjl4p79a', '', 1778798506, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4ftomqj1voh5q0d19j0tfv92nj', '', 1778799047, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4i205hicbo3gdjfrhnvm0gh6tf', '', 1779162803, NULL, '40.77.167.181', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('4jte67gvmjamq1b3c5iduqrs49', '', 1778798606, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4kad33i23t6m8qc1ukaectjv33', '', 1780497501, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('4kd7frt460rb8f1g2jll0jvcv2', '', 1779032783, NULL, '198.244.183.89', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('4koc3l64c3etfjmgc9tl991bo2', '', 1778798604, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4lbfn759ndv60sr5jnqd2ttlmk', '', 1778799134, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4lfjjb0h9gc6r2g2tk02s647g0', '', 1778799224, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4ljd7dgm4jtap8kcfu733t3p2h', '', 1779093177, NULL, '216.157.42.92', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('4lsjhjua8jv5mts7eljfoed2v5', '', 1779384295, NULL, '74.7.241.176', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('4m5i1a70oihfep85t1qtp1lthn', '', 1778798456, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4mk7vep3gf926c5n8k8jukt3pc', '', 1779178099, NULL, '152.42.213.139', 'python-requests/2.27.1'),
('4n98hs8but7fkajqf7o4qe2hsp', '', 1779120124, NULL, '2a03:2880:f808:4::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('4njhigo1q3lhp7o3rlam8gthai', '', 1778798894, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4nr1us9tsb4i0uk09u1h1ihnc5', '', 1778798799, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4o4hrltpjunjtf7csunujf6b2i', '', 1778799034, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4p2bmsck4uno8k3tn3t583tadn', '', 1778799250, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4p2iofsonjnndbe72j5nfpej6b', '', 1778798438, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4prn8n87ghgh8vq12snmd9fllp', '', 1778799213, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4q3j0l48bonu8vv4hph1p8tqhg', '', 1778799001, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4qcq5jihs2gsh18f9qqe3tcv6c', 'Y3NyZl90b2tlbnxzOjY0OiJjN2Y1ZTllMjAyNGY4Yjg5YjhkN2Q1YjZmZWY2MzJhZWExN2NkNmVjYTdkYzQzY2IyNDgwZWM3YWZkMzMzNWEyIjs=', 1779769199, NULL, '2600:3c03::2000:3bff:fee4:37eb', 'RootEvidence/1.0'),
('4rfc0a7glqk3cvuqvceuf9nmdv', '', 1778798436, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4s4d5ft580ntu74a8fs21ta0ao', '', 1778798721, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4s76rs5uaag2s1ksfgsv97n6o5', '', 1778868291, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0'),
('4ssheqnmsm4i7i8c3htrs2p7k5', '', 1778799463, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('4t0q5l2dccjrbinldaps2s2ia4', '', 1779093270, NULL, '3.127.178.149', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)');
INSERT INTO `sessions` (`id`, `payload`, `last_activity`, `user_id`, `ip_address`, `user_agent`) VALUES
('4vrfi66hpre2h6019s6ea3e00l', 'Y3NyZl90b2tlbnxzOjY0OiI4Njk0M2EzYmE4OWFiMzg0MjAxMDVkMDYzZGU5NWYzZjFjZjJmYzE0NmUxYWU3ZTkwYzI2YjJmYmU2MzYxZTY1Ijs=', 1780272382, NULL, '66.249.79.132', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('502r66934m7h9ivvuurafpfl1u', 'Y3NyZl90b2tlbnxzOjY0OiJlMDM4ZDQ0ZmRkOTdjMDc5NmUyODNmOTI2Yjk1YTM2MTdmMmQ0MjZiY2Y3MmI1ZDE4MzhlMzZkYzAxYTE5ZjEzIjs=', 1780228311, NULL, '192.71.2.57', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123'),
('50dcfdtdfrem060smu7a00etns', 'Y3NyZl90b2tlbnxzOjY0OiIxMDA2MDYwODQ5NzU4NDE2MzQxMjI5NzU3NzQ3YTc1MjEyZGU3NTBhNzIzYWMyN2VhZmE0YzU1MDE1NmNmNWY2Ijs=', 1779295022, NULL, '181.177.20.133', 'Mozilla/5.0 (Linux; Android 16; SM-S711B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36'),
('50pm4c0kl13qbipg63k5c1ojkc', '', 1779044919, NULL, '74.7.241.176', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('50q6q58jajt7p21rm1saq08t6d', 'Y3NyZl90b2tlbnxzOjY0OiI5NjFkNWIxZWQ3YzZmZDQ3MTdlMmVkMzA3ZmZjMDE0NWM4YmVmOGQ3ZTViYzIyNDUzOTBhZGVjM2Q0OTI2ZGZlIjs=', 1780450853, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('52hdjtj5h8oroj181avjt6ft8p', '', 1778901053, NULL, '66.249.79.7', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('52qlsbipsti0bs64di3bmiosug', '', 1778799479, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('53h0kgsvr4lji6j0r4osue1f07', '', 1779852466, NULL, '5.39.1.226', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('56ic487691p3q9sr0lom4t339q', '', 1778799007, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('57at2nkr6j65ej6l7nrrf5pt96', '', 1780364223, NULL, '198.244.242.87', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('57hhrp1h9f0ncas8isjp5v37ot', '', 1778798628, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('57uutfs68cqru2gqedpu6psmpe', '', 1779051366, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('58hcqeip2lc0fptng6orclt2ov', '', 1778799366, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('58lekdrjqb42hkiqfk09kn5qq4', '', 1778799496, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('594l1li1igci6eo7grqkoad2ba', '', 1778798528, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('59m6ocinsb168n68upbj5i3v84', '', 1778798444, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('59quh3s2jjebbm306ei96e75gl', '', 1778798956, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('59vs87d66dqaqg7ddjhfm670hs', '', 1779091878, NULL, '54.174.58.251', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('5aseu0hage117evsp9sqgldta1', '', 1780423908, NULL, '52.167.144.55', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('5bi3mdie0431vpn1i1t5j540h5', '', 1778799169, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5c910h2a2lfep4bstgqoia75oc', '', 1778798955, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5cbjd31bpu214dourej8nbted1', '', 1780414321, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('5cbto867pt0b6855ihhnvgsnum', 'Y3NyZl90b2tlbnxzOjY0OiIwNDU0NzFmYzgxYTc5MTUyNmRmMjY4YTY1NTEwYTBlZDY5NWEyY2NmMTBlODdlZGJkZmU2YWU4MTMwNGI0NmM1Ijs=', 1778937583, NULL, '185.6.9.148', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.3'),
('5cmelii9piebednh4f2agugrvd', '', 1778798756, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5d298dngd5ght8bcvlc8rrkrpo', '', 1778798886, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5d8vv3oq4gebqkd701in0hv2f7', '', 1778798667, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5df5r69tbn4cns6vrrunaospd1', '', 1778798524, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5eb5q16esqvbi6c6gpm4decl7e', '', 1778798847, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5er16642jillfcvbsjpgb3o9n4', '', 1778799240, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5h3f84ji7fhf7q12bsi2tnnqie', '', 1780775863, NULL, '66.249.85.110', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('5h6utguqo0s7ea9oak3j50ae6p', '', 1778799480, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5he9kl9mjffa5er9lm14012dle', '', 1778799205, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5i046st3h7bu9bcjg41a00ka3s', '', 1779276796, NULL, '74.7.241.176', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('5ke297q83gdune8q6l9ij1ptn7', '', 1779093175, NULL, '18.193.15.23', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('5n4ebob30383nv808sjlkejr9p', 'Y3NyZl90b2tlbnxzOjY0OiJhYTUzNjAwYWI1YTJlOTJjNDM2YzY0ODRmZjk4M2QyNzE1MDE5YTM5YzA0N2YzNWRiNWM1ZWY4NDgyMDIxYzdmIjs=', 1780303454, NULL, '116.203.103.191', 'Mozilla/5.0 (compatible; DomainAnalyzer/1.0)'),
('5n9a6jojb8kuugk8mrmacvoo4o', '', 1778799377, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5obcc2o2kquk2ehcpvknqk6lgs', '', 1778798951, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5obl3hs9lg39as3pm345lmadjq', 'Y3NyZl90b2tlbnxzOjY0OiI5MDczMDY4MmNmMzBjOTZiYTE0YmEwYTA2MWFlYWVhZjE0NTFkNjIxYzQ2MDhhMWZkODc5ZjcxYjZkNzI5ZGIzIjs=', 1780416338, NULL, '200.49.93.243', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0'),
('5oellcsap2gm0s1d5fmt0pvuas', 'Y3NyZl90b2tlbnxzOjY0OiI5OGY1NWU2ZmNkMzhmNDBlNzRjNzYxY2ViNTYwZjZiNTk1YTZkNTE3M2I0NGZiODUyYzM0OWQ3N2I2ODUyYzc5Ijs=', 1779810356, NULL, '54.37.118.85', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('5q5n5h9r64qv8ditu6aijq744k', 'Y3NyZl90b2tlbnxzOjY0OiI5MDQ4MTQ3MjNmYjc5ZGViZWZjNDg3YTgyNDYwYWY1ZTFiOTk0N2U5YTJmMGZhZDdhMWNhMmE3ZTlkMGRiNmJiIjt1c2VyfGE6MTg6e3M6MjoiaWQiO2k6MTtzOjQ6InV1aWQiO3M6MzY6IjAzOWM3Yzk1LTA1NDEtMTFmMS05ZjBlLTA2ZWM4ZGZjNGI4MCI7czo0OiJuYW1lIjtzOjIzOiJBZG1pbmlzdHJhZG9yIERhdGEgV3lyZCI7czo1OiJlbWFpbCI7czoxODoiYWRtaW5AZGF0YXd5cmQuY29tIjtzOjU6InBob25lIjtzOjE1OiIrMSAyMzQgNTY3IDg5MDAiO3M6NzoiY29tcGFueSI7czo5OiJEYXRhIFd5cmQiO3M6MTc6InR3b19mYWN0b3Jfc2VjcmV0IjtOO3M6MTg6InR3b19mYWN0b3JfZW5hYmxlZCI7aTowO3M6NDoicm9sZSI7czo1OiJhZG1pbiI7czo2OiJhdmF0YXIiO047czo5OiJpc19hY3RpdmUiO2k6MTtzOjE3OiJlbWFpbF92ZXJpZmllZF9hdCI7czoxOToiMjAyNi0wMi0wOCAxOTo1Mzo0MSI7czoxNDoicmVtZW1iZXJfdG9rZW4iO047czoxMDoiY3JlYXRlZF9hdCI7czoxOToiMjAyNi0wMi0wOCAxOTo1Mzo0MSI7czoxMDoidXBkYXRlZF9hdCI7czoxOToiMjAyNi0wNi0wNyAxMToxMToyOSI7czoxMDoiZGVsZXRlZF9hdCI7TjtzOjEwOiJsZWFkX3Njb3JlIjtpOjA7czo5OiJ0ZW5hbnRfaWQiO2k6MTt9', 1780843301, 1, '2800:40:3a:bd0d:7c73:2852:5b03:276e', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36'),
('5qi0oaegrt84b331a5hrik0go0', '', 1778798708, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5r6sev4pv81j57kioa3ssd9edj', '', 1778798493, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5rbdguk3a5naeont1tnmg393ir', '', 1778798754, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5ri3ab7tbkto68e5dlc0feaf7i', 'Y3NyZl90b2tlbnxzOjY0OiJjMmZiYzY4MzllMmZhMmYwNTAxYjBhZWI3ZTkyZGM1MWE4YTJkNDJjNDVjMGQ4NjE3Nzg5NTEzZmU4NmExM2IyIjs=', 1779410390, NULL, '52.167.144.161', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('5rl02cal3l140ihoh4qu53t6mp', '', 1780702002, NULL, '66.249.79.132', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('5sscb05qg30pmfl2rhltgq6a5p', 'Y3NyZl90b2tlbnxzOjY0OiI2OGExY2VjNTNlOTMwZmMzOGQ0NDAyYWIyZjZiODdmZjY2NTQzYTg4ZDVhYWFkNWUyYWMxOWMyYWZjYjE4YTBjIjs=', 1779113398, NULL, '144.217.135.236', 'Mozilla/5.0 (compatible; Dataprovider.com)'),
('5t6u9357kqlg8h6aquq8b7m8bu', '', 1778798655, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5taon0a5aomi0vqf9fmj251ema', '', 1778798657, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('5v1233ng0jmoou12td0iqre21d', 'Y3NyZl90b2tlbnxzOjY0OiI1NTlhNGM3YTgxNTM2ZmU0NGU1NDA3YWU4YTU5MmI3YTYzNjc2NDU4NjJhMzk1ZTk0OWQyMzE3OGU0YjBiMmYwIjs=', 1779755595, NULL, '5.133.192.188', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('610kk0uuq78ebg147pg17f6a4t', '', 1778798949, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('62dm3ns2huj9cmsvsa1nrqhs2d', '', 1778799288, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('636lg3me6p5ppb6rlmpl7f6fpm', '', 1778798816, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('63cahrocnnd0nvimfhcrhbpfa7', 'Y3NyZl90b2tlbnxzOjY0OiJiOWNmMjUxYTA4NmYwMjM5NzNiMWIyNzQ1YTkyMjc0MGQzMDhlYzFkYjUwYWI2ZGJkN2FkMzkzM2QzNGE3Yzg4Ijs=', 1779006455, NULL, '193.32.248.249', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.13 Mobile/15E148 Safari/604.1'),
('63natgcl42fdnnj6ige1pd3ele', '', 1778799162, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('64qkn4uqbpega903vtgau6m6s7', 'Y3NyZl90b2tlbnxzOjY0OiJjZWY0OTA0NjIyZWFmM2Y1N2FjM2FlYzk5YzAzYjIxNTE4N2QyNTk3Njk0MThiOWIyZjEzMDc5OGE5NDlkZjgzIjs=', 1780064142, NULL, '34.70.247.20', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)'),
('6550idcmg99rfrevou3675mt95', '', 1778882416, NULL, '40.77.167.181', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('65e0b40k4ln78r1unnvhkeegpj', 'Y3NyZl90b2tlbnxzOjY0OiJjODRhYmNjY2M1NTM0ZDY4Yzk3NGUyM2U0MWQ5YzhmZjViNmQ2ZDk0YjI4OGZiNDI5MDQ1YzczNDI2NmRmODI3Ijs=', 1780223036, NULL, '34.118.35.22', 'Mozilla/5.0 (iPhone13,2; U; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/15E148 Safari/602.1'),
('6632gnj9q66r9969shv92vormo', '', 1779808231, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('667sp58t41vrfsg3ujshh5s441', 'Y3NyZl90b2tlbnxzOjY0OiJmZjBjY2Y5ODk2MzNmNTliYTNjN2VkYTA4ZDFmYmYwMDc0YTRmOWFiNWVkNzJlOWVlNGI4MGMwZDg0ZGQzY2VhIjs=', 1779671423, NULL, '181.238.69.25', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36'),
('66fkrr42mcpsltn9k1a4o2gclm', '', 1778799320, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('66ro45362025cm3lr9fn3cieoh', 'Y3NyZl90b2tlbnxzOjY0OiI2YmZmYmNkNzg1MTY1MzFmNmVlZmQzODY0MjY3NzVkYjhmNjhkYmI2OTg3MGJjZWExNTc0ZTUwMjAxYjE2ZjE3Ijs=', 1780534859, NULL, '2a01:239:4e9:ea00::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15'),
('69v76g2pl1l4ac915sjl80330s', 'Y3NyZl90b2tlbnxzOjY0OiIyNDE2NzM5MzQ0ZGY5NDY0ZTlhNWY3OTBhODZmNzMxMDkxYmQ5Nzk2NTZiMWQ1YjQwYzUzNmE1N2MwYTJmNzgzIjs=', 1780223130, NULL, '34.118.35.22', 'Mozilla/5.0 (iPhone13,2; U; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/15E148 Safari/602.1'),
('6aiff8c8lcltcr66mfj4ri3ud8', '', 1779158291, NULL, '104.210.140.143', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('6ak6rnlgfpnii00fnvgbiku0eb', '', 1779251712, NULL, '40.77.167.181', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('6bau6ilgtj7g0f81uec6fm667k', '', 1778798990, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6bcs96ngq9mhu4c2e29lvlcu21', 'Y3NyZl90b2tlbnxzOjY0OiJmMTI4M2M3NjI3NjRkZTIzZWJkZThhOTk5NDY5MGQwNzMwYWMzMDcyODhlZTk1NWRjMDAyYThhOGEzZjI5MzE4Ijs=', 1780328665, NULL, '35.255.218.255', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)'),
('6bdb9ri1vfm5oalnbtlct3nfvo', '', 1778799368, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6cljr5qshs5atfa3cmoidkeeke', '', 1778799010, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6cr5caa8ml3s55l478iu8no63u', '', 1778798734, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6csmvi3s5nsfusrpcre6p0e1g4', '', 1778799050, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6d9ljdsme11342cs3j08eqie5s', 'Y3NyZl90b2tlbnxzOjY0OiI2NGFiNTAwZGEyMTE2ZjliNjFjMWY0NzFhZjAyY2M3OWY1ZTkwMDllYjE4YjBmYzJmNmRkYzI5NDUxN2EyNTQ0Ijs=', 1779628523, NULL, '40.77.167.154', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('6egtk7j45fd2ibb2b0h32iro0d', '', 1778798615, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6fu0qj95l84nnjnjbv81vn4706', '', 1778798674, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6gnjvh4s00ledmc47ukhpfrisd', '', 1778799255, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6hd4g91t3q6egjo0dkp50hvlt1', '', 1778799144, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6i8u02k49b1vrme3o3qepf1kh6', 'Y3NyZl90b2tlbnxzOjY0OiIyZjg2YzhmYjYwZmU2YTVkZWQyMWRjYzgxOTA5M2ExMDAyNDcwMjg3ZjJkYzU1MmU3MzMxYjM3OTkxYmNhMTc5Ijs=', 1780579461, NULL, '192.36.109.129', 'Mozilla/5.0 (Linux; Android 12; SAMSUNG SM-A415F) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/23.0 Chrome/115.0.0.0 Mobile Safari/537.3'),
('6ikdluu3s9f36lemaj09siote3', '', 1778799227, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6j6qmjnbi5ao73opsla7m7ara6', '', 1778799398, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6jp1bbj5chofnphh2mamvg7bdr', '', 1778799400, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6l35dvcq7ig7gsi7d0p4e5om6s', '', 1778798723, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6lg7ldhgnsdbg6of299ve0jokq', '', 1778799332, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6lru3qirf37oh6k4dt5kn5djd1', '', 1778798538, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6mf7mh2bcp912emdc6uqd298uu', 'Y3NyZl90b2tlbnxzOjY0OiI1YzI5YmE3YjJhZTdlOWVkM2E0MmFhYjMyOTc4MWYyYTNlZjBlZWY1NmJhNzllNmE2ZjE3MjI3NTA5NTA3MWY4Ijs=', 1779337249, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('6o5v7gj1eb41vkia575nlsdf7n', '', 1778799031, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6obgfst2u86ibdoo7p8m15s3re', '', 1778798445, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6odlqoqlunhq14h9rd1vtm7h6d', 'Y3NyZl90b2tlbnxzOjY0OiI5OWMzZmU1ZjJiMGM1ZTk2NzQ3ZGZiNWQ5ZjlhMTk0MjA4Y2YxNjk1MzlhMDE3NmI2MTcyNzAyNjQ3NjQ2MWRlIjs=', 1779675174, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('6ok315rbqd86m5755vttt5es37', '', 1779113404, NULL, '144.217.135.236', 'Mozilla/5.0 (compatible; Dataprovider.com)'),
('6oudtjne5schsajsa9dg4o0v1j', '', 1778799128, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6p3ll71rfu7vvpun10kjcs7er2', 'Y3NyZl90b2tlbnxzOjY0OiI4YTU1NzEzYTdlNDVlNWE3ZjI0OTE2YWNkY2RlNWYyYjExM2QyNTIxNmFjYTBmNGI0MmEzZGJmNmRkOTY2MjA1Ijs=', 1779251713, NULL, '40.77.167.136', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('6ps84238v4be9bd0fta3a86uco', '', 1779890054, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('6qnh37ogcpi9t066ta06cmjohu', '', 1778798924, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6r7vr2379s3puh1gngubdrcj44', '', 1778798910, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6reeu5n4plp9b71ggfus1ipmj2', '', 1778798928, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6rpsg2a8d42actfnv0aksf13bp', '', 1778798865, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6rse2u7bucsmmot562aik17e8v', '', 1778799431, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6s7u8nn63092abtgqcqb4f8le3', '', 1778799305, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6sc9pr19ot6a235jimj0c8fliq', '', 1778798463, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6t38emv4ljf09h70qth2rg1svk', '', 1778799352, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6t4c52r9bca4v1s7a2gn8cfphm', '', 1778798758, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6uhr7685hrr4batdcj9hjnpbsl', '', 1778799113, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6upuo0tv3kjofgotgsus6td224', '', 1778799206, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6utlrp072tlaehikfq488c1phu', '', 1778799459, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6va3tk410llmh37j7p2ve0fo22', 'Y3NyZl90b2tlbnxzOjY0OiI0MmZiMWM2MTIxNjVlN2MzM2M2NDAxNDY4YWIwN2M0YzEyMmNmYzNjMTcxYzUwMDZhZTNlMjBhMTE5ODk4ZDM1Ijs=', 1779888442, NULL, '52.167.144.18', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('6vip3r8rl0su8lq34q1rhvakm3', '', 1778798994, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('6vq7n7pmb45t25gh43nub61ngh', '', 1778799478, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('701p8k71e44me774ahvmps25as', 'Y3NyZl90b2tlbnxzOjY0OiJlYWYzZjdiZTMwOTNiMjcyMzc2OTRjMDFkNTk1ZjUzY2I2OGE4Nzg4NzljMTdiNWEzYzgzYmNlMjdlNjY1YmI3Ijs=', 1780295985, NULL, '44.250.251.124', 'Mozilla/4.0 (compatible; MSIE 7.0b; Windows NT 5.1; FDM; .NET CLR 1.1.4322)'),
('70cbkqjg6jo0eo6cru5fqbiku3', '', 1778798457, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('70hqnsj94j5jk3jq5trpnonvo7', 'Y3NyZl90b2tlbnxzOjY0OiIzYTI2OWU5YTU4OGM5MDBmZjc1NGNlODgxYmRhMTIyNmM1OTI2ZjRmNGI1ZjUxOWE1ZmIwZWNjZWEwY2JjZGE4Ijs=', 1780400200, NULL, '159.223.122.137', 'Mozilla/5.0 (X11; Linux x86_64; rv:142.0) Gecko/20100101 Firefox/142.0'),
('70jgcek0btbn0hg5d942nlh6as', '', 1778799024, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('70k8r2glnemk08h5i1kh80lu9g', 'Y3NyZl90b2tlbnxzOjY0OiJjYzdjYzE3Yjk5NWQwYjBkMmZkZGFkZDA1MDFmZjQ0NjBiZjIzMGM1ZWM5MDY1NGExNGJiOGQzZDc5NDhlNWMwIjs=', 1779021155, NULL, '201.216.219.114', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.160 Mobile Safari/537.36 Instagram 429.1.0.44.70 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 968419384; IABMV/1)'),
('71pupbu94i31etghv7ko66lhbv', '', 1779051368, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('723v4spmni1ob047epkd04e6h7', '', 1780023268, NULL, '74.7.175.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('733jtq67ka99jl0olmhsk65dn4', '', 1778799328, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7357aondfsldtkqihcb3acv643', 'Y3NyZl90b2tlbnxzOjY0OiJkNDFhOGRkNzFhOTI2ZTE3OWQwNzA4NjczNzdkMzFkOTI1ODZjMDZmZWYyZmE0ODlkNDg3ZTFlMGE3ZTY2MzU4Ijs=', 1779295061, NULL, '181.106.69.138', 'Mozilla/5.0 (Linux; Android 16; SM-A065M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36'),
('73vnla8dh782ot5rs9blmromh3', 'Y3NyZl90b2tlbnxzOjY0OiI5OTNjNjQ2NzIyMDFhMDUyNWFjOWNiY2NjNGM1MWU4OGNjYjRjYTAyNzU3YjMxZjFhZTc3ZmUxYTljYjRjMzRhIjs=', 1779743367, NULL, '51.68.111.208', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('74kd7c4pig8mf15gpefn90ttou', '', 1778798987, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('74vc5j0sij11drek6vl117shsd', '', 1778799323, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('755bv8r960p7o04h3pekrf4aak', 'Y3NyZl90b2tlbnxzOjY0OiJhMmVjZTM4ZDM0OGQ2NGRlNTRkYTQyYWQ2MjZmMDcyMDBjMWY5NGVjMDk1YTk3NWMxODBkYzg1Mzk0NThlNWIzIjs=', 1779033588, NULL, '5.252.20.182', 'Mozilla/5.0 (compatible; SMARTSEO-checker/0.1; +https://smart-seo-tools.sbs/bot)'),
('75prrd07lbjgf7hhoo4lqiidte', 'Zmxhc2hfZXJyb3J8czo1MzoiQWNjZXNvIGRlbmVnYWRvLiBTZSByZXF1aWVyZW4gcGVybWlzb3MgZGUgQXVkaXRvcsOtYS4iOw==', 1780182890, NULL, '66.249.85.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('76fj0har7bicmm68mhhub7qp44', 'Y3NyZl90b2tlbnxzOjY0OiJmY2FkODg0N2EwOTI1YmRjOTY5MTJhM2I4NTllZmE4N2U2Yzg5NjBkM2I0NDdhNzBjNzk2ODdjMzAyMzgzNWY2Ijs=', 1780084555, NULL, '2800:2242:1040:43d7:108f:f335:50ea:2bf9', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.166 Mobile/15E148 Safari/604.1'),
('76s8mjlvape8amikhv9ror4b27', '', 1778799033, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('77jqfotc0br0bd1oig61vs2sop', '', 1778798537, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('78qhg9ruv1ahufnlm31qbopmff', '', 1778798631, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('78tavlt3te6dve0p3sku4qccdu', '', 1778799124, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('79798pda4s367umnc2i5mcscho', '', 1780195580, NULL, '2a02:4780:27:1279:0:3a0c:b695:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('7a84jpbv497rbbbk1hsndprg5j', 'Y3NyZl90b2tlbnxzOjY0OiJhZjU5NjAwMWEwY2YxMGE3YmE2MGViZTc2ZjNlYTcwYzEyMWI2Y2JkMTYyOTBkNTMwNzI5Zjk0MTAzZDIyZDZhIjs=', 1780702581, NULL, '66.249.79.133', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('7aic8flasbmiq04ks67hagdh75', '', 1778798744, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7aqp9t92rbl480ln6jq6nq98n9', 'Y3NyZl90b2tlbnxzOjY0OiIzNzcwZGEyZTk1MDliM2VmMDlhMjllMGE1OGRmMzk1NmZhOGI1MmZlN2JkNGIxYjE0YjNlMDRkOTVjOGY3ODMwIjs=', 1780329329, NULL, '34.70.11.76', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)'),
('7auvve71lh9ja9mb8gpq4u7p84', 'Y3NyZl90b2tlbnxzOjY0OiJkNjE4OWJmNmZhN2NhMjlhOGY5OThiMTA4ZDc2YzBhODI2NmU4YzI4NmU2OGI2YzBlMGQxNWVjNTAwMGUxZTQ2Ijs=', 1780364977, NULL, '52.167.144.175', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('7b1bmb99bm6ne9mbffd25vte6m', '', 1778798901, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7b360p6sq4nmt01nr7nfvor136', 'Y3NyZl90b2tlbnxzOjY0OiI1MDAzNGM2ZTZmNjI2MzJjMzAzMjBmNGVlMGRjNjVkYTIyNGYzNjMxMzU5NmNmNTA2NjcwYzA0OGVlZWRkYjBjIjs=', 1779741707, NULL, '217.79.116.205', 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Vivaldi/5.3.2679.68'),
('7bdqo50ufuvcjv01t84tfi84qu', 'Y3NyZl90b2tlbnxzOjY0OiI3MjI0OGY0YzMwOTUzMGU2NmZiM2E3ZmM5ZTI1MjE5ZTI3N2ZmZmJkMTAxYjI0NDA2N2M1ZTNlZjM2YTY1YWUyIjs=', 1779093201, NULL, '216.157.40.64', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('7bps0etidph81ou1k9j7k1kscg', '', 1779091877, NULL, '54.174.58.239', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('7bs6h5ciibnbj8u5utncg6dl1c', 'Y3NyZl90b2tlbnxzOjY0OiIyMmViMDllZWE4M2ViMTNkMjFkMmRkZTExOWU5MDJkOTNjN2UzMGE3Y2UxMjQzMWExNTIyMjM1YzBiZGVkYmU3Ijs=', 1779386290, NULL, '66.249.79.134', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('7coclukj1shhq6ela4a3vbfer4', '', 1778798458, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7dh1nu44f4deli3ja8nm2sei15', '', 1778798570, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7e1g4d6omvdm4i2qptb8rm3p3i', '', 1778798804, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7ekiuth8io21ih2v6gno7kisln', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('7fo40f2lhho6if20v909fk4dvv', '', 1778799358, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7fppddea972pkuvm7klhriji7b', '', 1778799339, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7frtkvfa5lva4sfe12pq4rekcg', '', 1778798947, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7gg5he5sesfguuin0v4njmj7pt', '', 1780590130, NULL, '52.167.144.59', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('7gqd3o5pu1bcqpc5sq6196hvgu', '', 1780483417, NULL, '2a02:4780:a:1756:0:fee:342e:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('7h7g6h93tb3qlnfdn85ktopfb9', '', 1778798999, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7hia0ojo4ppibjrq451402j1mb', '', 1780375462, NULL, '13.222.222.53', 'Mozilla/5.0'),
('7i6jqbm9f3e5b1sj8epkrkeevo', '', 1779502918, NULL, '74.7.175.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('7im4j1e8fm8qpelofmt74i8bqu', '', 1778798640, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7inp5lcnndjq3h9hlm23aqhlcq', '', 1778798916, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7j2tfqltilf4eumn71mnifng5k', 'Y3NyZl90b2tlbnxzOjY0OiIyMTVmOTU5NWQ0ZmYyYTM3ZjY2OGM0YWFlNTNiZmE3MjlmYjRkYjdhMzhhYjY5YmNkYzk1NWMyMDU1ZTAxZWEzIjs=', 1780775864, NULL, '66.249.85.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('7jvjpu9qeolp6jcfi5mi6asu77', '', 1778798572, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7khl4sgq809qr0k6r9polh6kni', '', 1778798978, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7kl3kbijj79fmi33ct0cjj2q9g', '', 1778798914, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7lqir7agefhe2gt7jp9vcl97nj', '', 1778799391, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7lt8f5g3kdjtvd0v1slbnmtjrq', '', 1778798634, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7me9avk5oabok4bg6ed893hnif', '', 1778798974, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7n0art7fol5ubnhnbslgumo48k', '', 1778798976, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7oa9j1rosfmb67dic6e8spcfoo', '', 1778798532, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7ogbph19qu7komm0us9o3p607t', '', 1778798621, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7pdfjtc2a8t87s6gh21mgkpqcb', '', 1778799344, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7r9od24la28f3p9o76p65b5dq6', '', 1778798693, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7rbf5olcnkk5ljv96oop7me721', '', 1778799364, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7rjuefek0bh6dr7rrcu2asp2qc', '', 1778972981, NULL, '74.7.244.44', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('7rlto1kv5hii1771err9aqrv69', 'Y3NyZl90b2tlbnxzOjY0OiI5ZTA3YjYwNDdlMDczZjVmZTQ3OGRiNGZjYzBlOTE3NmYwZGI3NmM3NGRhNmU5Mzc1N2Y1ODNkOTgxNDgwNDZiIjs=', 1778813928, NULL, '157.245.123.90', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('7rsj1v4i3g805kgkmhvorbo372', '', 1778799044, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7sc2gl30a9dk5jou8ngc6oo8s5', '', 1778799443, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7trqrj13k0i9sadkv30806cmaf', '', 1778798996, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7u6pk0voh6j5grj0rfinjnbfha', '', 1778798550, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('7v860gg8j9kaf2dmh37g1pv30b', 'Y3NyZl90b2tlbnxzOjY0OiJhMjhkODc3YmQxN2M0OTRiY2QyY2FjY2EzNzBkNWI4YjhmOGUyNGZmZDJhZmRmYmQwMTNjNjllOGY1M2Y0NTViIjs=', 1778809792, NULL, '13.250.145.97', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36'),
('805k2nqf1m0um36ij6tsls4sab', '', 1778799155, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('80le4eul5quovmflcjgkl871ms', 'Y3NyZl90b2tlbnxzOjY0OiIwNGEwYTU5YzNiYzViOTkwZTEzZTY2MjU3YTlkOGM1MDg0YTg5NGY5NzcwOTVjNjYzOWE1NDYyOGUwZWZiZmY4Ijs=', 1780783428, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('80ooagsmfo13pobmu9da77vmbk', '', 1779099306, NULL, '40.77.167.77', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('8218j934h3ls1839monhvgaiph', '', 1778798488, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('82h6ds7i18pcfgvkao1up288a3', 'Y3NyZl90b2tlbnxzOjY0OiI0NmIxOGNhMzM3YmU3MWMxZTFjMWI0ODcxNzRjNmEyZmNkNGNmNjg4YzA0NDZmOTUyNGQ3MGMyZjQwYWExN2FjIjs=', 1779387810, NULL, '66.249.79.132', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('82q0f6fkmq9kiut38kt7i6n3h2', '', 1778798792, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('83ba63eri2k093i80vkfkonl5n', 'Y3NyZl90b2tlbnxzOjY0OiIzMmQzZGQ5YjA5MWRlOGYyODMyN2U5NTMyMmYwZmZiZTY2ODVlYWIzMzc2OTlmZDVkZDk4YzBhNmIxOWU1NmI4Ijs=', 1778813928, NULL, '206.204.51.248', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('84dfk911ajpa0v6mthlrcui86b', 'Y3NyZl90b2tlbnxzOjY0OiI0NWYxNDE4MGU3NDBiMDA2ZjA0OGUxMzZhMDNiMzgyZTkyOGUyMmE1NGJhZTc4MzUzNzNkOTljMjgwNzQzMGIxIjs=', 1778802458, NULL, '34.92.128.213', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36'),
('84eijhmlqgeu6djsdti4l6i03o', '', 1778868291, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36'),
('85hk1tu5pql1kpi958a1r751jf', 'Y3NyZl90b2tlbnxzOjY0OiJiZTlkZTk5NjBmMDMyZTMwNDNkNzZiMDNjNDU2NjVjNzZmMzMxY2NkNTE4YWNkYzM3YmEwOGQ2NTEyMzc1YTYzIjs=', 1779051352, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('85nlrib04npfkdgtbpo93mp370', 'Y3NyZl90b2tlbnxzOjY0OiJhMjg0NTVkNTY3ODA2MjZmNDQ3NWM2OGJmNDYyNDU5ZmJjNjZkMjg0MjQ1ZWRhMjE5YTk2MjgxNDk3Yzc5ZDkwIjs=', 1779093150, NULL, '216.157.41.79', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('865pabii3844qfv7aagp00ougr', '', 1778798843, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('86e0dgn6afcrf4cfenjtit7d0s', '', 1778799278, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('86fnb7uftrj600rlhgegv1k3pd', '', 1778799130, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('87g9ate8kjs1js4pdlnho6ove7', '', 1778798601, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('87held83bg89j7hf0i91ec0eg4', '', 1779935661, NULL, '138.246.253.24', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.134 Safari/537.36'),
('87miah9ugsos2dh8dmc4ucg52k', '', 1778798833, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('87q15s890qap8r1m3cop7rgla2', 'Y3NyZl90b2tlbnxzOjY0OiJiMGYwMzNmZTljOTFiMmJiMWU1YTIzMDk1OWFjMTUyNTBkYzgxNGY2YTU0N2NlZDE2NjgwMDYyZGRjOTJmMjk0Ijs=', 1779405513, NULL, '35.209.102.135', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
('88td6cd57fl16i3oq2se8ii5bq', '', 1778799329, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('89ivikhp3jpbf3q2q1unhsuqfq', '', 1778799310, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8a6p7d25jr6g7rum56ipqqb2cv', 'Y3NyZl90b2tlbnxzOjY0OiIwMzgzMzEyYmMyYTljYmI3M2UxYzFiMWQ2OTNiODZmNzI3Mjc1MjdiMTk4ODljZjhiMjRmNjVlMWFhOWYwN2I0Ijt1c2VyfGE6MTg6e3M6MjoiaWQiO2k6MTtzOjQ6InV1aWQiO3M6MzY6IjAzOWM3Yzk1LTA1NDEtMTFmMS05ZjBlLTA2ZWM4ZGZjNGI4MCI7czo0OiJuYW1lIjtzOjIzOiJBZG1pbmlzdHJhZG9yIERhdGEgV3lyZCI7czo1OiJlbWFpbCI7czoxODoiYWRtaW5AZGF0YXd5cmQuY29tIjtzOjU6InBob25lIjtzOjE1OiIrMSAyMzQgNTY3IDg5MDAiO3M6NzoiY29tcGFueSI7czo5OiJEYXRhIFd5cmQiO3M6MTc6InR3b19mYWN0b3Jfc2VjcmV0IjtOO3M6MTg6InR3b19mYWN0b3JfZW5hYmxlZCI7aTowO3M6NDoicm9sZSI7czo1OiJhZG1pbiI7czo2OiJhdmF0YXIiO047czo5OiJpc19hY3RpdmUiO2k6MTtzOjE3OiJlbWFpbF92ZXJpZmllZF9hdCI7czoxOToiMjAyNi0wMi0wOCAxOTo1Mzo0MSI7czoxNDoicmVtZW1iZXJfdG9rZW4iO047czoxMDoiY3JlYXRlZF9hdCI7czoxOToiMjAyNi0wMi0wOCAxOTo1Mzo0MSI7czoxMDoidXBkYXRlZF9hdCI7czoxOToiMjAyNi0wNi0wMiAxMzowMzozMyI7czoxMDoiZGVsZXRlZF9hdCI7TjtzOjEwOiJsZWFkX3Njb3JlIjtpOjA7czo5OiJ0ZW5hbnRfaWQiO2k6MTt9', 1780772971, 1, '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
('8au5dalo53ubfld80ojvlo4ler', '', 1778799198, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8bf5a701geguk05m8netd9ea59', '', 1778798600, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8c77e1cfvn7qk99nqqaaaqmtg8', '', 1778799119, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8cf4817mh40inmsgjeail4aitb', '', 1778798516, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8cnieik3tsna89gtreer2l0iok', '', 1778799436, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8d7lh0llrqmalbv6t2o004eg2g', 'Y3NyZl90b2tlbnxzOjY0OiJhMmM2YzViMGIyNzU2N2NhNDIyMTFiNjYwODhmOTY4MGM4YThlZWNiZjlhYmM0OWYzNzgxMjFiOTA3YmUzNjAzIjs=', 1780779328, NULL, '66.249.85.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('8edv7g55kjkmfq4rltc0qikpkg', '', 1778799092, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8f0cp4pvhkqtq5j07r1h3hn2fk', '', 1778799230, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8g13fa8jtabeovrof8r6v71cia', '', 1778843232, NULL, '51.195.183.132', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('8g4ov99nltj5vimoekj2gbskru', 'Y3NyZl90b2tlbnxzOjY0OiJhMTRiODE1YWFjMmEyMGJlZWZiMTNjNDdhN2RhZmZjZTI3YWMxNjEwOTE2NGEyMzYyYzg5MjczNjc4ZDljYmZkIjs=', 1780301856, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('8gfjs218daa44u8v6afp1lufhq', 'Y3NyZl90b2tlbnxzOjY0OiJjY2QxNjE1NTQ4NTdhZGEwODU2N2VjMzAxYjhiNGE1ZDFkMTkwMDE5ZGVlZjc3NjE5OTc1MWIwOWQ3ZDE2MzQ5Ijs=', 1779720375, NULL, '2a03:2880:31ff:30::', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0'),
('8h99jrndr7tpibv8k6nk6rpht1', '', 1778799156, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8hbmgejok7ld6dfpsrvhclicfc', '', 1778798834, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8hn31tg2m33u9mii2n7hd9li1s', '', 1778799085, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8jlt0l1ucgr78ucq5s88a7d73i', '', 1778798573, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8jua3hhj53i4go41abci1gpos0', 'Y3NyZl90b2tlbnxzOjY0OiI0M2VmOTAwZTA3OTIyMjk2MzQ5ZTlkZjZmMDA4NmRlNDNmMTZlNTA4NDE4MDlkNzU4YmNjMzM5MTc3ZWY2ZmEzIjs=', 1780389359, NULL, '192.71.142.40', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Viewer/99.9.8853.8'),
('8l2kc916m9d61nfei7ph2ngjj6', '', 1778799139, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8lc17bs8schjia3nim5r95nl11', '', 1778798478, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8li6l6mad9vs19lvq13pccq5p1', '', 1780340657, NULL, '104.210.140.136', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('8m4oh394diak6jjll8s2j6p250', '', 1778798441, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8me2k6t4jlm85hvn39cenmf5h7', 'Y3NyZl90b2tlbnxzOjY0OiIwMzFjNmNjMGU1YzFiZjlmNWQ2ZWZhYjMxYzYxM2U1YmZhOTlhZTU3NGFiYjI2ZDg4ZDhiMTI2MmZkYWFjNzRhIjs=', 1779113392, NULL, '149.56.150.167', 'Mozilla/5.0 (compatible; Dataprovider.com)'),
('8mtnm7jnto4hodkpksd6vl3mbt', '', 1778798839, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8nb0ghghapf8hf1q54ilnrepbb', '', 1778798876, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8pdl8fe794vcvi74mlglq45r12', '', 1778799105, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8qm5ks776590dlgb969afik1on', '', 1778799304, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8rl7q3bcj7m854radail97ra63', '', 1778799427, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8s3e1mpjvij4il7vcpbj0fir2a', 'Y3NyZl90b2tlbnxzOjY0OiJlNzk5MTM2OGQ5NWM1YTFlMTNhNTkyMTBiNjNhMWFmYjZlNzk4ZTA1MzI5NTE1YmUzOGJlMmNlN2NkYzc0MTBiIjs=', 1780235534, NULL, '40.77.167.53', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('8s6drnsjkeqvsjs9aip3sgt0u2', '', 1778799462, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8ssfiurf48n7r7q4qlse8q4iku', '', 1779051369, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('8su120du007gsvbjtbcmir4i78', '', 1778798930, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8tm9he61np19ofjb37b4aog93h', '', 1778799164, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8u830g58fd00vbj4a41vdb7925', '', 1778798954, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('8uu5772b6bbghd555b16vq5482', '', 1778798652, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('90dc2d36bn6pjdmr6n8jam221n', '', 1779532538, NULL, '34.31.126.2', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36'),
('90ofibbe14ksh5no2e1pqrudjs', '', 1779051368, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('91n0s4notefp5ivf07fvjahcqr', '', 1778798596, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9258m645tgih6g5avm6ls43bj1', '', 1778798439, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('93as24da2tt5i4cn8hn8odoilp', '', 1779051354, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('93j913bspab7gpc6h1ibla3lp6', 'Y3NyZl90b2tlbnxzOjY0OiI4NTgwNGRiNzBiMmMxMDU2OTQ5NzgwY2VhNzRhZTUwYzZmZGM0NTcxZTY0M2ViOWE4NjY0NjliNjlkOWFjZGM0Ijs=', 1778813928, NULL, '167.172.27.189', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('93lvikktbo9jigsb79vqhu4cct', '', 1779505441, NULL, '104.210.140.130', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('93tk3hsqirie0j48rq3j43njem', 'Y3NyZl90b2tlbnxzOjY0OiI2NmYwNTc1NGM2MzhkNzUzMWUzZDg2ZDJiNTZlNTIyNDAyOWRkODNjODczOWNlMGFiMDIwN2M1YjU3OGRlZWJiIjs=', 1779715758, NULL, '52.167.144.217', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('9400io36kjcspk8pqold26knfi', '', 1780783418, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('943gjet3m1vicosmnf96ki1e9d', '', 1780783424, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('94ela4k10fgijbmpthko81a8k1', '', 1778798633, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('951535sfg75tn3frabirn6hve5', '', 1778799484, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('956hodmnoaboff4fgnorts3292', 'Y3NyZl90b2tlbnxzOjY0OiI0MjZmMzNkYzlmMjVhMDg2ZWU4NDEwN2FkNjdjZjYwZmJhNWFkZWU3NDY2NTE3NmZjMDYzOWJjYzdlNTlhMmE0Ijs=', 1779556669, NULL, '186.157.53.40', 'WhatsApp/2.23.20.0'),
('9574p0njt48vvnp6299gbdub9t', '', 1778798645, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('95llkptf0k62dko2a4dvtqrmvo', '', 1778799218, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('962l1sbp76tvt36li1lu54p72c', 'Y3NyZl90b2tlbnxzOjY0OiJiMTg4ZjQwZDEzZDEyNWYyMzNlMDUxN2I3N2EwOWZiYjMyNmRjNTIxMjMxNDUzM2E3MjkyZTQ3YmM5YThiYTk2Ijs=', 1779532537, NULL, '34.31.126.2', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36'),
('963p4114rojgn47mnhfnh1u9ko', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:150.0) Gecko/20100101 Firefox/150.0'),
('966oug5arolbaip1qmu64975s1', '', 1780518342, NULL, '2a02:4780:27:1682:0:3458:6c83:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('96sr3fhv4tscik80pf22al4f8u', '', 1778799089, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('96vnhg3n4cq3tef4emuhhnmgqd', 'Y3NyZl90b2tlbnxzOjY0OiI1NTRjNWFlOTc5MzllMWE1MWUyMGFjMjQxYWVmYjUzN2MwZjlhZGIyYmIzYTg2NDg1MjMyY2JiMjc5MWYyZjc2Ijs=', 1780223042, NULL, '34.118.23.107', 'Mozilla/5.0 (iPhone13,2; U; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/15E148 Safari/602.1'),
('9af3kj0h161n5hdiklk5532qbv', '', 1779426932, NULL, '40.77.167.18', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('9akiqdnb7851fvfhddcn7pbf6a', '', 1778798579, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9al2917nqemjh8hrv714nibd4i', '', 1778799048, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9av2q8d2aq38gftfehmvh5qknh', 'Y3NyZl90b2tlbnxzOjY0OiJmN2I4YzNlNjY3ZTI2ZGU1MThlZjBkZTM0MjBjNjc0NzdhMTI3NTkyOWEyOWIwMDI3OWRmNTNmOTkxZmVmNWQ4Ijs=', 1780190051, NULL, '40.77.167.20', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('9bgtgudr4i6me4h5q0dknra80q', 'Y3NyZl90b2tlbnxzOjY0OiJkMDI0ZjY2YzA1OWMzMDRkY2QxMTcwZTVhYzdlOTkyMThhODEyYmM2ODQ1NWE3Yzk4NzFiYzE5OTYwYjAxNmE3Ijs=', 1779949013, NULL, '34.122.242.249', 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2224.3 Safari/537.36'),
('9brb4uqcdphv8dpcbmct49qtvv', '', 1778799039, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36');
INSERT INTO `sessions` (`id`, `payload`, `last_activity`, `user_id`, `ip_address`, `user_agent`) VALUES
('9ckp74o8dagmnfhlativ07gqh1', '', 1778798610, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9d0jm355mshjtv14tjienbouk1', '', 1779961901, NULL, '2a03:2880:3ff:4::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('9d0nat6lpg4grcuk4rkhk36jhq', '', 1779051372, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('9d0su3rbs3b3uqtgv69pbq82q1', '', 1778799004, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9dl4fcldp9punhts65edbp1nnv', '', 1778798972, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9eb2ssrngi79d0k88utac56016', '', 1778799070, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9eqvd9h1g613j4275d3rt9vuun', '', 1778798437, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9fi5jvcoc5beh71bkn7qgcuokq', '', 1778798519, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9fnnhu6da5ghkpig3ubrs9feud', '', 1778798646, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9gln861khbp2rlghsm7j6m9vke', '', 1780038371, NULL, '2a03:2880:16ff:4d::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('9i0c6k370b31ioetfs6julcueq', '', 1778798718, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9ik1udjuu6qnimevuerrhfrbn1', '', 1778798789, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9jie3jhvr7genco9l1o75b9evg', '', 1780331217, NULL, '51.75.236.144', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('9k6inohr13volangiuirr0sk2p', '', 1778798750, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9k8lcfnnhbt87j6avneqqdsir0', '', 1778798430, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9ka55c6epanbiiu0ietfo0lok2', '', 1778798465, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9kqhile5bt11bgbhh67imopebm', '', 1779296175, NULL, '104.210.140.142', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('9ljfu48l0lv2d2q5b87gep76tt', '', 1778798521, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9mn56sg16rsejhcm4ls2di33u0', '', 1778799132, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9nme8f9dutlv49vh5b23pd4qtk', '', 1780629254, NULL, '104.210.140.135', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('9o0il22brfllhjtv6s1cjvk1c3', '', 1780483417, NULL, '2a02:4780:a:1756:0:fee:342e:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('9ogactbm7ubnbrcpi6q7hfo9hc', '', 1778799495, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9pbdpdk0hoq78fvqlhklf8cp80', '', 1778798879, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9rmp71jrfmngc9ve1gbp4n0eam', 'Y3NyZl90b2tlbnxzOjY0OiJmNWNiNTllMTBjODNkMTkzMWMyYzVjZjNjNjdmMGFjYWRhZWRjNGIzNjI0NDc2MWUyNGI0NzQ1ZDg1ZjUyMDBkIjs=', 1779406572, NULL, '40.77.167.152', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('9sa5qrhf7pb9uo8n98hn75msj5', '', 1778799418, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9sl2opanhjs8ibu3bcvuo5a6dt', 'Y3NyZl90b2tlbnxzOjY0OiJkZmUzYjQ4NWJlMzNlM2Q5ZDFlNGVkOTRkZjExNDg3MDVlYzMzNjgyMjJkYzY5NjJlNzM5NjRlMDJlY2MyNjJkIjs=', 1780563919, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('9tde0au2hbko5g2oj5aad2fbm0', '', 1779093148, NULL, '216.157.41.71', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('9um35rf3u8pq6fgpreg94kqnr0', 'Y3NyZl90b2tlbnxzOjY0OiIyNzE5MGYzMmFjMGNlZGZmOTkxMTQ3YjhiMDYzMWNmOTQ0Zjg1OTMzNmI1MzEyYzk1MTY0ZWJhYzU0YTJkMzdlIjs=', 1778928322, NULL, '198.244.226.74', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('9ura92cmnth59q4228jndcv99k', '', 1778799325, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9uu0ljfhvncs60vvs8nkootg49', 'Y3NyZl90b2tlbnxzOjY0OiJlMjI4ZTE5NGU1OTUyNjVjOWUwYzhkYjRhYzVkZDU5OWZkZWE1NDMxN2RhNjdlMDUzZThjZjU4NTQ0YzJhOTM1Ijt1c2VyfGE6MTg6e3M6MjoiaWQiO2k6MTtzOjQ6InV1aWQiO3M6MzY6IjAzOWM3Yzk1LTA1NDEtMTFmMS05ZjBlLTA2ZWM4ZGZjNGI4MCI7czo0OiJuYW1lIjtzOjIzOiJBZG1pbmlzdHJhZG9yIERhdGEgV3lyZCI7czo1OiJlbWFpbCI7czoxODoiYWRtaW5AZGF0YXd5cmQuY29tIjtzOjU6InBob25lIjtzOjE1OiIrMSAyMzQgNTY3IDg5MDAiO3M6NzoiY29tcGFueSI7czo5OiJEYXRhIFd5cmQiO3M6MTc6InR3b19mYWN0b3Jfc2VjcmV0IjtOO3M6MTg6InR3b19mYWN0b3JfZW5hYmxlZCI7aTowO3M6NDoicm9sZSI7czo1OiJhZG1pbiI7czo2OiJhdmF0YXIiO047czo5OiJpc19hY3RpdmUiO2k6MTtzOjE3OiJlbWFpbF92ZXJpZmllZF9hdCI7czoxOToiMjAyNi0wMi0wOCAxOTo1Mzo0MSI7czoxNDoicmVtZW1iZXJfdG9rZW4iO047czoxMDoiY3JlYXRlZF9hdCI7czoxOToiMjAyNi0wMi0wOCAxOTo1Mzo0MSI7czoxMDoidXBkYXRlZF9hdCI7czoxOToiMjAyNi0wNS0wNyAxMTo0Mjo1NyI7czoxMDoiZGVsZXRlZF9hdCI7TjtzOjEwOiJsZWFkX3Njb3JlIjtpOjA7czo5OiJ0ZW5hbnRfaWQiO2k6MTt9', 1778975429, 1, '201.216.219.114', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0'),
('9vec7j729p85nqta0hacb08uoo', '', 1778798966, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('9vssputgm9gdbloos1ts2bicv0', '', 1778798511, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('a1dd55hmsam857b8958ag59nnq', '', 1778799154, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('a1g5j0js0u3c015h12rb6ptius', 'Y3NyZl90b2tlbnxzOjY0OiJmYjE5NjE5OGNiMzY5ZjVmNTljYjc2OTYzOTFhYjRlY2I2NzFjNzQ4NzU1Yzk0MTE0OWNiNTJmMTg4OTc0YzJiIjs=', 1779807809, NULL, '158.173.156.16', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'),
('a1qcaj4l13vgpivmojoksoa2kr', '', 1778799137, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('a1tqditjj6lgkbg4vtpqqll8i6', '', 1780783426, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('a35d96i6m5v55ecodmp2nihihp', '', 1778799404, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('a3ocjpq2l0q1fr9tf8kip7ca17', '', 1778798943, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('a478nd1fsdtpgr3bbfeusmt1fl', '', 1779093175, NULL, '18.159.199.77', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('a48i5cf5vapnnhseg8jqnr2uc0', '', 1778799211, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('a4dckfv5b1dna4eq9homh5u1vq', '', 1778798966, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('a4k5t919lpaudrkg8f56udnd03', '', 1778799280, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('a6849i1a23l6p2g72j8p78md02', 'Y3NyZl90b2tlbnxzOjY0OiI5NDMxMmNmZGIxNWFjZTM3NzFhYzUwNzUxOTExNzZmYTRmZmU1NjM3YzE5NTM4NTIyMjFiOGU3MzExYzgwMDQ4Ijs=', 1779532539, NULL, '34.31.126.2', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36'),
('a68kmgmuth11jrdaoiog039c4q', 'Y3NyZl90b2tlbnxzOjY0OiI5OGYzOTg1YzM4Yzk3M2MyMDdhYTE0MmMwZGIxNTAxNjJiYThkMzg4NjUxMmI2MmI4OTRjMzQ1YjRmNDRlMTVhIjs=', 1778939783, NULL, '188.166.117.11', 'Mozilla/5.0 (X11; Linux x86_64; rv:142.0) Gecko/20100101 Firefox/142.0'),
('a8g78bsfom3oje9u3rh4fr9qo9', 'Y3NyZl90b2tlbnxzOjY0OiJlMzA0YWViOTdiNzgxOTFjZGY4OWZjN2MwY2ViMmRhNTY0Yjc5MzM3MDE0OGZhNmRlNDAyMDBkYzU1NDk1OWQwIjs=', 1779296259, NULL, '46.17.174.172', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:98.0) Gecko/20100101 Firefox/98.0'),
('a97o917v5f48rta7l0pia5gd2e', '', 1778799416, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('a9hih0l6g2k53baiprlppd6erb', '', 1779009932, NULL, '2a03:2880:10ff:72::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('a9roipue22pffa7egelubd7nop', '', 1778798811, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('a9snt6grbsu29ff56vlkcnt28e', '', 1778799439, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('aai4ap3hm3fnvs6teobdoithj2', '', 1778798689, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ab9hcsee4smj0imq5jsbqassr7', '', 1778799494, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('abpqe17lrfnhu086b4kmc7l7ds', '', 1779233616, NULL, '2a02:c207:2324:3159::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:133.0) Gecko/20100101 Firefox/133.0'),
('ac2qshi3d47g11pjsnh00i1ilp', '', 1778798614, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ac6oqrhndtbdma3odhm2ufaitp', '', 1778798960, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('acceo1pjcn50i4u1ud7gl5foce', '', 1780417669, NULL, '52.167.144.55', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('aci5rqtb5lvgfn3cg7qc4urfsm', '', 1778798564, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ad1dfc86h9kdc4je3f7j8q038s', 'Y3NyZl90b2tlbnxzOjY0OiI4ZDg1ZTgzMDczOTgwMGZjNzE0YTZlMWNhYmRjMjgwYzY1ZjU3MzdmZWM2Y2QxMWNkMTQ0MDQ0NjhlNDBiYWJjIjs=', 1778985866, NULL, '51.68.111.209', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('ad2mjeeii7f50llk48fcpcvr79', 'Y3NyZl90b2tlbnxzOjY0OiIyZDhmODExY2I2NDEwZGZhMmM2OTExODY5NDk5NGZlYjI5MjNiYTU2NzExMWE5MmY1OTdhMTU1MGUxNzg3ZjNjIjs=', 1778868311, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36'),
('adchg38i7mjkmjqadoam71ckeo', 'Y3NyZl90b2tlbnxzOjY0OiIzMjk4ZDdkNjE3NGFlYjZkNDdhOWZkN2ZhOGVkZDAxNTA0NGQwYWMxOWU1Y2ZhMTU4MzMyM2YwYjhhN2ViMmVkIjs=', 1780062294, NULL, '93.158.90.73', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Mobile/15E148 Safari/604'),
('ae081lho0q14978e1onbnrh54r', '', 1778798738, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('aeqdldpk4indm3re3u2bip6var', '', 1779225381, NULL, '104.210.140.130', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('afom47j5hnagobsumoskv56usi', '', 1778799023, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ah5uhlpecer1apdq42gngktfah', '', 1780418717, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('ai7g730mimapflaaq4ubujb8h2', '', 1778798848, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('akec5njhe4q25822ucjlo9nk12', '', 1778798720, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('akpqdb345h537mccln04cr6sl8', '', 1778798685, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('aksp6slq44hht6qvt20fdm9b5a', '', 1778799188, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('al7ga32ftra200jps8ojtpe67b', '', 1778798765, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('am4aagdldt9410s40hvs7f9pgj', '', 1778799380, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('amti2vt715jpm3ok9sgq0k345g', 'Y3NyZl90b2tlbnxzOjY0OiJiZjhmNGZkYTUzMmJkOWRkZmI3MTA1NTg1N2QzYjRjMTE4YzljMzgyMTc4YjdjNGJjZjU2ZGQxYjRhN2QxNzIwIjs=', 1779161080, NULL, '51.68.111.203', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('ao11p5pc4akp33qlth86gv1anr', 'Y3NyZl90b2tlbnxzOjY0OiI3NGE4YTQ2ZTA1NGFmOGU1ZDg5Nzg4YTI0OGMwNmIyMTc5Y2M1NjU3NzU0ZjkyN2ZlNzY4NDcwMDYyNmExMWFmIjs=', 1779046686, NULL, '104.223.62.130', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36 Edg/104.0.1293.47'),
('aougv5vjbop7n8vknv0vc27er5', '', 1778798918, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('apko9jpm929bum7hssklnqb41k', 'Y3NyZl90b2tlbnxzOjY0OiI3ZTFiZDE3YjRmZmQ1MzcxODc4ZmE5NDYwMzk2MTJjZTgyYWM1ZDk2OGNkM2E3MjQ5ZTM2ODk1MTg3OTkzZGMyIjs=', 1779220476, NULL, '51.68.111.208', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('aq2tqor0bifr91v2re037ie49p', '', 1778798701, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('aq6ujgaokc39ia5napafq5u6us', '', 1780195580, NULL, '2a02:4780:27:1279:0:3a0c:b695:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('aqek08p5csfmtts7hj13or59i5', 'Y3NyZl90b2tlbnxzOjY0OiJkNzg2OGY4NWQwZGI4YmI5MzQ1ZGI4M2RkOTZhMzdiYTkzNWU5NGVlNWZiNzZlNzdkMWU1YjdhYWQ3N2IyNGJmIjs=', 1779005618, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('ar3qtde103hdepnok3sd0qsg4u', '', 1778798746, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('arbedei7l7168h2us7fhncrf48', '', 1778798855, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('as0mv2q35tuu9i7mdq86g7scj5', 'Zmxhc2hfZXJyb3J8czo1ODoiQWNjZXNvIGRlbmVnYWRvLiBTZSByZXF1aWVyZW4gcGVybWlzb3MgZGUgRW1haWwgTWFya2V0aW5nLiI7', 1780775863, NULL, '66.249.85.110', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('asd56m3to0nv1ski22pv109apb', '', 1778798844, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('aseb7luufmkjph0hqsiqlmkbqj', '', 1778798823, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('asugg5udsnoke6jai62ueb3b47', '', 1778798767, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('at69rm65ddu8ph62jl7l2sv48v', 'Y3NyZl90b2tlbnxzOjY0OiJiOTliYzU0YmUwZjdhNDM2ZTJhZTk1ZTVjYmQ3N2EyMGIyYzBlODU2OWIwNmQzYjUwZjZmYzdmZmU0ZmIwMGMzIjs=', 1779477115, NULL, '192.71.126.26', 'Mozilla/5.0 (Linux; Android 12; SAMSUNG SM-A415F) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/23.0 Chrome/115.0.0.0 Mobile Safari/537.3'),
('atesgote8ohu7ospvn9pccj6bb', '', 1778798828, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('atifa8i8bdqfajf82mcvt4s714', 'Y3NyZl90b2tlbnxzOjY0OiI2YzNhODljODE5YmJhYzUzOGFlYjM0MGY3Y2U1MzUyYTViNTVhN2UxNDg4NzRkNzc0YWE1MTIzZGE0MDQ0OTBmIjs=', 1779261851, NULL, '66.249.79.133', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; GoogleOther)'),
('aucllrknn8a7fjv608snl5kmv5', 'Y3NyZl90b2tlbnxzOjY0OiIwOTYxZTEyYjQ2MjYzNzliYjJkN2QyZTczOWFlMmViNGQzMGVlZmIwMzUyYmE1YWQwZmNmMzk1OTAyMmFiZjAxIjs=', 1779572981, NULL, '62.210.122.147', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36'),
('aupqlqkdau2tqeihrgcq65b64b', '', 1778799481, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('b08iq52h3tap8r49rvd69g8k9v', 'Y3NyZl90b2tlbnxzOjY0OiIzODNmOWU2ODBkNDk3MmUyZTg3MzhhOTZiM2I1ZDIzMjFlMWZkOTFjYzU2YjhjMjY2Njg4Y2NhOWEwY2U1YTNkIjs=', 1780783421, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('b0a5h0d6paugrjdhpi60uo0cqr', '', 1778798980, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('b0tmaq89elghvvn2fcft5kn8ls', 'Y3NyZl90b2tlbnxzOjY0OiIwNzAxYzE4M2MzYTRlMzBjZjYxYWM2YmNjODU5NTQ4ZDI3ZTA0YWNiNjc4MjMyMTczMmY4Y2RiNzE1MTI5YzVmIjs=', 1780064856, NULL, '35.232.90.160', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)'),
('b11aqalrepa6avfdi316s6u3fs', '', 1778799152, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('b3insld79hb77rbe2m7ki2vpqu', 'Y3NyZl90b2tlbnxzOjY0OiI2NzBjNmU5MGJjZDNjNzlmMTcyYTgyZGMwMzhiYzU4ZGJkMmY4Mzg1ODEzYTgwNzUyMTk0ODdhM2E4MmI3YzFkIjs=', 1779864822, NULL, '35.209.68.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36'),
('b3ol4ja5q1ikgrrc17sij68vbr', '', 1778799372, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('b40tfc77moas0epgbuhr07v0j0', 'Y3NyZl90b2tlbnxzOjY0OiJhNmNlM2JiZDljODRiZjc5YzlmYjBkNDQ0YzAyMzMwYjljN2M3YzFjMDEzZTEyODdmMzk4YmE5Y2Y2ZTJmYTJhIjs=', 1780223109, NULL, '34.118.23.107', 'Mozilla/5.0 (iPhone13,2; U; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/15E148 Safari/602.1'),
('b48b8a1ua1dos0ido8dlspspp3', '', 1779044731, NULL, '2a03:2880:f808:17::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('b4dqqjivu940ku8l3ft7j061hl', '', 1778798578, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('b4eppcv9gcjllspdfsqg77v99i', '', 1778799002, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('b4g203c5kf1vurc0ovn24o7tpf', '', 1778798791, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('b58m306sajnic2n2vblad7ms2p', '', 1778798433, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('b5dcpvuuhtval9q2ovtdh4etfh', 'Y3NyZl90b2tlbnxzOjY0OiI2NzZkZjc3NmFlNWM2YzNmMDNmYmM2ZjUzNDY5OGQ4Y2NmZTBjYzc4MDA1NWIwNGU3YTRmM2I5MjVhMzczNTM5Ijs=', 1779316044, NULL, '51.68.111.218', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('b77v8nib7ife0tvc62doau3s53', '', 1778799488, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('b7fo74ttguvae26f29na5bba74', '', 1778798896, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('b86aslr60nn3tvaedli2fcb7lb', '', 1779405513, NULL, '35.209.102.135', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
('b955lvl5ikpfgm2ahgc58e68lh', '', 1778799489, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('b9b1v35hlcpnrufqtbmji81ir8', 'Y3NyZl90b2tlbnxzOjY0OiJkMjdmOTFkOTgxMGE4MWRiNWNlNDVmOWE3ZmYwMDFmMWFmYTM5M2M1YTc5NmU1NTgxYjQyMmNjNTc2MDFiNTFiIjs=', 1780819442, NULL, '34.118.56.166', 'Mozilla/5.0 (iPhone13,2; U; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/15E148 Safari/602.1'),
('b9nak6tkopd2q2mrjuplt97i9h', '', 1778798948, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bbkrthlgt9uu4ngi0bis9louc2', 'Y3NyZl90b2tlbnxzOjY0OiIyNDdmZDY2ODM4M2QwZWZlZTYwOGZkYTI5NjdhODk1MDBkNTE3MTY0YTEzY2YzYjJkZTJhN2M4N2M2ZGQ2MzRiIjs=', 1778937583, NULL, '185.6.11.146', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.3'),
('bbl298tghpf794h0abfrdjt5i1', '', 1778799243, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bbneqn7m8ucjdvoscnv42rura2', '', 1778799319, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bc50gj5jidqe38hjb2nv5o1tef', 'Y3NyZl90b2tlbnxzOjY0OiJjYTA2ZjBlYTk2MjM3ZTI2YzY2OTliNzBiMTViOTYzYjEyMWY5MDM5ZjNlMzU5MzMwZWNiODIzNmYxZjUyNWIxIjs=', 1779628141, NULL, '52.167.144.190', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('bd1hnav8l4pl63ak7n5rnb0b5b', '', 1778799159, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bdlrgu0g4bnfcgn610fropcj6m', '', 1778798504, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('be5snkfm82cpubmu4nifc5n8jh', '', 1779051385, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('be63p95a3hckqpvnesspjktd3q', '', 1778799259, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('beua8vhf5cscjr4lcc4775dmca', '', 1778799121, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bf2ifelfkpgpijod0tkn8vbjek', '', 1778799489, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bfma11nu3p52u5njejlp7u77b5', '', 1779061681, NULL, '40.77.167.181', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('bg2ssf8mqaodcfp8j63410fpqp', '', 1779454571, NULL, '138.246.253.24', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.134 Safari/537.36'),
('bgd3a1vctjas2ggd1oshgqp1em', '', 1778799466, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bgv43uo651j4tpqit7ogo7a5dj', '', 1778799015, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bhlkqplibp97gt6s8rh1ceqi9j', '', 1779051384, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('bhqin1kkags9mmeiar2kmn2th0', '', 1778798749, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bi0at99pk711uij8o16rshptei', '', 1778798647, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bi99srdk5j62v26fo9eu132e7p', '', 1778798585, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('binfl4ilsn18ndunhl2cemf0sa', '', 1778798706, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bj3aa65n9q181mhrd4525f3ci2', '', 1778798686, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bjjhdaauh9tk36us849h10vi60', '', 1778799099, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bku25qoedn7p1s5bedt8ohshcc', 'Y3NyZl90b2tlbnxzOjY0OiI4YjJhNGQ4YTE4NGU2ZjEzNTM2ZGU4YjA5ODc5OTdkNjcwNmVhYjkzYTcwMjhlNTAzMDZhY2RlMzRjODNlNDMwIjs=', 1780342142, NULL, '54.37.118.68', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('bl1c6qmfsff0hemlv5k38dp29p', 'Y3NyZl90b2tlbnxzOjY0OiI4MTdhYjhmMGY1ODlhNDEzZDFkNzE1N2QzNjJlY2ZmNGE4MWMxNzI4YjAwMzQ3M2IxZGJlYzI5MDUxZTA1MWZjIjs=', 1779295697, NULL, '2a03:2880:10ff:2::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('bncs8b7t0474aisho36a1qsrp4', '', 1778798635, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bnhraqk1nj0sjma4rgrm9gu5vh', '', 1780269604, NULL, '2a02:4780:12:25ad::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('bnjo88kt02r8qtae0lvqa73nv7', '', 1780121744, NULL, '104.210.140.128', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('bq9j10eakoi3tsii0sps4hqisb', '', 1780561283, NULL, '104.194.213.85', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('bqqthi5f0d2ckq8occh2r7ub4f', '', 1778799106, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('br0h809phnnp2uc3a99nn6gm73', '', 1778798796, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('br5llp8kiruuo6g3p6ocv6kp8n', '', 1779316044, NULL, '51.68.111.218', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('br9ai13divd2375kd6krdoeqpu', '', 1778798883, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('brj7mmkn9uh9c23h7as7q0p44k', '', 1779051436, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('bsq4ihs0etejudn99sjmbq9pp7', '', 1778799096, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bt9phpfpuundj4rvur2l2qtrmi', '', 1778798668, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('btb6o1ihpudlhkadr4jk8mha3d', '', 1778799324, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bthi3m7kpnupnc7je1tcf776m5', '', 1778798515, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bv8rt2oeghd6so2ruurbv790hp', 'Y3NyZl90b2tlbnxzOjY0OiIxZjg1MGQ0NmMxMTVkMTYxYTUzN2IyODg1ZTQ0OWJmNDU3YWFhNjJhMWNkYTExZmE2NzAyN2Y3NzI0NmE3MTI5Ijs=', 1780389359, NULL, '192.71.126.245', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Viewer/99.9.8853.8'),
('bvfsp1mteibmfejts5sv94qb0u', '', 1778798913, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('bvotmo77j7t45ku0t4oh1sldd8', 'Y3NyZl90b2tlbnxzOjY0OiIyYzIzODk1ZWQxOWFkZjc4NjBjMzVmOWRjZjI5NmE2YWQwNzY5MzFiODkyZDUzNDAyZmFmNDUxOTAzZjZhMTkwIjs=', 1779483687, NULL, '51.68.111.219', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('c039s716vup25psalrbdjt7j4h', '', 1778798819, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c0pvka2m3cgln8ghusqo8cjj4i', '', 1778798653, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c0uicg4h9ndutrkncu07afboql', '', 1778798629, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c1mj61n3kudm4g9fkjk1tul31v', '', 1778798662, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c24q0ub092ibp7jci5qo3isebq', '', 1778799251, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c2fnsbmncdqi131bohuanhhbpe', '', 1778799284, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c2h3mn6drrrmlbkff4fvs1t98p', '', 1778799317, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c40mlg80dpn2nhpp24h3f6irdk', '', 1779505441, NULL, '104.210.140.130', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('c47rkso8m6idc5qv321htnao6r', '', 1778799163, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c4gv3qibt7pqj6qktagavlsck4', 'Y3NyZl90b2tlbnxzOjY0OiJhZjRjZDc5ZTFiZDdjNWVjMWY4MzViODcwYmI0Y2IxMjg5MTQzZDBkZmFmNWE0NjdjMjJiYWI0ZjUxNDIyNWZlIjs=', 1780149068, NULL, '64.227.118.194', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
('c6kn7ingv5glg8l80n8q1is65q', '', 1780177881, NULL, '167.114.139.136', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('c6m16g5hb0br58p60okhgtn3q7', '', 1778798632, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c72tnnfgvdcbfks616n86it2nm', '', 1778799026, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c73psl8uf7jachueub6fptfh9m', 'Y3NyZl90b2tlbnxzOjY0OiJiNGQ4MDlhYWI0YjZkNzhlNmM1YmYxYTI1M2RhZWE2ZjgzMGFjOWVmNmM5YWRkNGE4ZWQwYTljNTg1YmIwOWVhIjs=', 1779455839, NULL, '104.131.173.112', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
('c7fuegtrr0snk1h2abm4ni11bm', '', 1778799442, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c7la5u1uvl0el8gd9j14fi8iqp', '', 1778799096, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c82cu20ruqtnbti9ooc2roguk6', 'Y3NyZl90b2tlbnxzOjY0OiJkZWRmNGNiYTkwZGEwOGNhNjZiZTg4MWMyNzhlYjY3NmUyMjFmZDM4YjMzOGRkZTZlMzE5NzZiNzM3YmQzYzA5Ijs=', 1779621747, NULL, '95.108.213.92', 'Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)'),
('c83nq8ebiljcbj60qo8agoepku', '', 1778799390, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c8sqbcvi4tavd1usaethrki7an', '', 1778799041, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('c9j7e6fnfh9uvdo710sm97lqgd', '', 1778859783, NULL, '104.210.140.130', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('c9odq5ffa9qo579lh34d7ifh8t', '', 1778798795, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('cb1ajnkj97tgrdomh9b28ncel6', 'Y3NyZl90b2tlbnxzOjY0OiIwZTI4YmQ4ZTY5NmU0NGU0YmNmYzE0YzNmZWQ0YWM5Mjk2Njc4ZGU5MDA5YjNjODEwODZjOWE5NDQ3YjZkNmNlIjs=', 1779837799, NULL, '40.77.167.132', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('cb7r18l5fr7gqu681nimvlds4p', '', 1778798464, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('cbikuik1ld494j0dseenh0piv6', '', 1778798830, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('cbsj45r689anrcfcvj9dgq99i5', 'Y3NyZl90b2tlbnxzOjY0OiI5YzhiMDY5ZDRiNGI5MjE3MDZjNmFhMmZhYTA4ZTcxOWIyNDI3YmQ2Y2VjMWNiZTg3ZDdhMmI3M2EzN2FlOGIwIjs=', 1780497486, NULL, '2001:4ba0:cafe:b2c::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36 Edg/91.0.864.54'),
('cce4ns3a8oa24b8hg694qalvrd', '', 1778798613, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ccii2d3f7hh0onurd6f9gial8l', '', 1778798777, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ccvrs31ainqu1f2qku1vsi2tv8', '', 1778799372, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ceaknplvuruvchukaqakjb3dl0', '', 1778799314, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('cgko0fk8kl9uoito8ee5dlh5k9', '', 1778798455, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ch8kd6ru1tjbuadh1u8apipldd', '', 1778885546, NULL, '74.7.244.44', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('chha82i2muimqrk1g7skbk5scm', '', 1780793196, NULL, '2a02:4780:27:2004:0:d53:da4a:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('cjcn4681epk213nnlfrb3pnsh7', '', 1779161079, NULL, '51.68.111.203', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('cjrgrn232f7kqbtdrapgrfeajb', '', 1779829767, NULL, '52.167.144.174', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('ck6p7vd6pvdgk540hppjblh8mv', '', 1780727767, NULL, '52.167.144.59', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('cl0v08o4forr3sf6vkna0ottfu', 'Y3NyZl90b2tlbnxzOjY0OiJiYmYyZmMwNDliNDNiYzU1OWZhMDc1NWY1MzQ1NjQ0NzU4NjE2MjNmMmI5YzE4MWNmYzdmOTcxODVkMzU3ZDkzIjs=', 1780357759, NULL, '176.31.139.1', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('cligoevdvfsiub514ar186semk', '', 1778853050, NULL, '167.114.139.198', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('cls1hg2uum29ritgp2v0qhh2h7', '', 1779168433, NULL, '52.167.144.187', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('cm4sj1rep6p0gdd9cpgujr617c', 'Y3NyZl90b2tlbnxzOjY0OiI0NDRhNDliNTcyZDVjMmYwMzkwMWQxMzdmMjZiMTFlZjU1OTk1ODQxNjgwZDhjN2VlYzdiMGRlYjU0YWQ1Yzc3Ijs=', 1779023617, NULL, '185.13.99.111', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Mobile/15E148 Safari/604'),
('cm9a5r1noj1hq8bsfl9nc6ml0s', '', 1778798935, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('co3k6lac5ebeppmukhv0pher51', '', 1778798622, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('co3vf05un8t2dl6638qcha4sdn', '', 1779295696, NULL, '2a03:2880:24ff:5::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('co8kck84t16jgcg38osbj89gpq', '', 1780255414, NULL, '52.167.144.159', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('cont6rgiqjicqfuluolg5o5tgq', '', 1778799457, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('copqo1alfpls3nn3qde6esg77j', 'Y3NyZl90b2tlbnxzOjY0OiJkZGFjYzgwYTMzNzVmZTJlZjViNGJmMTZkNjEzNjBmNzY1YmFmMjM4NjA5Y2Q3NmVkZGUwYzNkOTViYjg1NTY1Ijs=', 1779720244, NULL, '2a03:2880:7ff:7::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('cpn9567oe963u9jp3708bat48q', 'Y3NyZl90b2tlbnxzOjY0OiJjZjEzYWFlYWU4NDdhMThiOWJmMTI4OTFlZGNiOGU1NjI0ZDVmYWIzYmUxY2Q0MzdlOWU3YjRmMzcxMTdmNDk0Ijs=', 1780779366, NULL, '66.249.85.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('cpsuiomr4990f0njidr734b071', '', 1779161365, NULL, '161.118.195.4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
('cq0sudcrdpmnr7r7lcvhtpg2k0', '', 1778799081, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('cq7m0uj6maif30f1an5lpd3kjj', '', 1779093147, NULL, '216.157.41.74', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('cragu0f593qc9o17bs5967ldpp', '', 1779093271, NULL, '18.159.93.15', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('crcva55vk6nlv0p9l6ev8951k8', '', 1778799202, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('crernatu1qoh0ki2qmggrqovc4', '', 1779051355, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('crn6k48me0oocerqfj97jk9bkn', 'Y3NyZl90b2tlbnxzOjY0OiIwZjJmMWU4OGRiZDAwNzNhY2NkNWM3ZmJiNTJhNWY3NTMxMTBmMzYxZTEwYzIzMGZjMGNmNDNhMzFhNTRjYjRmIjs=', 1780443401, NULL, '193.56.28.135', 'Mozilla/5.0 (compatible; bulk-validator/1.0)'),
('croohdvht7kfhbs01c6s5atnot', '', 1778798486, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('cslqr4ohmaqabkfbs0gf7h7a8b', 'Y3NyZl90b2tlbnxzOjY0OiI0NTg5Mzk4ZDkyNWIyMzUwNjE3YWU3ZDY4MGI0ODYyZTljMzY1YTkxY2JmNDM3YmU2YTE1MWU3ZmNlNDgyOGQ4Ijs=', 1779532538, NULL, '34.31.126.2', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36'),
('ctk849amkk5q9of50bjtdftttn', '', 1780237179, NULL, '2a03:2880:16ff:5a::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('cu0emddc5c9fmnta3nu4nlit42', '', 1778859772, NULL, '104.210.140.137', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('cubehh7fl0lolc0pdlmv667dhd', '', 1780518375, NULL, '2a02:4780:27:1682:0:3458:6c83:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('cuc5p3vkd2hvgp5qa2kmf25c0u', '', 1778798469, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('cvb7hrq8ee68binos0bg309a3g', 'Y3NyZl90b2tlbnxzOjY0OiIxMDFjODk4ZGRjMGE0Y2JlY2FjMzY3ZmI4MzJhMmJmOTAyMTgyZDIyMTZjM2VkMWFlNDkxMTQ4Zjk0MjJlZjI0Ijs=', 1779295661, NULL, '201.216.219.236', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.172 Mobile Safari/537.36 Instagram 430.0.0.53.80 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 974607439; IABMV/1)'),
('cveh2mqq5a1i782t8pkonckii7', '', 1778799476, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('cvh3g74lpal0pj6mq3lb0fj1cf', '', 1779093198, NULL, '216.157.40.69', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('cvr47klgc4mimag1e5psa7q2c1', '', 1778799149, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('d0a8qfk85b4sknkihvc8ccma5u', '', 1780340654, NULL, '104.210.140.136', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('d0bossm591irtf74t852kfq18b', '', 1778798807, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('d0ehrinv6o3vfa0o8fu8ha79d4', '', 1778799046, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('d0ojp4t7qktqs1phq1e8lj8hca', '', 1779075121, NULL, '66.84.90.89', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('d0vpgkep4h8b1l9krr68ufk34o', 'Y3NyZl90b2tlbnxzOjY0OiJlM2FhMWE5M2FlNWI1MjkxYTdjOTFjOWFhZmU0YzhkNDRiZjMwYjUyYjk2ODJlMDAzOWE5NmRlZjcyZjE5YTk3Ijs=', 1778904478, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('d1j302jh93p049a27bag5s6m3o', '', 1780182762, NULL, '66.249.85.110', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('d2egtjhij4u901t4ohekpkqnbr', '', 1778798563, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('d2kof69at8ocaa4oiu4vf5g9n0', '', 1778799402, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('d2ks4vhfa6e8kfft5vh7uuubu5', '', 1779051383, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('d2pfnp9im28dj5t0odkuq1ltkr', 'Y3NyZl90b2tlbnxzOjY0OiJiYjE2MzBmODljMjYwOWNhOTY4YWU5MGRmMDk5NjQ2ZTljNGE5NjdmZTEzOTFkZjQxZWFkMTlkODEwM2ZjYWYzIjs=', 1779963695, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('d3qq3no04s7qhc46t8v3l6p8pq', '', 1778798825, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('d4c9a7vat570filomkfru5n33s', 'Y3NyZl90b2tlbnxzOjY0OiIyMmY5MWUxZGI0MzE1Zjk3ZWZmOTY5YTMwYTE5OTAyYWMzNjZhNmM0ZjZmZjJhN2QzYThjNTM0ZTNjMWVhZTUxIjs=', 1780336516, NULL, '51.68.247.219', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('d4daluj27hnkilg8l7j74j68mj', '', 1778798684, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('d4mgdrsoqv8m7ikmavnd5m5ani', '', 1779366717, NULL, '66.249.79.132', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('d4qbandgbel66mefv9b50v8emt', '', 1779084093, NULL, '2a03:2880:18ff:45::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('d5jdcmcf9ifmfqgd59g95bshfq', 'Y3NyZl90b2tlbnxzOjY0OiIwODdkM2RlOTkwMjAyZWJiYjNjOGJkYjZiNTNkM2Q0OTBmMGVkNjI0MjBlZjNmZDZlYTA5ZDE2ODZjM2YyOWU5Ijs=', 1779113404, NULL, '144.217.135.236', 'Mozilla/5.0 (compatible; Dataprovider.com)'),
('d6b0fppg6tb37q8q3m6pfahobu', 'Y3NyZl90b2tlbnxzOjY0OiI3ZTg2ZjhjZmQ3ZjY2ZGFmMTNlMzc4ODJkYTM5ZGY0ZDZkYTI2MjhiYzM5ZTIxYmU5Mjc2OTQ0YmE0MmM5OWUwIjs=', 1779887645, NULL, '190.210.32.156', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.172 Mobile Safari/537.36 Instagram 430.0.0.53.80 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 974607439; IABMV/1)'),
('d6f5t0os03ie9ph24hppsqo7r8', '', 1778799381, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('d7013kdcc1gjvfm9h6se6entar', 'Y3NyZl90b2tlbnxzOjY0OiI1NGM0MjE0ZGQxNDQ4OTA2MTVkMzhiZjNmY2RmNTlmZjE2ZmQ3Nzc4Nzc2NGY0MDg5NDQ3OWVlZjE0YmEzMDkxIjs=', 1778868282, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0'),
('d751c4j5cib989kvdp5gq4fdc3', '', 1778799126, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('d7akoo4hm8t7sk0vd8qr7ul8dm', '', 1779906475, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('d7g9mo7c77icika0dulr17s5v1', '', 1780418710, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('d8r4t2gm8a6ilii4knb34m9278', 'Y3NyZl90b2tlbnxzOjY0OiJkZjdkNDdiMzA2NDM4ODYxYzZjMTA5ZDdiMjJkOTM2ZWI2MDA2ZDljMTUwZGJjMDk3MWEwYjc4OTAxMTYyNmU3Ijs=', 1778853051, NULL, '51.195.183.143', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('d9d802nvjgo4tkp7lahvg773hi', '', 1778799252, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('d9fmd51t5dme6m1usvguh3fbcc', '', 1780418707, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('da60dho3gbbno7ksdv93994dlk', '', 1778798625, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('damsfmsh35hin1akqnnhhs7cen', '', 1779024087, NULL, '66.249.79.7', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('dan1fc6kc6sit6324pa8nujefu', '', 1778798905, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('datfndi59bdcph4bm8u75iau08', '', 1779653597, NULL, '104.210.140.139', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('db8v98s73j4fqrhj9bhdrq67ij', '', 1778799263, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dceo2f7q4f7e41mj00n87ndoe3', 'Y3NyZl90b2tlbnxzOjY0OiI4OWY5YTEzNTBkMTUxNjgyZmEwYmQzMTcxMjNhNzI4ZjQ4M2ZkYzU2MDgyM2JlZjllYmIxOTUxODIxY2U2YTNkIjs=', 1779564881, NULL, '52.167.144.205', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('dd73sk9rr5hmv0g10ta21hpbtp', 'Y3NyZl90b2tlbnxzOjY0OiIyMjU0ZThkNjZjYWMyMTkwMTc3MDdmN2RkZGRmNmRmZjFlZjc1OTVmZTk1MjY3Y2YxODJjMTEyYzcyYmE3MDdlIjs=', 1779872575, NULL, '176.31.139.22', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('ddjrar0pcok05pjr8i323vskf4', '', 1778798835, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ddrcndj4c24pt54fodn2hh4s6e', '', 1778798989, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('def946ue0f23onnerlr5p90hm5', '', 1780509823, NULL, '52.167.144.237', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('df5snkmjafljfhqqal8rt78gn4', '', 1778799482, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dflop2e2i9bcol19mclajgmuo2', '', 1778798940, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dgbl38qitueomgsc2r9r5su649', '', 1778799479, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dgraqqt5pi50kt3v728u0dtka4', '', 1778798543, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dgrj5o9edf37727eo0k37gjcis', 'Y3NyZl90b2tlbnxzOjY0OiJiZjM4M2MzY2YxZTU0ZDdmYmNiZDQ2NGRkODcyN2E3MGQ5NDc1MmFkYjM3MDJjNTg4MDQ5NWMxM2I2ODljYmM0Ijs=', 1780474945, NULL, '178.156.249.178', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0.1 Safari/605.1.15'),
('dh5ag56keti3fckqh7ifuu86m9', 'Y3NyZl90b2tlbnxzOjY0OiI2NmYxN2M1NTFlOWFmNTI3ZDBiNWUyMDdhZTQ1NTM4YmJkM2U2M2E1NTA5ZDMyMGNjZmI5NTliMzhhYWY5MGQwIjs=', 1779921912, NULL, '176.31.139.21', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('dhj96fcrj10dokditf0f0ebddf', '', 1778798970, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('di3irovdkpj58qv7qct67tkare', '', 1778798747, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('di4hhm0tt9e24butv3i76lc956', '', 1778799496, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('djpvphopapjn0pov9vshnghikl', '', 1780834925, NULL, '104.239.13.160', 'Googlebot'),
('dkcr72eq9cre7cpe2fv37kse70', '', 1780071642, NULL, '198.244.242.132', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('dkik5rd30nlhda782jboujo1ot', '', 1780483449, NULL, '2a02:4780:a:1756:0:fee:342e:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('dkpdrqeeuap0d42qgi073p1omm', '', 1780195580, NULL, '2a02:4780:27:1279:0:3a0c:b695:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('dmdv83m4f4b2802jqpbifcr1gp', '', 1778799080, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dngdojjok2cgtg2ofvtsvunb8a', '', 1779426921, NULL, '40.77.167.181', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('dnh0rovtvmqnr2n3blanjrvrtm', 'Y3NyZl90b2tlbnxzOjY0OiJhNzBkNTllZDJmNjE2MjM4NTVjODA2ZDNlMDAyZGE3NzY4MzU1MmIwNTE1ZGRjYjc3MWE5NjQzYzcyNGNhOWNlIjs=', 1779614729, NULL, '40.77.167.29', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('dnjsavraq7nnfoubhdvevs4lms', '', 1778798963, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36');
INSERT INTO `sessions` (`id`, `payload`, `last_activity`, `user_id`, `ip_address`, `user_agent`) VALUES
('dnv4hp0r39og268945ooa32ce8', '', 1779715751, NULL, '40.77.167.181', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('do0km8ctih539n113cbe1gudcr', 'Y3NyZl90b2tlbnxzOjY0OiI5NjYxZTU3NjIzN2YzMzNiMTFkMzJlNTI3MGE4MDAyZjdmOGY1MTI0OGExNWNiZGVkN2NkODhkMTUyMjg5ZmViIjs=', 1779021086, NULL, '2a03:2880:f808:17::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('do8bnfa2itrd906758mejcilb5', 'Y3NyZl90b2tlbnxzOjY0OiI4ZWVkMWJjMjIyMWU4ODM5NzI3NTExNWRhZDI5MmM2MjEwZGEzOWY5N2E4YTJhMTU5MDYxN2VjM2Q2ZjkyOTA4Ijs=', 1779185594, NULL, '192.71.126.27', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('dp6omd0jr1b9ctjkf0j24m0hn4', '', 1780241148, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('dpg4phoa0fpcj5jrs36t3hjp7i', '', 1778799432, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dpk0l3rianfleolnrn6o91srt2', '', 1778798993, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dpmfmt3mcdda43k9ofdn2m0if0', '', 1778798597, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('drdmr9lf603mcdqa9qisish7tm', '', 1778799449, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('drs55g5k1nnj5legok7i75441d', '', 1778798444, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dt9qfo4a4e08dmtmjgmj82rgqt', 'Y3NyZl90b2tlbnxzOjY0OiI3ODk4NWMyYjY4YWNhZmE1ZGQyOTQwMjMzMzQ4MWZiNGQzNDNhZDJkYjMxOTM1NmMwMzI5MmY0ZjBjZDdhODU3Ijs=', 1779408009, NULL, '158.173.241.171', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36'),
('dtcucbhjk97i2mjfoee1idn4gn', 'Y3NyZl90b2tlbnxzOjY0OiJhYWNhNDhiZjQ0OGQyNGM1MmQ0ZGRkZDM0YjlkYjhmM2MyYzI0ZmYxODY4NTQxZDI3OWVmZGJlZjQ3YzU1OWJhIjs=', 1778829265, NULL, '198.244.240.242', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('dtj1skrrj3bk3nd660u3sblcr3', '', 1778798454, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dtrgesr99cne8kkroca53dlo79', 'Y3NyZl90b2tlbnxzOjY0OiJlM2Q1Y2JjZjU4NzI1NTc2NDdiYzE2Njc1OTk0YjljMzQ3MzRjNWI1N2FjYTcyMTY0MTgwYzZlM2U3NTNmZWNiIjs=', 1779612844, NULL, '52.167.144.170', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('dtuk8vbqmcpet0ooq4ejp90jt9', '', 1780843263, NULL, '66.249.85.110', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('dunjf9h18oirg1pq9m5pbhslad', '', 1778799461, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dv2r28rjlbpts4rpk98saskkd0', '', 1778799493, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dv488234114jgromqh5f3tnusv', 'Y3NyZl90b2tlbnxzOjY0OiI1ZGJkZDAxYzJmYjBmZDNhYmUwYTdmOGJiYWE0MDA4ZTU4OGRlMjY1MWMyMmQ1MmMxYTk4NzUzODU4NTcxNzkyIjs=', 1779973854, NULL, '2a03:b0c0:1:e0::c00:9001', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'),
('dvbfnv92c9rmbrnhhfegrk1auh', '', 1778799180, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('dvmqqvk3esgm2onc9cbp4pgl6q', '', 1779093197, NULL, '216.157.40.94', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('e0jgglb5gkf8r3j1gr8vf1qmet', '', 1778799212, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('e0o7982fpggiksvmu3riug00lm', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('e2krhm9o0j9591g9m31sh54s2q', '', 1778798554, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('e4imprfa5j7h1nmj87pa6mrbmd', '', 1780483449, NULL, '2a02:4780:a:1756:0:fee:342e:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('e4kiuujal52aumdm14h7ospkhe', '', 1778799388, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('e4piqgvngds0ru1iatau2s8dgk', '', 1778799210, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('e58can4p74gl0kpge62ge08iml', '', 1778799335, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('e6tj1mc4p0dnmb5sopr4d7vfd9', '', 1778798870, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('e74ve3epu0sjeun7tp8uv0ieo5', '', 1778799361, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('e7d6ljl7fmc0rcifc1anam8hrh', '', 1778798552, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('e7jmejpusg1chptth4hldit22o', '', 1778799125, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('e80cqtjavo7f0ijcg79l8jboic', '', 1779629377, NULL, '192.36.109.128', 'Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115'),
('e8qspjr78nm0kmcog0ruiet2q6', '', 1780830270, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('ea17q4gqndomd0mtgr5qm52aj6', '', 1779757235, NULL, '2a01:7e01::2000:c9ff:fe2e:fe0a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
('ea8hgqnhh2gaj3lsv183i32iui', '', 1778799438, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ebbidqco91os1h5uoifdqoedk9', 'Y3NyZl90b2tlbnxzOjY0OiI1YWIxNGVhNzA3N2ZkYzFhOWUwNTE3NDU2Y2Q5ZmNiZDdlZTJlYjRiOWJkNmY2MWE5ZTE4YTc1ZTEzNjE4YmMwIjs=', 1780074834, NULL, '192.36.24.172', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.3'),
('ecjr4l29f4b3acg1vbohdjsl18', '', 1778799341, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('eck39o9re2nqum0kmgtbrps51q', '', 1778798461, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('eeiamvvcf65n0g2v18sgmerbiv', 'Y3NyZl90b2tlbnxzOjY0OiIxNGY2ZjVlOTQ4MTA4ZjlkMjYzYjNjZTcxYmExODIwODA2MTVhYzNlMGFlNjljZDk2YTMzYzU4NGVlZWFlZDYzIjs=', 1779755595, NULL, '185.12.248.5', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('ef8nlti9i05t8si3o7hchna02m', 'Y3NyZl90b2tlbnxzOjY0OiJlYzljNGM0ZDBlMTM2M2VlNmI2MGFmYTk5MTRhZTQ3ZTBmZGI1MTIxMmU5MWVlMWRkNWQ4ZTkyZGZmYjJkNmM4Ijs=', 1780364224, NULL, '176.31.139.9', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('egm7c9a44av76suropcvfjcde3', '', 1778798802, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ehsppin3d7nq2nr4jbmk7bgkop', '', 1779292431, NULL, '15.235.27.183', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('eisu2unsmh87r11akphp5rrhg0', 'Y3NyZl90b2tlbnxzOjY0OiJiMWZkMzVhNDg5YjkzZTBjNzRkYWVkM2M1MTBhZWQyNjI2ZjU1NDUxNTQxOTBkN2E2ZDhiY2QxZGI4NmZkOWYwIjs=', 1779556666, NULL, '186.157.53.40', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36'),
('ek5aamnup8ndvdk5ib8728n3om', '', 1778799158, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ek8p85a0eaq6rljt16besq4e0g', 'Y3NyZl90b2tlbnxzOjY0OiJjMDUzYWM1MDIwNTNmMjkwYjk0NGViYjRiZTAyMzgxYTI0MzE4MDMzZDUzNDZkZThiNjgxYmU0NzU2MTE4Y2Q1Ijs=', 1780783429, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('elb0jhu2v9aa51cseu6b6be8r8', '', 1778798712, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('em76b4sa9ih5f8k96udaqddvv2', '', 1778799270, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('emnlrs2sfk3gseup9bnahe0jla', '', 1779303238, NULL, '66.249.79.134', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('emsiakce1u46dbrqtf29fofi46', '', 1778799017, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('en4a66l5udvqluu3aputq9a05h', '', 1778799334, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('eong589bjptqu5o71d0pljbfg8', '', 1780456157, NULL, '2a03:2880:24ff:48::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('epob0oed1r79lfv2478b11qb7a', '', 1778798907, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('eqd9frelh495q1m5sdo5cag122', '', 1778798813, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('eqhataul2de3aja6bj735iin5q', '', 1780489157, NULL, '2a02:4780:6:1254:0:3166:f11d:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('er1kqu8u4j0792rk9jj5p5alh0', '', 1779621746, NULL, '5.255.231.19', 'Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)'),
('erqgsnb6i2v3h27gfrgi4gtuv5', '', 1778798452, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('eru07bom94ttd8hvet6cc6tdhd', '', 1778799453, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('es01q6feolrlkdu9teme75kc9b', '', 1778799309, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('es1ocf5vv25396oe9udgdkp857', '', 1778798624, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('evr6slhosglnui0otlreac70sk', 'Y3NyZl90b2tlbnxzOjY0OiIxOTk4ZjFjM2I2ZTE5YTAxNjBhYmFjOTg1NjNiYTlkYzliNDc3MWM0ZTM0ZmY1Nzg3OGI4YTZmZjM0YzYwOWVlIjs=', 1780414882, NULL, '34.207.63.212', 'Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36'),
('f0ngtg6e131k9m466jcq4v38n5', '', 1778799233, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('f37ude3iggr75s4r3vtba49o32', '', 1778798518, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('f3iv3qshvhb3tiu25t5428o5g5', '', 1778799374, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('f3sdmc0rs12q03j5s5ojah67hv', '', 1779195636, NULL, '52.167.144.160', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('f5bbstkpd7elirh3s66bd5dmkk', '', 1779711322, NULL, '66.249.79.132', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('f5hb4f5uvs7b08tbjlt48ld1vq', '', 1778799161, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('f5i701o5rrfhvbvfk6j75tfmk4', '', 1778799299, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('f6855ttvpa381khmfmvu1i2lda', '', 1778798800, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('f6fa5mkhve4ppvqias5kb0fv39', '', 1779727013, NULL, '104.210.140.136', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('f77b27k0r7vjibv2q6b2af5vo4', '', 1778798783, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('f86d5qojupb6bavuibc1tbjcp2', '', 1778799146, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('f8gv9dfjljidhgb05d2hfom4c5', '', 1779915306, NULL, '74.7.175.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('f8ip38bd2budeaf2usv17d7qsk', '', 1779093149, NULL, '216.157.41.74', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('f8jlns8vblrhvtjusjvnd0hkrj', '', 1778799383, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('f8od8iva9q4pgo2vjcr6i5fkdh', '', 1779093283, NULL, '216.157.40.89', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('f8paukc5oerp28duhck9dkqh9o', '', 1778799117, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('f96lopi7bp297ucecknmjd5aoo', '', 1778799049, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fa0rk4d5hevu0j7ejit10fkm52', '', 1778799474, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fbltnh5s8l0logt7ufj8lutimv', 'Y3NyZl90b2tlbnxzOjY0OiJhNGE4YjJlNDNmNjhmODMxMjllMzExNjRjMjVmYzAxNDdkYmI0NWI4ODQzOTE5NzJkMDNkZGE1ZmNlYmQwMGZhIjs=', 1779109430, NULL, '188.166.8.82', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
('fbmpo62c3eapaf6ucjeoqjaffj', '', 1778799083, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fbntk0mb72si5icphctshjmdnv', '', 1778799076, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fc976s11v06gikm44tkvfearm9', '', 1778799430, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fcv7hp4amo9ovha375jm010454', 'Y3NyZl90b2tlbnxzOjY0OiI1OWI2NDEwZmFiZjJhMmNmMTVmMTMxNTE5NGE1YjIxZTE5ODU2ZDVhM2FkZTAzNjgxZmMzMTMzZmNlYzg0NTcwIjs=', 1779800392, NULL, '4.209.236.22', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0'),
('fdo6898ck3e63ngfphr9g1ks6d', '', 1780334918, NULL, '2a02:4780:2b:2028:0:cf8:d000:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('fgl61op41q7p8j59mthd4o49bk', '', 1778799110, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fha8hb13spgbeljvk3fr22ej58', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Safari/605.1.15'),
('fhe7k89ge8e94cnvd4mujkcjqm', '', 1778799013, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fhgsqosqkptnnid6qpok8bdt7v', '', 1778975232, NULL, '2a03:2880:24ff:72::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('fhhbmc0em7e806tqea59t4nlvp', '', 1778799219, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fhsqd68nan5shm0i5p67nfgti7', 'Y3NyZl90b2tlbnxzOjY0OiJkM2EwN2JmMTE0NDgzMzdjMjk3OTIyYTliOTY2MWJmYWZkYTAxZWZmMTdmZWU0ZmRmODRjMzViMmNmZGVlYTJhIjs=', 1779871983, NULL, '192.71.126.53', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('fib2rabraefu6cij127cs7u920', '', 1778845774, NULL, '74.7.241.176', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('fimi94423ijqcg86edqo0lkk5u', '', 1778798927, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fj95j6outtesi40rrbr9sff94o', '', 1778799494, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fjboem8vr860tdi18022r1bqok', '', 1778799475, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fjj6ihhunuua77kuqp5alf0df2', '', 1779823706, NULL, '85.208.96.210', 'Mozilla/5.0 (compatible; SemrushBot/7~bl; +http://www.semrush.com/bot.html)'),
('fjri47m5o6hv2c5b8o5ce4vkmp', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0'),
('fk9blr1drtp3nkjqhp4a9e538s', '', 1778799052, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fl0949m9k2n21canah7601otho', 'Y3NyZl90b2tlbnxzOjY0OiJhYTQwYTBmZGJhNmVmYWIwYjMwMDlmZTU2YzRiYzljODVlN2ZlOTMzYTkwMDAxYWQwMmUzZTA4MzFkMWE4ZTAyIjs=', 1780281668, NULL, '149.57.191.8', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('fl6hsr8b495ltcrgubh1530n5m', 'Y3NyZl90b2tlbnxzOjY0OiI5NTNmMTM3ZTc1Y2UxYjg5ZWJjMTU0NjE1NzhmOTU2ZDhlZTMzMGI4NTAxNjUxOWMyNGIwOWJiZjI2ZGExZTA5Ijs=', 1779822350, NULL, '158.173.241.27', 'Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'),
('fmp4iml2e4j0eg0qafusfq0hce', 'Y3NyZl90b2tlbnxzOjY0OiI3YmI2ZDgxYTk2OWQ0ZTJhYWI1M2Q4ZDk4NjExN2IxNWVjZTg2YTFlM2Y0NmU5YWFmOTZjMGJjMjVhZTk1Njg3Ijs=', 1780783427, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('fn2mob4gffq8osm5s3e3lvqmqf', 'Y3NyZl90b2tlbnxzOjY0OiJiNGQwZTNkMTFiN2ExNDVlM2RjNjdjZTdmODhiNTA3YTU5MDc0NzVhZDBiZGYzZDFmNzEwYjRmYjAxMjIyOWU5Ijs=', 1779021217, NULL, '2a03:2880:f808:17::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('fnc1djmdceujl5tdjpe8bv6spg', '', 1778798619, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fp91e0bagdmf0erb6t14lqd46s', '', 1778799337, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fpl351tuejosh1i29rsdub6jqd', 'Y3NyZl90b2tlbnxzOjY0OiI0YzM3YzA5ODIwZmNiMWZhZDg5MzNlNWYzNjNjYjkxNjBhNGZjNmJmOGE1MjEwM2QyNTc1NDk1NTUzY2I0YzFjIjs=', 1780623211, NULL, '51.68.247.197', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('fqb6e4hgbddbivb0t9o6b6r6rv', '', 1778799469, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fqoa0kpb5brfog8c23mdgrkr38', 'Y3NyZl90b2tlbnxzOjY0OiJjYjQ4MDg3YmM1M2QxMjdjNGNiMGFlODA0YjNmNTNmMmQ2YTE5ODcwMjEwNmUyZmM3ODYzMWUyMTM1ZDk0YThiIjs=', 1780101302, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('fqtf2f25ecv7qagpd9eig729dr', '', 1780064735, NULL, '52.167.144.158', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('fr15l7hc62n8rdugkfrtdarqij', '', 1778799285, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('frc8jj28hf5v52f25ugpke26te', '', 1779810349, NULL, '198.244.168.210', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('frhhjgnnuada3c18nhkn79bf2h', '', 1778799253, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('frldn5o6hkefaha783rrliq1mi', 'Y3NyZl90b2tlbnxzOjY0OiIzYjM5Y2ViZmNlMWViOWRmYzY3ODBkNjZjNmUxZWQzN2RmMzE4ODJhYjExMDBhNmFmYzQ4ZDU3MDczYTNkNzgwIjs=', 1778881393, NULL, '51.195.183.248', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('fs4mir77b117l789qtckc106dk', '', 1778798484, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fs9rgv3itll2cral2cl3q0uvl8', 'Y3NyZl90b2tlbnxzOjY0OiIyMDVkNmJjNDlmOTQ4ZTMxNmM1Zjc1YWU3M2M5OTEzNDQyNzllMzI2M2YxOGYwM2QxZjAxZGI0NTI1N2FjYjY1Ijs=', 1779380609, NULL, '40.77.167.0', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('ftgcsonc2u729ho8lvvtiboqd2', '', 1778798936, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fthnl3i06msibqup92701bb5ct', 'Y3NyZl90b2tlbnxzOjY0OiJjOTMzMGZiODI5ZDEyNDVkMjlhNzg0NzMyZTVjMmYwN2M3NWY1MzkzOTYxZmVkNjNlZThkOTBhMzgyOTE0ZGRjIjs=', 1780182955, NULL, '190.210.32.173', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36'),
('fubfplmr0mm6v9vbrvagl2ajqo', '', 1778798859, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fv09g1r9uqnq5177p8h8ltdurf', '', 1778799093, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('fv1drlepbr8dbjfrte8u6hqtd0', '', 1780375894, NULL, '52.167.144.55', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('g00d5k6v2rhcvjluibs3d8sp18', 'Y3NyZl90b2tlbnxzOjY0OiIzMGNlOTFlYzFjMTk5YzU4YjdlNTY2ZDBjMDI5N2UxOTc3MzlkM2QyNGE0NDcwYzk3NmM2MTMxMzIzOGQ2YmIxIjs=', 1779018481, NULL, '104.28.205.80', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'),
('g04r349ilg7poloptvp932negp', 'Y3NyZl90b2tlbnxzOjY0OiJjNjJiZDY4ZTBmZWQ0MWIwMDBhMTU4YmYzM2RmZTlmM2EzZmEzMDBjZmI4MzEzY2RjNDJkYjcxYzUwMTRkOTQ1Ijs=', 1779720374, NULL, '2a03:2880:2ff:10::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('g1jj5t155bqoaj99nnbviu64v4', '', 1778798490, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('g1mqjd0cihqaavcsgnmkset1nu', '', 1778798675, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('g23rcfon3d2q7m4vfn1nhpbikn', '', 1778798874, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('g24uopuhou6gl3q9p70ibjdadq', '', 1780073382, NULL, '77.240.87.244', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_6_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15'),
('g3d7okfqvivrk1plk5nkp67s5g', '', 1778798658, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('g5sjeoa73talcitsdqrl39m5ft', '', 1778799484, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('g6kdgpb2kmg81hkd23bdpr53sk', '', 1780615248, NULL, '20.161.69.32', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'),
('g7p6jcsr1va2rjpvk9jbrcfcol', '', 1779079706, NULL, '104.210.140.130', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('g886lfd98i16kemc92qd6ah8pl', 'Y3NyZl90b2tlbnxzOjY0OiI4MTk3ODNmY2Y1MjBhZDZlMjFlY2FiNDhiMTNlZTk4NGZhZjk2ZWJjNmI5MGRjOTljMjMzODdlOTg2ZjA4MTFlIjs=', 1780834923, NULL, '178.62.244.173', 'Mozilla/5.0 (X11; Linux x86_64; rv:142.0) Gecko/20100101 Firefox/142.0'),
('g95tletj6ue4b3mpoif9iqk5ii', '', 1778798763, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('g9tul5gc52erg0l57e5ko7hvd8', 'Y3NyZl90b2tlbnxzOjY0OiJkMjMyMGMyZWI5OWIwOGE2Yjk3ZGMwMzM0ZjM4ZGU4MDljMGE4ODFiZDZjNjcyZjFhZTY1YzY4YzFkNGFkOTc0Ijs=', 1779519483, NULL, '135.225.181.173', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0'),
('gaa2gju8v6qtae4qs56f19l9cn', 'Y3NyZl90b2tlbnxzOjY0OiIyNzQxYTQ1YTlkM2U0MzA4Mjk0NWFhNjQ4ZDdjYjY4N2RhYTk3NmM5OGFjNTU3OGYxM2JhZjNkNGIwOTVjN2FjIjs=', 1779871983, NULL, '194.103.212.184', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('gajeabvqte53gjrsurm21s0eb8', 'Y3NyZl90b2tlbnxzOjY0OiI5YzczODRjYmY0YjEyY2VkMzFmNzlhMzBhYTBlODUwZGEzM2I0NGM1YjRiYTM0ZDQ3YTllODQ4MWZlYzQ5ZDZjIjs=', 1779671429, NULL, '181.238.69.25', 'WhatsApp/2.23.20.0'),
('gaqdres32d97ccmvauesdvght4', 'Y3NyZl90b2tlbnxzOjY0OiJjYzA0ZjU2ZjI0MmUyZGE1ODZkZjI1MjUyZmRhMzAwNGQxMjE1MDQ4MzM5ZGQzNzdlNTU0MTFiNTc2ODExMDRiIjs=', 1780485841, NULL, '100.54.134.27', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36'),
('gbi4fuv6kiuccd12ofmen9jt54', '', 1778798986, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('gcbelor5p5r49st91dei5h83gl', '', 1778798809, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('gd98vrf67h2igokoa546hdvcka', 'Y3NyZl90b2tlbnxzOjY0OiIwNDQ5YWRiMTk0NDEwZGZhMWQzNzRiNGFmYjFjODczZjU3MjI5NTNlYzFlNzMyNDI3YWEwMGIwMGRhZjA2YTA0Ijs=', 1780676814, NULL, '31.57.41.46', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36'),
('gdfc5hen76j86ddtufmi6bjbg7', '', 1778799401, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('gegj26ntq0ljl5ga77splaao6l', '', 1778799042, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('gf9a314hd8o9r3ebism5n4dhnf', 'Y3NyZl90b2tlbnxzOjY0OiI2MTM0NjY2NjY2YmJjZWIzMzFmNWY3MmI5N2MwZDNjZWNhOGNkNDljMGQxMzUyZmIxYzBkMTUzOGU0MmRjMDU4Ijs=', 1779442036, NULL, '52.167.144.212', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('gfh0crrmn2hdf5tmgpki1tbb24', '', 1780323217, NULL, '66.249.79.132', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('gfvbqa1jm3bqsl7v81lttth0kk', '', 1778798731, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('gg7hrgd61s306ajicbdm9d48t5', '', 1778798446, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ggk845jkc0r745l9it2cvkur5s', '', 1778799254, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ggrh2m2dmh9u8akdv8qaoopnec', '', 1778799421, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ggvubqhh2n0aorj87e3s4mt4h9', '', 1779093284, NULL, '216.157.40.78', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('gi0212o4rjm0t5t994rtsfiblc', '', 1778798586, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('gici92vfljq28d9mb01sp1io7o', '', 1778799292, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('gjhb69o921105ov6mqnqcala01', '', 1779739667, NULL, '40.77.167.62', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('gkvaing09k4sbagsi5h5rl5c48', 'Y3NyZl90b2tlbnxzOjY0OiIyZjZjYWE4ZjYzM2RmZGM1YTM3OTBjMThlOWQ3ZTk4M2ExMWNlMTQzZjQzYzJhMDZmOGZhMTVhNDM2NWY5N2YzIjs=', 1779093175, NULL, '18.159.231.78', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('gm06c5n0s585ve8chd835msmfh', '', 1779495993, NULL, '66.249.79.132', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('gnqth6ngn8tcgcejsu67u5ora6', '', 1778799409, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('gol31c6vkp939qitbcfmnmhubd', 'Y3NyZl90b2tlbnxzOjY0OiI4N2MxZjllMDAxZWU3YjFkMTM0NzBjNjljNDFmZWM0NDM4YmQyOGY5NTZjMGI0ZDg5ZDA3ODhhZGNlZGZlN2E3Ijs=', 1779071506, NULL, '168.91.40.100', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('gq96u77jc9om79or5truc7imv9', '', 1778799239, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('gqqfn955hrru6dh3qo19nkupvl', '', 1780334881, NULL, '2a02:4780:2b:2028:0:cf8:d000:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('grrhdqb7shv4slahttabirhk58', '', 1778799075, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('grsk2svuslqv10val7v3jd9a5f', '', 1780272382, NULL, '66.249.79.132', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('gs0carqfl0rocfq9dphm9n5h74', '', 1779983784, NULL, '66.249.79.134', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('gss0gplc3flrshhcje9ab2vjon', 'Y3NyZl90b2tlbnxzOjY0OiJhMjM4OTEwNDBhMmQ4ZjVmNWVkZjI3NTYzYTJkYTRmYWI1MjYyZDJmMDk0OGVhMjgxZmE5NjY4ZGM0MDZkNjlhIjs=', 1779770064, NULL, '71.6.240.45', 'RootEvidence/1.0'),
('gtgrukk9k7tll7d9vgoujhtdin', '', 1780270805, NULL, '104.210.140.138', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('gtj4ippgm2uq43a2rjs5378l9p', '', 1779220476, NULL, '51.68.111.208', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('gu6ol4vep0e2rnl9onfi5inl68', '', 1780270806, NULL, '104.210.140.138', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('guuieq8nhu2moutt8a8t6mvhip', '', 1778799271, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('gv966hhd2oqhadcbpp15449ik3', '', 1778799028, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('gvm5pvn1udmc5i3vp0l2nflv3i', 'Y3NyZl90b2tlbnxzOjY0OiJmY2JiMmE3MjliY2ZmYTY0MTM2NWUwNzMwNmIzOTQzYmMxMDA0ZjU2MGExYjRjZDUyZDNiYTFhYmE1OWZiNGMyIjs=', 1779721892, NULL, '54.237.240.97', 'Mozilla/5.0 (Linux; Android 11; SM-A217F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Mobile Safari/537.36'),
('gvrjb1p81akps9o7c816ki2frc', '', 1778799295, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h0iogavma65lv055mnq9hh0fqj', '', 1778798555, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h0q7jdahjvai8q358g1mqof4ht', '', 1778798505, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h197o9jngms8u876ln8igoqdh3', '', 1780229075, NULL, '45.12.3.114', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0'),
('h29ugib6hefbl3fvel41rtcs6n', '', 1778798636, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h2gfijgqs0ko1etgiffit3okv5', '', 1778799274, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h2rdc2bd98g0njd9cr9gn8i9bd', 'Y3NyZl90b2tlbnxzOjY0OiJjNTMzNmVmNjFkMjY3MTIwYWYwN2RmNTlkOGM0Y2FmNTgyMjIyYzI4ZDRhNjBkYjllMDcxNmUwOGEzMTQ1NGU0Ijs=', 1779165690, NULL, '136.113.22.215', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36'),
('h3idvknv7gq708fi68ba5acaim', '', 1778798559, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h3lq573hmv040fdd1b4nr2rpsd', 'Y3NyZl90b2tlbnxzOjY0OiIyYWFjZmU2MTcxMWU2N2VlZWZmMTFiNTM2YmEwMjg3OTg0Y2M0ZGVlZDMxOWQ1YjhmYTkyYzQwNWMwMTM5OWQwIjs=', 1779215656, NULL, '158.173.241.246', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36'),
('h3m9j5amoralal23o21m7a6oqh', 'Y3NyZl90b2tlbnxzOjY0OiIzZTllYTBjMmU3Zjc5YmMyMTRhYjg5NTMxMDAxY2RlNmQ1YWRmZThmMDM5MTEwYmY2NDIxM2IxMDMzNTZlMjk2Ijs=', 1779093284, NULL, '216.157.42.84', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('h3ng3098qcg14517s57efjpaem', '', 1778798651, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h4f3gklof851dij4a6ppukibct', '', 1778798981, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h4v5t6222tu0c9fim7745qkinr', '', 1778799286, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h5785fkr61ms9htpmf27v2em00', '', 1778799183, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h6qa0f0552av7971ec5oc8j4ef', '', 1778798470, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h703k89c6n6h38un4nu6big8rh', '', 1778798627, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h7a72ce388f9btrfk9m35ljpjb', '', 1778799487, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h8s7skb0kb292nfesubdbtiuuk', '', 1780702030, NULL, '104.210.140.128', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('h912hi9757gpjgdk0rrvvv0rav', '', 1778798984, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('h9lh1alalc2abc86s3c5alv3s6', '', 1778799151, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hbjf0lv8a6ssips18j8jdu6mu6', '', 1779054814, NULL, '66.249.79.6', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('hblu67bubat6c7mc6qitl1dg44', 'Y3NyZl90b2tlbnxzOjY0OiI5MzZmMmE3YjRmOWRjOGVlNTM4NmFlYjE2YzcwMDk2Njc0ZjYxN2U5NmZiYTk0NjZiNWVjZmVlNDVlNGVmNTQ2Ijs=', 1779534170, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('hc4kn2dt47b6v6qht2ut0d5frp', '', 1778798696, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hca4n7h0q5vlpisdjf2rnbrcdv', '', 1779898823, NULL, '104.210.140.137', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('hcb7et4065291lmgnge5e2gp85', '', 1778798836, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hcqtsq05ruvnllu7ujvo735d46', '', 1780418719, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('hd052c8d1k5ivb70es4a21hm6a', '', 1778798939, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hd5a1fi4dlm8qvfhg51n8p6bao', '', 1778799014, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hdlcen27bhlfd9rq45gbqtq4hn', '', 1778799488, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('heukudk556mafjv3qlpoau2dpc', '', 1780012397, NULL, '74.7.244.19', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('hf9k15tgt7f1ponpv572o1e1nk', 'Y3NyZl90b2tlbnxzOjY0OiIzNmFmZjQzZjgyM2UzMTBlNzk5ZmQyMTkyZDY3ZTQ4OWYyMTJhOTYyNjMyZjMwNjc5YWNiOTljOGYwODkxNzVkIjs=', 1780683225, NULL, '192.36.109.120', 'Mozilla/5.0 (Android 14; Mobile; rv:123.0) Gecko/123.0 Firefox/123'),
('hfgihj0lv1jgirama12fm6d16o', '', 1780748681, NULL, '4.181.54.15', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0'),
('hfu0l003vrkqpi5foeh3lu1ir4', '', 1778799225, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hgbilfbt5r66dd2tl8mdb3mn00', 'Y3NyZl90b2tlbnxzOjY0OiJmNDcyZjFlMDMwZjhlYTNhMDg5NTJjZWYyNmM2YzMyYjBhY2FhMmY0Yjk4MjM5NTZmYTU0NWQwN2NhOTBlMWZiIjs=', 1779990833, NULL, '66.249.79.132', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('hhflg90134542o05vufg3frh5d', '', 1778798545, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hhqvlttlga68fu4jbgbknjrbn2', 'Y3NyZl90b2tlbnxzOjY0OiIxNGZhNGEwMDdkODBkODVmYjhjZTE4ZDllMDdjMGI2MjVlYmQ1ZGZiOWY3YTcyY2FkMDBhMTNhYTE2NTIyZDljIjs=', 1780240863, NULL, '18.183.206.236', 'longlist-research/1.0'),
('hj9ab5cb42p1st0t4ghpnm2e40', '', 1778799355, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hkcmfv8be4hbarmd8ejatqb4h0', '', 1779051435, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('hpk65gvgvdepojkktimg4rbhcc', '', 1778798451, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hqakf55oda7s1atnpd9fuepfcd', '', 1778799458, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hr8nbgl5f8a7oula1bk60gvfo7', 'Y3NyZl90b2tlbnxzOjY0OiIzMjkzNWQ3MTUwYzQ0NTljNDRiODE3MWYwZGQ5YmRlNTk0NzkxYjE5M2I2NzhmODY3MTk0YjAzNjMxMjcxMGVjIjs=', 1779977513, NULL, '5.133.192.140', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36'),
('hr9j10hgfde23499of4ss86ek3', 'Y3NyZl90b2tlbnxzOjY0OiIwN2Y5YWIzZGE2MTQ4YjI3ZDkzMGZjNjZmMjE0MDFjODc1Y2M3NDc5MGFhNDYyOWU3YTNkZWMwZDIzOTJhY2M0Ijs=', 1779285742, NULL, '159.65.32.131', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
('hrlofeoueskpe7ggbgpnt46ipv', '', 1778798717, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hs909u1q3a69hl7j80c2hc7q2g', '', 1778798549, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('htupss61a9vtmk5k1mi4fpgchk', '', 1778798846, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hu923iau28kbss0umj3vsoeo13', '', 1778798867, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('hunpd5eo6gsgu91eu4la36k748', '', 1779296177, NULL, '104.210.140.142', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('hv05it7q5jn9f2p8n7oiv66qm4', '', 1778798889, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('i02lif8nhqebn7uokunbak2gcc', '', 1778798997, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('i0e0rcfn0q4qluhp6p55v8hnv8', '', 1778799098, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('i0fc3855v6q4mf1sqqeeh0gued', '', 1778798741, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('i1nolj9k2ddemjsas0kf7irag7', '', 1778798983, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('i21fliolvbifi8bar8voup2snu', '', 1778799122, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('i2bdvv80rsq7n8tp1ulqed7724', '', 1778799234, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('i2hl1hl4h2rvlgo1q8uetjpvmq', 'Y3NyZl90b2tlbnxzOjY0OiI5MzM5NTQyMTU2ODNhMGEzZjY1OWFjNmFhMzcyN2FiM2NkZTM5NjU3ZmU3ODYxMDhjYzI2MDQ3NmIzNWI4MjAwIjs=', 1779113382, NULL, '149.56.150.167', 'Mozilla/5.0 (compatible; Dataprovider.com)'),
('i2ki541r2uqhtkdl83ueh4arl6', '', 1779922444, NULL, '144.76.23.144', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; trendictionbot0.5.0; trendiction search; http://www.trendiction.de/bot; please let us know of any problems; web at trendiction.com) Gecko/20100101 Firefox/125.0'),
('i3tlkcomuugk82arch2t1nl6rl', '', 1780089603, NULL, '52.167.144.55', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('i6g2t6l3pm5qatnsacm6qlmr7t', '', 1778799477, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('i6o61j2fmq16bc954oufnkpues', '', 1778799261, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('i84dssqsk4moki5q0u9amlop1b', '', 1778798660, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('i9hb7tpbshcuuop76r0uq5cnnl', 'Y3NyZl90b2tlbnxzOjY0OiIxMmI3NDgwYTA5MDdhM2YxNWM5Y2M5OGVlZmYxOTI2OTVmZTBhMDYyOTQxMmFhMjZhNzU5ZDdjNmVkMDMxYjE5Ijs=', 1779017696, NULL, '104.28.205.80', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'),
('i9rpoqcg2jchiaflf4phtm4rql', '', 1778799490, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('iadc6ohttrrtvqr5vgrdugerqf', '', 1778798878, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('iam97sr4qtt6b0vape2462ea4c', '', 1778798784, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ib3s102sbkaep98tpugd5jclgb', 'Y3NyZl90b2tlbnxzOjY0OiJhYmQ0MDE4ZTFiNTc1YTgxMmZmY2YxOThjNzVlMjJmZWYyMmRkNTIyMTk1ZGNkOTk0NWVhMmQ4ZDg0ODQyNmQxIjs=', 1780783431, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('ibn09r7u23smsam9khtufjbtjs', '', 1778798499, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('idtfocoonpcm4qm13co6cdgiee', '', 1778799492, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('idu6jankgm0ofvrc23ki4k6abi', 'Y3NyZl90b2tlbnxzOjY0OiI5OTYwYjQwMWJhNGVmYTM1YWJmODJlYTI3NTczNGZjOTJjODJlYTFiMjYyNGYwNjQyYzZlZTQ4NzhlN2ExNzhjIjs=', 1778847940, NULL, '2802:8010:8b77:db00:486a:9ca6:2f53:c092', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36'),
('ieuo2pa1jjh382onub1r33ndfn', '', 1778799196, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ifvi0ptqjbhgbm0nkdiustdrr3', '', 1778798729, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('igb0prv0rf8ovmeahr8o62l7m0', 'Y3NyZl90b2tlbnxzOjY0OiJhZjAwNWJhNTQ1NTNhOGI2YWNkOWY4ZGI5NTU0MDM2Y2RmOWVhNTlmMzJjN2VkMjIzYWE3ODY3OTVlNjc5YjNjIjs=', 1780318391, NULL, '138.197.93.186', 'Mozilla/5.0 (X11; Linux x86_64; rv:142.0) Gecko/20100101 Firefox/142.0'),
('iggrm9qc5abb68mbt46mte4sdc', '', 1778799040, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('igm6ffba8pf46g4a178tith052', '', 1778799359, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('igobgapuqiaq3qnl79i4vuubk7', '', 1778799160, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ih62kbnb1ie7ovuga4n6372gb7', '', 1778798891, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ihs62g69l2er2fpofc9qqo67b3', 'Y3NyZl90b2tlbnxzOjY0OiJkMTliZjU1YzU5Zjc1ZmM5MTMwMjJkMjIxOTk5OGI4NmRjNWZiODA0OTNlNDZlY2ExYjcwNWJjNzgzZjhmYWU1Ijs=', 1780342793, NULL, '40.77.167.62', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('ii4c2ghp6sioo0o7tngdl4mv4a', '', 1778799384, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('iiu1p45tdqso13rclhcu8t16ki', 'Y3NyZl90b2tlbnxzOjY0OiI5ZDNiZmFmMWU2YmY3MzI1MTkyNTUyZjBiOTIzMzkxZDE2YTQ1MmJhMDQ5YjcyZmU0NzQ2MmExYmMxNjNlNzc3Ijs=', 1780783423, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('ikam7bor2r61qsmn92nk5sef3a', 'Y3NyZl90b2tlbnxzOjY0OiI5OTRjMWYxY2ZiZmUyMTkxNjY4OWM0ZTJjNzkwYTQ1ZjYxZjc2Mjg0NDEzYmM1MGIyOWRjNDhjOTQ5YzUyZDVhIjs=', 1780783422, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('ikrumsi3v9qoujfgsaim2cm37c', 'Y3NyZl90b2tlbnxzOjY0OiI1NzZmYzkwYTYyMmUxYmFlY2JiZDg1Yzk0N2ViZmZmMDgzMGFkMWIwOWNkYmExZDIxODQxMTMwNDk0ZjAxMmFkIjs=', 1779093271, NULL, '18.158.189.225', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('iku09avlgmjadordric9hl91ja', '', 1778798587, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ilh691nmuv0j39604jun7jnpc6', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0'),
('im19if51c0noug6f8h2hd81vem', '', 1779051372, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('imlkrvepabl6ffeb6dgvjb44uv', '', 1778799022, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('imqo4snu1kqp4ovjtsiq6aotir', '', 1778798431, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('inidus1onbobdr0iasjs8hp4bp', '', 1778799342, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('io6ue30eq18dddrujqmt9n6q6o', 'Y3NyZl90b2tlbnxzOjY0OiI3YWI0MDNiMDJlNGM1YWViYTE5NzM2NDQwMDUzOGZmMzM3ODhiY2ZiNzRlNTVkNzNhMzFlNDM4ZjA3MDc5N2JiIjs=', 1779477115, NULL, '192.71.142.134', 'Mozilla/5.0 (Linux; Android 12; SAMSUNG SM-A415F) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/23.0 Chrome/115.0.0.0 Mobile Safari/537.3'),
('ipornb39fdccuaab2ppkf1oes4', '', 1778798467, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ipp6h0ig6t6didg2g5m8ef78ve', '', 1778798895, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('iqf9v4lmeng4cjfabcgkl33i33', '', 1778813928, NULL, '165.227.122.21', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36'),
('iql312223fjci93kmqm1cpasas', '', 1778799072, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('iqrteu8ku8ehfmsddpekrehk23', '', 1778799483, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('irb8gf5ko8n9h3ndvb9k9miudp', 'Y3NyZl90b2tlbnxzOjY0OiIxZjFiYjRhNTAyZWIzYzYzYTU2MDhkNGM4MzQ2ZmM0YTE0YWY3ODQxYWZhOWE5OGI5NzQ5ZWY3MTk3ZGZhNjkwIjs=', 1780272382, NULL, '66.249.79.132', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('irvfvs7fo4f1j8m3akm9ji4je4', 'Y3NyZl90b2tlbnxzOjY0OiI4YTkwNmRkYWE2NjExZDI0YWU1ZDU3NTRmZDQwZTA0NmEzZWFjNWNlZDU0ODcxM2JiM2VlNzU0NzFiNDkzNGM2Ijs=', 1778815234, NULL, '198.244.168.202', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('irvqt9pjnn416jh8smodrum2vj', '', 1778798588, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('isduacejepgi9454l6ker0ru6g', '', 1778798798, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('itfca5t3qn13qic3qs3kn4va1d', '', 1779225380, NULL, '104.210.140.130', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('ivd98r3itaaqo02grifhjlnb6a', '', 1779061694, NULL, '40.77.167.181', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('ive2g0r89ovon2mvn0jjpoiajl', 'Y3NyZl90b2tlbnxzOjY0OiJkYzg3MThmNzA2NmYyMDQ1YjAxMjI4MjA3OTFjMWY4MGIwNGJlYjlhY2QzMzViOGMzMmRlOWI3Mjk4MzlmMzljIjs=', 1779007205, NULL, '138.246.253.7', 'quic-go-HTTP/3'),
('ivo6m91hahk9ub56ei9st7eneo', '', 1778799108, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('j02d0c39nl3p0du3nnsv22ga4h', '', 1778799036, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('j0pmdimskobocmvgmibjisi008', '', 1778799397, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36');
INSERT INTO `sessions` (`id`, `payload`, `last_activity`, `user_id`, `ip_address`, `user_agent`) VALUES
('j0qp2eaag831eqcabf82bie27s', '', 1780779328, NULL, '66.249.85.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('j1s8ggoe2orsdo6974ns8puejl', '', 1778798664, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('j2reh7afv8b4o6s2uovgt06op5', '', 1778799174, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('j3b5u6khcnfutfo7f6sb6c9g94', '', 1778799203, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('j3s6c8ut607l2q21v8ocpnbatv', 'Y3NyZl90b2tlbnxzOjY0OiI3MzI1NWZhZjNlMTVlNGE1MmM1ZWQ5ZGZhYTk5M2Q4MTk3MzRiMzNmMmQ2ODcwODNlNmY2MWIzYWQxMzBkYmRhIjs=', 1779331148, NULL, '175.27.136.83', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1'),
('j55ug948jl99mr0a68vj05uhd7', '', 1778798513, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('j6a663kla7ttdm7qutpqoneqrg', '', 1778799307, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('j6brtruomlnk92b99m63pi1hp7', '', 1778799293, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('j6iokunvlr1nre7u1862lipmkp', '', 1778799141, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('j74vsl1t7v85ohmtvbgvsij7uc', '', 1780073381, NULL, '77.240.87.244', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0'),
('j7ceb0p8prfulqfc9bbt45jsoh', '', 1779158289, NULL, '104.210.140.138', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('j7ecge1tb8q88pur58siets3so', '', 1779051370, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('j7m4v7rel4efhquuislalk5qf1', '', 1778813928, NULL, '136.227.176.22', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36'),
('j81onp017un6jgm5cguia21ghr', '', 1778799153, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('j8m0r4nt83k2hnoj9i28gpcpb5', 'Y3NyZl90b2tlbnxzOjY0OiIyYzAxNTY3MDlkNzFjNmNjODkzNTE0NGQ0YTIwYzJjNWFjNTdjNjJhMzgwMDk4ZDQxNzc5MTFmOWJkNDc2OTc5Ijs=', 1780843252, NULL, '66.249.85.110', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('j8sf1eeeduuif1dsb6mnp67olt', 'Y3NyZl90b2tlbnxzOjY0OiIwMWIxYjBmNWUwMmU2ZjY5MTkyZDNmNmJiYjQzYmM2ZmExNTdhMjEyNTE4MzhjMGMyYWIxYzVjYzU3NTVhNjE3Ijs=', 1780666866, NULL, '64.227.138.243', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
('j999lb2noj1vq9gdmn76kacvr9', '', 1778798534, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('j9c2465l76v637p6f939hjkegd', '', 1778798857, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jalj56pom9p2a917ffusiampsl', '', 1778799389, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jardtnasae81mfnm9erc9m5sd0', '', 1778798748, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jb073nhbn15d242asc16g8nui2', 'Y3NyZl90b2tlbnxzOjY0OiJjNGU4NWNhMjIxZGRhZDhmMDc3YmM4OTc0ZGEzODBmMWJmMjM5NjU2MTk3ZTZlODYwMjg3OWI2NjRlODNhOGY4Ijs=', 1780714885, NULL, '100.25.180.254', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
('jbk1i87c48j754us0omt53qj1o', '', 1779265601, NULL, '74.7.244.44', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('jc6u489gidmkf6a483ktjr45kc', '', 1778798818, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jcl7si3u399icjd93cubvb9tqe', '', 1778799456, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('je9aku9p4mi78br51rmkl9s9oi', '', 1778799166, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jed3u9t3dja9jsopdmdm13av0q', '', 1778799086, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jf8fh9v11ivuhnbqeliqtuubha', '', 1779093176, NULL, '216.157.42.86', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('jflispbjkf14rmomlnlr8kln4a', 'Y3NyZl90b2tlbnxzOjY0OiI5YjcyOWRlYTczOGVlZWIzOTc4YjA4NTQ0M2YzMWQ0Y2UxNjE5NzE3MmY3M2U2ZGM4ZGY4Njg5MmFlNGRiNGY0Ijs=', 1778798407, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jg7ij6behtd8nkdkoe0r68v3i2', '', 1778798752, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jhe3ofl4b1m5am03rbkbca5sop', '', 1779093200, NULL, '216.157.40.92', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('jhrj9n2bkac50lul29030kf7ei', 'Y3NyZl90b2tlbnxzOjY0OiJjNjU3OTFjZTc4ZTE3MGUwZjA4NjY1MmUzNzk2NmJiNjFlY2I5YjUzYTIzOWZjYTYyYzllNzkyNDE5ODJlMzE0Ijs=', 1779113381, NULL, '149.56.150.167', 'Mozilla/5.0 (compatible; Dataprovider.com)'),
('jhu4l9n3a0jb9tbkk0mmorcrma', '', 1778798483, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ji67d18o4327kmvsjp9vnmr08t', '', 1778799090, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jibi5d54hok7qm3ei371hknbtg', '', 1778799350, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jil1ilmsa1um32pvfetv1fpceh', '', 1778798618, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jj53sifluo0du21biimnulnjfs', 'Y3NyZl90b2tlbnxzOjY0OiI1ODM3MTI1MzM5ODRmMGRlM2M0MzYwMmFkM2QyMjUyOGUyMjk1YzgwMmJhOTFmNWQ0OTJjMWExODQ5ODE4YjEzIjs=', 1780182762, NULL, '2001:13d2:2808::8', 'Mozilla/5.0 (Linux; Android 16; SM-S711B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36'),
('jjg7c37q2akbtn4cka3a13qnpm', '', 1780272793, NULL, '74.7.175.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('jjk10o9h3la77kr1o1bqeg5rh6', '', 1778799302, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jjr68t3jv6pgleq3024eugum7d', '', 1780418716, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('jk09og5p458jsb2iqavfn67git', '', 1778798776, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jld4t8shqr5tmt4dedk8hkjodv', '', 1778799114, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jm6vp27ks41okgshv4rar9j877', '', 1778798562, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jmphsqtti0n1nnpi7965rd0i93', '', 1778799316, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jpeieopcgnlvq5ecks3njsifqo', '', 1778798433, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jph70n7dl6pm0cq37d7u8385e6', '', 1778798770, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jpl914kqm17fqvi9cucn14udl9', 'Y3NyZl90b2tlbnxzOjY0OiI1NDcyZjE1MWIwY2FhZjdiNWEwZDRlYThjZGY2ZmJhYjM5OGRhMTk1NzI2MmZlNTliNjIxODUxODc2Y2U5YzY5Ijs=', 1779871983, NULL, '192.71.12.10', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('jprkva8bf634unpbf45746vsjc', 'Y3NyZl90b2tlbnxzOjY0OiJlYTM3MzQwMzQ1NDlhNGUwZmE2ZWM3ZWIwNzAyOGE3NGQ2ODY3YWQ4YzFiMjQ2OGM0MDg0YjUyYjAzZDJjZDljIjs=', 1780063731, NULL, '34.203.11.88', 'Mozilla/5.0 (Linux; Android 7.1.1; XT1710-02 Build/NDS26.74-36) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36'),
('jpuj11bl56jrq8p1ot37nm5l6h', 'Y3NyZl90b2tlbnxzOjY0OiJjZTU5NTU2NDVjODc0YTZjYWNlNzcwNDMwMWYyMGVmZjhjYWFiODAzMDgwYTcwMGEzYTQ0MjUzZjFlNTc4YWIyIjs=', 1779113402, NULL, '144.217.135.236', 'Mozilla/5.0 (compatible; Dataprovider.com)'),
('jq639bt0ieclci6hrgqmmr2vhq', '', 1778799376, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jq953ge2v1ibv8biif9ib8c7s1', '', 1778798757, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jqh01rf4vs1b8cb3l4a03n9rs2', 'Y3NyZl90b2tlbnxzOjY0OiI1M2RlMTk2ZmI5ZjZiZGNjZTcyZWY4MTZlZWI4M2VjZGVkNGQ2ZWNiYjUyZmYxNTAxYjY0Mjg5NmI1YzhmNzVkIjs=', 1780218199, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('jtlcivgtmaiupfvaegspikbulv', '', 1778799143, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jtlotafs79vp3k1m46e315bqa8', '', 1778798860, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jtq90vlt88618gjfa97brl8ge7', '', 1778798461, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('juoqj86o13u3rej4a539tg8us5', '', 1780194090, NULL, '74.7.175.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('jv6u7p5t36nok0ofqq7kgogcs0', '', 1778798665, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('jvtn0tsssgv5nsalrvs0hss719', 'Y3NyZl90b2tlbnxzOjY0OiJjNTBhYTM4NmQ0OGYxNmY3NDk3MzU4MjQ3NzhhMjUwYWQ0OWY4OTQ3NjBmZTczYjcwZDVkNDI3MDk0MWU4YzgwIjs=', 1779305327, NULL, '192.71.2.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('k0cro355979lcbds7h0heodth6', '', 1778799167, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k1eb7b03sr3rgj5evj2b8j7rje', '', 1778799236, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k1kedrd81vnnjcu14p30is69dt', '', 1778798449, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k26893anetf84t7sgtr17raou4', '', 1779405513, NULL, '35.209.102.135', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
('k31b3kgjbj4h4n6rc5ank7a7f6', '', 1778798700, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k3o36s071677dbsq3r144jjl5n', '', 1778798782, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k41a6jaigi3s62aeao971p3srf', '', 1778798841, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k56768cqnr3uovikvnkcbmufbo', 'Y3NyZl90b2tlbnxzOjY0OiJhNDhiMTEzNDdmYjkwNzdlYWU4NGNiMjcxYjBjMTFiOWM4Zjk4NjdjOWI5MjJjNjQ3NjViYWM4ZTIwYTRkM2I1Ijs=', 1779720343, NULL, '2800:40:3a:bd0d:b91:2606:6f7f:2285', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.172 Mobile Safari/537.36 Instagram 430.0.0.53.80 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 974607439; IABMV/1)'),
('k5e7eoptnf27q80578rfv38d4t', '', 1778798739, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k6fln4qcs9sqdnhqc2bifu4d2o', '', 1779973090, NULL, '104.210.140.136', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('k6frliarmvj414s5if1vt8qm83', '', 1778799429, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k6n5e7uhf6pjhbn6vksbmli1mu', '', 1778799100, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k6qnqtf9sued3bfa1l17hv6dts', 'Y3NyZl90b2tlbnxzOjY0OiJkYTNlMDc1NTQzMWExMzY2MzIzMTZkYjQwMjczZDQ3ODljNzMzZjA4OTJhOTE2M2QxYWJmYzNmNWVlNTU4ZGRhIjs=', 1779552204, NULL, '198.244.168.223', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('k6srur78vqf2hu1lttgchg6qk8', '', 1778799000, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k7n5u2d7hiig4rno4i0qv3tj26', '', 1778798430, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k7nu988tnk8jj5c9rms60obqnk', '', 1778799428, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k7pohe4ogh4qcmd0eivhl9nj5j', '', 1778798679, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k7ppm392peb4htv4ri93smjcps', '', 1778798774, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('k9tvcji7rh27u6r3u88gco8dv5', '', 1780793157, NULL, '2a02:4780:27:2004:0:d53:da4a:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('k9v52ftq8387792bjnu7l2nd4r', '', 1778799131, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kahttcvl8harivsmajvi8sq2sp', '', 1778799434, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kau72k01fan19ooc74kcut76uk', 'Y3NyZl90b2tlbnxzOjY0OiI3ZGQ4Mzc2ZjFmNmMyODhiZDhmMDZhNmMxMjVjZWY4NDBjNjNlYzQxYTJjMjg4MzJjYWIwMzc5ZDc1ZmVmNWM2Ijs=', 1780573349, NULL, '23.234.81.87', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.10 Safari/605.1.1'),
('kb23ur3qe77jjmlnsuh9flk7iu', '', 1778798839, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kbdna3s1doacoqd3oa4tcegujg', '', 1779392524, NULL, '2401:4900:1c84:ff2c:7820:18ba:2f93:83b9', 'Mozilla/5.0 (Windows NT 6.3; arm64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'),
('kd8qsnirbhs3ge95cassmb1a16', '', 1778799260, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kd90pec0prcj674dfuak7fafo8', '', 1778798640, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kdfma4mk31sakplei5hao8gndf', '', 1778798669, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kdhmrvk509piqgmtkcgu3abcvv', 'Y3NyZl90b2tlbnxzOjY0OiIyYTQ3YzU5ZWQ0Y2Q5YzE5ZTA5ZTVlZjMyYjY4ZGY5YTJjNDgyMWI5OGM3YTExYjE5YTRhNzNlODJiMjQ3ZTg4Ijs=', 1779990835, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('kdjafm8tft9kfrgvengfbip73s', '', 1778798985, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ke2sbaguapp2t699332s8mta9m', '', 1778798900, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kecp94925o9bkifhnierkgjumi', '', 1778799176, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kesg5jf262e2pgu1a0eqa7g4dg', 'Y3NyZl90b2tlbnxzOjY0OiJmMGE1MzY1Mjc2ODgzMTgzNjE0YWRhNjBiNDk5MDU1ZTdiNTkzOTY3MDYxODQ0NjFmODdlNzBkOTY2NDk3MWFmIjs=', 1778831223, NULL, '198.244.183.169', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('kf386k6rbrb75iqi2boije3qh6', '', 1778798770, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kf5n53n57ts4l24itj51mdet97', '', 1779573346, NULL, '62.210.122.147', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36'),
('kfe2ke8kqa7nh5mbtd0v2daqdi', 'Y3NyZl90b2tlbnxzOjY0OiIyNTIzODI3YTQyNDNhYTc1NGYyYjQyNWMxY2FlZWQyNGI5MzA1Yzg3OWEzYzcwYzQxMjMyZDBkMWUwOWEwZmNlIjs=', 1780470208, NULL, '13.221.215.33', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36'),
('kij1vfr4qhrnuguuv8bi89khno', '', 1778798775, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kja1jee115tl7o9h0on5eo4c6g', 'Y3NyZl90b2tlbnxzOjY0OiI5NzIwODUyMWQ5NzgyM2NhOTg3NzY4NGNiOGY4MTNkZTQwZmE5MDhkNGY1Njc2ODQ5YTYwZmJlNjZkNWE2OWMwIjs=', 1779415449, NULL, '18.219.176.173', 'curl/8.3.0'),
('kjrk2ef7k72m4lnjth151dp90d', '', 1778798945, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kjskmajh83jpv9cjjdm0iqtkdh', 'Y3NyZl90b2tlbnxzOjY0OiI0YWY4OTA0MmExMDVkMGYxOTU2MTMxM2U3ODM5MTFiNjdhZWExYjU4MjUzNjQ5NGM4YWViOTFmZDhlNzA1NzVmIjs=', 1779814045, NULL, '52.167.144.195', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('kk2lt983smrtgqo1a11mfpe5ed', '', 1778798589, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kkii27lnibqt1hii459ht3mmdr', '', 1778799170, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kli4fva0mm5hjc6aag01sa7039', '', 1780418714, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('kmspen1gut7v39k6jbp8tfug5f', '', 1778798893, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('knamnknddsbnscmjjj29iunfjd', 'Y3NyZl90b2tlbnxzOjY0OiIyZmU2N2FmOWJjOTI4YTZiNThiNzA1Mjk2OTJlYzRiODUwNDQwMjRiZWU1OGM3NDI5NTk2MjdmMGRhYTdjMGUxIjs=', 1778857864, NULL, '157.55.39.60', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('kng8pjeb1b6v453kci4c9fepcr', '', 1778799419, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('knm11jcda1gju4614748n1tn8k', '', 1778799363, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('konn21pt415djeffpkm0jmf3jf', '', 1778798794, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('koov2hdekrr5k6na5ft48q59ne', '', 1778799035, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kqk65502njrjjevortlcf1obr7', 'Y3NyZl90b2tlbnxzOjY0OiIyMGE5YjI4YWI5OWY4YWY5ODYwZGNlZGViMDczNWNlYWUwNGJmNzk4NzIwZjFlOTYxOTEyMjVmNWU0NDJmNmViIjs=', 1778882428, NULL, '157.55.39.11', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('kqpjord4pd5pq5poaob2tmiuu7', 'Y3NyZl90b2tlbnxzOjY0OiI0MWJlNzBiMTk2MTJkN2JjNWY5Zjc0NmZjZThkYTFmYjc5Yzk1NGFiMTIxZTgzOTkzMWQ2MTZmNzRjNzIyY2JjIjs=', 1779045826, NULL, '46.17.174.172', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:98.0) Gecko/20100101 Firefox/98.0'),
('kr13d85nrvg40odknnu51jebvj', '', 1778799375, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('kra2ti5p3h22qbsirteshkv40t', '', 1778798497, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ks1llmp0kg5tttk1fcq8av3vkr', '', 1779051364, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('ks562g5eh5bj5ail62n68fe6ra', '', 1780850573, NULL, '207.46.13.229', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('ks7gnm21tds8ukbg5jvfebr1ku', '', 1778798931, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ks9o5geurq5vb8tct3t217j4um', '', 1778799424, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ksisus6i37ga7dc0akagbp304t', '', 1780418713, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('ksrfvs3ll2v2gdt655p4aumsff', 'Y3NyZl90b2tlbnxzOjY0OiJhN2Q4MTQ5YTY0NjMzMmZhZDJhNWRiOTFjZGFmODQ2NDMwMDk5YjU2MDE3NDliMmJlNmZjMTQyZTgwN2I5YmZkIjs=', 1779590105, NULL, '192.71.12.181', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1.2 Mobile/15E148 Safari/604'),
('kth3odf6ck78qakk62ubf7et94', '', 1778799112, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ktjvd9vcb0d7eks21g9f44q26m', '', 1779091876, NULL, '54.174.58.251', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('l0ok6c53qj7e1ajfr9omvk4iqm', '', 1778798988, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('l37ha5fv0p4mhlnbg3rilkp186', '', 1779973855, NULL, '2a03:b0c0:1:e0::c00:9001', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'),
('l3la63n3lva0c77bgl2qb58upf', 'Y3NyZl90b2tlbnxzOjY0OiI5NWZhYjY4YWU4MmVjNWNiMDVhNGRiYWVmMzgwODk0ZjdmODgxZmRhNDgwYmI1M2UyN2RiZDUwMDlkODhmNWY1Ijs=', 1779720424, NULL, '2a03:2880:18ff::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('l4d7sdvqjorc519lud3k33pnfo', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36'),
('l4f63fgm2d8089eo6omis3aa56', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('l5hs7oli7a52djiaitc2s0of6q', 'Y3NyZl90b2tlbnxzOjY0OiIyNTJmNjNjNDg3YzA3N2JiYjdhYWNkYzhkZjA5MWE4MTk5OWU4NzYwOTc3NGUzNDAxYzcwMzMyZDhmNzk5MzIzIjs=', 1780084541, NULL, '205.169.39.2', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36'),
('l6tklnvogj215085e69qpq20h9', '', 1778798842, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('l8hkq22afe6thgiev2jrdvv3mg', 'Y3NyZl90b2tlbnxzOjY0OiI3YzA5MzYzYzQ0MDhiZTcyYTFlZjQ4NDVlMmZjMGYxY2Y4N2NlYTI5OTc2MzViNTdjNmM3Y2U5MTVmODM1NjRkIjs=', 1779347866, NULL, '54.213.236.174', 'Opera/9.80 (Windows NT 6.0; U; it) Presto/2.6.30 Version/10.61'),
('l9a7t4od1q0shar1urhd29rp6e', '', 1780334918, NULL, '2a02:4780:2b:2028:0:cf8:d000:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('l9bithutrk1ak1fc7ej9313ti4', '', 1778798459, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('la1qg842schcdf57j0k6nm1f0f', '', 1780289376, NULL, '52.167.144.173', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('la8lf2fr9hrshsua2impg9a2a3', '', 1778799287, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('laooaaqfo7h6psmlmq24gdtnmb', '', 1778799191, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lavj0djuuevb1mfkrh8dljdoev', '', 1778798663, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lba8f3mk71vag22pfg8fa1af53', '', 1780411732, NULL, '104.210.140.134', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('lckulba13rg255c382ipanqmt8', 'Y3NyZl90b2tlbnxzOjY0OiJiYTQ4Mzk1YmFkYWViMWE5ZmZmYWEwNDNiYWU1MWU3MTJjZTZhZTNjY2UwY2NjNmRlMGE4Y2ZhOTQxYzMwMzZiIjs=', 1779805420, NULL, '40.77.167.13', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('ld2u86jmo0fmcaf1dq3hsg0vda', '', 1778799476, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ld6hcjto2qeqo0qculdsrmussv', '', 1778799348, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ldqd3n6ueo77htucf1fc4fd53u', '', 1780417682, NULL, '40.77.167.53', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('ldvkimt3j0qpccrqd3lr2scgee', '', 1778798482, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('leaab1mi3abjverf4kvad9r1si', '', 1778798561, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lf0g0g995oaedu5c4vvlmo4r01', '', 1778798832, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lf1ob3tiiv7a9vl60rg3p2n3rt', '', 1778799347, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lf9026p63a8v8ig65smc5tikas', 'Y3NyZl90b2tlbnxzOjY0OiJjZWFjZmU1Y2VlMGY2ZTQzZTIzYmNjMjNkNGQ4MzJlOGMyNjc2ODU1YTQxMjY3Yzc0YTg4NGRhYzAyMWMxMTMyIjs=', 1780835098, NULL, '142.147.128.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36'),
('lfhokcaa057sffp40uph6rp0qk', '', 1780552865, NULL, '74.7.175.172', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('lfjft0ijoj24mmvqkhc2l04lal', '', 1778798494, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lfqe9rb2vjpam1o79gn2pabshq', '', 1780272796, NULL, '74.7.244.19', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('lg0om9oss6rr0h4mrf5jr43622', '', 1778798551, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lg54jmtot3j42oaj775o0608te', 'Y3NyZl90b2tlbnxzOjY0OiIxYmRmMzQzNDYwM2JlODkyYTg1NzdhYmVhZmMyZGZmZGFmZGVlZGE4MDdjZjMzYzU4OTAzOWM1Njk0ZWMwYzI1Ijs=', 1780516425, NULL, '2800:2260:4000:49:65b0:3a44:5245:3327', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36'),
('lg5vaaj3457oe0l71gtcglcilb', '', 1778798735, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ljb3upqu7f96sn5jer0gltvdk3', '', 1779974583, NULL, '139.59.119.151', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('ll8gpacef0pb9mq8tihbcdcucd', '', 1778798637, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ll99kvkgf8019mtlvtfd564ooj', '', 1778798612, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('llkf3h66s1sqhr4u74vq2m2ohj', '', 1778799091, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lllffqjc52stccu9gnhmnp8j8g', 'Y3NyZl90b2tlbnxzOjY0OiIzMzBkNjUwZjg5YTEzMDg1Y2ZkN2Q4M2MwMWZmZjI3Y2U4NmM3N2Q2ZjE0MmNkNmYxZTM4YmE0MDM2MTY3YzZjIjs=', 1779615883, NULL, '52.167.144.214', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('llncnv3ukth2eb2pn5i9t5psfo', '', 1778798737, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lmabijsuh2gtpuo0p9kdt1voej', '', 1778798688, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lmfnbasgo9uv45g1eha961tufo', '', 1779990797, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('lnbqvi7bb5c3rlbqmm2u9tl41c', '', 1778799027, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lotmdrdbartrnba2ahtsj2pn78', '', 1778798781, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lq2l0u9ckb9luu5j6giaj3eiio', 'Y3NyZl90b2tlbnxzOjY0OiI3MjdlMWM3ODc0MmE2ZWZiMmQwODc4NWYwNzcyYTc2YTlmZmQ0NjczOWI0ZWVjNzIyZGE2NDM4ZmFlOTFkNDIxIjs=', 1779629378, NULL, '192.36.109.82', 'Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115'),
('lqak1oe0oecharuljl8t5qr65b', '', 1778799258, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lqgad5frrgrd6s2oul7rcf3idh', 'Y3NyZl90b2tlbnxzOjY0OiIzMjE4OTVkOWExOWVhM2UxNjg2MmJmMjM2YzhjYzk0N2NhZjVkYjUxY2JmM2E5ZjRjYzA2OGRkM2IyOGNmZGU1Ijs=', 1780783431, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('lr7utm3kahhj611clbc7e77ubv', '', 1778799346, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lrhbvtv41ubvn4s96k3ffgj60t', '', 1778799495, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lsifubelcqv0ojs8vm9f63q7lr', '', 1778798858, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('lthkp34me567e8meam5r2krtlc', '', 1780195580, NULL, '2a02:4780:27:1279:0:3a0c:b695:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('luejcblmpg67snir58p57mcicp', '', 1779093287, NULL, '216.157.40.94', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('lvdq9nro06tjbrncbpmohk47u2', '', 1780483449, NULL, '2a02:4780:a:1756:0:fee:342e:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('lvj14omnjajj6klsmqclid0nd7', '', 1780356963, NULL, '74.7.175.191', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('m075jhv4h0l0hk7are8gr1jl2p', '', 1779762972, NULL, '74.7.175.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('m0ent94drfsqkjpuen3ccgp02m', '', 1778798755, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('m2f0nm520n2101o8p53s00o4k4', '', 1779973091, NULL, '104.210.140.136', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('m38tq8k2uv21ie5g8p5gg3noau', '', 1779295695, NULL, '2a03:2880:24ff:4b::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('m3ehut9uk411rdu2l4u8nb0jj9', '', 1778799415, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('m3gtt5q3bbm2mon81ednl98h04', '', 1779903317, NULL, '176.31.139.24', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('m3mrr6vnl1k2j8m9a42a4jt6od', '', 1778798887, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('m3r64s19cphsflaknsn1ffd771', '', 1779568004, NULL, '161.118.210.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
('m4ohh3lndmr0e34l6ulkaabl86', '', 1778799200, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('m51ggbjv2kusjhmdq3097jbuip', '', 1778798932, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('m64d51338mhbamtclsa0lqhsks', 'Y3NyZl90b2tlbnxzOjY0OiIzY2QwYjBiMDFiNGEyODJlMmE4NjBhNWQ3MWZmNGY4MDU4ZjI1NmU5N2EyNDY0ZGJhOWI0ZGZiNDI2NTlmNzZiIjs=', 1779625495, NULL, '188.166.122.197', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
('m6e3422av2qngtkjc6pjn0k61p', '', 1779051365, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('m74c3pt7jk8mt1555lctad8obj', 'Y3NyZl90b2tlbnxzOjY0OiIwMjAxNDk1YTU5NDMwMWEyM2MwNmYzY2FiMjYwZDg4M2FmNjlmMzc3NDJiNTYzOGU3ZWMxNzVmMWRjOGM3NGUyIjs=', 1778902979, NULL, '51.195.183.218', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('m7cjh9keihn6kujktlhm5ror1f', '', 1778799472, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('m7eju6pcch3s610fhfnjkf2vj1', '', 1778868289, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0'),
('m7m0f2ae3qope1ud82kfav2s5v', '', 1778815233, NULL, '198.244.240.175', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('m7v8f02581tnds6ceqr17mejd9', '', 1779163196, NULL, '51.68.111.216', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('m9dmqbof8g1e92u6i6p9dk4g9p', 'Y3NyZl90b2tlbnxzOjY0OiJjMWVlM2JhYWE5MmRmNTcwMTE4YjRlZmExNzQ3MjhiM2Q2MDgxNDYyMmJmZThlZmVkODY0NjEwZTQzOTgzYzAyIjs=', 1779459206, NULL, '52.167.144.182', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('m9eki3rbro87bcotilce9godb5', '', 1780793157, NULL, '2a02:4780:27:2004:0:d53:da4a:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('maa4k9104hun9ufolpmdqmov6j', '', 1778799012, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mag84kf5m4j4qe94ejksvt27om', '', 1778799045, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mc1h8qf1q4pl86mcslo0lhd843', '', 1778798863, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mdjomvt1f9oqadv4iq8i1ek6er', '', 1778798872, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mdv69shvdkqm67i91pkh7810gl', 'Y3NyZl90b2tlbnxzOjY0OiIxYWYwMWRlMGE1MjRiMTlkNmE5MjZjY2U2OTdmMGY3YzQzMjVhYmRjODBmZDUyYjE3ZDE0YmVmZWQ5Nzg2YjYxIjs=', 1780783430, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('me8demta1jkapm7gb0h5hj6rii', '', 1778798743, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mefce2atlaeql1sh8me9c1qc12', '', 1778799246, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mepls8u1u8hq5aoiodc985tv1v', '', 1778798594, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('meuuhrh58hevjilau3a252ipoa', 'Y3NyZl90b2tlbnxzOjY0OiJlOTM4YzFhY2ZiM2U1OTJhNDYxYzg3MTM2Y2Y2NGQ3ZjE0MTVlZmIyOGI1MzkxNzc1M2QwNDM3YzFjZTJjYzZjIjs=', 1780849978, NULL, '2605:f540:1:5:fb0c:5:0:2e14', 'Mozilla/5.0'),
('mf1qd8fvlr9buh6gikh5bmb97t', '', 1778799109, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mg14g99l06t85e6mctmecc2501', '', 1780418704, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('mi5l1dn8q7e5f1ock2v91d9f8j', '', 1780783425, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('mj0sjaf62j5rj4s34mp8kumnab', '', 1778798958, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mjb5v094htom75v3jcnc5pc98o', 'Y3NyZl90b2tlbnxzOjY0OiI4ZGVmOTZjODkzZTU1M2QxM2I4M2Y3NWI5OTU2ZmE4MjgwYmRhNTgwOWE1ZmNiMWE0YmNiMzUzYjUzYjM0MmRkIjs=', 1779208773, NULL, '5.133.192.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36'),
('mjb8454kiafrv47c3bf72s99v4', '', 1778799150, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mjsheprren68iddo0vntpp2vjl', '', 1778798556, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mk370nrsjh4g86blsg2un4n9un', '', 1778799340, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mki67lajn58er9qa5ruij2o8ag', '', 1778798880, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mkn0kor4p3nk91tej6j7flf3hv', '', 1780062283, NULL, '93.158.90.72', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Mobile/15E148 Safari/604'),
('mktkka28lcmpo44i8r371fn1do', '', 1779093150, NULL, '216.157.41.79', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('mljkrkiqo14gb02e9f0ke4c8qv', '', 1778798705, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mmqhnsuo63vpjsimdgkjvdhfon', 'Y3NyZl90b2tlbnxzOjY0OiJjZTExZjU3YzQ5NTY2YTE3M2E1ZTA2NTYwMDRkNjJjMzgxNTk3NmE5YTRhMWJjMjVjMGMxZTIzOTkwODJjZjY3Ijs=', 1779556651, NULL, '186.157.53.40', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36'),
('mnbq70a2p1p4ja2o10a4e7o4kt', '', 1778799303, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('moc5otc3q2gfph51f0stt4mqb4', 'Y3NyZl90b2tlbnxzOjY0OiJjNjQ2Y2I3YmQ3NjhiYzFhNjgzMGRlOTI4M2QxMjg4ZmYyZWJjZDlmMGEyNTk2ZjlhNDY5Yzg3ZTUyZGY1OTFiIjs=', 1778815475, NULL, '35.252.76.201', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36'),
('mogudq98o6nb8i421a29hb0q21', '', 1779034208, NULL, '66.249.79.7', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('moqb0so5mf3fhbs7n431tcqfq5', '', 1778799173, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mpdh9epu4onk6rss1f4t8b5t2t', '', 1780161257, NULL, '2a03:2880:11ff:5::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('mpkcpg58492ktvtqj7o44clcem', '', 1778799378, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mq40grq1f48krfsb9p220jr1lg', 'Y3NyZl90b2tlbnxzOjY0OiIyNjcxYTkxNTk5M2IxOTg5MWNlY2JjZWFlY2E2MjNhYjZlMTRhYmNmNWVhYTQ1YjBmN2YyYWVlYjQ0MmZiNDc3Ijs=', 1780683226, NULL, '192.36.109.105', 'Mozilla/5.0 (Android 14; Mobile; rv:123.0) Gecko/123.0 Firefox/123'),
('mqhsopm98oebs03gpr2g290omv', 'Y3NyZl90b2tlbnxzOjY0OiIxNjdjYzA0N2RhZDc3OTYyOTM2MjNkNjIyMTIzMjkzMDcxOWQyMDMxNjZmODFkYjc0YTE0ZmJkZDYyMTY5OGM1Ijs=', 1779341486, NULL, '137.226.113.44', 'Mozilla/5.0 researchscan.comsys.rwth-aachen.de'),
('mqktv6369kj8si7on8565mlgvi', '', 1778798491, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ms1jomgbbn7fs26d38hh3gvbsh', '', 1779572032, NULL, '52.167.144.204', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('mt143d0kmvvph9v977qaito4i7', '', 1780529531, NULL, '2001:41d0:701:1100::abb3', 'python-requests/2.31.0'),
('mtiteksoqqcjfpj6uaprvhcunj', '', 1778798995, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mtnn9knkpj2d43bk8lg95qs2vp', '', 1778798808, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mu3iv7hb53fdinhdc5mb50h3dp', 'Y3NyZl90b2tlbnxzOjY0OiJmZjVlYTc1ZWU1NzRiYWU4OWYxNWJhMzlhZDVmY2QyNzBkMTgzNjg5YTgyYzU3YTk0MThiNzYzMGQ0YzdhNWQzIjs=', 1779496227, NULL, '66.249.79.134', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('mujtnjslshut82c0m20skfp1re', '', 1778799214, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('mv3et89bk9n7825p2n1n01q4qe', 'Y3NyZl90b2tlbnxzOjY0OiI2MTYxMDMwNmRjZDA1YWNiNDZhOWEyNzdlMDY1Yjk0ZTZlMTIyZjhhNzY1NzkxNjMwM2YyZjYzYjg4NzhiMTYzIjs=', 1779051363, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('n02n0pfpi9iboaq8hvi40ffsl6', '', 1778798508, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('n0dblsjjrrtnpjkm1rjehmp6qn', '', 1778799394, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('n0qligprncsdcurqjqn0tik3uf', '', 1778798509, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('n15pdb9lfrj3l6tgv2h2819dlb', 'Y3NyZl90b2tlbnxzOjY0OiJjYTc3OGE1YzI3YWNkNTY1YjFhYmVhNjlmMWQ0ZGQxZjlhMDg0NWQ1ZmE5NDUwNGFlMjRmODdhMDlkNjJiMjQxIjs=', 1780228311, NULL, '192.71.126.245', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123'),
('n1uq70kvq7vg3c7gcv3flg0p9n', '', 1778798790, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('n2f478lohhssloj5jt45tt8gbj', '', 1778799247, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('n2jpblc5et1bn7952s897bh8e5', '', 1780046393, NULL, '104.210.140.131', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('n3ep5k3kp4t9p8704i6pie3bmo', '', 1780418711, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('n41vo7tc6ob4tdcp1kdmg87h7o', '', 1779015235, NULL, '68.183.237.250', 'python-requests/2.27.1'),
('n6d1s7rkadrv04qlo16or8upao', '', 1780324142, NULL, '178.128.118.6', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('n6engkj1p1idvddncoig0a8goh', '', 1780699933, NULL, '138.246.253.24', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.134 Safari/537.36'),
('n6pl2o1k859dp15ltl5a3sdi78', '', 1778798961, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('n6tcp284393t3k4bauhfnjtt04', '', 1778798840, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('n73gtmnj94485mjao34vbgtuer', 'Y3NyZl90b2tlbnxzOjY0OiJiNzcxZDdhMTExYmQ4NGUxZGViYTMxNjJhZGM4ZWUyYmM4ZmEyMmVhYmUyZDcxZmRhZjM1N2MzNWRmMDk2NDBjIjs=', 1779208128, NULL, '40.77.167.17', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('n7dlq0f325qtb7bq8a75gnf5ou', '', 1780046397, NULL, '104.210.140.131', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('n7gbavgd87ah1kqdjr3efflsqi', '', 1778798527, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('n877bm64mn92ds12jgan6s7h4p', 'Y3NyZl90b2tlbnxzOjY0OiJkOTVkN2Y3NzI3ZTA5YzdlZTMxNDUxMWE5MWI5OGE3ZGFlOWJiNWYyOTIwOGRhOTY5MTY5MWRlZTJhMzdhYzFlIjs=', 1778813928, NULL, '45.33.155.93', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('n8nn0ntrhv7scl1hhu1mqusg5h', 'Y3NyZl90b2tlbnxzOjY0OiI2MTIzNzBkNDE5MGViMDc1MjU5NzEwMjU0MjNhNzQ1MTY5YjNlNjc5NTNmNmUyN2YwZjcwMThkZmQ4YWEwMzM5Ijs=', 1780328301, NULL, '34.86.146.124', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)'),
('n8pautcgp1e44n0ashjpb87csc', '', 1778799333, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('n97n4v6k7coc6pdr09fofbap3l', '', 1778798982, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('na7ig8l97n6f46bf2ljafhakj8', '', 1778799356, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nbf4he41jlq41sk8159kv35jgq', 'Y3NyZl90b2tlbnxzOjY0OiJjN2Y3OWQzYmQ5YjE0MzE1NzBiYzZmMTY1N2I0NTk0NjQyY2IzYjI5NTRkODk2MjJhNjVlZjM4OWVlMTExYzQ2Ijs=', 1779194553, NULL, '34.23.201.38', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)'),
('nbi7kqmakepbp8cgasalfu1hq1', '', 1778799326, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nbj4md1aavmvtqkisolbe8udn3', 'Y3NyZl90b2tlbnxzOjY0OiJhMTg3YzZhMDIzYjc1NDYyMzRhMmZiYmViYmE3MDBkMjJmYWEwODkyMDZhYWRhMTNhZjk1ZDc2MThmYjRiMmE1Ijs=', 1779741543, NULL, '217.79.116.205', 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Vivaldi/5.3.2679.68'),
('nddi6m5rr4jch564r0llgrdbm3', '', 1779887677, NULL, '2a03:2880:18ff:47::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('ndis4g2gj60fkth2lruu3goed9', '', 1778799281, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('neui5pibuhmlrvsl8m34kp1nt1', '', 1780561284, NULL, '45.59.17.2', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('nfb4nfrtul8cu5j5tuisgimr9h', 'Y3NyZl90b2tlbnxzOjY0OiJhYTdhYzA4ZmMzODAzYWFlODJiODUzZGJlYzE4MDYxOGM0NTA4MjNhOTUxN2JlZmZkZTVjZDQwYjdmY2QzNjliIjs=', 1779023617, NULL, '185.13.99.111', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Mobile/15E148 Safari/604'),
('nfgmkbon8s7b2034h2tvk573pe', '', 1778799018, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nfn0ump3bo1i4o7vj2qore4m83', '', 1778799133, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ngfj3q3oj1p3m24hkm5ait1o93', '', 1779552202, NULL, '51.68.247.210', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('nh3qc66lhl9osodmd057vehl82', '', 1780418706, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('nhb2lg51nemvmra5pfmd7qa44m', '', 1780334338, NULL, '136.144.42.233', 'Mozilla/5.0 (Windows NT 10.0; Win64; rv:143.0) Gecko/20100101 Firefox/143.0'),
('nhilfsucekuj39kobktrtrrbv9', '', 1778798666, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nimia88m2eekfbmmpbd4ja65bv', '', 1779405514, NULL, '35.209.102.135', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
('nio7p11lqs5cnj0i09soq3dgqn', '', 1778799053, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nivikrghc15uaufhenip3lmdpc', '', 1778799446, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('njodvppfug95apb33nfs726510', '', 1778798797, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nkfl5hmr80r0rtqujjbqhsn854', 'Y3NyZl90b2tlbnxzOjY0OiJkMzY3ZTY2ZGQyMjJiODUwOWM3ZmZjYTlmYTM2MDI4MTk1YTlmODA2ZWZiNTVhZGMzOGYyMTk3OTk4NDk2M2E4Ijs=', 1779341485, NULL, '137.226.113.44', 'Mozilla/5.0 researchscan.comsys.rwth-aachen.de'),
('nkm25pon4iusallqmt4jpd7qv9', '', 1778799300, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36');
INSERT INTO `sessions` (`id`, `payload`, `last_activity`, `user_id`, `ip_address`, `user_agent`) VALUES
('nkqpr0gl01nt11h5g8ineo3h78', '', 1778799386, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nkrlscnma49vt61t3733cbkmdj', 'Y3NyZl90b2tlbnxzOjY0OiI3YmJlNjNhNWUxMjAyYjZiMDZhZGQ3MWRiZmIwNTg3ZDJjMDQ5ZmNlYzZkMDkyNTU3NDQ0ZWJhNzZmODllODEwIjs=', 1780463726, NULL, '71.56.88.74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0'),
('nlps4tif7fro34h15kenbttodi', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36'),
('nm0uthqp89h405ept6j28fo5ub', '', 1778798460, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nm4ij3500gjcp2ce8ctbjdiumi', '', 1778799138, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nm5kne8tpa4hulj5kobsjt6k41', '', 1778798695, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nn5kmfta3m8p8gokle1dbolef3', '', 1778798709, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nohfdfqkivt9kmllvd7qvernl8', '', 1778798950, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nonl7la90nsf9ne64kt5hvhtb8', '', 1778799276, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nqr0o08hfoq0v9l0a7dng6khlj', '', 1778798593, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nr63gujm0nvq9ved33j9u9ta8m', '', 1780330616, NULL, '66.249.79.132', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('nstklkk77tk4gi76vlgjt2eroi', '', 1778799142, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nuse3k9eni17qmro28jse49a5b', 'Y3NyZl90b2tlbnxzOjY0OiIzMjEwNGYwNmIzYTgwYzc3MDMzYjdjNWUzMTk0MDgzNjZiNzI2YjVlZjZmZDdkOGE4NTQ4ZTBhODUyMDRjYTViIjs=', 1780783423, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('nvaia3c1urnniiafob90i21u14', 'Y3NyZl90b2tlbnxzOjY0OiI3YmE0YzgyYjM1Yjc2NGJiZGE2OGM4YThhZTQyM2M0N2EyOWJjNWMzMTFmNWIwMDM2YzI1ZTRlMmIwY2Q1MTE2Ijs=', 1779798252, NULL, '137.184.157.201', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
('nvj3ifash4u1872ecrc4s510n3', '', 1778799037, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('nvlbvua5h24k6ie12v0vctdrtp', '', 1778799069, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('o07dqmr2gjbf43u7dd2bq9vlke', '', 1780377103, NULL, '74.7.175.172', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('o10skqiml0aggl3ia8013nd1i6', '', 1778798962, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('o1jqr2qptt1t77418q0r7hehv5', '', 1778798670, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('o1mip37o3dugbod3589v1jp26d', '', 1779757232, NULL, '2a01:7e01::2000:c9ff:fe2e:fe0a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
('o1r49g140iqf4hf0ml7nmmtjc0', '', 1778838188, NULL, '51.195.244.32', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('o45sqb32iiei4j65gsu48d8of0', '', 1778799229, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('o4a7q1ld84tjpe3vhqge1vaphq', '', 1778799123, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('o4cisf03uk1boibuk5mgoqt4l5', '', 1778798492, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('o4ogc99o64ln56nfhudcu5crs1', '', 1778798510, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('o4p8m6hqkp64m8sn6cvltrkiqf', 'Y3NyZl90b2tlbnxzOjY0OiJlNWE0ODVhNzI3MjhiODQ1NGU4YTk4Mzc2NzhjMTJmNDQyZDI5MjA3NWM0NmI1ZjkzOTIwYWYzY2E5ZGEyMGIxIjs=', 1780773578, NULL, '139.167.79.64', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'),
('o4q00s5o1g85h9niin8loenont', '', 1778798921, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('o4s1f488943cvvbd5rbqkfmpvb', '', 1779302330, NULL, '74.7.241.176', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('o64q1gkd1gjbl177h0mao1bnrm', '', 1779061697, NULL, '52.167.144.214', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('o6ok4q9h389l6npvd80shb2cbk', '', 1778799451, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('o8dl880ru1sri1ge6j1vthk46q', '', 1778798677, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('o8dn2as1tj6qvublfnlm32hice', '', 1778798942, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('o90tnnff9103itmtoc1046use8', 'Zmxhc2hfZXJyb3J8czo1ODoiQWNjZXNvIGRlbmVnYWRvLiBTZSByZXF1aWVyZW4gcGVybWlzb3MgZGUgRW1haWwgTWFya2V0aW5nLiI7', 1780843262, NULL, '66.249.85.110', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('o9d6qci79degl3b4aoq1f3js8e', '', 1778798885, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('oa5q5qost76b4eldlqkcdlrdr5', 'Y3NyZl90b2tlbnxzOjY0OiI2YTYwNTkxMjRiMDU1NTg4NTg1MGNmOGFmNzFhODY3YjU2MzQ1MTY1NWIwYWE2MmRmNjU2ZDA3YzRiYTRjNTNhIjs=', 1780783433, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('oad86mbivp7lhac17s0p6udhrb', '', 1778799147, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('oalnbevjb12v1c7754bh69am2r', '', 1778798477, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ob3jv4a524aitacjggf3pmdk38', '', 1778798435, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('obc6guv82n9nie47ra7t951ruk', '', 1778799005, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('obmfivkjf1d9dmkra9upn86ocl', '', 1778798993, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ocd4okd4f792ptmuue4athj9p4', 'Y3NyZl90b2tlbnxzOjY0OiJkZDE5M2U0YzdlYzg4NDIwMjhmMWE5NDk3NGVlZjg0Y2YxMGNjYjVlOGJhMjE1NmNlMzk3NzQ2NzRkNGZmZmQyIjs=', 1779185593, NULL, '192.71.2.99', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('ocph6c08u1ks54n6qribbqckr8', '', 1780629260, NULL, '104.210.140.134', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('oe3k6eduv0t0t7pgh3kak547jo', '', 1778799014, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('oe8anpo6gp3opvh6o9tivdfurs', '', 1778799454, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('oeiom8r3lp532su37vv0dcn8vq', '', 1778798805, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('oek38nr16p4m2d0sq3t9q0jlr0', '', 1780137573, NULL, '52.167.144.55', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('oemblhmoa27mqktou3lilpaj79', '', 1778798801, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('oepo10t93t24aomm07sfo1nnuk', '', 1778798977, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('of7u1tiov2lt8ajfcdfkb1bfam', '', 1779191765, NULL, '2a03:2880:18ff:4d::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('ofdndk4lml73vnpel43kg7c06c', 'Y3NyZl90b2tlbnxzOjY0OiJiZTdkNDM2NzRjMjNiNzBkZTViZDc1ZDM1M2IxZTBlNjViZThhM2UyYmJlZWFkMmE3MmY3ZDM2YWZhODU5MzdjIjs=', 1779305327, NULL, '192.71.12.181', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('og7vtlaq8buc2n3nal9ijolhof', '', 1778799405, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ogunet0ampiterrggagdq2g0gc', '', 1778799385, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ohbmgjv5143sia3j379l4trkim', 'Y3NyZl90b2tlbnxzOjY0OiIyODUwMDgxMTBhOWQ0N2RiYzc3Y2EzOTJjY2I0MjBhY2U4MGJmOTExZTcxZjY1MDNhNGZiYjg1YzE3MWEwMzA4Ijs=', 1778813928, NULL, '167.71.248.244', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('ohbn7s8tiqekl2okljhlvscdda', '', 1778799471, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ohqmm7v3a35pkueicbdj8dohca', 'Y3NyZl90b2tlbnxzOjY0OiI3YTkwYzZiYmE1ZGU2ZGYyYTA3YTVlZmNmZjUyZjg5NjkyNDIzODMxYjZiMTg1OTFlZWFkMjhlNDI2OGI1MmVlIjs=', 1779093287, NULL, '216.157.40.84', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('okbgu4um7f9fgc51b7os8vrlsr', '', 1778799136, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('old2nrl7p06gebhucrg4v899jp', '', 1778798462, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('oldkuce4da3b0btrrt5peopi5j', '', 1778798882, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('omaggs55nsqqh8m04mq2mr2299', '', 1778799097, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('omomplkf2k78mfm6f5atqbai5l', '', 1778868291, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Mobile/15E148 Safari/604.1'),
('onb5vdkin0jc1gj23n00odoa8k', '', 1779757227, NULL, '2a01:7e01::2000:c9ff:fe2e:fe0a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
('onh79k0jle5n5ibvi1l7q5641o', '', 1778799256, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('op86tv5902fi3e4pfbcqjbro82', '', 1778799051, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('oplt09qr5ih9m9fkdir8u2irk8', '', 1778799189, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('oqnl1a6b6jnvnfmrip2p9tln1f', '', 1778798429, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('or1n8maie99abapsokuumkegdc', '', 1778798919, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('or8a4eo9072kankam08crg25cv', '', 1778799148, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('osi6s7ua73201k8lasalopajjl', '', 1778798884, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('osk724i6n9nugcvr5e9k0uj9eq', '', 1778799020, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('osogniudee3khjc8rgqvqvmrsj', '', 1778799129, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('otfh0rn8s89u1nminq5r5a47r3', '', 1780105254, NULL, '74.7.175.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('otve0jji05u0f0r8hi2302lfco', '', 1778798846, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ovpfmija8jlpv22qkc6h3b4p06', 'Y3NyZl90b2tlbnxzOjY0OiIyYWY5ZjQ0ZGQ0NDQ1MDUwMzQxYmQ5M2FjM2VkNzMwNTA1YTVmOWNkZGY0NmFjYzUzMjZkMjBjMTI5YmQ5YTVlIjs=', 1778821919, NULL, '51.195.183.249', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('p0grvpu67h1lfe3jd9ce67rncr', '', 1778798582, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('p13d04cl0bi5msrnf3mvo4qiti', '', 1778798771, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('p1utg4hrsknq07m72945jko39p', 'Y3NyZl90b2tlbnxzOjY0OiIyYzg5OTRjODNkOWU4OTI1NjFmNmU3YTY3YjhmNmE4Mzk5YjIxNTRjY2RlOGFkM2ViOGFlMjViZmYwYmQwNmYyIjs=', 1779317111, NULL, '2607:a2c0:800::56', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'),
('p1uut18s2cmr2ervuor9bj2a6r', 'Y3NyZl90b2tlbnxzOjY0OiI3NTQ2MTcwM2NiN2ExOWYzZTNiYjA0M2RjNGJkZWUxZjkyOWEwNDFiZTdkYjczZDBlOGQxOTliNWEwOTVlNzRmIjs=', 1779755595, NULL, '185.12.248.5', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('p2jlclh0r5rscmerv5e80up6gu', '', 1778799399, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('p3ltk6t6klvovjtbahe6kg8i2o', '', 1780598373, NULL, '66.249.79.132', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('p3mf0h48hscpq0fd27bgguaeop', '', 1778798904, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('p5aa71f0nulccm26ri6t8jssno', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0'),
('p6f7k57u7pro4n3jpupc33joci', '', 1778798888, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('p7i4ap3r96ma9mdm2vosdu9cdi', '', 1778798772, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('p87g2tt9ksf1lgbnfa65lp9ill', '', 1778798861, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('p8q92tjfppb44gugdhohl29jea', 'Y3NyZl90b2tlbnxzOjY0OiI1YWM0ZGE0ZmRiZmU0ZjcwZGRhNWMxM2FiNWUxYTdkMTUzMTk5ZGJlODc1MTQxZWE0ZDZlY2I2MWE2YjBjODRjIjs=', 1779754468, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('p908arc0mtklugocmlffctjscd', 'Y3NyZl90b2tlbnxzOjY0OiJmMThlNTllMmFiNjAxZDA0YjMyMjQ2MGFkZDgxZGNhOGU5NjgyZjVmNjY5ZTNlYjU5Yzg4ZTBjMGQ0NDNjMmQ2Ijs=', 1779266750, NULL, '52.167.144.190', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('p9bc29038kr43co7sgf2md1v0p', '', 1778798864, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('p9ke4ldscrdakntq0dap8fr55e', '', 1778798542, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pa8hmnliocppedi6sv1esbhvf0', '', 1779973855, NULL, '2a03:b0c0:1:e0::c00:9001', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'),
('pcb3un0sukubin6a9gf40mavje', '', 1778798959, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pcgvjaq19isbofcpmu0u61oh12', '', 1778798447, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pd8q0hma0agqqo5n8kep0io5j9', 'Y3NyZl90b2tlbnxzOjY0OiJmZGE2NTdjNTdmODhhMDc0MmRmMjEwYzU5MzY3M2JlNGUzNDUwOGQ1MTZiMDU0ZGY1NmM1ODAxMjE2YTY0NWRkIjs=', 1779684534, NULL, '34.214.47.103', 'node'),
('pdk0up4bdu7lijup572247cl6i', '', 1778798957, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pfvdffpem04otdh8ksl6fnlb8h', 'Y3NyZl90b2tlbnxzOjY0OiI3NmRjOWI2MTk1YjNjYWFlMGNkOTRmOWQ1ZTMwYmFkYWMzNjhhZDQ2Y2Q0YmZiZmU0ODE3MGIwMzMzYzk2NmMzIjs=', 1780702626, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('pgq5soqrkdksfjd6tibba4en2o', 'Y3NyZl90b2tlbnxzOjY0OiI3MGNkNDI3YzIzZjQ4OTY2NzFiMjVlNTNhMDQxZGM5MTg3YTg0MTkyOTViNGIzN2UwYWVmODFjMGU5MmNkMzc1Ijs=', 1779093027, NULL, '40.77.167.25', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('ph17c7cbuek8kvcksadi7f5kup', '', 1778798583, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('phinuq1g7m6khkr34v510bin8v', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Safari/605.1.15'),
('phjk89erngdtupqrh9qij02t8j', '', 1778799192, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pifjor8uaj5oaqk8ek6sjb87rm', 'Y3NyZl90b2tlbnxzOjY0OiI4Nzg4YzhhM2JkNjYwYTcwZmU5MGVjYjg3ZTg0NGI2NThmMDAyOTBjZTY0Y2M0ZjdjOTg1OTEwY2JjZDQyNzdhIjs=', 1779770061, NULL, '71.6.240.45', 'RootEvidence/1.0'),
('pihhanuovidq7sm7skf04mcl0l', '', 1778798866, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pir8ht7u3d9gsnbt49umklclde', '', 1779973854, NULL, '2a03:b0c0:1:e0::c00:9001', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'),
('pj1fvchlataq4rsm7n0vq2jt04', '', 1778798992, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pk0dc7aapu3e53d39t1j0bh8ko', '', 1778799185, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pkm4usgjbbl38gl0jg9ndjl0ml', '', 1778798647, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pl03sf40bem99mmid4sc40dbac', '', 1778798568, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pl6rgir3u0frhtjafbrn7cmvr4', '', 1778798592, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ploeqc59e4lcr4d96mr2f4jpnd', '', 1778902978, NULL, '94.23.188.194', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('pnplofgftl4ou8lua8dcpi9k1m', '', 1778798641, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('poigm9ll6bj5pbaf03m9h0v7sd', '', 1778798917, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pon4lh3vuhu2a6aorlb0vv8fl5', '', 1778798788, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pp2l08jqlhmt35u80u9ne3ofrc', '', 1778799194, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ppmto2ftesntq482m3n8jnjdje', '', 1778799084, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pq2mno420qfr1vnc72vqg01kbl', '', 1778798495, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pqmuk4vp12gr8vpf3gif7occh0', '', 1778798473, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pqscpu33pkhlciq1cem0otqe1c', '', 1779093270, NULL, '18.192.252.214', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('pr3qlb9lrt41t9sulc20lcsngv', '', 1778798521, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pr8j95cg7d048ttv8gh1s8o6mq', '', 1778799237, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('praghmj4kpk4iolrtnsaahsra2', '', 1778798577, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ps2dv6oramdo3a2mmh2183u82l', 'Y3NyZl90b2tlbnxzOjY0OiJlMTM3YzA3OTgwOTFkM2ExY2ZhMWE4N2FjZTE1NDk1NGU2MWMzZWZkNDM0OWNiNDMwMTJmZjNlOWE5ZTM1MzZiIjs=', 1780071643, NULL, '51.75.236.129', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('psh7s77gns23s97v1fmdlkljkd', '', 1778799102, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('psmtfekm0cf3qhobu3i3862qhl', '', 1778798827, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ptb61gt85n1o5patkf5ger6tv0', 'Y3NyZl90b2tlbnxzOjY0OiIwOTJhYmUzNzdmYTcwZjk5YjM0YTk3MDYyMDQxZjY2MDQ3ZTUxN2E1OWZhNjhkYmE3ODViMTAyMzBhZWMzMmQxIjs=', 1779093182, NULL, '216.157.42.92', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('ptpfq4a331klddv71s3jf1ri56', '', 1778799423, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pura3m8evb8prnt6gba4olc63h', '', 1778798476, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pv5o7oouaef33o6eq054dtuktk', '', 1778799272, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('pv7npm029l75uahujnd725ccul', '', 1778798448, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q03vbo2avag1aije7igd5l63gj', '', 1778798642, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q04iu6jp021j623qqj0i0pisud', '', 1779235735, NULL, '2a03:2880:3ff:74::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('q0cfjd50n6u24ipg08jjl0r7vv', 'Y3NyZl90b2tlbnxzOjY0OiI5MzYxNzE1NjdlOTE2ZjQxOTFkZjJiY2ZjZjRlMDExNmY4NWMzYjc1ZTQ3ZjUwNDE4ZGVlOGExYTdlZjg5OTc1Ijs=', 1779051348, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('q1h0n482ndplgjeemi08hkc8b9', '', 1779852465, NULL, '15.235.27.142', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('q1ivpbg5pec0663qknn9c57lp3', 'Y3NyZl90b2tlbnxzOjY0OiI3NDM4NDQ0MzZhYzY0Mjg3NGIwNmM5YjEwMDFiYTE1MjZjZmU5NDUzYzMzYjI0YzM0ZTI5MGE2MGM5MjZlZTA0Ijs=', 1779590105, NULL, '192.71.142.146', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1.2 Mobile/15E148 Safari/604'),
('q23ek2bjgrds92g6dou27hs7f3', '', 1778799406, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q30e9s2d6g61jf6d48ov9971ln', '', 1778799193, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q37mth6iv3pi6f3jjv150knp0j', '', 1778798654, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q3meiu5bj18r369dhu397401lm', '', 1778798810, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q3nlmep2vr2sv7rk3h57kbvk8t', 'Y3NyZl90b2tlbnxzOjY0OiI0NWQxNDY5NjNkNzYxMTI1MjliYmM2ZGNkZTk3OGUzYTkwNTA3MTYwODMwNjMwMGNlZDBiNWRiMTA5NjUzMjMyIjs=', 1779769199, NULL, '50.116.49.156', 'RootEvidence/1.0'),
('q44cq0nirgc95lsncc5brk88op', '', 1778798724, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q44keg3krdo0pg6dieus1cde2i', 'Y3NyZl90b2tlbnxzOjY0OiI3YTUzOGJmNzVhNTNmMGIwNWMzZWJlZTBiM2I5OTAxOWE1YjM3NjI1MTg2MmFhMDBhZGZhMjZhZWVmNGU0MDRkIjs=', 1779025721, NULL, '3.90.184.238', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.92 Safari/537.36'),
('q58gl37qmpbf9dfkg1bi6gmt43', '', 1779093199, NULL, '216.157.40.64', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('q65d336234st7shaqfmmt49u92', 'Y3NyZl90b2tlbnxzOjY0OiIxYWFiM2FiNTY3MDAyMGE4MmJmMjI2Zjc2MTU1MWJjYTYwOGEwOWZmNDA0OGE4NDcwNjdlMGYwYWM5YzI0MDJmIjs=', 1780683225, NULL, '192.36.109.99', 'Mozilla/5.0 (Android 14; Mobile; rv:123.0) Gecko/123.0 Firefox/123'),
('q68kr9qd6rsrqmao5d2rptn8c1', 'Y3NyZl90b2tlbnxzOjY0OiI0MWZmZWQ3NzlhZDY4ZWY1Y2MzNGY3ZGY1MmY5NGQ0YTRkZTc0NmFiYzA1OGUwMjdhOGZiM2E5MTcwOTVkMzZkIjs=', 1780073378, NULL, '77.240.87.244', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_6_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36'),
('q6beinhvr7dh0j66154h4qlmh4', '', 1778799273, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q6gvlk0lkt5o3atn0mqucatr1c', '', 1778798938, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q6hograivk4mq49drqqvknnpph', '', 1778798442, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q6opadaeh41r6fj7cei8ks7bhl', '', 1780678345, NULL, '52.167.144.59', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('q81ifjoo7nkgnqinlkosdbg0cc', 'Y3NyZl90b2tlbnxzOjY0OiI2ODVmNTRjYWRkNzQ0MjA3ZTRkNTE0OWEyNGMwMDUyMTAwM2E5ODdkM2JmMmZhNDQwNmFmMjE1OTMyZTVlOWI5Ijs=', 1779636710, NULL, '161.115.234.124', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.30'),
('q89aknb5buk96scctgj68rau4g', '', 1778798906, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q8fl6om84ha9ekcvino3on549c', '', 1778799354, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q8uf6mv2jiq6eecmm3r03trs1h', '', 1778799073, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q96b526m0drkl780rahvpg30kl', '', 1778798937, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q9jb2hom18f99mbi9q6g90fqsv', '', 1778798946, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q9lbjknebpdkggj0ibibdf87p8', '', 1778798678, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('q9nlffprkrlhv5tf7o7boa1067', 'Y3NyZl90b2tlbnxzOjY0OiJhM2E5ZTM5YjZkZjQ0YTg4ZWM5NTczNjg3ZTlmZGY4M2JiNDQzZWE2NjgwYjczMDg2MWJlZDAxZmQ1NDhlZDM0Ijs=', 1780371161, NULL, '35.204.134.146', 'Scrapy/2.13.4 (+https://scrapy.org)'),
('qa1a3g98ohcali275cu7trl5ub', '', 1778798623, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qa1tnlbe797l1rcbgcu3dk4haj', '', 1780514610, NULL, '74.7.175.191', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('qbvvtj7j18av1jp5midhmd0dhb', '', 1780411736, NULL, '104.210.140.134', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('qcihib3e8ibc27a1b4mk7ajeav', '', 1778868291, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('qd1ungvdk01ua3mgqs0oo6igqo', '', 1778798602, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qddsab055gqeu8ok7s13bhvi90', '', 1778799016, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qdpflhmo8rl565rfbs04ncvbh7', '', 1778868291, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Safari/605.1.15'),
('qe1u3homcsncdfjqpuv6339leb', 'Y3NyZl90b2tlbnxzOjY0OiI1N2ExNWNmZDEzNjMyNGFlZTg5MmFmNTFlMGZiOTNmOGIwYTU0MjdlZGQxN2UwYWQ4ZGU5M2NhYWI0YmM5YmUwIjs=', 1780586530, NULL, '2800:40:3a:bd0d:21eb:cbe9:c55f:a135', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.208 Mobile Safari/537.36 Instagram 431.1.0.49.82 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 981604583; IABMV/1) NV/501'),
('qec67ifre21sn418fdb5eus852', '', 1778798659, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qf7d078jo35jkf4oa0men36tf8', '', 1778798926, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qf805hdk45e823mc53i2dofkq4', '', 1778798438, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qf953dfb5olane4lmhk40cia4t', '', 1780195616, NULL, '2a02:4780:27:1279:0:3a0c:b695:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('qgn47k40dobaccg8icmpah30b3', 'Y3NyZl90b2tlbnxzOjY0OiIyOTdjYjg3MWMzOTZjZTdlNmMzNjc5ZjVlZDZmYTk5YjQyOGYwNjRjNGJiNzI5YWRhZGZjMTJjODU4YWU3ZjU1Ijs=', 1779620073, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('qgpot444egbrbdbi5q7c90dctl', '', 1778799437, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qh7juqe3bs4nanor7eqjn69hue', 'Y3NyZl90b2tlbnxzOjY0OiJkNTI4ZjEyNmY1OWJjMjIxNjQzZmRkZWJkZjIyYTBkMTY1NjM2NDIzNTMyMzMzN2MwNGI2OTY0YzY5YWJhYTA5Ijs=', 1779215330, NULL, '34.134.235.139', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)'),
('qi8mdn1iqacqvq49n3682hqbqr', 'Y3NyZl90b2tlbnxzOjY0OiJlMDM5ZTkzODYyNjI1MTA2MWMwMDI4NjlkZDUzYjQ4NmNjYmYyYTU0NDcxYTYwZDRlZDg1ZWM3YWM4MGVmMjU1Ijs=', 1780780080, NULL, '181.239.159.14', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36'),
('qia13ac0d52mrqmul95d6ggp21', '', 1778798858, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qicvpk6jfun732l1ieg02v8sjq', '', 1780177882, NULL, '94.23.188.202', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('qj3jl1ru5etvfag04ifqgp6i78', '', 1778799464, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qkkjfl7i9j371um3186dna0qk6', '', 1778798697, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qm75pmctkn6cb40khd9d67kfh0', '', 1778799313, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qmelevpn5tqu8q74nfal3ifsqa', 'Y3NyZl90b2tlbnxzOjY0OiJiNDE3ZDVlZjA0MzViMzIyZmRlYjVkNTFmNzJkYzA0ZWIwZWRlM2E3NWM3OWRmYzE5YmUzMjY1YjcyZmE0MThjIjs=', 1778972011, NULL, '52.167.144.19', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('qmrq2gq16rddbg5as4afpb2hrh', 'Y3NyZl90b2tlbnxzOjY0OiI3YjNiMjJkNGU4NzJlNTg5YTIyZjM0MmZkMGFiODg4NDZiNDJkMjc1M2RjZDQ0MDkxY2YxMjlhOTM0YjA1NTg2Ijs=', 1778859331, NULL, '198.244.226.41', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('qnr89kd0dp90llammkkea7ml5m', '', 1778798609, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qo38i2dhbq25mre47aomm1dn2u', 'Y3NyZl90b2tlbnxzOjY0OiI0NDkzZDhmZWJlNWYxZDg2MWMyOGFkYmI5NmFmZDA2NmJhN2NhMTZiMTExNTE1NTQyNDljYjM2NmJhODljODBmIjs=', 1779004703, NULL, '34.165.210.74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'),
('qoliths83b84c9bpm6hsin0eua', '', 1778799029, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qpjb62liq6l4rn2luf4vim53dg', '', 1778799279, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qq9sgk1ssd465f9tm4t0ai0r7r', '', 1779410702, NULL, '74.7.175.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('qqfrlc5jgnc04j1j7jhsn084s7', '', 1778798911, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qriu668h4k5ang48pg0lv6l2pf', 'Y3NyZl90b2tlbnxzOjY0OiI3YjBhN2YyODI5NzFhNThiMmQxMjZiODIyZDNkM2ZiYzc1NDYxODYwZGJlZjE0OWQ4MGNjNDBhODY1NDc3OTgwIjs=', 1780783424, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('qs1vejaomirr7sjh62iqsmphcc', '', 1780418720, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('qsbkiu8ndj8pn3pg2tbah7j7o1', '', 1778799412, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qsp1rlpij54vr1v6328pq9qlgk', '', 1778799372, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('qss3vhddkb8eflvnqv3vse8vv2', '', 1779079707, NULL, '104.210.140.130', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('qssq83534d48c4qmap60d595g8', 'Y3NyZl90b2tlbnxzOjY0OiJmMzBiMmNhMzA5YmYyYWIzZmE3YzczZmZmY2VlNjhmMzJhYzkwZGZlZTI5ZmFjOTFkNDRjYTE3YjIxOTYyNGMwIjs=', 1779532540, NULL, '34.31.126.2', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36'),
('qt4c5p89heqtci5nn81acmsjik', '', 1780502998, NULL, '40.77.167.158', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('r1e72mp87mm3ua3f3fov9qe24i', 'Y3NyZl90b2tlbnxzOjY0OiIzODZlN2YzNjZkN2M3YTAyNWEyMDEzMWE3NmUwYzM5OTdlZGRhNGRkMzNjYTI5ZDgzZjExOTMzYjMyMzBiNjhmIjs=', 1780187561, NULL, '103.107.197.179', 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:114.0) Gecko/20100101 Firefox/114.0'),
('r26jihhg5tlaniori1ago2mt7t', 'Y3NyZl90b2tlbnxzOjY0OiI4OGMyYmJjZDk0M2RiMzFhNTMzNmZmN2IyZWQzODk5NTMyMDg2OGU4MjcwM2RjNzk3ZTU0NWYzNjM2YTU3ODAxIjs=', 1780819440, NULL, '34.116.217.8', 'Mozilla/5.0 (iPhone13,2; U; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/15E148 Safari/602.1'),
('r38ouqkc2md1ab7srluo5pn2lt', '', 1780489157, NULL, '2a02:4780:6:1254:0:3166:f11d:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('r3noolaboiuhjr90l89fd8ajng', 'Y3NyZl90b2tlbnxzOjY0OiJjMWNhYTVjZTFlNGU2MTQzMjQ1NDgyNGI1ZDZjOGFmMmY5Yjk1N2JkYTU5MjQ5YjgyYTJlODE1OTdiNWNhMDVhIjs=', 1780830270, NULL, '66.249.79.133', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('r3qvr7fduac0qqk0dej46citsk', '', 1778798764, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('r3smi52qinc68hoolgsog9v5lu', '', 1779973855, NULL, '2a03:b0c0:1:e0::c00:9001', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'),
('r43fgk3vpsjeik34et4kmn7taq', 'Y3NyZl90b2tlbnxzOjY0OiJlNmI3ZTMzZDRmN2FlOWQ1NTNhZTI2ZGMwNTIwZjMwMDVkZjJhNzhlYjljZTFlYjU0N2U3NzZmYjAyMWUxMjY4Ijs=', 1780843263, NULL, '66.249.85.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('r460k1mj006s2b0u8eic63ekmm', '', 1779720243, NULL, '2a03:2880:18ff:4e::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('r4perq1nj8k6eu7sakckjh9dtf', '', 1778799195, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('r5g34it37b3bdoqnqo11v4rgc8', '', 1778799365, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('r5idib7l625tmup82b9clp113e', '', 1778798925, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('r6het36h3edar9nptf14kpveao', '', 1778798643, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('r6hg8jnhlcgmnn2uebsdd0pj18', 'Y3NyZl90b2tlbnxzOjY0OiI3MGViMjYwNjVlZTY3NzU0NWMzNDk0OGNiNDEzMmNkOTVkNzYxZDYzNDc4ZjM0OGVkNTMzNWE2MTQ5MGUwZWE3Ijs=', 1780228311, NULL, '192.71.224.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123'),
('r71dba65cluehoda4l8p5dot8o', '', 1778798732, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('r7s7r2hjt3cj9vei0n9ln3adpo', '', 1778798871, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('r87keii3kn0ra76fjbp194btui', '', 1778799208, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('r87kfs7qhr3r1ank87cs4akb7c', '', 1778798500, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('r89cgvf72mbqr29b3obu2bgrn7', 'Y3NyZl90b2tlbnxzOjY0OiI0MjQzNjNlMjA0ZjY0OTVlZjNhZGQyOWY4NGE1OWVlNDA0ZjVhN2NhZTExOTE0YTFiNzk3MDg3MzAyOTBmZDM0Ijs=', 1779295461, NULL, '201.216.219.236', 'Mozilla/5.0 (Linux; Android 16; SM-A245M Build/BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.172 Mobile Safari/537.36 Instagram 430.0.0.53.80 Android (36/16; 450dpi; 1080x2340; samsung; SM-A245M; a24; mt6789; es_US; 974607439; IABMV/1)'),
('r8eq9c972pse9uo1ta53oankk3', 'Y3NyZl90b2tlbnxzOjY0OiJjMjdmNmRjNGNlN2I5NTY2YWFhYjU3NThlZWM0YTJmYzNlZjRiOWVjOTBjNTZjODQ2YmU4MDRlMzI4YmUzNWZkIjs=', 1779922444, NULL, '144.76.23.144', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; trendictionbot0.5.0; trendiction search; http://www.trendiction.de/bot; please let us know of any problems; web at trendiction.com) Gecko/20100101 Firefox/125.0'),
('r8slaa80q5nddgetdtnlc38nlf', '', 1779757224, NULL, '2a01:7e01::2000:c9ff:fe2e:fe0a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
('r919r5d86rrq69j7aamn3p7hl8', '', 1779169656, NULL, '52.167.144.166', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('r9b6pd110bsj3q4cnj6c9aaehf', '', 1780334881, NULL, '2a02:4780:2b:2028:0:cf8:d000:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('r9kdcifblupfk5en8ig9r64i3u', '', 1778799453, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('r9rueoc8ttf28asv3iafss9kgf', '', 1778798475, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('r9uismjl269rvlmlh6ghi6kqor', 'Y3NyZl90b2tlbnxzOjY0OiIzM2RkMjc1NTk1N2U5Y2I0OTE0MWIxNWJhMmU0OGVjMjE2YTc3ZWE3MTg1NWM0NmRiZmNiZmNiYjkyMDgxZGVlIjs=', 1779259339, NULL, '37.19.210.80', 'Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101 Firefox/103.0'),
('ran6tbojcvi18hsif47c80rd1p', '', 1778798712, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('rbsglhrfk62jp8jk3s2ds7r1ff', 'Y3NyZl90b2tlbnxzOjY0OiIwY2U0ZWU5NTczN2IwNjQ5Njc4NGNlOTQxNTc4ZWUxNjk5NTY5Yzc4ZmU2NGUwNGI5ZmQ1MjI0YzQ0ZWRhZDM3Ijs=', 1780071514, NULL, '34.156.170.4', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)'),
('rcqc1hltj10mr2saql56modkb5', 'Y3NyZl90b2tlbnxzOjY0OiJlNjNjZGJmZjViNGFkNzZjMDE5MWJmYzBmMWY2ZmUwNWVlOTg2OGFkMWEyYzc1ZThmZWQzNzVhNTYxYTAwOWIyIjs=', 1779720411, NULL, '2a03:2880:3ff:51::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('rdcq9bmhfei0tctt4vroijje9i', 'Y3NyZl90b2tlbnxzOjY0OiI5YWRlYzU1YjE2Y2U4ZjU1MWE5ZDA2ZjJkNDliOTgzOWYyOThhZWQyZjcwOWE2NWFjOTVkZGZhMzM5NGY2MmU0Ijs=', 1779590105, NULL, '192.71.2.119', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1.2 Mobile/15E148 Safari/604'),
('resqmpn0qddvk4k6n2sb9k6u2m', '', 1778799103, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('rg9fojbj5ct4qhq55pl0ka1fdn', '', 1778799338, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('rgmjlv89se13a2nkdsh4nd8ah7', 'Y3NyZl90b2tlbnxzOjY0OiJjYWQyY2FlYjNkOWY3YTFlOGY3M2VmYTQ4ODk0NTlkM2FmYWQ4YWI0ZTY1ODExNmIzN2FjZjdiNTE4NzRlYjEwIjs=', 1780187180, NULL, '103.107.197.179', 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:114.0) Gecko/20100101 Firefox/114.0'),
('rhve4n8khu4jpis1rbekcea2p4', '', 1778798611, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ri602i4hchafvipmvrr153ulmb', '', 1780198323, NULL, '104.210.140.142', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('riier4hvt3j40a7tkt3qp9ng89', '', 1778798432, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('rk54a9m83gkssh8r76ro7ihoma', '', 1780089614, NULL, '52.167.144.213', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('rkae93gfuv7isd1s9uefe77pp5', '', 1778798571, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('rkhuf59pkpsju0a2p4dv6vk0vd', '', 1778799120, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('rl2j744bvimtmhsrus9tndhag2', 'Y3NyZl90b2tlbnxzOjY0OiJjY2M1OWY1Mzg0M2FkYmZlNGE3YTVhNDNiMzQ3ZDAzNGY1ZGU0YzZhMGQxNTdmZjNjY2E3YzUxMTQ1MGYzNjI3Ijs=', 1779401223, NULL, '66.249.79.132', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('rl8kr7i5nmq9aent3g0teiercr', 'Y3NyZl90b2tlbnxzOjY0OiJiMTA1M2VlYjk0MzYwOTc0NDVmMWJiZWI1MzNlY2U3NDQ2MTU4MGRiMjU0NjE2NWU2OTIxNWVlOGUwOWNhNzhhIjs=', 1780718406, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('rla1for0be57tdqkjtpud7l4ke', '', 1780561011, NULL, '66.249.79.134', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('rm7drq4gu0j84rej8oqgci9guo', '', 1778798933, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('rmc65l6pj5te6e0357qkengujk', 'Y3NyZl90b2tlbnxzOjY0OiJlYTI3ZTFkNGZhZDIwY2FkZmNjZGZjNjk4ZWI2MDY2YjliMTBmZDg1NTRmODIzMzljNDJjMDUwM2JiOGViNzAzIjs=', 1778813928, NULL, '96.11.155.198', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36'),
('rmnco5n0mr8q96v1em9ts95463', 'Y3NyZl90b2tlbnxzOjY0OiIzOWUxOTliMWFlZGQ4NTM5MGQ3MDEyZDZjZGYxNDQxOTA3MTI1ZjE3YmY0MDdhNmRmOGFjZDAwYWVhYmZjYjY3Ijs=', 1779242027, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('rmtm30m2qk19g79ucddi9i0bv7', '', 1778798908, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('roo8b9c7ud1nm3rsvn9c6qiq35', '', 1780843252, NULL, '66.249.85.110', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('rp6bu0u4jh1ed2tv39h8jss1ml', '', 1778799387, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('rpsrk8jc14cp0ggk025bcseflc', 'Y3NyZl90b2tlbnxzOjY0OiI0OTk0Y2YyZDJiNjU2MTBjZGFlMmYxM2NkNzI1OGQxYzAyZjMwNTRmNDlhOWVhMGE1OTM1Y2I5Yzk3YjYwN2Y4Ijs=', 1780790980, NULL, '2800:40:3a:bd0d:e5eb:a3f6:500a:5e61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
('rq7nc5tajdkvt57h1npeknv56b', '', 1778798541, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('rr9ru2t09ok9hbcecgstr3gtjt', 'Y3NyZl90b2tlbnxzOjY0OiI0NGFlMjQ2OWQzMmU5YzgxYzc5ZDU3MGRhNTYxZWRhY2I2MDMwMzEzZjAwMGJmMGMyMzdjYzM1MjUxOWMzNTQ3Ijs=', 1780783430, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('rrdr178fombfct0bgpv8egtcts', 'Y3NyZl90b2tlbnxzOjY0OiIyOWFiMmI0MTk4YzQ4YjgwZTllY2FlOWZlY2VkYjA0OTNhODFjNjcwYjcxOWVjMjRmM2NlYjE2OGQxZDA4ZDhmIjs=', 1780424459, NULL, '141.138.211.251', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.3'),
('rrq32jdvrgtuv1e5fslfqsjnem', '', 1778798580, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('rrqiik1engh3ipaqnqkc28ftbv', '', 1778799209, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ru89d78431gv4s5v844rpgoiss', '', 1779119645, NULL, '178.128.22.102', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('rue605i0a9td1ohfa4no7t8aoh', '', 1780375461, NULL, '13.222.222.53', 'Mozilla/5.0'),
('ruqp8ble9mbnd2rkm9u3t0bs8j', '', 1778798870, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('rvqlb5v97ngofei641kb48q178', '', 1779916427, NULL, '40.77.167.181', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('rvr893narh548j76du1d4qm6ot', '', 1780441463, NULL, '52.167.144.55', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('s01hco6qcp4o79e5p9g6v0cel3', '', 1778799447, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('s25dk66jldfspl1fnei9rol08k', '', 1778798878, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('s2hkll7orl37kcfkuop61bepgs', '', 1778798726, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('s2vsqoqh889pppshhsjjjej9n9', '', 1778798826, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('s315ktft9gtss4iu5u97sujqjq', '', 1778798617, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('s31j55q7si5qso2igsbnii6b0h', '', 1778798605, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('s4776d40jdddua81vhd57e068q', 'Y3NyZl90b2tlbnxzOjY0OiIzOTgwZjM0NDBkZDkwMTM0MTA3NGUzZGIzMGI4MDlkOGExYWQzYmJlMDc2MmM2Zjk4Y2M4YTIzNzI4NjFhNjE3Ijs=', 1780503789, NULL, '4.209.236.30', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0'),
('s4ei3atfmbcvsrvg5npv6rj8uv', '', 1778799493, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('s6n5gtml87lk94buf21ct3clq4', 'Y3NyZl90b2tlbnxzOjY0OiI3ZDMwNzcyMmJmMDQ3OTRkN2NhZWUxZDIxMDRkZmFkOGIxZTdhYWRlN2FmYmNmODExMGQ3ZGQ0YWU0ZjAxNjIzIjs=', 1780493978, NULL, '104.248.11.172', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
('s7fneo8mee0d84tihd7jogd671', '', 1778799182, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('s7hv6h7f866q47e6bs3klg9n2v', '', 1778799118, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('s7jo1tgthvpkurvbns3bqilpb5', '', 1778798429, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('s7s5lnsmkseecl6rntchk15cc1', '', 1779093285, NULL, '216.157.40.82', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('s95eaj7tq4l5al4l528cqp64d5', '', 1778868291, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('s9900k13ev3u7mgvvjpv77jl57', '', 1778953170, NULL, '40.77.167.77', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('sa180g5vlv6ct5uhfm0gnb0054', '', 1778799440, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36');
INSERT INTO `sessions` (`id`, `payload`, `last_activity`, `user_id`, `ip_address`, `user_agent`) VALUES
('sahr3in4b3g34diantlvcnj4is', 'Y3NyZl90b2tlbnxzOjY0OiI4ODUyNzBmNTdhZjk3ZWFkNjhhYzY2ZGZhZjQyMTQ5ZjY3Yjg2OTI2ZjBmMmRkZTlkYjYxZjE3ZTY5NjNlZjcyIjs=', 1780783427, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('sbg4rudol7e46h0hc5e7tgl5u7', '', 1779268355, NULL, '2a03:2880:10ff:42::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('sc9d4bpg7q7ded4ac8amgmrofl', 'Y3NyZl90b2tlbnxzOjY0OiIwZjdhYTE4MDFmM2JhOTA2YmE0OWI5YjU1OThlMTNkMjYyZmVmNjA2YmZmZWRkZTlhNTVjNjdiNmYyNmI1ODJjIjs=', 1780139221, NULL, '40.77.167.37', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('sctujjlmnan0plaqevjgmildvm', '', 1778868291, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36'),
('sd2riqv4qh4u8eot3sbj45t1rs', '', 1778798607, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('sec8pjffrlb9fjthugt1ps2ca1', '', 1778798967, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('sefjrd82uh71fpe99tkkbj69ok', 'Y3NyZl90b2tlbnxzOjY0OiJlNGYwNDZmYzg2NjMxMTI4Zjc2Mzc5MWE4YTNhNzA0MzA2NDc3NTdhODdjZjMxZjY5YjM3YTNhNjQzMmYxZTAzIjs=', 1780757740, NULL, '3.87.144.65', 'Mozilla/5.0 (Linux; Android 12; SM-P615) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36'),
('seflvttnnjri8q34lsa5m9u1d5', 'Y3NyZl90b2tlbnxzOjY0OiJjZWIwZmQ2NGRiZmI1ZGU3YWY1YmUyZmU3ZGY1YmI2MmM5OGZhMjgyNjVlOGZiMDkyYTc1ZDdkZGYwYTkzN2NkIjs=', 1778937583, NULL, '185.6.9.148', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.3'),
('sfdfqb5tgorhndbj5spruvsacv', '', 1778799460, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('sfli2ehh7e6d305v2ea0vk7l62', '', 1778799241, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('sg8a0bavptbum31grui7tmeufh', '', 1778798548, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('sgau7od4o8bdpchn257b35edgr', 'Zmxhc2hfZXJyb3J8czo1ODoiQWNjZXNvIGRlbmVnYWRvLiBTZSByZXF1aWVyZW4gcGVybWlzb3MgZGUgRW1haWwgTWFya2V0aW5nLiI7', 1780779365, NULL, '66.249.85.110', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('shbdf7p88n88qv0vmoqk04lqls', '', 1779093278, NULL, '216.157.42.84', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('shifccuucubjtflog1seb345jq', '', 1778801706, NULL, '74.7.244.44', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('shn6291a7fc45eonocvnfvs942', '', 1778799343, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('sieoku2eklh512erfivgruaoc8', '', 1778798498, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('sj9et5r392bi0evc3hvahru975', '', 1778798728, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('skn4394iit8q4tqj7tr8f04noj', 'Y3NyZl90b2tlbnxzOjY0OiIxMmE2MDUwMWM4NmY1N2ZlM2E5MzMxZmYwNWE4MzcyOGNlYTAyODZhNWEyZWQ5NGVmMTIyMDNlN2VhOGZjYTczIjs=', 1780182891, NULL, '66.249.85.96', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('sktgqvmoc994ves4u6f8qafojf', 'Y3NyZl90b2tlbnxzOjY0OiI2YWIwYzRkY2YyMDlkMGFiMmE5MjZmODFlNWRlZTgxNTU2MjQ4MWYyMDg2YWQ4Zjg2ZWZhMjM0NmNmNGZhMzhlIjs=', 1779903322, NULL, '37.59.204.141', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('slevh9lqi953bqhcbtskvsq5ee', '', 1778798576, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('smd7mbpquoj7ferh6co4iqdmej', '', 1778799108, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('smfoqicu7cee138pov955m5m83', '', 1778799231, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('smlk0nhfv92ph6egqgemvrfl8b', '', 1778798944, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('sn8a0qvme49ec7fnjchse36p6f', '', 1778798906, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('soe9uplg2pntanlmmih4cnkksk', '', 1779873514, NULL, '91.217.72.93', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('soqe6bjb0a7kvlhoj66iceghci', '', 1778798903, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('sorur6lkov4top2lf7pn1ns7ca', '', 1778798703, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('spuocedjm45kp14jvi736jvbfq', '', 1779093280, NULL, '216.157.42.70', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('squj6okt4ku7netrbvau5tmmbt', 'Y3NyZl90b2tlbnxzOjY0OiI0YmQxOGY1YWU4YWYyYzUyYjc1ODkwZTYzNmM2YjBkMzczNmUzZTAwZWRjMzVhNjY3YmFlNDkyMTZjZWUyMjIwIjs=', 1779093150, NULL, '216.157.41.75', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('srj6op3tqu482f01mr1sdtktpv', '', 1778798897, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('srvcoq9rjvjvdq0pr36oddjjk1', '', 1778798468, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ssc5svnr81nst490invh0ivp07', '', 1778868305, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0'),
('sspmsauct48k7tu36e4v594lkt', '', 1779483687, NULL, '51.68.111.219', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('st2hcfo2ibl7dkt0l4p2m6i1t2', '', 1778799351, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('st6r70g1l2bp4505kbknpi0eb5', '', 1778798971, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('stjm8lgrmaaims43gp4o69g1u9', '', 1778798975, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('stnmmal84rm7luoihrla9seck8', '', 1778798873, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('su9sjbl6l5311dsn450qafg1eh', '', 1778799126, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('suj50fuo3rtj8q6o924l74766v', 'Y3NyZl90b2tlbnxzOjY0OiJkZWEwMWVmZjljMGFhODc2NzRiMzlhZTRjYjgxYjM5ODI1NGY3MTlmODYyOTc4M2M3NzFlNmY1ZmEwYWJiNzEzIjs=', 1780819351, NULL, '34.116.217.8', 'Mozilla/5.0 (iPhone13,2; U; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/15E148 Safari/602.1'),
('svb63apeschd70bv5dh5uogrit', 'Y3NyZl90b2tlbnxzOjY0OiJiNzI5MWRiZGFiOTgyNzI2Y2E0NDViM2NiNTU4NTYzMWZmMjA1MzVlZGZkMDI4MmY5NjE3NTJhZDkzYjE0ZDI3Ijs=', 1778812500, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('t1651qckjv93abhs9o7dcibksq', '', 1778798856, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t2edsvpdcboom96gfgubse5i61', '', 1780489191, NULL, '2a02:4780:6:1254:0:3166:f11d:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('t2jrl7sa2qjig18n8dh3olq0o7', '', 1778799417, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t39si069fhu3se7qbpsgkagdc1', '', 1778798713, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t3cd0qm52hpdo3h78nuic7p4v2', '', 1778799026, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t3h6ol7rpmhrmgpskg4ivlkvuu', '', 1778799420, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t3rs73pedqs3nu2i7p2ds1rlp9', 'Y3NyZl90b2tlbnxzOjY0OiJkYTk1MzJhZWQ3ZWZiMGM2MjlkYThmMjNmYTg3OWRjZTlhZjA2YzZkNTVmNWI0Njg1ZWFiZjQ0ZTc2NWJmYjRlIjs=', 1779163196, NULL, '51.68.111.216', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('t43p4qhorpnc77p58q4jd394ki', '', 1778799223, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t49f1rfkk8etvsd7u6a7hb5t9c', 'Y3NyZl90b2tlbnxzOjY0OiIxNGU4NGFmY2UyYTc1ZTY5ODYzMTk0ZGRkMWY0MDE4OWI2M2MwMGU2OTZiNDllMjgwZDU3YjMxMTkyYjA2MWY4Ijs=', 1778868295, NULL, '2602:fb54:1400::19a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36'),
('t4n5330jiahevr46q335l7abss', '', 1780334918, NULL, '2a02:4780:2b:2028:0:cf8:d000:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('t4psirm4bbsqhg634cm08qmj3j', '', 1778799116, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t4t28osnuddq54k3pr7bm6vjrp', '', 1778799071, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t5842e8a54gl4b7m3c42tsgml6', 'Y3NyZl90b2tlbnxzOjY0OiJiZjkwMzE5NGY3YmI1MzdiNjQyMzI4YzkyMTMzOGIwMGQ5NjY3NDA1MTNhN2ZmZTIzYTYxZmU1NDMyZjhlNzczIjs=', 1779185869, NULL, '164.90.181.197', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
('t5v48r5r2jjpsr36cq13uanvn4', '', 1778798698, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t61ts0j93ai8qt7cs9fqongujh', '', 1779800126, NULL, '74.7.244.19', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('t678d9780g9t00jqrkmpt64dsa', '', 1778799181, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t6ia580tpsupqrfkbfgcqef539', '', 1778798780, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t6rg7nddn5ola0p19u9dg42r1u', 'Y3NyZl90b2tlbnxzOjY0OiJmZTVlYWFhZjAyZDdiNzFhZDVmN2M4NmNlYmNiZmQxOGE0ZGZmZjczMTBjOTM3NmNlNDQ2Njk3ZDlkNjc3ZmFmIjs=', 1779295116, NULL, '201.216.219.236', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36'),
('t72e577c2fl2ophdtlb7n3p9ju', '', 1778798566, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t7u81n8pe4ugdsrgiq874gh4bd', '', 1778798687, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t8c2p0d83ncdok9ouadh3pv54v', 'Y3NyZl90b2tlbnxzOjY0OiI5MDVmZDJhZWRhM2RkMGZjOTNkYTRlYzYxNTRhMjRkNjdiMGQ3NjFlYTg5MDc3OTc5ZDdlNDdiY2JjOTBhNmUxIjs=', 1780182794, NULL, '181.30.247.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36'),
('t8loqqcppfnieib1cmgvu8in1p', '', 1778799038, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t8oaaunma258n9mm3n9is5ob15', '', 1780555809, NULL, '2a03:2880:24ff:47::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('t8q69p6rs8clg5khr1b5fr6i6o', '', 1778798787, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t939o35pn7nto57ms52ilcp2s9', '', 1778798934, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t96kcpsjbski6cb7gd68suaheh', '', 1778798532, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t9d3juiscertms1ig2h4gjutd8', 'Y3NyZl90b2tlbnxzOjY0OiJiNDBjMTNjMjc2N2MyNDE4MGZhOGFkMTM0NzRmODZhOWQxZjIzMjI3YzQwYmJhNGM1ZDdiODJjMDRjN2FmOGViIjs=', 1780182762, NULL, '66.249.85.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('t9djn3pkkgv0g6njf6o6v2csut', 'Y3NyZl90b2tlbnxzOjY0OiJlNTUxN2E2NTAyYTkzODY3ZDQwY2JjMzYwNjk3Y2IwYTQyYTVkZTFiYTI4NGVmMjk3YWZmYzBiZWUxNzY3ODIxIjs=', 1780352334, NULL, '92.222.104.216', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('t9e442kb4174tf5k6da0o1mrgd', '', 1778798453, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('t9ticq9frspfbk0f8vn81ek7hj', '', 1779743367, NULL, '51.68.111.208', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('tam8khapgs3ev6gleim1vl4ag0', '', 1778798920, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tb0reh01lqi4q7dnv8c59nv1hc', '', 1778798690, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tb630v2gcfpok069c63kn0sap3', '', 1778798727, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tbsfj8eg9ecrdq8voulofdraia', '', 1778798762, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tbudf5lchqtd10saiim6e9a8m5', '', 1780285926, NULL, '192.171.81.143', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36'),
('tcktk265ui83l28crfsve4jkmm', '', 1778798794, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tcl16920gn1i9tss5s9rp85gc3', '', 1778798890, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('td0gulchm1kjbfj8m7q8r53cl9', 'Y3NyZl90b2tlbnxzOjY0OiJjYmIzYjViNWE5ZGRmZGM1MjhiZGYwMjY5MmY4ZDRhZDA1MTljOTkzNzU5ZDkxZTk0OTZiNTIxMTA0NTQ5Y2UzIjs=', 1779185593, NULL, '192.71.142.176', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.1'),
('tddkq7qsi0b8logkmu1shq12ig', '', 1778798487, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tdf74r554l2nk9komjt4m0575f', 'Y3NyZl90b2tlbnxzOjY0OiJkYjdhNWE1NWRmZTMwMTk0MWYwYmI5M2M3NzM3YzA4NTc0YzI4NDM5YTE4NTM1NjY5ZDRlOWY3YjA3YzU5OTk2Ijs=', 1780605848, NULL, '199.244.88.226', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36'),
('tekqfgr38b15kgau3s4v8er0lr', '', 1778798676, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tf821itmvriejde6rco60io43f', '', 1779172995, NULL, '138.68.58.67', 'Mozilla/5.0'),
('tfcrqjuo8fqqlr0fb1q2ubtdal', '', 1778799490, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tfk2uuogsh2mevcjao0b3fc9g8', 'Y3NyZl90b2tlbnxzOjY0OiJkNWM4YzA5YWQ1MzIxNWIwYTA2YTM1NzVlMDI4NDY4N2M5YjU3MDk0NWE0Y2EyODNmY2QyZTI5NDhlYjNiMDJkIjs=', 1778818552, NULL, '198.244.242.94', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('tg3riv81t0ns1kop3ev3hqc49f', '', 1778799221, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tge2pbhhf05pjp19ukejmicj96', '', 1778798481, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tgj4npb57e1j49hccks665pg6u', '', 1779339175, NULL, '18.212.4.162', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36'),
('thb16vt12gplm8f9hbtfp3ik6u', '', 1778799491, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('thljpdqi70b366e6mv96p1lfvj', '', 1778798443, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tjqvsmaiflf3glvd2i3hou4338', '', 1778798691, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tkcsj99juq7041jak2k2teh09u', '', 1780518375, NULL, '2a02:4780:27:1682:0:3458:6c83:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('tlfm2sipir5fodpcc40p9p0o6r', 'Y3NyZl90b2tlbnxzOjY0OiJlZmUwYmRjNjgwYzJiZTJkZjYyZmYxMDZjMzI5YjcwMDA3MWIzNmRiMTI2MjRlZGMyNmU1ZGQ5MzdjMmE4YmRkIjs=', 1779405514, NULL, '35.209.102.135', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
('tm3g9jktuu5rmp28fvuusvm9bm', '', 1778799135, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tmq2ntjj0tp73iq6m7i105h1c4', '', 1779093270, NULL, '18.158.189.225', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('tnd3ib8lqru7keakaf6167pfdp', '', 1778799468, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tned32lifforeq3cbtcaa3fi6l', '', 1778798474, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tnog36ooidselp3st27jqicj4e', '', 1778798514, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('to3c9jc4p9ksq6t1m11e62cqg1', '', 1778798817, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('to9t1ki433s7kv2mcpdaf2q9aa', '', 1778799330, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tp9d9nsu2p4uj9ftmq72ci4mb2', '', 1778798485, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tph2h660gmd8sa3g8u582etqbe', '', 1779093175, NULL, '18.159.93.15', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('tqrc4jccesanlebbnaka99p0eb', '', 1778798953, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tr719dck499kgeca9ag38cdc0d', '', 1779727016, NULL, '104.210.140.136', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('trb8n13pmrs4e544ge19q36s8o', '', 1778799265, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('trs9lii22lq6gi84gubca1hk20', 'Y3NyZl90b2tlbnxzOjY0OiI1NTIyMjEyYzI5YzUwM2VlYzBmNTBiODQ5MmU0M2I3MjM5YWViMTkyZjY1ZDAyYjIzN2YzZmE2NmRmNDU1NjNiIjs=', 1780779326, NULL, '200.50.248.100', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36'),
('ts8eej9ptlviitfv6ocb4gb948', '', 1779344522, NULL, '129.212.228.202', 'python-requests/2.27.1'),
('tsija4v29ckgous1mpvab0b5ma', '', 1778798567, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ttvlv328q54s04cle599ura7o1', '', 1778798862, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tu4opkbbpcf1d4818knu0ogvtk', '', 1778798434, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tua5oqq1j7n2knrd7iq7mckca9', '', 1779093283, NULL, '216.157.42.75', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('tv1o156ml5hl0p68vmq7b6mqjd', '', 1778799006, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tv3iq2eai7sohecuca8s8nqlus', 'Y3NyZl90b2tlbnxzOjY0OiJjZmJhMDFmMjA5N2QyMzE3NGE1ODAzOTE0ZjI2NTM2NzY3YmI2ZjhhYjZlYmI1M2ZjZGI0MjIzZWI2NzFiMzUwIjs=', 1780819347, NULL, '34.118.56.166', 'Mozilla/5.0 (iPhone13,2; U; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/15E148 Safari/602.1'),
('tvfbmin6b1fobp2q19mdd3i5j4', '', 1778799115, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('tvs1gq3o7b2svduhmmbnaj738j', 'Y3NyZl90b2tlbnxzOjY0OiI2MmNhNWY3NDA5NWE2NjcwNzIyMThhYzVlNTBiNjhlNDAyZmUyYTcxNmZhZTY1NGU2M2JmZmYzNTU0ZTNmNzlhIjs=', 1779013985, NULL, '35.163.99.88', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.66 Safari/537.36'),
('u20h4ehif0vrbq0c614e2thqof', 'Y3NyZl90b2tlbnxzOjY0OiJlODNjNmQzNjExNjdmNWI4YzcyMmYyZTM2NmUwNWE3YzkwYjYzOTJjNjUzOTQyNGFiY2NiZTMyODZmZDRlOTNmIjs=', 1778933491, NULL, '2602:fa59:9:16f4::1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0'),
('u2d6j77kb0rgkjrg9abfu35tc5', '', 1778985866, NULL, '51.68.111.209', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)'),
('u2urdle6is6u91bh06evrleqan', 'Y3NyZl90b2tlbnxzOjY0OiIzZDM3OTFlNWY4ZWJjMzU1ODRkZGQwYzRmZmYwZTg2NGEzNzBmNmNhYzBmYjhkZjRhMzgyYjc5MDc0NjQ0ZWQ0Ijs=', 1779292432, NULL, '198.244.183.213', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('u3cr0jjmfd3rfgo5kb4vo438s4', '', 1778798648, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('u3lnedg1pjtv34ejnc62mqrfoo', '', 1778799235, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('u3mkpvo10kke5u3ug2mdq85h4v', '', 1778798546, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('u4os8snsf77eutfrek5cdgbanb', 'Y3NyZl90b2tlbnxzOjY0OiI2YzI1ODRmMmYwZTY2MjU4YTk5ZDQ4MjMyODQyNjg1YjJmMTI3YmY1YjQ2OTg4Y2ZjMDE4YTA1MmRmNjExNDAxIjs=', 1779477115, NULL, '194.103.212.184', 'Mozilla/5.0 (Linux; Android 12; SAMSUNG SM-A415F) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/23.0 Chrome/115.0.0.0 Mobile Safari/537.3'),
('u58t41q2vnncb4nnfeb9f1a6nl', '', 1778798924, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('u5lqc7eqanb1j9nrgp011j756l', '', 1780182891, NULL, '66.249.85.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('u5q409eqv56hbunpkjc6dqqjm0', '', 1780103229, NULL, '74.7.244.19', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('u60hc96sbe0avlooq43la1b2hm', 'Y3NyZl90b2tlbnxzOjY0OiIyYWM4NDlkMWU0YTNmYzI1NmYxNDFkNGI5OWYzOTE3ZTE2MmNhYWVmMjA1MjVlYjBlM2Y1YTkxYWQ1OTg1NzQyIjs=', 1779091879, NULL, '54.174.58.240', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('u62o89muu4jl970568ap6pve3j', 'Y3NyZl90b2tlbnxzOjY0OiJlNGFkMGMwZGQwMWM0NTE5YjhiZjc1NzhhYTA2YTcxN2E2YTBhZWE5NDM1YTdjYWFjZTZiZjdmOGI0MjY5MTMwIjs=', 1780849994, NULL, '201.216.219.226', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
('u64kro77p6l37g1cqp11rs6kv8', 'Y3NyZl90b2tlbnxzOjY0OiJiM2U4MDQ5Y2JmNTc3ZWIxNTM4ZmM1MTNjNDU2ZDM2MTZjNzYyZjQyM2VjNTlhNjExNjdkYzE5NzJjN2MyMzQxIjs=', 1779032789, NULL, '54.38.147.215', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('u6ir5qe305hqks3fl55j7bfbei', '', 1779204648, NULL, '74.7.244.44', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('u6m7i84k8tmscr1u85chsfopjc', '', 1778799107, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('u7k2u0l39cjjm994jof5madrdk', '', 1778799019, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('u7lhtisl6trcapebcv3pb0fbfg', '', 1780407033, NULL, '66.249.79.134', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('u7rokg0dmi0t5ccp319450vdca', '', 1778799009, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('u81ismgdbhrmqs3en7bdcjkifc', '', 1780489191, NULL, '2a02:4780:6:1254:0:3166:f11d:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'),
('u8e5g3prd3vn8fbfa59ueiqcki', '', 1778798630, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('u9ep4ikv23pf1as8kjcofao1ic', '', 1779386290, NULL, '66.249.79.133', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('u9pllgnjstki147mb0tls6l7e5', '', 1780418708, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('ua3fj5da43o6ugiu58umhvi78c', '', 1778799441, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ua9sp0pma0gdb4bb8o7t0hk3cf', '', 1778798889, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uagni0vff0ec9fhvt8fo24u392', '', 1778798845, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ubduij208pn49kj92sp7ni5d2f', '', 1779042776, NULL, '66.249.79.5', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('ubvvjstp0tbaffrn99uj06nmpm', 'Y3NyZl90b2tlbnxzOjY0OiIyODVkMWRjMTJlODE5NTBmOWNkNWY4M2VhMDk5MTMzOGU2ZTNhOWE1OWIxYmIzZjkzZTI4Njk0ZmU4MGI5Y2E5Ijs=', 1780707050, NULL, '66.249.79.133', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('ue22kdne5ei87f82vks3g0hu86', '', 1779199649, NULL, '74.7.241.176', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot'),
('uegjk4l7fa40pdl0toeum8labp', '', 1778798620, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uf86mhg0bghtfvvsefqs7ine75', '', 1780418721, NULL, '170.64.187.141', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'),
('ugnb16fsk1215711p99nbg9ocv', '', 1778799291, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ugvhlgbjc4vcimtk49at0i333e', '', 1778799003, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uhfo51vkc06gkqq744gbbqbtji', '', 1778798877, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uhhcpj9tf0ds34292ae4av1qdr', '', 1779051416, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('uiee6nj2h62n2fhlopjdso3md0', '', 1778798824, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uimuomsbcg3s36r04gogurk971', '', 1778798998, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uinne23u0ljdto58i1oqkd3004', '', 1778798733, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uj9blshrrdut98u68317dprn9k', '', 1778798591, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ujj3b6ckqtekjimqdtlr5917ph', '', 1778798451, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ujnjagkcl2rtfi0lahb5ovo3el', '', 1778798991, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ukincvk1m4cn4odsjhq99m9rho', 'Y3NyZl90b2tlbnxzOjY0OiI5NmU5YTNmMTRhZjkwYTlkM2IwNTUzZjMwZTNkMWFlY2M2ZWZkNGU5NDhmY2UxZDllMmZjN2VlMzFjODVjNTE3Ijs=', 1780579462, NULL, '192.36.109.131', 'Mozilla/5.0 (Linux; Android 12; SAMSUNG SM-A415F) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/23.0 Chrome/115.0.0.0 Mobile Safari/537.3'),
('ung20d9kdg47laa50869c3l8ra', '', 1779822485, NULL, '104.210.140.131', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('uo3lc7l2vedm2m6b509cu3l0k0', '', 1778798812, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uodknuneahq6e2ig0nhn3vjok7', '', 1778799357, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('upccu2fk3o8didfrd3c32as13n', 'Y3NyZl90b2tlbnxzOjY0OiJjYmFkYWMwZjM4NWY2MDdhM2E0YWVlNzgyZDY2MmRmMGU3YTg0Yjg1MWEzOTgxNjY5NGJiMjgxMWMwOGY0ZmFhIjs=', 1779990798, NULL, '66.249.79.133', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('upd9anib4r44m28okcq2u286mn', '', 1778798779, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uprjpv2tcqcvi3537oa59vs4v3', '', 1779051367, NULL, '45.11.127.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/71.0.3542.0 Safari/537.36'),
('upt2tsd9ud318p89ivjsh55jfa', '', 1778798969, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('upumf34beu7ltmb2lg5atf09lq', '', 1778798853, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uqts4t3qcsnjn0dt0u4v2cgsuh', '', 1778799396, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('urtdb1j00ov8riaa3ar9urc786', '', 1778799296, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('usg4h1gl354qi7u6tmt3f9ok41', 'Y3NyZl90b2tlbnxzOjY0OiJmYjUzYmZhNTNmOGZiMjVkODZiMjg4MTc0MmIzNWUzNGYzZDc2ODg0Mzk1MTAwMjliN2FhZTZlZjgyNDc4YTAzIjs=', 1780702626, NULL, '66.249.79.133', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('uslp2kvkuon3r46obql1lo3jel', '', 1778798899, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('usq5tbsspeq0q3ljp142vgodnh', '', 1778799197, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('ut0g53mocdteu9uerhndel1ct4', '', 1778798854, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uthcrsqao0q9ruphj4hvrbnd29', 'Y3NyZl90b2tlbnxzOjY0OiIxZGU1OGRmZjNmMTg3ZjYzZmFiYWVmYzBmZTQ4YjQxOTEzMmE2MGU4NGE3MjlhOTk5MmE5YmE0OTVkODM2MTBhIjs=', 1779339177, NULL, '18.212.4.162', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36'),
('utk4epglad4nn5ob5m29o5d6pn', 'Y3NyZl90b2tlbnxzOjY0OiIzMzY3MTc3ZWZlY2JlYjRlOTAyZmNiMGRmZTA1YjNhODdjZTA1MDNlZDBjODQ1Yjg1MTBmZjk4NjA5MWUyY2FmIjs=', 1779401223, NULL, '66.249.79.134', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('utsm4ad55obdml7hghgcpep542', '', 1780623210, NULL, '54.39.136.124', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)'),
('utthlll7uk5nkhem9823onl5vo', '', 1778798681, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uu1fed4op3dj2h4hlp34merruv', 'Y3NyZl90b2tlbnxzOjY0OiIxNDAzMDU2ZWQ3M2U5MjdmOGIyYjVkMjgxZjNhMTkyNDBkMWYyM2E1YTgzOTZmOGM2YjhhOTgyZDEwMjUzODQ3Ijs=', 1779449149, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('uvo3enidlsa4d09lsv1l8sj8la', '', 1778799298, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('uvqs65362m1ivppiqp4s79sbom', '', 1778799282, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('v10a3k50khs9pq4vbsaud8jagk', 'Y3NyZl90b2tlbnxzOjY0OiJkZmY0N2M2ZGIxODY1YzdiODBiNjcwMDllMjI5MmZhZDAxMDUzZDQ0N2JkODYyZWJhNTE0NjU3OWYyMjdkYThmIjs=', 1780828258, NULL, '23.27.145.186', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36'),
('v1i1cpvofsbvn2nchm3lrtsceo', '', 1779093179, NULL, '216.157.42.84', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('v22j71pdduceosl11p51h8js7u', '', 1778799467, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('v24j9tom5ajs6urm67kik3h3r8', 'Y3NyZl90b2tlbnxzOjY0OiIwNDFhNTU3NDhhOTMzZmMyMDVkOTFiYWY2MjUwZWNjMjNmZGFiZjE3N2RkZjEyYTkyZWZlNTNiMjJkYjA4YjAwIjs=', 1780252961, NULL, '216.73.216.140', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; ClaudeBot/1.0; +claudebot@anthropic.com)'),
('v2h0478nce6p6sftsu4epq00hm', '', 1778799171, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('v3ipq7qjr7ebt5ucpd4ub2cj5e', '', 1779233616, NULL, '2a02:c207:2324:3159::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0'),
('v42f7jmlg4e1n1jhkvbqk6oeet', '', 1778799294, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('v4i3a78lgeuc9libnbpl7mv46u', '', 1780382212, NULL, '2a03:2880:11ff:41::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('v63tej8bqj8d8gbhfmevmn6uka', '', 1778799228, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('v74fltaunnerl50pvb4ncu96fi', '', 1779883604, NULL, '74.7.244.19', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; robots.txt; +https://openai.com/searchbot'),
('v7bu5b3lc0b425tkh3jd2pi4e1', '', 1778798598, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('v7ffhr0k7pdjlqoqq0ircs4sc1', '', 1778799408, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('v7lssmtd7gie2ctipgp1nudd8o', '', 1780783426, NULL, '34.77.20.39', 'Mozilla/5.0 (compatible; VelenPublicWebCrawler/1.0; +https://velen.io)'),
('v7polievs2i9bgqo0akdsng94s', '', 1780364969, NULL, '52.167.144.55', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('v7stfvk4118csfk9tlpht8udt7', 'Y3NyZl90b2tlbnxzOjY0OiJlNTA5NTdjN2RkM2RiMWY4NzI4ZjliNTQwMTJhZDJhMmEzYjM4NWNkMjllOThkNDc3NThhNTYwZWMzZDk1ZWNiIjs=', 1780362445, NULL, '2a02:4780:9:c0d3::60', 'Go-http-client/2.0'),
('v85hvgopu4ksqd9jl5n1d3ocga', '', 1778799407, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('v8n7qb44qmdh81evbj5ga2pgpt', '', 1778799043, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('v8uogud5veabgjmuu5gshohvp0', '', 1778799178, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('v8v1j1mkirn6c7scqeslos4bpn', '', 1778799054, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('va9hi2e2lfbjnl30jehp49f50r', 'Y3NyZl90b2tlbnxzOjY0OiJlMWYzZWU0NTk2MmZkM2Y0YjE5YWJlZGVmZTY2YjRhMzU3OWNmZjBiMzI0OGIzNTEyOGVmN2IzZjkxNzRmZmYyIjs=', 1779382420, NULL, '13.222.189.124', 'Mozilla/5.0 (Linux; U; Android 4.0.3; en-us; KFTT Build/IML74K) AppleWebKit/535.19 (KHTML, like Gecko) Silk/2.1 Mobile Safari/535.19 Silk-Accelerated=true'),
('vc1dp4qd1oe0qukrj5e4vn5s8i', 'Y3NyZl90b2tlbnxzOjY0OiI4ODMxNTZhMTIyMjM5NTk1OTNlNjEzY2ZkMTQ1MWQ2ZjFhYTNlYjI2YjFhZDRiNzFlMmM1NTkyODJkZGY4MDY2Ijs=', 1780046791, NULL, '240e:362:518:a500:6e92:bfff:fe96:aca1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36'),
('vc5it6l76frb1tu4v28n2u766e', '', 1778798770, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vcc92nu7o0tt49erc1g13ofecm', '', 1778799410, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vce6h786uo1d1msqvfogen4o14', '', 1778798742, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vcf5iqi1vmmbvltkl9se3mbd93', '', 1778798968, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vd9fuukle3he3hsvurbn6j03d7', '', 1779392565, NULL, '2401:4900:1c84:ff2c:7820:18ba:2f93:83b9', 'Mozilla/5.0 (Linux; Android 10; x64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/73.0.0.0 Safari/537.36'),
('vdb4ci2dr30ijeqe3i07vfetdd', '', 1778799379, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vf0gb07bhe67962vpcgso3r671', '', 1779972035, NULL, '40.77.167.16', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36'),
('vfraus2l8a8ebgj7jpc1hruiv4', 'Zmxhc2hfZXJyb3J8czo1ODoiQWNjZXNvIGRlbmVnYWRvLiBTZSByZXF1aWVyZW4gcGVybWlzb3MgZGUgRW1haWwgTWFya2V0aW5nLiI7', 1780843251, NULL, '66.249.85.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)'),
('vge8h2p1h50a7gg2s37v9i24qv', '', 1778798821, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vghro3aoaledemf9g8eiodpfen', '', 1778798683, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vh3k8ms621g2sc926v8iurvi3b', '', 1778798640, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vhlfanp0r971d6ov371a7s61as', '', 1778799451, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vi0ulgbn6oc0s36d1nnnknl8q8', '', 1779898823, NULL, '104.210.140.137', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('vj0gnr83u5ov5mhk3j7gtoevms', '', 1778799250, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vj25dhm1oi18gmsjk94pgc1kfb', '', 1779093175, NULL, '18.192.172.225', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)'),
('vj7hdq0e4ooi0npqehtcduu2uk', '', 1778798480, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vjlos88e1q1numvbjuf065mbeh', '', 1778799088, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vjvtj58hnq9f8s2ftge601tl2g', '', 1778799362, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vkg9lvi4r57j5ebql9l3uh4vs6', '', 1778798966, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vkhrcki9qu0bs3gmjb8os1e2pm', '', 1779578652, NULL, '104.210.140.139', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('vlgg3oja23ftgofmcvp8cton31', '', 1778799485, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('voe5db4ae04i3aan809hmin20h', '', 1778799312, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vp0rkomhrndgumtmc6olgh8arq', '', 1778798955, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vpb3ogqtv3653jtmiint3dvqlt', '', 1779653598, NULL, '104.210.140.139', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot'),
('vpcdbutn9n0smt8o5lubbnbtca', '', 1778799095, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vq7soarjmcc3eek4ouepeqjj1m', '', 1779261851, NULL, '66.249.79.134', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'),
('vr427ktd1cfgjtv5qbvnjolf3j', '', 1778798815, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vskspmr573aggiuu2uuljorvmf', 'Y3NyZl90b2tlbnxzOjY0OiI4NDE3YzFkYTE0OTgyZGMzYzhlNDVkMTMxOGRkODlhZTY4YWY2YjFmMWQyZmYwZGRkZjMzZDM3YmJmZjJjZGFiIjs=', 1780161258, NULL, '2a03:2880:11ff:6::', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'),
('vtc7ivrrs11r1a7r7nv223q06s', '', 1778798838, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vtk4c4tne3hunj3mf68p0k0e7j', '', 1778798736, NULL, '34.131.6.206', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'),
('vva37jvuoir99rd7trgn4sabj4', 'Y3NyZl90b2tlbnxzOjY0OiJmMjFhOGEzZjcwMDkyNGRmMmI3ZjQzOTg0NzBkOTMwM2YwNDQ1ODI0OGVkYWFmN2U4NWJkNDdhYjFjYjZiZjMyIjs=', 1779684533, NULL, '34.214.47.103', 'node');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tenants`
--

CREATE TABLE `tenants` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tenants`
--

INSERT INTO `tenants` (`id`, `name`, `domain`, `is_active`, `created_at`) VALUES
(1, 'Data Wyrd Internal', 'internal.datawyrd.com', 1, '2026-03-09 00:02:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tickets`
--

CREATE TABLE `tickets` (
  `id` int(10) UNSIGNED NOT NULL,
  `ticket_number` varchar(20) NOT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `assigned_to` int(10) UNSIGNED DEFAULT NULL,
  `service_plan_id` int(10) UNSIGNED NOT NULL,
  `subject` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `priority` enum('low','normal','high','urgent') NOT NULL DEFAULT 'normal',
  `status` enum('open','in_analysis','budget_sent','budget_approved','budget_rejected','invoiced','payment_pending','active','closed','void') NOT NULL DEFAULT 'open',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `closed_at` timestamp NULL DEFAULT NULL,
  `tenant_id` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tickets`
--

INSERT INTO `tickets` (`id`, `ticket_number`, `client_id`, `assigned_to`, `service_plan_id`, `subject`, `description`, `priority`, `status`, `created_at`, `updated_at`, `closed_at`, `tenant_id`) VALUES
(10, 'TKT-6BD2E8', 9, 1, 2, 'Hi datawyrd.com Administrator!', 'Hi,\r\n\r\nI am a senior web developer, highly skilled and with 10+ years of collective web design and development experience, I work in one of the best web development company.\r\n\r\nMy hourly rate is $8\r\n\r\nMy expertise includes:\r\n\r\nWebsite design - custom mockups and template designs\r\nWebsite design and development - theme development, backend customisation\r\nResponsive website - on all screen sizes and devices\r\nPlugins and Extensions Development\r\nWebsite speed optimisation and SEO on-page optimisation\r\nWebsite security\r\nWebsite migration, support and maintenance\r\nIf you have a question or requirement to discuss, I would love to help and further discuss it. Please email me at e.solus@gmail.com\r\n\r\nRegards,\r\nSachin\r\ne.solus@gmail.com', 'normal', 'void', '2026-03-06 10:05:19', '2026-03-07 16:22:26', NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ticket_attachments`
--

CREATE TABLE `ticket_attachments` (
  `id` int(10) UNSIGNED NOT NULL,
  `ticket_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `filename` varchar(255) NOT NULL,
  `filepath` varchar(255) NOT NULL,
  `filetype` varchar(50) NOT NULL,
  `filesize` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ticket_tasks`
--

CREATE TABLE `ticket_tasks` (
  `id` int(10) UNSIGNED NOT NULL,
  `ticket_id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `description` varchar(255) NOT NULL,
  `is_completed` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `two_factor_secret` varchar(32) DEFAULT NULL,
  `two_factor_enabled` tinyint(1) DEFAULT 0,
  `role` enum('admin','staff','client') NOT NULL DEFAULT 'client',
  `avatar` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `lead_score` int(11) DEFAULT 0,
  `tenant_id` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `uuid`, `name`, `email`, `phone`, `company`, `password`, `two_factor_secret`, `two_factor_enabled`, `role`, `avatar`, `is_active`, `email_verified_at`, `remember_token`, `created_at`, `updated_at`, `deleted_at`, `lead_score`, `tenant_id`) VALUES
(1, '039c7c95-0541-11f1-9f0e-06ec8dfc4b80', 'Administrador Data Wyrd', 'admin@datawyrd.com', '+1 234 567 8900', 'Data Wyrd', '$argon2id$v=19$m=65536,t=4,p=3$Q3BDcWwxSFBIdlNRemV2Mw$dTNdrZZcQEnGqatxxPq3FahW2qzDsSTCOyIV3e/NjEI', NULL, 0, 'admin', NULL, 1, '2026-02-08 22:53:41', NULL, '2026-02-08 22:53:41', '2026-06-07 16:30:30', NULL, 0, 1),
(2, '039c7eb8-0541-11f1-9f0e-06ec8dfc4b80', 'Staff Demo', 'staff@datawyrd.com', '+1 234 567 8901', 'Data Wyrd', '$argon2id$v=19$m=65536,t=4,p=3$WGVVTFBJREVqLzZoeHVuRw$+OrDIDbRsTQNCrSh/sYEz8mxUR/5mbbiQzX00KSyrbA', NULL, 0, 'staff', NULL, 1, '2026-02-08 22:53:41', NULL, '2026-02-08 22:53:41', '2026-03-09 00:49:29', NULL, 0, 1),
(3, '039c7f39-0541-11f1-9f0e-06ec8dfc4b80', 'Luther Smith', 'luther.smith@datawyrd.com', '+1 234 567 8902', 'Data Wyrd', '$argon2id$v=19$m=65536,t=4,p=3$LzFJWWZvb3dtT0FTTmFBMg$VtItdjLSGHLo+j4i5fLjCgikNbEAXimtV1ONPXQ32s8', NULL, 0, 'admin', NULL, 1, '2026-02-08 22:53:41', NULL, '2026-02-08 22:53:41', '2026-03-14 19:53:54', NULL, 0, 1),
(9, 'dc1d8928a3f11d18883f584af4b573c8', 'Laurence Herrod', 'laurence.herrod@hotmail.com', '7740672183', 'Laurence Herrod', '$argon2id$v=19$m=65536,t=4,p=3$ai5tLjMvUmQxa1JZYTJJTQ$Njfv9NuT844yYmd4sZLJivtAa2sqJspQhcA3rFQR51w', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-03-06 10:05:19', '2026-03-06 10:05:19', NULL, 0, 1),
(17, 'd74b8dc059b8b08f926da01bbf9f27f6', 'MichaelAcawn', 'jacksrenome@gmx.com', '89563576543', 'google', '$argon2id$v=19$m=65536,t=4,p=3$TXFHMFVmV0FJcDNyL0Jncw$rVcbYgy22EWvB8faOpc366xn5G3wPiIm/VLYK/Kd6t8', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-04-15 05:28:46', '2026-04-15 05:28:46', NULL, 0, 1),
(18, '07776224b99a55870b2682fe3b4b8705', 'David Williams', 'davidwilliams28798@gmail.com', '', '', '$argon2id$v=19$m=65536,t=4,p=3$d3U3bnlMM3BLS1R6cTJKQw$ZiCuPlt/PR3BHlZ1dpbxmZ7ri30fr1WwSNanISDsb/w', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-04-25 21:51:01', '2026-04-25 21:51:01', NULL, 0, 1),
(19, 'b922ce415a0d955d4ab54621d20de90d', 'DavidStert', 'no.reply.ArthurJanssens@gmail.com', '82675934814', 'google', '$argon2id$v=19$m=65536,t=4,p=3$djdaakFyQ3plY2JZNkJmSg$uMdUu87KfIxss9kbHhwlOmsLD47bAxVDpLuw7LjohWc', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-05-03 15:10:38', '2026-05-03 15:10:38', NULL, 0, 1),
(20, 'c2ecd2b3d97fd5500ac20af416d531e0', 'WilliamtwedS', 'thirteenonionsreboot@gmail.com', '86383696583', 'google', '$argon2id$v=19$m=65536,t=4,p=3$bUsxVkFsMTB4b0RiOWVnZQ$z/Q0HcpluBxyHGi6GrgpWkWDuw58qHzRqRQtDxK1coM', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-05-19 18:34:13', '2026-05-19 18:34:13', NULL, 0, 1),
(21, 'b5911511fd20ba226606cf097c02adb8', 'WilliamtwedS', 'joepain911@outlook.com', '84139397851', 'google', '$argon2id$v=19$m=65536,t=4,p=3$NFF1SGU2dnBCMFBHTHMzcw$m2e3Lwvv0qcWNDnSRB1JHqzolMwoW0yxh3o9OHJDYww', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-05-21 23:59:58', '2026-05-21 23:59:58', NULL, 0, 1),
(22, 'f0046b7828396168bdf9616bb8c3ef56', 'Ashton Wolfgang', 'ashton.wolfgang@outlook.com', '', 'Ashton Wolfgang', '$argon2id$v=19$m=65536,t=4,p=3$SWlQc3FDMGxxTU5Va2VKOA$1OOZnftYT5XtvJd8gxsEH5CdRECB5SK1sb/6kGpcLlA', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-05-24 07:23:01', '2026-05-24 07:23:01', NULL, 0, 1),
(23, '0360193145cc95fd07b2269512526aee', 'Ella Bryan', 'ella.bryan@gmail.com', '', '', '$argon2id$v=19$m=65536,t=4,p=3$NE5HdnZTUG91bWNjbFJndA$9fWOQQNTbRNOumkZnHk09PXfF0vie4lfmyY0BkkIoyw', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-05-25 20:41:43', '2026-05-25 20:41:43', NULL, 0, 1),
(24, '29d26a43e855b11c204157e6c5ecc3d4', 'Director Alexander', 'exchangebureau@yahoo.com', '82583689455', 'google', '$argon2id$v=19$m=65536,t=4,p=3$WVFYVTVYU1ZyT3dmL2s3eQ$qqiRtiXMN3jxqA/+O3L36ZqKhU2mzRGVixXn6DV8vmQ', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-05-26 15:03:25', '2026-05-26 15:03:25', NULL, 0, 1),
(25, '2be4848e3bfcf74d76e5ca6638dfec6c', 'WilliamHanda', 'avtosalon-tm@mail.ru', '86222132473', 'google', '$argon2id$v=19$m=65536,t=4,p=3$YkZEQmNobE5pLmkzanlNSw$8up7i5yg6L9PyR+c5EyMVotKCgcvdZ+geegIlI3WM6E', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-05-26 19:05:46', '2026-05-26 19:05:46', NULL, 0, 1),
(26, '131ed5c3fa453fd8fe1b087d8655d9f0', 'Noel Auld', 'noel.auld@gmail.com', '', '', '$argon2id$v=19$m=65536,t=4,p=3$MmFQaW1iZGx4dnV2RDNJaQ$jVteoB4hsyiwE5u4z60wHTOg4EAyhYk2W/nzpcGyAiQ', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-05-26 20:05:05', '2026-05-26 20:05:05', NULL, 0, 1),
(27, '9218e6c11a79f8b68e46cdd9cdb352bf', 'Mohammad Abdallah', 'fennellfinancialgroup1@gmail.com', '81833575114', 'google', '$argon2id$v=19$m=65536,t=4,p=3$T0VWZ21ybGdKYkF0cHN3ZA$tJ0lk76njL15YbgcPwnzvpdEsiyNVwx/0ocDF2r7Is4', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-06-02 16:18:05', '2026-06-02 16:18:05', NULL, 0, 1),
(28, '72044708881f62636c521270f4fa37a6', 'Humberto Boada', 'hboadar@gmail.com', '+541170215822', 'VeZetaeLeA', '$argon2id$v=19$m=65536,t=4,p=3$b3ppZGIyMllCWGEyN0RNbA$K8nbgyVQoNjP7Roj1tDEc+IXGN7b4s14nx3XZ5o6x2g', NULL, 0, 'client', NULL, 1, NULL, NULL, '2026-06-07 15:27:37', '2026-06-07 15:27:37', NULL, 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_dashboard_config`
--

CREATE TABLE `user_dashboard_config` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `widget_key` varchar(50) NOT NULL,
  `is_visible` tinyint(1) DEFAULT 1,
  `sort_order` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `user_dashboard_config`
--

INSERT INTO `user_dashboard_config` (`id`, `user_id`, `widget_key`, `is_visible`, `sort_order`) VALUES
(31, 1, 'stats_cards', 1, 1),
(32, 1, 'bi_indicators', 1, 2),
(33, 1, 'insight_alerts', 1, 3),
(34, 1, 'performance_chart', 1, 4),
(35, 1, 'resource_dist', 1, 5),
(36, 1, 'recent_tickets', 1, 6);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `active_services`
--
ALTER TABLE `active_services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_active_services_client` (`client_id`),
  ADD KEY `idx_active_services_status` (`status`),
  ADD KEY `fk_active_services_ticket` (`ticket_id`),
  ADD KEY `fk_active_services_invoice` (`invoice_id`),
  ADD KEY `fk_active_services_plan` (`service_plan_id`),
  ADD KEY `fk_active_services_activated_by` (`activated_by`),
  ADD KEY `idx_active_services_created_at` (`created_at`);

--
-- Indices de la tabla `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_level` (`level`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_user_email` (`user_email`),
  ADD KEY `idx_composite` (`user_id`,`action`,`created_at`),
  ADD KEY `idx_date_range` (`created_at`,`action`),
  ADD KEY `idx_user_date` (`user_id`,`created_at`),
  ADD KEY `idx_audit_logs_request_id` (`request_id`),
  ADD KEY `idx_audit_logs_tenant` (`tenant_id`);

--
-- Indices de la tabla `automation_logs`
--
ALTER TABLE `automation_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rule_id` (`rule_id`);

--
-- Indices de la tabla `automation_rules`
--
ALTER TABLE `automation_rules`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `blacklist`
--
ALTER TABLE `blacklist`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_blacklist_email` (`email`);

--
-- Indices de la tabla `blog_categories`
--
ALTER TABLE `blog_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_blog_categories_slug` (`slug`);

--
-- Indices de la tabla `blog_posts`
--
ALTER TABLE `blog_posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_blog_posts_slug` (`slug`),
  ADD KEY `idx_blog_posts_status_date` (`status`,`published_at`),
  ADD KEY `idx_blog_posts_author` (`author_id`),
  ADD KEY `idx_blog_posts_category` (`category_id`);

--
-- Indices de la tabla `budgets`
--
ALTER TABLE `budgets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_budgets_number` (`budget_number`),
  ADD KEY `idx_budgets_ticket` (`ticket_id`),
  ADD KEY `idx_budgets_status` (`status`),
  ADD KEY `fk_budgets_created_by` (`created_by`),
  ADD KEY `idx_budgets_tenant` (`tenant_id`);

--
-- Indices de la tabla `budget_items`
--
ALTER TABLE `budget_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_budget_items_budget` (`budget_id`);

--
-- Indices de la tabla `candidates`
--
ALTER TABLE `candidates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_candidates_email` (`email`);

--
-- Indices de la tabla `candidate_update_tokens`
--
ALTER TABLE `candidate_update_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_candidate_token` (`candidate_id`,`token`);

--
-- Indices de la tabla `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_chat_ticket_created` (`ticket_id`,`created_at`),
  ADD KEY `idx_chat_user` (`user_id`),
  ADD KEY `idx_chat_messages_tenant` (`tenant_id`);

--
-- Indices de la tabla `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_comments_post_status` (`post_id`,`status`),
  ADD KEY `idx_comments_parent` (`parent_id`),
  ADD KEY `fk_comments_user` (`user_id`);

--
-- Indices de la tabla `email_logs`
--
ALTER TABLE `email_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email_logs_created` (`created_at`),
  ADD KEY `idx_email_logs_related` (`related_type`,`related_id`),
  ADD KEY `idx_email_logs_status` (`status`);

--
-- Indices de la tabla `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_invoices_number` (`invoice_number`),
  ADD KEY `idx_invoices_client` (`client_id`),
  ADD KEY `idx_invoices_status` (`status`),
  ADD KEY `fk_invoices_budget` (`budget_id`),
  ADD KEY `fk_invoices_created_by` (`created_by`);

--
-- Indices de la tabla `invoice_events`
--
ALTER TABLE `invoice_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_invoice_events_invoice` (`invoice_id`),
  ADD KEY `idx_invoice_events_tenant` (`tenant_id`),
  ADD KEY `idx_invoice_events_created_at` (`created_at`);

--
-- Indices de la tabla `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `job_applications`
--
ALTER TABLE `job_applications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_candidate_id` (`candidate_id`);

--
-- Indices de la tabla `job_application_status_logs`
--
ALTER TABLE `job_application_status_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_application_log` (`application_id`);

--
-- Indices de la tabla `jwt_refresh_tokens`
--
ALTER TABLE `jwt_refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `login_logs`
--
ALTER TABLE `login_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ip_address` (`ip_address`),
  ADD KEY `idx_email_attempted` (`email_attempted`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indices de la tabla `mktg_automations`
--
ALTER TABLE `mktg_automations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mktg_auto_tenant` (`tenant_id`),
  ADD KEY `idx_mktg_auto_status` (`status`),
  ADD KEY `idx_mktg_auto_deleted` (`deleted_at`);

--
-- Indices de la tabla `mktg_automation_steps`
--
ALTER TABLE `mktg_automation_steps`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mktg_steps_automation` (`automation_id`),
  ADD KEY `idx_mktg_steps_order` (`step_order`);

--
-- Indices de la tabla `mktg_campaigns`
--
ALTER TABLE `mktg_campaigns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mktg_campaigns_tenant` (`tenant_id`),
  ADD KEY `idx_mktg_campaigns_status` (`status`),
  ADD KEY `idx_mktg_campaigns_schedule` (`scheduled_at`),
  ADD KEY `idx_mktg_campaigns_deleted` (`deleted_at`);

--
-- Indices de la tabla `mktg_contacts`
--
ALTER TABLE `mktg_contacts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_mktg_contacts_email_list` (`email`,`list_id`),
  ADD UNIQUE KEY `uk_mktg_contacts_token` (`unsubscribe_token`),
  ADD KEY `idx_mktg_contacts_tenant` (`tenant_id`),
  ADD KEY `idx_mktg_contacts_list` (`list_id`),
  ADD KEY `idx_mktg_contacts_status` (`status`),
  ADD KEY `idx_mktg_contacts_deleted` (`deleted_at`),
  ADD KEY `idx_contacts_segment` (`tenant_id`,`list_id`,`status`,`country`,`industry`),
  ADD KEY `idx_contacts_tags` (`tenant_id`,`list_id`,`tags`);

--
-- Indices de la tabla `mktg_conversion_events`
--
ALTER TABLE `mktg_conversion_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mktg_conv_tenant` (`tenant_id`),
  ADD KEY `idx_mktg_conv_campaign` (`campaign_id`),
  ADD KEY `idx_mktg_conv_contact` (`contact_id`),
  ADD KEY `idx_mktg_conv_type` (`conversion_type`);

--
-- Indices de la tabla `mktg_events`
--
ALTER TABLE `mktg_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mktg_events_campaign` (`campaign_id`),
  ADD KEY `idx_mktg_events_contact` (`contact_id`),
  ADD KEY `idx_mktg_events_send_log` (`send_log_id`),
  ADD KEY `idx_mktg_events_type` (`event_type`),
  ADD KEY `idx_mktg_events_occurred` (`occurred_at`),
  ADD KEY `idx_events_search` (`campaign_id`,`event_type`,`contact_id`),
  ADD KEY `idx_events_behavior` (`contact_id`,`event_type`,`occurred_at`);

--
-- Indices de la tabla `mktg_lists`
--
ALTER TABLE `mktg_lists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mktg_lists_tenant` (`tenant_id`),
  ADD KEY `idx_mktg_lists_deleted` (`deleted_at`);

--
-- Indices de la tabla `mktg_send_log`
--
ALTER TABLE `mktg_send_log`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_mktg_send_log_token` (`tracking_token`),
  ADD KEY `idx_mktg_send_log_campaign` (`campaign_id`),
  ADD KEY `idx_mktg_send_log_status` (`status`),
  ADD KEY `idx_mktg_send_log_provider_msg` (`provider_message_id`),
  ADD KEY `idx_mktg_send_log_queued` (`queued_at`);

--
-- Indices de la tabla `mktg_templates`
--
ALTER TABLE `mktg_templates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mktg_templates_tenant` (`tenant_id`),
  ADD KEY `idx_mktg_templates_deleted` (`deleted_at`);

--
-- Indices de la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_user_read` (`user_id`,`is_read`),
  ADD KEY `idx_notifications_created` (`created_at`);

--
-- Indices de la tabla `payment_receipts`
--
ALTER TABLE `payment_receipts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_receipts_invoice` (`invoice_id`),
  ADD KEY `fk_receipts_uploaded_by` (`uploaded_by`),
  ADD KEY `fk_receipts_verified_by` (`verified_by`);

--
-- Indices de la tabla `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `project_deliverables`
--
ALTER TABLE `project_deliverables`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_deliverables_service` (`active_service_id`),
  ADD KEY `fk_deliverables_user` (`uploaded_by`);

--
-- Indices de la tabla `roles_custom`
--
ALTER TABLE `roles_custom`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `permission_id` (`permission_id`);

--
-- Indices de la tabla `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_services_slug` (`slug`),
  ADD KEY `idx_services_category` (`category_id`);

--
-- Indices de la tabla `service_categories`
--
ALTER TABLE `service_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_service_categories_slug` (`slug`);

--
-- Indices de la tabla `service_plans`
--
ALTER TABLE `service_plans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_service_plans_service` (`service_id`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sessions_last_activity` (`last_activity`) COMMENT 'Índice para garbage collection',
  ADD KEY `idx_sessions_user` (`user_id`) COMMENT 'Índice para consultas por usuario',
  ADD KEY `idx_sessions_expiry` (`last_activity`);

--
-- Indices de la tabla `tenants`
--
ALTER TABLE `tenants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `domain` (`domain`);

--
-- Indices de la tabla `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_tickets_number` (`ticket_number`),
  ADD KEY `idx_tickets_client` (`client_id`),
  ADD KEY `idx_tickets_assigned` (`assigned_to`),
  ADD KEY `idx_tickets_status` (`status`),
  ADD KEY `idx_tickets_service_plan` (`service_plan_id`),
  ADD KEY `idx_tickets_created_at` (`created_at`);

--
-- Indices de la tabla `ticket_attachments`
--
ALTER TABLE `ticket_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_attachments_ticket` (`ticket_id`),
  ADD KEY `fk_attachments_user` (`user_id`);

--
-- Indices de la tabla `ticket_tasks`
--
ALTER TABLE `ticket_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ticket_tasks_ticket` (`ticket_id`),
  ADD KEY `idx_ticket_tasks_tenant` (`tenant_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_users_uuid` (`uuid`),
  ADD UNIQUE KEY `uk_users_email` (`email`),
  ADD KEY `idx_users_role` (`role`),
  ADD KEY `idx_users_created_at` (`created_at`),
  ADD KEY `idx_users_company` (`company`);

--
-- Indices de la tabla `user_dashboard_config`
--
ALTER TABLE `user_dashboard_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_widget_unique` (`user_id`,`widget_key`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `active_services`
--
ALTER TABLE `active_services`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=435;

--
-- AUTO_INCREMENT de la tabla `automation_logs`
--
ALTER TABLE `automation_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `automation_rules`
--
ALTER TABLE `automation_rules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `blacklist`
--
ALTER TABLE `blacklist`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `blog_categories`
--
ALTER TABLE `blog_categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `blog_posts`
--
ALTER TABLE `blog_posts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `budgets`
--
ALTER TABLE `budgets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `budget_items`
--
ALTER TABLE `budget_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `candidates`
--
ALTER TABLE `candidates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `candidate_update_tokens`
--
ALTER TABLE `candidate_update_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `chat_messages`
--
ALTER TABLE `chat_messages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `email_logs`
--
ALTER TABLE `email_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `invoice_events`
--
ALTER TABLE `invoice_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `job_applications`
--
ALTER TABLE `job_applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `job_application_status_logs`
--
ALTER TABLE `job_application_status_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `jwt_refresh_tokens`
--
ALTER TABLE `jwt_refresh_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `login_logs`
--
ALTER TABLE `login_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=167;

--
-- AUTO_INCREMENT de la tabla `mktg_automations`
--
ALTER TABLE `mktg_automations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mktg_automation_steps`
--
ALTER TABLE `mktg_automation_steps`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mktg_campaigns`
--
ALTER TABLE `mktg_campaigns`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mktg_contacts`
--
ALTER TABLE `mktg_contacts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mktg_conversion_events`
--
ALTER TABLE `mktg_conversion_events`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mktg_events`
--
ALTER TABLE `mktg_events`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mktg_lists`
--
ALTER TABLE `mktg_lists`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mktg_send_log`
--
ALTER TABLE `mktg_send_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mktg_templates`
--
ALTER TABLE `mktg_templates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT de la tabla `payment_receipts`
--
ALTER TABLE `payment_receipts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `project_deliverables`
--
ALTER TABLE `project_deliverables`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `roles_custom`
--
ALTER TABLE `roles_custom`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `services`
--
ALTER TABLE `services`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `service_categories`
--
ALTER TABLE `service_categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `service_plans`
--
ALTER TABLE `service_plans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `tenants`
--
ALTER TABLE `tenants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `ticket_attachments`
--
ALTER TABLE `ticket_attachments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ticket_tasks`
--
ALTER TABLE `ticket_tasks`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `user_dashboard_config`
--
ALTER TABLE `user_dashboard_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `active_services`
--
ALTER TABLE `active_services`
  ADD CONSTRAINT `fk_active_services_activated_by` FOREIGN KEY (`activated_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_active_services_client` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_active_services_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_active_services_plan` FOREIGN KEY (`service_plan_id`) REFERENCES `service_plans` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_active_services_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `automation_logs`
--
ALTER TABLE `automation_logs`
  ADD CONSTRAINT `automation_logs_ibfk_1` FOREIGN KEY (`rule_id`) REFERENCES `automation_rules` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `blog_posts`
--
ALTER TABLE `blog_posts`
  ADD CONSTRAINT `fk_blog_posts_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_blog_posts_category` FOREIGN KEY (`category_id`) REFERENCES `blog_categories` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `budgets`
--
ALTER TABLE `budgets`
  ADD CONSTRAINT `fk_budgets_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_budgets_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `budget_items`
--
ALTER TABLE `budget_items`
  ADD CONSTRAINT `fk_budget_items_budget` FOREIGN KEY (`budget_id`) REFERENCES `budgets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD CONSTRAINT `fk_chat_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_chat_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `fk_comments_parent` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_comments_post` FOREIGN KEY (`post_id`) REFERENCES `blog_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `fk_invoices_budget` FOREIGN KEY (`budget_id`) REFERENCES `budgets` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_invoices_client` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_invoices_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `payment_receipts`
--
ALTER TABLE `payment_receipts`
  ADD CONSTRAINT `fk_receipts_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receipts_uploaded_by` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receipts_verified_by` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `project_deliverables`
--
ALTER TABLE `project_deliverables`
  ADD CONSTRAINT `fk_deliverables_author` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_deliverables_service` FOREIGN KEY (`active_service_id`) REFERENCES `active_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles_custom` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `services`
--
ALTER TABLE `services`
  ADD CONSTRAINT `fk_services_category` FOREIGN KEY (`category_id`) REFERENCES `service_categories` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `service_plans`
--
ALTER TABLE `service_plans`
  ADD CONSTRAINT `fk_service_plans_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `fk_tickets_assigned` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_client` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_service_plan` FOREIGN KEY (`service_plan_id`) REFERENCES `service_plans` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ticket_attachments`
--
ALTER TABLE `ticket_attachments`
  ADD CONSTRAINT `fk_attachments_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_attachments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `ticket_tasks`
--
ALTER TABLE `ticket_tasks`
  ADD CONSTRAINT `fk_ticket_tasks_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
