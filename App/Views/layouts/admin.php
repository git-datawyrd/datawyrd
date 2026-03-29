<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <?php echo $title; ?>
    </title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link
        href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Space+Grotesk:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="<?php echo url('assets/css/style.css?v=1.3'); ?>">
    <link rel="icon" type="image/x-icon" href="<?php echo url('assets/images/DataWyrd.ico'); ?>">
    <script>window.APP_URL = "<?php echo url(); ?>";
        window.SESSION_CONFIG = {
            lifetime: <?php echo \Core\Config::get('security.session_lifetime'); ?>,
            heartbeat: <?php echo \Core\Config::get('security.session_heartbeat'); ?>,
            warning: <?php echo \Core\Config::get('security.session_warning'); ?>
        };
    </script>
</head>

<body class="bg-deep-black">
    <!-- Preloader corporativo -->
    <div id="preloader">
        <img src="<?php echo url('assets/images/DataWyrd.ico'); ?>" alt="Data Wyrd" class="preloader-logo">
        <div class="preloader-dots">
            <span class="dot">.</span><span class="dot">.</span><span class="dot">.</span>
        </div>
    </div>

    <script>
        (function() {
            const preloader = document.getElementById('preloader');
            const referrer = document.referrer || '';
            const isInternal = referrer.includes(window.location.hostname);
            
            // Definimos qué rutas consideramos "dentro del panel administrador" (excluyendo el request publico)
            const adminPaths = ['/dashboard', '/admin', '/ticket', '/users'];
            const fromAdmin = isInternal && adminPaths.some(p => referrer.includes(p)) && !referrer.includes('/ticket/request');
            
            // En admin.php, carga el preloader cuando entras desde cualquier lado que NO sea admin (externo, publico local, o link directo)
            const isEntry = !fromAdmin;
            
            if (isEntry) {
                window.addEventListener('load', () => {
                    setTimeout(() => {
                        preloader.classList.add('fade-out');
                        setTimeout(() => preloader.style.display = 'none', 300);
                    }, 900);
                });
            } else {
                preloader.style.display = 'none';
            }
        })();
    </script>


    <div class="d-flex min-vh-100">
        <!-- Sidebar Overlay (mobile) -->
        <div id="sidebar-overlay" class="position-fixed w-100 h-100 bg-black bg-opacity-50 d-none"
            style="z-index: 1040; top: 0; left: 0;"></div>

        <!-- Sidebar -->
        <aside id="main-sidebar"
            class="bg-midnight border-end border-white-10 flex-shrink-0 d-flex flex-column sidebar-responsive">
            <div class="p-4 border-bottom border-white-10 bg-deep-black bg-opacity-50 side-header">
                <a href="<?php echo url(); ?>"
                    class="text-decoration-none d-flex align-items-center gap-3 side-logo-link">
                    <img src="<?php echo url('assets/images/DataWyrd_logo.png'); ?>" alt="Logo"
                        class="rounded-circle shadow-gold side-logo-img"
                        style="width: 38px; height: 38px; object-fit: cover; border: 1px solid var(--elegant-gold);">
                    <h2 class="text-white h5 mb-0 fw-bold tracking-tight text-gradient side-logo-text">
                        <?php echo \Core\Config::get('business.company_name'); ?>
                    </h2>
                </a>
                <button id="close-sidebar" class="btn text-white-50 d-lg-none p-0 border-0">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <nav class="flex-grow-1 p-3 mt-2 overflow-y-auto">
                <p class="text-white-50 x-small fw-bold uppercase px-3 mb-2 tracking-widest"><?php echo __('nav.main_menu'); ?></p>

                <a href="<?php echo url('dashboard'); ?>"
                    class="nav-link-custom mb-1 <?php echo ($_SERVER['REQUEST_URI'] == '/dashboard' || $_SERVER['REQUEST_URI'] == '/' || strpos($_SERVER['REQUEST_URI'], 'dashboard') !== false) ? 'active' : ''; ?>">
                    <span class="material-symbols-outlined">dashboard</span>
                    <?php echo __('nav.dashboard'); ?>
                </a>

                <?php if (\Core\Auth::isClient()): ?>
                    <a href="<?php echo url('ticket'); ?>"
                        class="nav-link-custom mb-1 <?php echo ($_SERVER['REQUEST_URI'] == url('ticket') || strpos($_SERVER['REQUEST_URI'], '/ticket') !== false) ? 'active' : ''; ?>">
                        <span class="material-symbols-outlined">confirmation_number</span>
                        <?php echo __('nav.tickets'); ?>
                    </a>
                    <a href="#" class="nav-link-custom mb-1">
                        <span class="material-symbols-outlined">inventory_2</span>
                        <?php echo __('nav.projects'); ?>
                    </a>
                    <a href="<?php echo url('invoice'); ?>"
                        class="nav-link-custom mb-1 <?php echo strpos($_SERVER['REQUEST_URI'], '/invoice') !== false ? 'active' : ''; ?>">
                        <span class="material-symbols-outlined">receipt_long</span>
                        <?php echo __('nav.invoices'); ?>
                    </a>
                <?php endif; ?>

                <?php if (\Core\Auth::isAdmin() || \Core\Auth::isStaff()): ?>
                    <a href="<?php echo url('ticket'); ?>"
                        class="nav-link-custom mb-1 <?php echo (strpos($_SERVER['REQUEST_URI'], '/ticket') !== false && strpos($_SERVER['REQUEST_URI'], '/ticket/request') === false) ? 'active' : ''; ?>">
                        <span class="material-symbols-outlined">support_agent</span>
                        <?php echo __('nav.tickets'); ?>
                    </a>
                    <a href="<?php echo url('project/workspace'); ?>"
                        class="nav-link-custom mb-1 <?php echo strpos($_SERVER['REQUEST_URI'], '/project/workspace') !== false ? 'active' : ''; ?>">
                        <span class="material-symbols-outlined">folder_shared</span>
                        <?php echo __('nav.projects'); ?>
                    </a>
                    <a href="<?php echo url('invoice'); ?>"
                        class="nav-link-custom mb-1 <?php echo strpos($_SERVER['REQUEST_URI'], '/invoice') !== false ? 'active' : ''; ?>">
                        <span class="material-symbols-outlined">receipt_long</span>
                        <?php echo __('nav.invoices'); ?>
                    </a>
                <?php endif; ?>

                <?php if (\Core\Auth::isAdmin()): ?>
                    <p class="text-white-50 x-small fw-bold uppercase px-3 mt-4 mb-2 tracking-widest"><?php echo __('nav.admin_section'); ?></p>
                    <a href="<?php echo url('admin/services'); ?>"
                        class="nav-link-custom mb-1 <?php echo strpos($_SERVER['REQUEST_URI'], 'admin/services') !== false ? 'active' : ''; ?>">
                        <span class="material-symbols-outlined">settings_suggest</span>
                        CMS de Servicios
                    </a>
                    <a href="<?php echo url('admin/blog'); ?>"
                        class="nav-link-custom mb-1 <?php echo strpos($_SERVER['REQUEST_URI'], 'admin/blog') !== false ? 'active' : ''; ?>">
                        <span class="material-symbols-outlined">newspaper</span>
                        Gestión de Blog
                    </a>
                    <a href="<?php echo url('admin/users'); ?>"
                        class="nav-link-custom mb-1 <?php echo strpos($_SERVER['REQUEST_URI'], 'admin/users') !== false ? 'active' : ''; ?>">
                        <span class="material-symbols-outlined">shield_person</span>
                        Usuarios y Roles
                    </a>
                    <a href="<?php echo url('admin/log'); ?>"
                        class="nav-link-custom mb-1 <?php echo strpos($_SERVER['REQUEST_URI'], 'admin/log') !== false ? 'active' : ''; ?>">
                        <span class="material-symbols-outlined">history_edu</span>
                        Logs de Auditoría
                    </a>
                    <a href="<?php echo url('admin/jobs'); ?>"
                        class="nav-link-custom mb-1 <?php echo strpos($_SERVER['REQUEST_URI'], 'admin/jobs') !== false ? 'active' : ''; ?>">
                        <span class="material-symbols-outlined">work</span>
                        Módulo de RRHH
                    </a>
                    <a href="<?php echo url('admin/posts'); ?>"
                        class="nav-link-custom mb-1 <?php echo strpos($_SERVER['REQUEST_URI'], 'admin/posts') !== false ? 'active' : ''; ?>">
                        <span class="material-symbols-outlined">share</span>
                        Post en RRSS
                    </a>
                <?php endif; ?>

                <div class="mt-auto p-3">
                    <a href="<?php echo url(); ?>"
                        class="btn btn-outline-primary btn-sm w-100 py-3 rounded-4 fw-bold uppercase tracking-widest d-flex align-items-center justify-content-center gap-2">
                        <span class="material-symbols-outlined fs-5">open_in_new</span> Ver Sitio Público
                    </a>
                </div>
            </nav>

            <div class="p-3 border-top border-white-10">
                <div class="user-card glass-morphism p-3 rounded-4 d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-midnight d-flex align-items-center justify-content-center text-accent fw-bold"
                        style="width: 40px; height: 40px;">
                        <?php echo strtoupper(substr(\Core\Auth::user()['name'], 0, 1)); ?>
                    </div>
                    <div class="flex-grow-1 overflow-hidden">
                        <p class="text-white small fw-bold mb-0 text-truncate">
                            <?php echo \Core\Auth::user()['name']; ?>
                        </p>
                        <p class="text-white-50 x-small mb-0 text-truncate uppercase">
                            <?php echo \Core\Auth::role(); ?>
                        </p>
                    </div>
                    <div class="d-flex flex-column gap-1">
                        <a href="<?php echo url('profile/settings'); ?>" class="text-white-50 hover-gold transition-all"
                            title="<?php echo __('nav.settings'); ?>">
                            <span class="material-symbols-outlined fs-5">settings</span>
                        </a>
                        <a href="<?php echo url('auth/logout'); ?>" class="text-white-50 hover-gold transition-all"
                            title="<?php echo __('nav.logout'); ?>">
                            <span class="material-symbols-outlined fs-5">logout</span>
                        </a>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="flex-grow-1 overflow-auto bg-deep-black" style="max-height: 100vh;">
            <header
                class="bg-midnight bg-opacity-75 border-bottom border-white-10 sticky-top p-3 px-md-4 backdrop-blur">
                <div class="d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center gap-3">
                        <button id="toggle-sidebar" class="btn text-white p-0 border-0 d-lg-none">
                            <span class="material-symbols-outlined fs-2">menu</span>
                        </button>
                        <h2 class="h5 text-white fw-black mb-0">
                            <?php echo $title; ?>
                        </h2>
                    </div>
                    <div class="d-flex align-items-center gap-2 gap-md-3">
                        <button id="theme-toggle-btn" type="button"
                            class="btn btn-outline-light btn-sm rounded-circle p-2 border-white-10 d-flex align-items-center justify-content-center"
                            title="Cambiar Tema">
                            <span class="material-symbols-outlined fs-5" id="theme-icon">light_mode</span>
                        </button>
                        <div class="dropdown">
                            <button id="notification-btn" type="button" data-bs-toggle="dropdown" aria-expanded="false"
                                class="btn btn-outline-light btn-sm rounded-circle p-2 border-white-10 d-flex align-items-center justify-content-center position-relative">
                                <span class="material-symbols-outlined fs-5">notifications</span>
                                <span id="notification-badge"
                                    class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-2 border-midnight d-none"
                                    style="padding: 0.35em;"></span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end shadow-lg border-white-10 glass-morphism p-0 overflow-hidden"
                                style="width: 320px; max-height: 400px; overflow-y: auto !important; margin-top: 10px;">
                                <div
                                    class="p-3 border-bottom border-white-10 d-flex justify-content-between align-items-center bg-midnight">
                                    <h6 class="mb-0 fw-bold text-white small uppercase tracking-widest">Notificaciones
                                    </h6>
                                    <button
                                        class="btn btn-link py-0 px-2 text-primary x-small text-decoration-none fw-bold"
                                        id="mark-read-btn">Marcar Leídas</button>
                                </div>
                                <div id="notification-dropdown-items" class="d-flex flex-column">
                                    <div class="p-4 text-center text-white-50 small placeholder-text">No hay
                                        notificaciones nuevas.</div>
                                </div>
                            </ul>
                        </div>
                        <div class="dropdown me-2">
                            <button class="btn btn-outline-light btn-sm rounded-pill px-3 border-white-10 d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <span class="material-symbols-outlined fs-6">language</span>
                                <span class="x-small fw-bold uppercase"><?php echo \Core\Session::get('locale', 'es'); ?></span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-dark shadow-lg border-white-10 glass-morphism">
                                <li><a class="dropdown-item x-small fw-bold" href="?lang=es">Español</a></li>
                                <li><a class="dropdown-item x-small fw-bold" href="?lang=en">English</a></li>
                            </ul>
                        </div>
                        <div class="bg-white-10 d-none d-md-block" style="width: 1px; height: 24px;"></div>
                        <span class="text-white-50 small fw-bold d-none d-md-inline">
                            <?php echo date('d M, Y'); ?>
                        </span>
                    </div>
                </div>
            </header>

            <div class="p-3 p-md-4 p-lg-5 mb-5 mb-lg-0">
                <?php echo $content; ?>
            </div>

            <!-- Quick Action Bar (Mobile Only) -->
            <div class="d-lg-none position-fixed bottom-0 start-0 w-100 bg-midnight border-top border-white-10 backdrop-blur d-flex justify-content-around py-2 px-1 no-print"
                style="z-index: 1030; height: 65px;">
                <a href="<?php echo url('dashboard'); ?>"
                    class="d-flex flex-column align-items-center text-decoration-none <?php echo strpos($_SERVER['REQUEST_URI'], 'dashboard') !== false ? 'text-primary' : 'text-white-50'; ?>">
                    <span class="material-symbols-outlined">dashboard</span>
                    <span class="x-small fw-bold">Inicio</span>
                </a>
                <a href="<?php echo url('ticket'); ?>"
                    class="d-flex flex-column align-items-center text-decoration-none <?php echo strpos($_SERVER['REQUEST_URI'], 'ticket') !== false ? 'text-primary' : 'text-white-50'; ?>">
                    <span class="material-symbols-outlined">confirmation_number</span>
                    <span class="x-small fw-bold">Tickets</span>
                </a>
                <a href="<?php echo url('invoice'); ?>"
                    class="d-flex flex-column align-items-center text-decoration-none <?php echo strpos($_SERVER['REQUEST_URI'], 'invoice') !== false ? 'text-primary' : 'text-white-50'; ?>">
                    <span class="material-symbols-outlined">receipt_long</span>
                    <span class="x-small fw-bold">Facturas</span>
                </a>
                <a href="<?php echo url('profile/settings'); ?>"
                    class="d-flex flex-column align-items-center text-decoration-none <?php echo strpos($_SERVER['REQUEST_URI'], 'settings') !== false ? 'text-primary' : 'text-white-50'; ?>">
                    <span class="material-symbols-outlined">settings</span>
                    <span class="x-small fw-bold">Perfil</span>
                </a>
            </div>
        </main>
    </div>

    <!-- Toast Notification Container -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 2000;">
        <div id="liveToast" class="toast align-items-center text-white bg-glass border-0" role="alert"
            aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body d-flex align-items-center gap-2">
                    <span id="toastIcon" class="material-symbols-outlined fs-5">info</span>
                    <span id="toastMessage"></span>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                    aria-label="Close"></button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .sidebar-responsive {
            width: 280px;
            transition: transform 0.3s ease;
        }

        @media (max-width: 991.98px) {
            .sidebar-responsive {
                position: fixed;
                top: 0;
                left: 0;
                height: 100vh;
                z-index: 1050;
                transform: translateX(-100%);
            }

            .sidebar-responsive.active {
                transform: translateX(0);
            }

            #main-sidebar {
                overflow-y: auto !important;
                max-height: 100vh;
                padding-bottom: 80px !important;
            }

            .side-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .side-logo-link {
                flex-direction: column;
                gap: 8px !important;
                width: 100%;
                text-align: center;
            }

            .side-logo-img {
                width: 45px !important;
                height: 45px !important;
            }

            .side-logo-text {
                font-size: var(--text-base) !important;
            }
        }

        .nav-link-custom {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            border-radius: 12px;
            color: rgba(255, 255, 255, 0.6);
            text-decoration: none;
            font-size: var(--text-sm);
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .nav-link-custom:hover {
            background: rgba(255, 255, 255, 0.05);
            color: var(--elegant-gold);
        }

        .nav-link-custom.active {
            background: rgba(212, 175, 55, 0.1);
            color: var(--elegant-gold);
            border: 1px solid rgba(212, 175, 55, 0.2);
        }

        .nav-link-custom .material-symbols-outlined {
            font-size: 1.25rem;
        }

        .backdrop-blur {
            backdrop-filter: blur(15px);
        }

        .text-accent {
            color: var(--tech-blue) !important;
        }

        /* Responsive Table adjustments */
        .table-responsive {
            scrollbar-width: thin;
            scrollbar-color: var(--elegant-gold) var(--deep-black);
            position: relative;
        }

        /* Subtle indicator that table is scrollable */
        .table-responsive::after {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            bottom: 0;
            width: 30px;
            background: linear-gradient(to right, transparent, rgba(0, 0, 0, 0.5));
            pointer-events: none;
            opacity: 0;
            transition: opacity 0.3s;
        }

        @media (max-width: 991.98px) {
            .table-responsive::after {
                opacity: 1;
            }
        }

        #sidebar-overlay {
            transition: opacity 0.3s ease;
            opacity: 0;
            visibility: hidden;
        }

        #sidebar-overlay.active {
            opacity: 1;
            visibility: visible;
            display: block !important;
        }

        @media (max-width: 575.98px) {
            header h2 {
                font-size: 0.9rem !important;
                max-width: 160px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            header .btn-outline-light {
                padding: 0.4rem !important;
            }
        }
    </style>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const toggleBtn = document.getElementById('toggle-sidebar');
            const closeBtn = document.getElementById('close-sidebar');
            const sidebar = document.getElementById('main-sidebar');
            const overlay = document.getElementById('sidebar-overlay');

            function toggleSidebar() {
                sidebar.classList.toggle('active');
                overlay.classList.toggle('active');
                document.body.style.overflow = sidebar.classList.contains('active') ? 'hidden' : '';
            }

            if (toggleBtn) toggleBtn.addEventListener('click', toggleSidebar);
            if (closeBtn) closeBtn.addEventListener('click', toggleSidebar);
            if (overlay) overlay.addEventListener('click', toggleSidebar);

            // --- Theme Toggle Logic ---
            const themeBtn = document.getElementById('theme-toggle-btn');
            const themeIcon = document.getElementById('theme-icon');
            const htmlEl = document.documentElement;

            // Load saved theme
            const savedTheme = localStorage.getItem('datawyrd-theme') || 'dark';
            htmlEl.setAttribute('data-theme', savedTheme);
            updateThemeIcon(savedTheme);

            if (themeBtn) {
                themeBtn.addEventListener('click', () => {
                    const currentTheme = htmlEl.getAttribute('data-theme');
                    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';

                    htmlEl.setAttribute('data-theme', newTheme);
                    localStorage.setItem('datawyrd-theme', newTheme);
                    updateThemeIcon(newTheme);
                });
            }

            function updateThemeIcon(theme) {
                if (themeIcon) {
                    themeIcon.textContent = theme === 'dark' ? 'light_mode' : 'dark_mode';
                }
            }
        });
    </script>
    <script>
        window.showToast = function (message, type = 'info') {
            const toastEl = document.getElementById('liveToast');
            const toastIcon = document.getElementById('toastIcon');
            const toastMessage = document.getElementById('toastMessage');

            const icons = {
                success: 'check_circle',
                error: 'error',
                warning: 'warning',
                info: 'info'
            };

            const colors = {
                success: 'bg-success',
                error: 'bg-danger',
                warning: 'bg-warning',
                info: 'bg-primary'
            };

            toastIcon.innerText = icons[type] || 'info';
            toastEl.className = `toast align-items-center text-white border-0 ${colors[type] || 'bg-primary'}`;
            toastMessage.innerText = message;

            const toast = new bootstrap.Toast(toastEl);
            toast.show();
        };

        document.addEventListener('DOMContentLoaded', function () {
            <?php if ($msg = \Core\Session::flash('success')): ?>
                showToast("<?php echo $msg; ?>", 'success');
            <?php endif; ?>
            <?php if ($msg = \Core\Session::flash('error')): ?>
                showToast("<?php echo $msg; ?>", 'error');
            <?php endif; ?>
        });
    </script>
    <script src="<?php echo url('assets/js/session_monitor.js'); ?>"></script>
    <script src="<?php echo url('assets/js/notifications.js'); ?>"></script>
    <script src="<?php echo url('assets/js/realtime.js'); ?>"></script>
</body>

</html>