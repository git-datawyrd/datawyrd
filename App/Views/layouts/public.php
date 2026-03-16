<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <?php echo $title ?? \Core\Config::get('business.company_name'); ?>
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
    <link rel="stylesheet" href="<?php echo url('assets/css/style.css'); ?>">
    <link rel="icon" type="image/x-icon" href="<?php echo url('assets/images/DataWyrd.ico'); ?>">
    <script>window.APP_URL = "<?php echo url(); ?>";</script>
</head>

<?php
// Global fetch for dynamic navigation
$db = \Core\Database::getInstance()->getConnection();
$navCategories = $db->query("SELECT name, slug FROM service_categories WHERE is_active = 1 ORDER BY order_position ASC")->fetchAll();
?>

<body>
    <header class="fixed-top w-100 py-3 glass-morphism border-bottom border-white-10">
        <div class="container d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-3">
                <a href="<?php echo url(); ?>" class="text-decoration-none d-flex align-items-center gap-3">
                    <img src="<?php echo url('assets/images/DataWyrd_logo.png'); ?>" alt="Logo"
                        class="rounded-circle shadow-gold"
                        style="width: 45px; height: 45px; object-fit: cover; border: 1.5px solid var(--elegant-gold);">
                    <h2 class="text-white h5 mb-0 fw-bold tracking-tight text-gradient">
                        <?php echo \Core\Config::get('business.company_name'); ?>
                    </h2>
                </a>
            </div>
            <nav class="d-none d-md-flex align-items-center gap-4">
                <div class="dropdown">
                    <a href="<?php echo url('#pilares'); ?>"
                        class="text-white text-decoration-none x-small transition-colors hover-gold d-flex align-items-center gap-1 dropdown-toggle tracking-widest"
                        id="servicesDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        Servicios
                    </a>
                    <ul class="dropdown-menu dropdown-menu-dark glass-morphism border-white-10 rounded-4 p-2 shadow-2xl mt-2"
                        aria-labelledby="servicesDropdown">
                        <?php foreach ($navCategories as $navCat): ?>
                            <li><a class="dropdown-item small text-white-50 hover-gold transition-all py-2 rounded-3"
                                    href="<?php echo url('service/category/' . $navCat['slug']); ?>"><?php echo $navCat['name']; ?></a>
                            </li>
                        <?php endforeach; ?>
                        <li>
                            <hr class="dropdown-divider border-white-10">
                        </li>
                        <li><a class="dropdown-item small text-primary fw-bold hover-white transition-all py-2 rounded-3"
                                href="<?php echo url('#pilares'); ?>">Ver Todos</a></li>
                    </ul>
                </div>
                <a href="<?php echo url('#dw-os-showcase'); ?>"
                    class="text-white text-decoration-none x-small transition-colors hover-gold tracking-widest">Productos</a>
                <a href="<?php echo url('blog'); ?>"
                    class="text-white text-decoration-none x-small transition-colors hover-gold tracking-widest">Blog</a>
                <a href="<?php echo url('ticket/request'); ?>"
                    class="text-white text-decoration-none x-small transition-colors hover-gold tracking-widest">Contacto</a>
            </nav>
            <div class="d-flex align-items-center gap-2 gap-md-4">
                <?php if (\Core\Auth::check()): ?>
                    <a href="<?php echo url('dashboard'); ?>"
                        class="d-flex flex-column align-items-center text-decoration-none hover-gold transition-colors"
                        title="Ir al Dashboard">
                        <span class="material-symbols-outlined fs-2 text-primary">account_circle</span>
                        <span
                            class="x-small text-white-50 fw-bold mt-1 d-none d-md-block"><?php echo explode(' ', \Core\Auth::user()['name'])[0]; ?></span>
                    </a>
                <?php else: ?>
                    <a href="<?php echo url('auth/login'); ?>"
                        class="d-flex flex-column align-items-center text-decoration-none hover-white transition-colors"
                        title="Acceso Clientes">
                        <span class="material-symbols-outlined fs-2 text-primary">login</span>
                    </a>
                <?php endif; ?>

                <!-- Mobile Hamburger Menu Button -->
                <button id="mobile-toggle" class="d-md-none btn btn-link p-0 d-flex align-items-center justify-content-center border-0" 
                        type="button" data-bs-toggle="offcanvas" data-bs-target="#mobileMenu" aria-controls="mobileMenu">
                    <span class="material-symbols-outlined fs-1 text-gradient">menu</span>
                </button>
            </div>
        </div>
    </header>

    <!-- Mobile Navigation Offcanvas -->
    <div class="offcanvas offcanvas-end glass-morphism border-start border-white-10 text-white" tabindex="-1" id="mobileMenu" aria-labelledby="mobileMenuLabel">
        <div class="offcanvas-header border-bottom border-white-10 py-4">
            <div class="d-flex align-items-center gap-3">
                <img src="<?php echo url('assets/images/DataWyrd_logo.png'); ?>" alt="Logo" class="rounded-circle" style="width: 35px; height: 35px; border: 1px solid var(--elegant-gold);">
                <h5 class="offcanvas-title fw-bold text-gradient" id="mobileMenuLabel">Menú</h5>
            </div>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        </div>
        <div class="offcanvas-body p-0">
            <div class="list-group list-group-flush">
                <a href="<?php echo url(); ?>" class="list-group-item list-group-item-action bg-transparent text-white border-white-5 py-3 px-4 d-flex align-items-center gap-3">
                    <span class="material-symbols-outlined text-primary">home</span> Inicio
                </a>
                
                <div class="list-group-item bg-transparent text-white border-white-5 p-0">
                    <a class="d-flex align-items-center justify-content-between py-3 px-4 text-decoration-none text-white w-100" data-bs-toggle="collapse" href="#mobileServices" role="button" aria-expanded="false">
                        <div class="d-flex align-items-center gap-3">
                            <span class="material-symbols-outlined text-primary">hub</span> Servicios
                        </div>
                        <span class="material-symbols-outlined x-small transition-transform">expand_more</span>
                    </a>
                    <div class="collapse bg-white-5" id="mobileServices">
                        <?php foreach ($navCategories as $navCat): ?>
                            <a href="<?php echo url('service/category/' . $navCat['slug']); ?>" class="d-block py-2 px-5 text-white-50 text-decoration-none small hover-gold">
                                <?php echo $navCat['name']; ?>
                            </a>
                        <?php endforeach; ?>
                        <a href="<?php echo url('#pilares'); ?>" class="d-block py-2 px-5 text-primary text-decoration-none small fw-bold">Ver Todos</a>
                    </div>
                </div>

                <a href="<?php echo url('#dw-os-showcase'); ?>" class="list-group-item list-group-item-action bg-transparent text-white border-white-5 py-3 px-4 d-flex align-items-center gap-3">
                    <span class="material-symbols-outlined text-primary">inventory_2</span> Productos
                </a>
                <a href="<?php echo url('blog'); ?>" class="list-group-item list-group-item-action bg-transparent text-white border-white-5 py-3 px-4 d-flex align-items-center gap-3">
                    <span class="material-symbols-outlined text-primary">rss_feed</span> Blog
                </a>
                <a href="<?php echo url('ticket/request'); ?>" class="list-group-item list-group-item-action bg-transparent text-white border-0 py-3 px-4 d-flex align-items-center gap-3">
                    <span class="material-symbols-outlined text-primary">mail</span> Contacto
                </a>
            </div>
            
            <div class="mt-5 px-4">
                <a href="<?php echo url('auth/login'); ?>" class="btn btn-primary w-100 py-3 d-flex align-items-center justify-content-center gap-2 shadow-gold">
                    <span class="material-symbols-outlined">login</span> Área de Clientes
                </a>
            </div>
        </div>
    </div>

    <main id="top">
        <?php echo $content; ?>
    </main>

    <!-- Toast Container (PRD 9.5) -->
    <div id="toast-container" class="position-fixed bottom-0 end-0 p-3" style="z-index: 10000;"></div>

    <script>
        /**
         * System Toasts Helper
         */
        window.toast = function (message, type = 'primary', duration = 4000) {
            const container = document.getElementById('toast-container');
            const toast = document.createElement('div');
            toast.className = `toast align-items-center text-white bg-${type} border-0 show mb-2 fade-in`;
            toast.setAttribute('role', 'alert');
            toast.setAttribute('aria-live', 'assertive');
            toast.setAttribute('aria-atomic', 'true');

            toast.innerHTML = `
                <div class="d-flex">
                    <div class="toast-body d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined x-small">${type === 'danger' ? 'error' : (type === 'success' ? 'check_circle' : 'info')}</span>
                        <span class="small fw-500">${message}</span>
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            `;

            container.appendChild(toast);
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => toast.remove(), 500);
            }, duration);
        }

        // Auto-show PHP Flash Messages as Toasts
        <?php if (\Core\Session::has('success')): ?>
            window.addEventListener('load', () => window.toast("<?php echo \Core\Session::flash('success'); ?>", 'success'));
        <?php endif; ?>
        <?php if (\Core\Session::has('error')): ?>
            window.addEventListener('load', () => window.toast("<?php echo \Core\Session::flash('error'); ?>", 'danger'));
        <?php endif; ?>
    </script>

    <!-- Floating Scroll Button -->
    <a href="javascript:void(0)" id="scroll-to-top" class="floating-btn" title="Ir arriba">
        <span class="material-symbols-outlined">arrow_upward</span>
    </a>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const scrollBtn = document.getElementById('scroll-to-top');

            // Handle click - go to Diferenciación Estratégica (por-que-nosotros) if exists, otherwise top
            scrollBtn.addEventListener('click', function (e) {
                e.preventDefault();
                const targetSection = document.getElementById('por-que-nosotros');
                if (targetSection) {
                    targetSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                } else {
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                }
            });

            function handleScroll() {
                const targetSection = document.getElementById('por-que-nosotros');
                let triggerHeight = 500;

                if (targetSection) {
                    // Aparecer recién después de haber bajado la sección completa
                    triggerHeight = targetSection.offsetTop + targetSection.offsetHeight;
                }

                if (window.scrollY > triggerHeight) {
                    scrollBtn.classList.add('active-btn');
                } else {
                    scrollBtn.classList.remove('active-btn');
                }
            }

            window.addEventListener('scroll', handleScroll);
            handleScroll();
        });
    </script>

    <footer class="bg-midnight border-top border-white-5 py-5">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <img src="<?php echo url('assets/images/DataWyrd_logo.png'); ?>" alt="Logo"
                            class="rounded-circle" style="width: 35px; height: 35px; object-fit: cover;">
                        <h3 class="text-white h5 mb-0 fw-bold"><?php echo \Core\Config::get('business.company_name'); ?>
                        </h3>
                    </div>
                    <p class="text-white-50 small"><?php echo \Core\Config::get('business.company_slogan'); ?> avanzada
                        para la era de la inteligencia
                        artificial. Transformamos complejidad en claridad estratégica.</p>
                </div>
                <div
                    class="col-12 col-md-2 offset-md-1 mb-3 mb-md-0 border-bottom border-md-0 border-white-5 pb-3 pb-md-0">
                    <h5 class="text-primary small fw-bold mb-md-4 tracking-widest d-flex justify-content-between align-items-center cursor-pointer mb-0"
                        data-bs-toggle="collapse" data-bs-target="#footerServices" aria-expanded="false">
                        Servicios
                        <span class="material-symbols-outlined d-md-none x-small transition-transform"
                            id="iconServices">expand_more</span>
                    </h5>
                    <ul class="list-unstyled text-white-50 small collapse d-md-block mt-3 mt-md-0 mb-0"
                        id="footerServices">
                        <?php foreach ($navCategories as $navCat): ?>
                            <li class="mb-2"><a href="<?php echo url('service/category/' . $navCat['slug']); ?>"
                                    class="text-white-50 text-decoration-none hover-gold transition-colors"><?php echo $navCat['name']; ?></a>
                            </li>
                        <?php endforeach; ?>
                    </ul>
                </div>
                <div class="col-12 col-md-2 mb-3 mb-md-0 border-bottom border-md-0 border-white-5 pb-3 pb-md-0">
                    <h5 class="text-primary small fw-bold mb-md-4 tracking-widest d-flex justify-content-between align-items-center cursor-pointer mb-0"
                        data-bs-toggle="collapse" data-bs-target="#footerNav" aria-expanded="false">
                        Navegación
                        <span class="material-symbols-outlined d-md-none x-small transition-transform"
                            id="iconNav">expand_more</span>
                    </h5>
                    <ul class="list-unstyled text-white-50 small collapse d-md-block mt-3 mt-md-0 mb-0" id="footerNav">
                        <li class="mb-2"><a href="<?php echo url('#como-trabajamos'); ?>"
                                class="text-white-50 text-decoration-none hover-gold transition-colors">Cómo
                                Trabajamos</a></li>
                        <li class="mb-2"><a href="<?php echo url('#dw-os-showcase'); ?>"
                                class="text-white-50 text-decoration-none hover-gold transition-colors">Productos</a></li>
                        <li class="mb-2"><a href="<?php echo url('blog'); ?>"
                                class="text-white-50 text-decoration-none hover-gold transition-colors">Blog</a></li>
                        <li class="mb-2"><a href="<?php echo url('ticket/request'); ?>"
                                class="text-white-50 text-decoration-none hover-gold transition-colors">Contacto</a>
                        </li>
                    </ul>
                </div>
                <div class="col-12 col-md-2 mb-2 mb-md-0 border-bottom border-md-0 border-white-5 pb-3 pb-md-0">
                    <h5 class="text-primary small fw-bold mb-md-4 tracking-widest d-flex justify-content-between align-items-center cursor-pointer mb-0"
                        data-bs-toggle="collapse" data-bs-target="#footerLegal" aria-expanded="false">
                        Legal
                        <span class="material-symbols-outlined d-md-none x-small transition-transform"
                            id="iconLegal">expand_more</span>
                    </h5>
                    <ul class="list-unstyled text-white-50 small collapse d-md-block mt-3 mt-md-0 mb-0"
                        id="footerLegal">
                        <li class="mb-2"><a href="#"
                                class="text-white-50 text-decoration-none hover-gold transition-colors">Privacidad</a>
                        </li>
                        <li class="mb-2"><a href="#"
                                class="text-white-50 text-decoration-none hover-gold transition-colors">Términos</a>
                        </li>
                        <li class="mb-2"><a href="<?php echo url('auth/login'); ?>"
                                class="text-white-50 text-decoration-none hover-gold transition-colors">Acceso</a></li>
                    </ul>
                </div>
            </div>
            <hr class="my-4 border-white-10">
            <div class="d-flex justify-content-between align-items-center text-white-50 x-small">
                <p class="mb-0">© <?php echo date('Y'); ?> <?php echo \Core\Config::get('business.company_name'); ?>.
                    Todos los derechos reservados.</p>
                <div class="d-flex gap-3">
                    <a href="https://github.com/git-datawyrd/datawyrd" target="_blank"
                        class="text-white-50 hover-gold transition-all" title="GitHub">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor"
                            class="bi bi-github" viewBox="0 0 16 16">
                            <path
                                d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27s1.36.09 2 .27c1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.01 8.01 0 0 0 16 8c0-4.42-3.58-8-8-8" />
                        </svg>
                    </a>
                    <a href="https://instagram.com/datawyrd" target="_blank"
                        class="text-white-50 hover-gold transition-all" title="Instagram">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor"
                            class="bi bi-instagram" viewBox="0 0 16 16">
                            <path
                                d="M8 0C5.829 0 5.556.01 4.703.048 3.85.088 3.269.222 2.76.42a3.9 3.9 0 0 0-1.417.923A3.9 3.9 0 0 0 .42 2.76C.222 3.268.087 3.85.048 4.7.01 5.555 0 5.827 0 8.001c0 2.172.01 2.444.048 3.297.04.852.174 1.433.372 1.942.205.526.478.972.923 1.417.444.445.89.719 1.416.923.51.198 1.09.333 1.942.372C5.555 15.99 5.827 16 8 16s2.444-.01 3.298-.048c.851-.04 1.434-.174 1.943-.372a3.9 3.9 0 0 0 1.416-.923c.445-.445.718-.891.923-1.417.197-.509.332-1.09.372-1.942C15.99 10.445 16 10.173 16 8s-.01-2.445-.048-3.299c-.04-.851-.175-1.433-.372-1.941a3.9 3.9 0 0 0-.923-1.417A3.9 3.9 0 0 0 13.24.42c-.51-.198-1.092-.333-1.943-.372C10.443.01 10.172 0 7.998 0zm-.717 1.442h.718c2.136 0 2.389.007 3.232.046.78.035 1.204.166 1.486.275.373.145.64.319.92.599s.453.546.598.92c.11.281.24.705.275 1.485.039.843.047 1.096.047 3.231s-.008 2.389-.047 3.232c-.035.78-.166 1.203-.275 1.485a2.5 2.5 0 0 1-.599.919c-.28.28-.546.453-.92.598-.282.11-.705.24-1.485.276-.843.038-1.096.047-3.232.047s-2.39-.009-3.233-.047c-.78-.036-1.203-.166-1.485-.276a2.5 2.5 0 0 1-.92-.598 2.5 2.5 0 0 1-.6-.92c-.109-.281-.24-.705-.275-1.485-.038-.843-.046-1.096-.046-3.233s.008-2.388.046-3.231c.036-.78.166-1.204.276-1.486.145-.373.319-.64.599-.92s.546-.453.92-.598c.282-.11.705-.24 1.485-.276.738-.034 1.024-.044 2.515-.045zm4.988 1.328a.96.96 0 1 0 0 1.92.96.96 0 0 0 0-1.92m-4.27 1.122a4.109 4.109 0 1 0 0 8.217 4.109 4.109 0 0 0 0-8.217m0 1.441a2.667 2.667 0 1 1 0 5.334 2.667 2.667 0 0 1 0-5.334" />
                        </svg>
                    </a>
                    <a href="#" target="_blank" class="text-white-50 hover-gold transition-all" title="LinkedIn">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor"
                            class="bi bi-linkedin" viewBox="0 0 16 16">
                            <path
                                d="M0 1.146C0 .513.526 0 1.175 0h13.65C15.474 0 16 .513 16 1.146v13.708c0 .633-.526 1.146-1.175 1.146H1.175C.526 16 0 15.487 0 14.854zm4.943 12.248V6.169H2.542v7.225zm-1.2-8.212c.837 0 1.358-.554 1.358-1.248-.015-.709-.52-1.248-1.342-1.248S2.4 3.226 2.4 3.934c0 .694.521 1.248 1.327 1.248zm4.908 8.212V9.359c0-.216.016-.432.08-.586.173-.432.568-.878 1.232-.878.869 0 1.216.662 1.216 1.634v3.865h2.401V9.25c0-2.22-1.184-3.252-2.764-3.252-1.274 0-1.845.7-2.165 1.193v.025h-.016l.016-.025V6.169h-2.4c.03.678 0 7.225 0 7.225z" />
                        </svg>
                    </a>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .hover-gold:hover {
            color: var(--elegant-gold) !important;
        }

        .dropdown-menu-dark .dropdown-item:hover {
            background: rgba(212, 175, 55, 0.1);
        }

        .dropdown-toggle::after {
            display: inline-block;
            margin-left: 0.255em;
            vertical-align: 0.255em;
            content: "";
            border-top: 0.3em solid;
            border-right: 0.3em solid transparent;
            border-bottom: 0;
            border-left: 0.3em solid transparent;
            font-size: 0.8em;
            opacity: 0.7;
        }

        .border-white-10 {
            border-color: rgba(255, 255, 255, 0.1) !important;
        }

        .border-white-5 {
            border-color: rgba(255, 255, 255, 0.05) !important;
        }



        /* Floating Button Styles */
        .floating-btn {
            position: fixed;
            bottom: 30px;
            left: 30px;
            width: 50px;
            height: 50px;
            background: rgba(27, 31, 59, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid var(--elegant-gold);
            border-radius: 12px;
            color: var(--elegant-gold);
            z-index: 9999 !important;
            display: none;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        .floating-btn.active-btn {
            display: flex !important;
        }

        .floating-btn:hover {
            transform: translateY(-5px);
            background: var(--elegant-gold);
            color: var(--midnight-blue);
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.4);
        }

        /* Mobile responsive styles for floating button */
        @media (max-width: 768px) {
            .floating-btn {
                width: 40px;
                height: 40px;
                left: 50%;
                transform: translateX(-50%);
                bottom: 20px;
            }

            .floating-btn:hover {
                transform: translateX(-50%) translateY(-5px);
            }

            .floating-btn .material-symbols-outlined {
                font-size: 20px;
            }
        }

        .btn-tooltip {
            position: absolute;
            left: 65px;
            background: var(--midnight-blue);
            color: var(--white);
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .floating-btn:hover .btn-tooltip {
            opacity: 1;
            visibility: visible;
        }

        /* Footer Collapsible Styles */
        .cursor-pointer {
            cursor: pointer;
        }

        .transition-transform {
            transition: transform 0.3s ease;
        }

        [aria-expanded="true"] .transition-transform {
            transform: rotate(180deg);
        }

        /* Typography & Spacing Refinements (Mobile First) */
        @media (max-width: 768px) {

            h1,
            .display-1 {
                font-size: 2.5rem !important;
            }

            h2,
            .display-5 {
                font-size: 1.8rem !important;
            }

            .py-5 {
                padding-top: 2.5rem !important;
                padding-bottom: 2.5rem !important;
            }

            .section-padding {
                padding: 3rem 0;
            }

            /* Mobile Menu Toggle Animation */
            #mobile-toggle {
                transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            }

            @media (max-width: 768px) {
                #mobile-toggle {
                    opacity: 0;
                    visibility: hidden;
                    transform: translateX(20px) scale(0.8);
                }
                #mobile-toggle.toggle-visible {
                    opacity: 1;
                    visibility: visible;
                    transform: translateX(0) scale(1);
                }
            }
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            /* Mobile Toggle Visibility Logic */
            const mobileToggle = document.getElementById('mobile-toggle');
            const heroSection = document.querySelector('.hero-bg');

            function handleMobileToggleVisibility() {
                if (!mobileToggle) return;
                
                if (heroSection) {
                    // Si hay hero, aparecer cuando el scroll pase el 80% de su altura
                    const triggerHeight = heroSection.offsetHeight * 0.8;
                    if (window.scrollY > triggerHeight) {
                        mobileToggle.classList.add('toggle-visible');
                    } else {
                        mobileToggle.classList.remove('toggle-visible');
                    }
                } else {
                    // En páginas sin hero, siempre visible
                    mobileToggle.classList.add('toggle-visible');
                }
            }

            window.addEventListener('scroll', handleMobileToggleVisibility);
            handleMobileToggleVisibility(); // Initial check

            // Footer Accordion State Handling
            const collapses = ['footerServices', 'footerNav', 'footerLegal'];
            collapses.forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('show.bs.collapse', function () {
                        // Optional: close others if you want accordion style
                    });
                }
            });
        });
    </script>
</body>

</html>