**Estado al:** 16 de Marzo, 2026 (Mobile UX Perfection & Navigation Hardening)  
**Versión:** 11.2.1  
**Estado:** ✅ **Evolución 11.2.1: Menú Reactivo, Alineación Mobile y Producto Exclusivo (Desplegado)**

## 🎯 Visión del Proyecto
Data Wyrd OS ha culminado su transición hacia una plataforma enterprise de alto rendimiento. Con la implementación de la **Fase 4**, el sistema cuenta ahora con seguridad criptográfica impenetrable, observabilidad inmutable y rutinas analíticas de IA que evitan cuellos de botella mediante asincronía y CRON.

---

## 🏗️ Arquitectura Avanzada (Fase 4)

El sistema ahora opera bajo un modelo de **Arquitectura de Capas** refinada y resistente:

1.  **Capa de Gestión de Dependencias:** Integración total de **Composer** para estándares PSR-4.
2.  **Capa de Eventos (Async-Ready):** Desacoplamiento total mediante `Core\EventDispatcher`.
3.  **Capa de Dominio (Pure Domain):** Reglas de negocio puras en `App\Domain`.
4.  **Capa de Servicios (Services):** Orquestadores de flujos en `App\Services`.
5.  **Capa API v1:** Enrutamiento especializado en `Core\ApiRouter` con seguridad **JWT**.
6.  **Capa de Observabilidad:** Logger estructurado JSON y trazabilidad universal vía `request_id`.
7.  **Capa de Calidad (Test-Driven):** Suite de pruebas unitarias con **PHPUnit**.

---

## ✅ Cumplimiento PRD Técnico (DEMO Ready)

### 1. Gestión de Entornos Profesional
- [x] **ENVIRONMENT**: Soporte obligatorio para `local`, `demo`, `production`.
- [x] **Zero Hardcode**: URLs y credenciales cargadas dinámicamente desde el entorno. Implementación total del helper `url()` en todas las vistas administrativas y de cliente.
- [x] **Configuración Jerárquica**: Carga exacta `.env` > `app.php` > `{env}.php`.

### 2. Blindaje de Seguridad y Estructura
- [x] **CSRF Global**: Verificación automática en `Core\App` para todas las peticiones POST. Estandarización de `csrf_field()` en formularios de tickets, chat, presupuestos, facturas y gestión de proyectos.
- [x] **Config Unificado**: Eliminación de `config()` global en favor de `Core\Config::get()`.
- [x] **Autoload PSR-4**: Estructura `Core/` y `App/` con primera letra en mayúscula para compatibilidad Linux.
- [x] **Session Hardening**: Cookies con flags `HttpOnly`, `Secure` y `SameSite`. 
- [x] **Session Fixation**: Regeneración de ID tras login exitoso.
- [x] **File Protection**: Validación MIME real de archivos y desactivación de motor PHP en directorio de subidas via `.htaccess`.

### 3. Operatividad y Monitoreo
- [x] **Error Handling**: Handler global que oculta detalles técnicos en Demo/Prod y muestra una UI genérica.
- [x] **Logs Fuera de Public**: Registro de errores y envíos de correo en `/storage/logs/`.
- [x] **Mail Control**: Flag `mail_enabled` para evitar envíos accidentales en local.

### 4. Certificación de Infraestructura Zero-Hardcode & Client UX
- [x] **Configuración Pura**: Eliminación de valores por defecto en PHP. El sistema ahora exige configuración vía `.env` para garantizar portabilidad inmediata.
- [x] **Soporte SMTP**: Configuración de correo totalmente mapeada a variables de entorno para facilitar el despliegue en cualquier servidor.
- [x] **Configuración Financiera**: Parámetros como `TAX_RATE` ahora son inyectados desde el entorno.
- [x] **UX de Cliente & Comercial (Fase 6)**: 
    - [x] Enlace lateral "Mis Tickets" apunta correctamente a `/ticket`.
    - [x] Enlace lateral "Mis Facturas" apunta correctamente a `/invoice`.
    - [x] Dashboard dinámico con **Executive Summary Cards** y **Barras de Progreso**.
    - [x] Visualización de metodología y valor en Home ("Cómo trabajamos").
    - [x] Confirmación de solicitud profesional (Página dedicada + Email HTML Premium).
- [x] **Perfección Estética & Armonía (Fase 7)**:
    - [x] Tipografía armónica basada en proporciones áureas (`line-height: 1.7`).
    - [x] Espaciado de secciones expandido (7rem) para sensación premium.
    - [x] Eliminación de ruido visual (números en metodología).
    - [x] Logo dinámico con degradado branding.
    - [x] Harmonización de componentes dinámicos (Cards de JS).
