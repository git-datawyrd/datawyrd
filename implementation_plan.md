# Plan de Implementación Consolidado (Fase 11.5.0)

## Módulo 1: Core de Seguridad y Hardening (COMPLETADO)
- [x] Crear `Core/EnvValidator.php` para exigir `.env` estructurado (JWT_SECRET, DB config, APP_ENV, APP_KEY).
- [x] Unificar Bootstrap en `Core/bootstrap.php` que invoca `EnvValidator` fallando explícitamente y evita duplicidades en index.php y bin/console.
- [x] Generar claves únicas por entorno en los `.env`.

## Módulo 2: Experiencia de Usuario - Preloader (COMPLETADO)
- [x] Añadir diseño CSS (`pulse-glow`) en `style.css`.
- [x] Inyectar en `layouts/public.php`, `layouts/admin.php` controlando el `referrer` o `sessionStorage`.
- [x] Inyectar de manera reactiva en el módulo de RRHH (`public/jobs/index.php`) durante el submit final o validación OTP, unificando la navegación.

## Módulo 3: Refactorización Service-Repository Restante (COMPLETADO)
- [x] Modificar `DashboardService` e implementar `getStats`/`getRecentWithClients` en `TicketRepository` (Solucionado `FATAL ERROR`).
- [x] Refactorizar `ProjectController.php` extrayendo consultas a `ProjectRepository` y lógica a `ProjectService`.
- [x] Refactorizar `InvoiceController.php` centralizando el manejo de pagos, pasarela MP y listados a `InvoiceService` / `InvoiceRepository`.
- [x] Integrar Notificaciones automáticas a administradores al subirse un comprobante de pago.

## Módulo 4: RBAC Imputable y Consola Unificada (COMPLETADO)
- [x] Generar Migración de `rbac_audit_logs` y ejecutar en Base de Datos.
- [x] Modificar `Admin/UserCMSController.php` para registrar cambios de rol de usuarios de manera inmutable.
- [x] Configurar `Core/Console/Kernel.php` con comandos: `migrate`, `worker`, `diag`.
- [x] Crear el binario centralizado `bin/console`.

## Módulo 5: Testing (COMPLETADO)
- [x] Validar que no hay errores fatales de inyección de dependencias.
- [x] Correr y corregir la batería de test automatizados `vendor/bin/phpunit` comprobando el correcto funcionamiento de `InvoiceEvent` e `InvoiceService` con Service-Repository.