- [x] **Automatización del Flujo Comercial (Fase 8)**:
    - [x] Generación automática de facturas tras aprobación de presupuesto.
    - [x] Orquestación de estados financieros en `InvoiceService`.
    - [x] Confirmación de pago y activación de servicio en un solo paso para Staff.
    - [x] UX de pago inmediato para Clientes ("Ver Factura y Pagar").
    - [x] Notificaciones automatizadas de generación y verificación.
- [x] **Validación de Entorno**: Script de verificación (`verify_env.php`) para diagnóstico rápido de conectividad y variables.
- [x] **Posicionamiento Estratégico Enterprise (Fase 9)**:
    - [x] Actualización de Arquitectura de Categorías ("ETL" a "Arquitectura y Gobierno").
    - [x] Narrativa Ejecutiva orientada a ROI, riesgo y decisiones directivas en la Home.
    - [x] Agregada sección "Para Quién es Data Wyrd" y "Prueba Social" (conmutable vía `SHOW_ENTERPRISE_PROFILE` en `.env`).
    - [x] Zero-Hardcode total garantizado: todas las métricas de autoridad dependen del `.env`.
- [x] **Security Hardening (Fase 10 - Sprint 1)**:
    - [x] **IP & Account Rate Limiting**: Limitador estricto (`Auth_Max_Attempts`) programable por `.env` en endpoints críticos.
    - [x] **Anti Brute-Force**: Bloqueo automático progresivo (`Auth_Account_Lock`) para defender accesos.
    - [x] **Auditoría Forense Avanzada**: Implementación de la tabla `login_logs` interceptando exitos, fallos y perfiles de conexión (IP/User Agent).
    - [x] Acondicionamiento de BD para futura configuración del escáner visual 2FA (TOTP) en Perfil.
- [x] **Enterprise Readiness & FinOps Automation (Fase 11)**:
    - [x] **Zero-Delay Queues (Asincronía):** Emails procesados asíncronamente vía base de datos usando `worker.php` para fluidez total del cliente.
    - [x] **CI/CD Unit Testing:** Capa fundacional de pruebas con PHPUnit simulando motores de pago (`InvoiceServiceTest`).
    - [x] **Man-out-of-the-loop (Webhooks):** Endpoint bypass de seguridad programada en `WebhookController` para automatización financiera integral con confirmación cURL doble hacia MercadoPago.
    - [x] **Blindaje Avanzado de Sesión**: Contención de Race Conditions de CSRF provocadas por recursos estáticos (File Not Found Exceptions mitigadas de forma temprana en Router).
- [x] **Consolidación de Documentación (Limpia la Raíz):**
    - [x] Creación de ecosistema `/docs` para manuales técnicos y `/docs/archive` para historial de implementación.
    - [x] Reducción de ruido visual en la raíz del repositorio, moviendo +15 archivos a la carpeta de archivo técnico.
- [x] **Perfección Mobile UX (Fase 12):**
    - [x] **Footer Colapsable:** Acordeones inteligentes en mobile para condensar la navegación.
    - [x] **Adaptabilidad Tipográfica:** Re-escalado dinámico de fuentes `display` y `padding` de secciones para pantallas táctiles.
    - [x] **Density Optimization:** Grid de KPIs en Dashboard rediseñado para 2 columnas en mobile.
    - [x] **Reactive Navigation:** Menú hamburguesa dinámico que aparece solo tras bajar de la sección Hero para mantener minimalismo.
    - [x] **Adaptive Showcase:** Eliminación de carruseles pesados en mobile y recentrado de elementos de conversión (Data Wyrd OS).
    - [x] **Precision Alignment:** Optimización de la lista de características en mobile para garantizar prolijidad visual y legibilidad.
    - [x] **Scroll Hints:** Indicadores visuales de scroll horizontal en tablas de datos para evitar layouts rotos.

### 5. Evolución 9.5: Arquitectura Enterprise (NUEVO)
- [x] **Composer Core**: Eliminación de autoloaders manuales fragmentados.
- [x] **API Layer v1**: Prefijo `/api/v1` gestionado por un router dedicado que garantiza respuestas JSON puras.
- [x] **JWT Security**: Wrapper `Core\JWT` para generación y validación de tokens de corta duración.
- [x] **Traceability (Request ID)**: Generación de ID de rastreo único por petición para auditoría forense instantánea.
- [x] **Event Dispatcher**: Sistema de pub/sub en `Core\EventDispatcher` para desacoplamiento de procesos.
- [x] **PHPUnit Integration**: Suite de pruebas unitarias cubriendo lógica financiera crítica.
- [x] **Skeleton Screens**: Placeholders animados para carga percibida ultra-veloz.
- [x] **Global Toast System**: Notificaciones reactivas en toda la plataforma.
- [x] **Functional Plan Management**: Implementación de flujos de creación/eliminación de planes de precios.

### 6. Evolución 9.6: Refinamiento UX & CMS (NUEVO)
- [x] **Multi-Select Pillar Filtering**: Sistema de filtrado dinámico en el catálogo de servicios con soporte para selecciones múltiples.
- [x] **Executive growth narrative**: Actualización de la identidad visual de la Home centrada en el crecimiento sostenible y ventaja competitiva.
- [x] **CMS Plan Management**: Formulario de creación de planes integrado en la edición de servicios con eliminación directa.
- [x] **UI Polish**: Mejora en la jerarquía visual de formularios administrativos.
- [x] **Middleware Layer**: Centralización de la lógica de autenticación y RBAC mediante una nueva capa de Middlewares en el core.
- [x] **Rate Limiting Hardening**: Implementación de límites de peticiones en formularios públicos (Tickets) para prevenir abuso y spam.
- [x] **Enterprise SecurityHeaders**: Configuración de CSP, HSTS y X-Frame-Options para blindaje contra ataques de inyección y sniffing.
- [x] **Visual Consistency**: Aplicación de degradados branding (`text-gradient`) en nombres de planes y refinamiento de alineación en cards.

### 7. Fase 4: Inteligencia y Seguridad (NUEVO)
- [x] **Criptografía Argon2id**: Migración completa y transparente del hashing de contraseñas de bcrypt a Argon2id, maximizando protección.
- [x] **Permisos Granulares y RBAC Dinámico**: Tablas `permissions` interconectables configurado vía variable `RBAC_MODE=granular`.
- [x] **Lead Scoring Dinámico**: Lógica predictiva en `LeadService` que puntúa prospectos entre 0 a 100 de manera autónoma (`LEAD_SCORING_ENABLED`).
- [x] **Analíticas Predictivas de Operación**: Notificación proactiva de posibles retrasos en Tickets ejecutándose en `scripts/cron_predictive.php`.
- [x] **Auditorías Inmutables (Zero Trust)**: Los rastros de auditoría están ahora encriptados en cadena SHA256 (columna `signature_hash`) haciendo imposible la manipulación de base de datos sin detección.
- [x] **Asincronía en Correos**: Sustituido motor base por `PHPMailer`, asegurando consistencia en la entrega usando colas a través del archivo `worker.php`.
- [x] **Refinamiento de Permisos RBAC**: Corregido bug de acceso en `LogController` asegurando que el permiso `view_logs` esté correctamente mapeado para administradores en modo granular.

### 8. Evolución 9.7: Premium Admin UI (Executive Mode)
- [x] **Executive Optimized Light Palette**: Implementación de un modo claro de alta gama con separación jerárquica entre sidebar, fondo y contenido.
- [x] **Divided Hierarchy Layering**: El sidebar utiliza un tono pizarra frío (#EEF2F7) para mejorar el enfoque en las tarjetas de datos blancas.
- [x] **High-Visibility Interactivity**: Rediseño total de los estados de hover y activo en tablas y navegación, garantizando 100% de legibilidad mediante el uso de oro vibrante y texto blanco puro en selecciones.
- [x] **Polished Badge System**: Adaptación de todos los indicadores de estado (Pagado, Vencido, etc.) para máxima claridad visual en fondos claros.
- [x] **Consistent CMS Branding**: Harmonización de iconos y botones de configuración para mantener la estética premium en toda la suite administrativa.

### 9. Evolución 9.8: Commercial Flow Hardening (NUEVO)
- [x] **Estado Negativo de Cierre (Anulado)**: Implementación del estado `void` para tickets que no califican como solicitudes de servicio (spam, ofertas, consultas externas).
- [x] **Domain State Transitions**: Actualización de la lógica en `TicketStatus.php` para permitir la anulación desde estados tempranos (Open, In Analysis) y estados operativos.
- [x] **UI Badge Consistency**: Integración de estilos visuales específicos (`badge-dark`) para el estado anulado en dashboards de Admin, Staff y Cliente.
- [x] **SQL Migration Ready**: Generación de script de migración para actualización de esquema ENUM en producción.

### 10. Evolución 9.9: FinOps Automatizado (Pasarelas de Pago)
- [x] **MercadoPago Webhooks**: Checkout activo en UI de cliente comunicándose vía cURL con el endpoint de preferencias, reduciendo deuda o activando servicio global sin requerir personal humano.
- [x] **Pagos Parciales Flexibles**: Se permite seleccionar el monto para abonar partes del adeudo a través de la pasarela MP.
- [x] **Banking Data Unification**: Las cuentas y alias bancarios manuales dependen del entorno y se inyectan estéticamente en tiempo de capa de vista.

### 11. Evolución 10.0: Data Wyrd v3.0 (Inteligencia & SaaS)
- [x] **Business Intelligence Nativo**: `AnalyticsService` para cálculos de conversión (L -> T -> I) y KPIs financieros en tiempo real.
- [x] **Automation Engine**: Motor de reglas IF-THEN para automatizar procesos comerciales y operativos (Notificaciones, Escalaciones).
- [x] **API First Expansion**: Nuevos endpoints v1 para Analytics, Automation y Gestión de Reglas.
- [x] **Workspace Intelligence**: `InsightEngine` que genera recomendaciones proactivas y alertas inteligentes en el dashboard.
- [x] **Observabilidad Avanzada**: `MetricsCollector` para monitoreo de performance y métricas de negocio.
- [x] **Multi-Tenant Foundation**: Infraestructura lista con `TenantResolverMiddleware` y esquema SQL para aislamiento de datos.
- [x] **Pruebas de Calidad**: Suite de tests unitarios para servicios analíticos críticos.
- [x] **Dashboard UI Evolution**: Implementación de widgets avanzados (`bi_indicators`, `insight_alerts`) con gráficos de embudo (Funnel Chart) en tiempo real.
- [x] **Evolución 11.0: Enterprise Reactor & GAI (NUEVO)**:
    - [x] **Generative AI (GAI)**: Integración con OpenAI para resúmenes ejecutivos, extracción de tareas y Copilot de chat.
    - [x] **Real-Time Reactor**: Servidor WebSocket nativo (Ratchet + Redis) para notificaciones y chat instantáneo.
    - [x] **FinOps Event Sourcing**: Migración a modelo inmutable de eventos contables para facturación infalible.
    - [x] **CI/CD Pipeline**: Automatización de pruebas unitarias y despliegue vía GitHub Actions.
    - [x] **Multi-Currency Dynamic Conversion**: Blindaje total de la pasarela de MercadoPago. El sistema ahora garantiza que los cobros y registros contables reflejen la conversión exacta (u$d a ARS) sin pérdida de precisión ni saldo negativo erróneo.
    - [x] **Enterprise Showcase (Data Wyrd OS)**: Sección inmersiva en la Home con diseño Glassmorphism coordinado con la estética de Diferenciación Estratégica.
    - [x] **Automated Funnel (Pre-select Logic)**: Los botones de producto ahora inyectan parámetros de pre-selección en el formulario de contacto, eliminando fricción del cliente.
    - [x] **Agencia Digital & Productos**: Integración de la nueva categoría "Productos" en la navegación global (Header/Footer).

---

| Color | Hex (Dark) | Hex (Light) | Uso Principal |
| :--- | :--- | :--- | :--- |
| **Deep Black** | `#0A0A0A` | `#F6F8FB` | Fondo principal del sistema. |
| **Elegant Gold** | `#D4AF37` | `#B7791F` | **Branding Primario.** Acentos y selecciones. |
| **Main Surface** | `#1B1F3B` | `#FFFFFF` | Cards, contenedores y superficies táctiles. |
| **Tech Blue** | `#30C5FF` | `#0284C7` | **Acceso Digital.** Botones y links de acción. |
| **Primary Text** | `#FFFFFF` | `#0F172A` | Máxima legibilidad y contraste tipográfico. |

---

## 📅 Próximos Pasos Certificados (Data Wyrd Roadmap)
1.  **Mobile Companion App**: Iniciar desarrollo de frontend móvil conectando al `ApiRouter` v1.
2.  **Audit Log Blockchain**: Explorar integración con servicios de log inmutables externos para máxima auditoría.
3.  **Global Multi-Language**: Implementación de archivos de traducción dinámicos.
4.  **Generative Intelligence 2.0**: Automatización de respuestas para tickets recurrentes basada en base de conocimientos.
