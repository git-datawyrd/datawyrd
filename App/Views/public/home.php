<!-- Hero Section -->
<section
    class="min-vh-100 d-flex align-items-center justify-content-center pt-5 hero-bg position-relative overflow-hidden">
    <!-- Video Background -->
    <video autoplay muted loop playsinline class="position-absolute w-100 h-100"
        style="object-fit: cover; z-index: 1; opacity: 0.6;"
        poster="<?php echo url('assets/images/hero_background.png'); ?>">
        <source src="<?php echo url('assets/images/DataWyrd_hero.mp4'); ?>" type="video/mp4">
    </video>
    <!-- Overlay -->
    <div class="position-absolute w-100 h-100 bg-deep-black opacity-50" style="z-index: 2;"></div>

    <div class="container text-center pt-5 position-relative" style="z-index: 3;">
        <div
            class="badge hero-badge text-wrap rounded-pill border border-primary text-primary px-2 px-md-3 py-2 mb-4 text-uppercase fw-bold tracking-widest">
            <span class="d-inline-block rounded-circle bg-primary me-2 shadow-gold"
                style="width: 8px; height: 8px;"></span>
            Arquitectura de Datos & Analítica Avanzada
        </div>
        <h1 class="display-2 fw-black text-white mb-4 tracking-tight" style="font-size: clamp(2.1rem, 5vw, 4rem);">
            Construimos la columna vertebral de tu <br><span class="text-primary text-gradient">inteligencia de
                negocio.</span>
        </h1>
        <p class="lead text-white-50 mx-auto mb-5" style="max-width: 750px;">
            Diseñamos arquitecturas de datos que eliminan el caos operativo, reducen riesgo estructural y convierten la
            información en ventaja competitiva real.
        </p>
        <div class="d-flex flex-column flex-sm-row justify-content-center gap-3 hero-btns">
            <a href="#contacto" class="btn btn-primary px-4 py-3 shadow-gold fw-bold uppercase tracking-widest">Iniciar
                Diagnóstico Estratégico</a>
            <a href="#como-trabajamos" class="btn btn-outline-light px-4 py-3 fw-bold uppercase tracking-widest">Ver
                Cómo Generamos Impacto</a>
        </div>

    </div>
</section>

<!-- Por qué trabajar con nosotros (PRD v1.0) -->
<section id="por-que-nosotros" class="bg-midnight border-top border-white-5 section-fluid-y">
    <div class="container py-5">
        <div class="row align-items-start g-5">
            <div class="col-lg-5">
                <h6 class="text-primary fw-bold text-uppercase tracking-widest mb-3">Diferenciación Estratégica</h6>
                <h2 class="display-5 fw-bold text-white mb-4">¿Por qué confiar en <span
                        class="text-gradient"><?php echo \Core\Config::get('business.company_name'); ?></span>?</h2>
                <p class="text-white-50 mb-5">No solo implementamos tecnología. Diseñamos sistemas que impactan
                    directamente en la rentabilidad, la eficiencia y la capacidad de crecimiento de tu empresa.</p>
                <div class="row g-4">
                    <div class="col-12">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle bg-white-5 p-2 text-primary">
                                <span class="material-symbols-outlined">visibility</span>
                            </div>
                            <div>
                                <h6 class="text-white mb-1 fw-bold">Visión End-to-End</h6>
                                <p class="text-white-50 small mb-0">Control total desde la ingesta hasta la toma de
                                    decisiones.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle bg-white-5 p-2 text-primary">
                                <span class="material-symbols-outlined">analytics</span>
                            </div>
                            <div>
                                <h6 class="text-white mb-1 fw-bold">Orientación a Decisiones Reales</h6>
                                <p class="text-white-50 small mb-0">Datos accionables que impactan directamente en tu
                                    rentabilidad.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 mt-4 pt-2">
                        <div
                            class="d-flex align-items-center gap-3 p-4 rounded-4 border border-white-10 bg-white-5 hover-lift w-100">
                            <div
                                class="rounded-circle bg-midnight p-2 text-primary d-flex align-items-center justify-content-center">
                                <span class="material-symbols-outlined fs-4">hub</span>
                            </div>
                            <p class="text-white-50 small mb-0" style="line-height: 1.6;">
                                <strong class="text-white">Wyrd</strong> representa el entramado invisible que conecta
                                eventos. Nosotros hacemos visible el entramado de tus datos.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-7">
                <!-- Strategic Image (PRD v1.6.5) -->
                <div
                    class="mb-4 position-relative overflow-hidden rounded-5 shadow-2xl border-white-10 hover-lift transition-all">
                    <img src="<?php echo url('assets/images/working.jpg'); ?>" alt="Data Wyrd Team Working"
                        class="img-fluid w-100" style="height: 320px; object-fit: cover; opacity: 0.9;">
                    <div class="position-absolute bottom-0 start-0 w-100 p-4"
                        style="background: linear-gradient(transparent, rgba(10,11,14,0.9));">
                        <div class="d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined text-primary fs-5">verified</span>
                            <span class="text-white x-small fw-bold uppercase tracking-widest">Excelencia Operativa en
                                cada sprint</span>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="glass-morphism p-4 rounded-5 border-white-10 h-100 hover-lift transition-all">
                            <span class="material-symbols-outlined text-primary fs-2 mb-3">monitoring</span>
                            <h5 class="text-white fw-bold mb-3">Portal de Seguimiento Propio</h5>
                            <p class="text-white-50 small">Acceso exclusivo a nuestro portal de clientes para ver el
                                progreso de tus proyectos en tiempo real.</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="glass-morphism p-4 rounded-5 border-white-10 h-100 hover-lift transition-all">
                            <span class="material-symbols-outlined text-accent fs-2 mb-3">update</span>
                            <h5 class="text-white fw-bold mb-3">Optimización Continua</h5>
                            <p class="text-white-50 small">Nuestras arquitecturas nacen preparadas para evolucionar con
                                la complejidad de tu negocio.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>


    </div>
</section>

<?php if (\Core\Config::get('business.show_enterprise_profile', false)): ?>
    <!-- Client Selection Component (PRD Wyrd Enterprise Profile) -->
    <section id="para-quien" class="bg-deep-black border-top border-white-5" style="padding: 7rem 0;">
        <div class="container py-5">
            <div class="row align-items-center g-5">
                <div class="col-lg-6">


                    <h2 class="display-5 fw-bold text-white mb-4">Trabajamos con empresas que...</h2>
                    <p class="lead text-white-50 mb-5">Nuestro perfil ideal (*Ideal Customer Profile*) son organizaciones de
                        mediana/gran escala o StartUps fase Growth que:</p>

                    <ul class="list-unstyled text-white-50">
                        <li class="d-flex align-items-start gap-3 mb-4">
                            <span class="material-symbols-outlined text-accent fs-4 mt-1">dynamic_feed</span>
                            <div>
                                <strong class="text-white d-block mb-1">Múltiples Fuentes Desorganizadas</strong>
                                Lidian con datos aislados en diferentes CRMs, ERPs, o bases de datos sin conexión.
                            </div>
                        </li>
                        <li class="d-flex align-items-start gap-3 mb-4">
                            <span class="material-symbols-outlined text-accent fs-4 mt-1">stairs</span>
                            <div>
                                <strong class="text-white d-block mb-1">Necesitan Escalar Infraestructura</strong>
                                Sus sistemas actuales no soportan el ritmo de crecimiento operativo y requieren cimientos
                                robustos.
                            </div>
                        </li>
                        <li class="d-flex align-items-start gap-3 mb-4">
                            <span class="material-symbols-outlined text-accent fs-4 mt-1">insert_chart</span>
                            <div>
                                <strong class="text-white d-block mb-1">Buscan Decisiones Basadas en Métricas
                                    Reales</strong>
                                Quieren dejar de lado el "intuition-based" y pasar a análisis predecibles con tableros
                                ejecutivos.
                            </div>
                        </li>
                        <li class="d-flex align-items-start gap-3">
                            <span class="material-symbols-outlined text-accent fs-4 mt-1">robot_2</span>
                            <div>
                                <strong class="text-white d-block mb-1">Reducir Dependencia Operativa Manual</strong>
                                Necesitan automatizar reportes y pipelines para que el equipo financiero y el C-Level se
                                enfoque en estrategia.
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="col-lg-6 text-center">
                    <div class="row g-4 justify-content-center">
                        <!-- Social Proof / Authority cards -->
                        <div class="col-md-6">
                            <div
                                class="glass-morphism h-100 p-5 rounded-4 border-primary text-center hover-lift transition-all">
                                <h2 class="display-3 text-white fw-black mb-0"><span
                                        class="text-primary text-gradient">+<?php echo \Core\Config::get('business.years_exp', '10'); ?></span>
                                </h2>
                                <p class="text-white-50 uppercase tracking-widest x-small fw-bold">Años de Exp. Combinada
                                </p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div
                                class="glass-morphism h-100 p-5 rounded-4 border-white-10 text-center hover-lift transition-all">
                                <h2 class="display-3 text-white fw-black mb-0"><span
                                        class="text-accent">+<?php echo \Core\Config::get('business.projects_delivered', '45'); ?></span>
                                </h2>
                                <p class="text-white-50 uppercase tracking-widest x-small fw-bold">Proyectos Entregados</p>
                            </div>
                        </div>
                        <div class="col-12">
                            <div
                                class="glass-morphism h-100 p-5 rounded-4 border-white-10 text-center d-flex align-items-center justify-content-center gap-4 hover-lift transition-all">
                                <span class="material-symbols-outlined text-white-50 fs-2">verified_user</span>
                                <div class="text-start">
                                    <h4 class="text-white fw-bold mb-1">Cero Compromiso de Deuda Técnica</h4>
                                    <p class="text-white-50 small mb-0">Arquitecturas SaaS/Enterprise Grade preparadas para
                                        crecer.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
<?php endif; ?>

<!-- Cómo Trabajamos Section (PRD v1.0) -->
<section id="como-trabajamos" class="cta-parallax-bg border-top border-white-5" style="padding: 7rem 0;">
    <div class="container py-5">
        <div class="glass-morphism rounded-5 p-5 p-lg-5 text-center border-white-10 shadow-2xl">
            <div class="text-center mb-5">
                <h2 class="display-5 fw-bold text-white mb-3">Modelo de Entrega <span class="text-gradient">Data
                        Wyrd™</span></h2>
                <p class="text-white-50 mx-auto" style="max-width: 600px;">Desarrollo iterativo y arquitecturas precisas
                    que garantizan impacto medible en tu negocio desde la entrega del primer sprint.</p>
            </div>

            <div class="row g-4 mt-4">
                <div class="col-md-6 col-lg-3">
                    <div
                        class="process-card p-4 rounded-5 border-white-10 h-100 bg-midnight hover-lift-sm transition-all text-center">
                        <div class="rounded-circle bg-white-5 mx-auto mb-4 d-flex align-items-center justify-content-center text-accent icon-container"
                            style="width: 70px; height: 70px;">
                            <span class="material-symbols-outlined fs-1">search</span>
                        </div>
                        <h4 class="text-white h5 fw-bold mb-3">Diagnóstico</h4>
                        <p class="text-white-50 small mb-0">Análisis profundo de tu infraestructura actual y definición
                            de
                            objetivos comerciales críticos.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div
                        class="process-card p-4 rounded-5 border-white-10 h-100 bg-midnight hover-lift-sm transition-all text-center">
                        <div class="rounded-circle bg-white-5 mx-auto mb-4 d-flex align-items-center justify-content-center text-accent icon-container"
                            style="width: 70px; height: 70px;">
                            <span class="material-symbols-outlined fs-1">architecture</span>
                        </div>
                        <h4 class="text-white h5 fw-bold mb-3">Arquitectura</h4>
                        <p class="text-white-50 small mb-0">Diseño técnico escalable y diseño de la solución de datos
                            adaptada a tus necesidades.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div
                        class="process-card p-4 rounded-5 border-white-10 h-100 bg-midnight hover-lift-sm transition-all text-center">
                        <div class="rounded-circle bg-white-5 mx-auto mb-4 d-flex align-items-center justify-content-center text-accent icon-container"
                            style="width: 70px; height: 70px;">
                            <span class="material-symbols-outlined fs-1">bolt</span>
                        </div>
                        <h4 class="text-white h5 fw-bold mb-3">Implementación</h4>
                        <p class="text-white-50 small mb-2">Desarrollo iterativo. <span
                                class="text-accent fw-bold text-gradient">Impacto medible desde el primer sprint.</span>
                        </p>
                        <p class="text-white-50 small mb-0">Releases pequeños pero completos para evitar riesgo.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div
                        class="process-card p-4 rounded-5 border-white-10 h-100 bg-midnight hover-lift-sm transition-all text-center">
                        <div class="rounded-circle bg-white-5 mx-auto mb-4 d-flex align-items-center justify-content-center text-accent icon-container"
                            style="width: 70px; height: 70px;">
                            <span class="material-symbols-outlined fs-1">trending_up</span>
                        </div>
                        <h4 class="text-white h5 fw-bold mb-3">Optimización</h4>
                        <p class="text-white-50 small mb-0">Ajuste de rendimiento, escalabilidad y soporte continuo para
                            acompañar tu crecimiento.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Excelencia Técnica Section -->
<section id="pilares" class="bg-deep-black" style="padding: 7rem 0;">
    <div class="container py-5">
        <div class="text-center mb-5">
            <h6 class="text-primary fw-bold tracking-widest mb-3">Excelencia Técnica</h6>
            <h2 class="display-5 fw-bold text-white mb-3">Nuestros Pilares</h2>
            <div class="bg-primary mx-auto rounded-pill" style="width: 60px; height: 4px;"></div>
        </div>

        <div class="row g-4 mt-4">
            <?php foreach ($categories as $category): ?>
                <div class="col-md-6 col-lg-3" id="pilar-<?php echo $category['slug']; ?>">
                    <div class="card h-100 border-white-10 bg-midnight p-0 overflow-hidden hover-lift transition-all">
                        <?php if (!empty($category['image'])): ?>
                            <div class="pillar-image-container w-100" style="height: 160px; overflow: hidden;">
                                <img src="<?php echo url($category['image']); ?>" alt="<?php echo $category['name']; ?>"
                                    class="w-100 h-100" style="object-fit: cover; opacity: 0.7;">
                            </div>
                        <?php else: ?>
                            <div class="p-4">
                                <div class="mb-4 d-inline-flex align-items-center justify-content-center rounded-circle bg-midnight text-accent icon-container"
                                    style="width: 55px; height: 55px;">
                                    <span class="material-symbols-outlined fs-2"><?php echo $category['icon']; ?></span>
                                </div>
                            </div>
                        <?php endif; ?>

                        <div class="p-4 pt-3">
                            <h3 class="h6 text-white fw-bold mb-3"><?php echo $category['name']; ?></h3>
                            <p class="text-white-50 small mb-4"><?php echo $category['description']; ?></p>
                            <a href="<?php echo url('service/category/' . $category['slug']); ?>"
                                class="text-primary text-decoration-none fw-bold small text-uppercase tracking-widest mt-auto d-flex align-items-center gap-2">
                                Saber Más <span class="material-symbols-outlined fs-6">arrow_forward</span>
                            </a>
                        </div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section id="contacto" class="pt-5 position-relative overflow-hidden cta-parallax-bg">
    <div class="container py-5 position-relative z-1">
        <div class="glass-morphism rounded-5 p-5 p-lg-5 text-center border-white-10 shadow-2xl">
            <h2 class="display-5 fw-black text-white mb-4">¿Listo para transformar tus datos?</h2>
            <p class="lead text-white-50 mx-auto mb-5" style="max-width: 700px;">
                Únete a las empresas líderes que ya optimizan sus procesos con
                <?php echo \Core\Config::get('business.company_name'); ?>. Diseñemos juntos el futuro de
                tu infraestructura.
            </p>

            <div id="dynamic-ticket-flow">
                <!-- Level 1: Pillars -->
                <div class="mb-4">
                    <h5 class="text-primary fw-bold mb-4 tracking-widest">Paso 1: Selecciona un Pilar</h5>
                    <div id="pillar-selection" class="row g-3 justify-content-center">
                        <?php foreach ($categories as $category): ?>
                            <div class="col-6 col-md-3">
                                <div class="pillar-card glass-morphism rounded-5 p-4 transition-all cursor-pointer h-100"
                                    data-id="<?php echo $category['id']; ?>" data-name="<?php echo $category['name']; ?>"
                                    onclick="selectPillar(this)">
                                    <div class="mb-3 d-inline-flex align-items-center justify-content-center rounded-circle bg-white-5 text-accent icon-container shadow-gold"
                                        style="width: 55px; height: 55px;">
                                        <span class="material-symbols-outlined fs-2"><?php echo $category['icon']; ?></span>
                                    </div>
                                    <h6 class="text-white fw-bold mb-0 x-small tracking-wide">
                                        <?php echo $category['name']; ?>
                                    </h6>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>

                <!-- Step Summary -->
                <div id="flow-summary" class="mb-5 d-none">
                    <div class="d-flex flex-wrap align-items-center justify-content-center gap-3">
                        <div class="x-small uppercase tracking-widest text-white-50 fw-bold me-2">Progreso:</div>
                        <span id="summary-pillar"
                            class="badge rounded-pill bg-white-5 text-accent px-4 py-2 border border-white-10 shadow-gold"></span>
                        <span id="summary-arrow-1"
                            class="material-symbols-outlined text-primary fs-5 d-none animate-flicker">double_arrow</span>
                        <span id="summary-service"
                            class="badge rounded-pill bg-white-10 text-primary px-4 py-2 border border-white-10 shadow-gold d-none"></span>
                    </div>
                </div>

                <!-- Level 2: Services -->
                <div id="service-step" class="mb-5 d-none">
                    <h5 class="text-primary small fw-bold mb-4 text-uppercase tracking-widest">Paso 2: ¿Qué servicio
                        necesitas?</h5>
                    <div id="service-selection" class="row g-3 justify-content-center">
                        <!-- Fetched services here -->
                    </div>
                </div>

                <!-- Level 3: Plans -->
                <div id="plan-step" class="mb-5 d-none">
                    <h5 class="text-primary small fw-bold mb-4 text-uppercase tracking-widest">Paso 3: Elige un Plan
                    </h5>
                    <div id="plan-selection" class="row g-3 justify-content-center">
                        <!-- Fetched plans here -->
                    </div>
                </div>

                <!-- Level 4: Form -->
                <div id="form-step" class="text-start d-none">
                    <div class="glass-morphism p-4 rounded-4 border-white-10 shadow-lg">
                        <h4 class="text-white fw-black mb-4 h4">Completa tu solicitud</h4>
                        <form id="dynamic-ticket-form" action="<?php echo url('ticket/submit'); ?>" method="POST">
                            <?php echo csrf_field(); ?>
                            <input type="hidden" name="service_plan_id" id="selected-plan-id">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="text-white-50 small mb-2 uppercase tracking-widest fw-bold">Nombre
                                        Completo</label>
                                    <input type="text" name="name"
                                        class="form-control bg-midnight border-white-10 text-white p-3"
                                        placeholder="Ej: Juan Pérez" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="text-white-50 small mb-2 uppercase tracking-widest fw-bold">Correo
                                        Electrónico</label>
                                    <input type="email" name="email"
                                        class="form-control bg-midnight border-white-10 text-white p-3"
                                        placeholder="tu@email.com" required>
                                </div>
                                <div class="col-md-6">
                                    <label
                                        class="text-white-50 small mb-2 uppercase tracking-widest fw-bold">Empresa</label>
                                    <input type="text" name="company"
                                        class="form-control bg-midnight border-white-10 text-white p-3"
                                        placeholder="Nombre de tu empresa">
                                </div>
                                <div class="col-md-6">
                                    <label
                                        class="text-white-50 small mb-2 uppercase tracking-widest fw-bold">Teléfono</label>
                                    <input type="text" name="phone"
                                        class="form-control bg-midnight border-white-10 text-white p-3"
                                        placeholder="+1 234...">
                                </div>
                                <div class="col-12">
                                    <label
                                        class="text-white-50 small mb-2 uppercase tracking-widest fw-bold">Asunto</label>
                                    <input type="text" name="subject" id="form-subject"
                                        class="form-control bg-midnight border-white-10 text-white p-3"
                                        placeholder="Ej: Consulta sobre Pipeline de Datos" required>
                                </div>
                                <div class="col-12">
                                    <label
                                        class="text-white-50 small mb-2 uppercase tracking-widest fw-bold">Descripción
                                        del Proyecto</label>
                                    <textarea name="description"
                                        class="form-control bg-midnight border-white-10 text-white p-3" rows="4"
                                        placeholder="Cuéntanos los detalles, objetivos y desafíos de tu solicitud..."
                                        required></textarea>
                                </div>
                                <div class="col-12 mt-4">
                                    <button type="submit"
                                        class="btn btn-primary btn-lg w-100 py-3 fw-bold uppercase tracking-widest shadow-gold">
                                        Enviar Solicitud <span
                                            class="material-symbols-outlined ms-2 align-middle">send</span>
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>
    </div>
</section>

<!-- Data Wyrd OS: Tu Centro de Mando Enterprise (E11-OS) -->
<section id="dw-os-showcase" class="bg-midnight border-top border-white-5 section-fluid-y" style="padding: 7rem 0;">
    <div class="container py-5">
        <div class="row align-items-start g-5">
            <div class="col-lg-5">
                <h6 class="text-primary fw-bold text-uppercase tracking-widest mb-3">Producto Exclusivo</h6>
                <h2 class="display-5 fw-bold text-white mb-4">Data Wyrd <span class="text-gradient">OS</span></h2>
                <p class="text-white-50 mb-5">Un ecosistema digital completo. No solo creamos tu web, te entregamos la infraestructura necesaria para escalar y dominar tu operación diaria.</p>
                
                <div class="row g-4 mb-5">
                    <div class="col-12">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle bg-white-5 p-2 text-primary d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;">
                                <span class="material-symbols-outlined fs-4">groups</span>
                            </div>
                            <div>
                                <h6 class="text-white mb-1 fw-bold">Gestión de usuarios y roles</h6>
                                <p class="text-white-50 small mb-0">Control total de accesos y permisos para tu equipo.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle bg-white-5 p-2 text-primary d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;">
                                <span class="material-symbols-outlined fs-4">chat</span>
                            </div>
                            <div>
                                <h6 class="text-white mb-1 fw-bold">Chat en vivo</h6>
                                <p class="text-white-50 small mb-0">Conexión instantánea con tus clientes en tiempo real.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle bg-white-5 p-2 text-primary d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;">
                                <span class="material-symbols-outlined fs-4">article</span>
                            </div>
                            <div>
                                <h6 class="text-white mb-1 fw-bold">Gestor de contenidos</h6>
                                <p class="text-white-50 small mb-0">Publica y actualiza información sin depender de terceros.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle bg-white-5 p-2 text-primary d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;">
                                <span class="material-symbols-outlined fs-4">receipt_long</span>
                            </div>
                            <div>
                                <h6 class="text-white mb-1 fw-bold">Gestión de Facturas</h6>
                                <p class="text-white-50 small mb-0">Control financiero y facturación profesional integrada.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <a href="<?php echo url('service/detail/sistemas-web-complejos?preselect=Data Wyrd OS Pro'); ?>" class="btn btn-primary px-4 py-3 shadow-gold fw-bold uppercase tracking-widest">
                    Quiero mi Data Wyrd OS
                </a>
            </div>
            
            <div class="col-lg-7">
                <!-- Premium UI Carousel styled like Strategic Image -->
                <div id="osCarousel" class="carousel slide carousel-fade glass-morphism p-2 rounded-5 border-white-10 shadow-2xl overflow-hidden hover-lift transition-all" data-bs-ride="carousel">
                    <div class="carousel-indicators" style="bottom: 20px;">
                        <button type="button" data-bs-target="#osCarousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
                        <button type="button" data-bs-target="#osCarousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
                        <button type="button" data-bs-target="#osCarousel" data-bs-slide-to="2" aria-label="Slide 3"></button>
                        <button type="button" data-bs-target="#osCarousel" data-bs-slide-to="3" aria-label="Slide 4"></button>
                    </div>
                    <div class="carousel-inner rounded-4 shadow-lg border-white-5">
                        <div class="carousel-item active" data-bs-interval="5000">
                            <img src="<?php echo url('assets/images/dw_os_crm.png'); ?>" class="d-block w-100" alt="CRM Leads" style="height: 450px; object-fit: cover; opacity: 0.9;">
                            <div class="position-absolute bottom-0 start-0 w-100 p-4" style="background: linear-gradient(transparent, rgba(10,11,14,0.9));">
                                <p class="mb-0 small fw-bold tracking-widest text-uppercase text-white">Gestión de usuarios y roles</p>
                            </div>
                        </div>
                        <div class="carousel-item" data-bs-interval="5000">
                            <img src="<?php echo url('assets/images/dw_os_ai.png'); ?>" class="d-block w-100" alt="AI Dashboard" style="height: 450px; object-fit: cover; opacity: 0.9;">
                            <div class="position-absolute bottom-0 start-0 w-100 p-4" style="background: linear-gradient(transparent, rgba(10,11,14,0.9));">
                                <p class="mb-0 small fw-bold tracking-widest text-uppercase text-white">Gestor de contenidos</p>
                            </div>
                        </div>
                        <div class="carousel-item" data-bs-interval="5000">
                            <img src="<?php echo url('assets/images/dw_os_realtime.png'); ?>" class="d-block w-100" alt="RealTime Chat" style="height: 450px; object-fit: cover; opacity: 0.9;">
                            <div class="position-absolute bottom-0 start-0 w-100 p-4" style="background: linear-gradient(transparent, rgba(10,11,14,0.9));">
                                <p class="mb-0 small fw-bold tracking-widest text-uppercase text-white">Chat en vivo</p>
                            </div>
                        </div>
                        <div class="carousel-item" data-bs-interval="5000">
                            <img src="<?php echo url('assets/images/dw_os_finops.png'); ?>" class="d-block w-100" alt="FinOps Billing" style="height: 450px; object-fit: cover; opacity: 0.9;">
                            <div class="position-absolute bottom-0 start-0 w-100 p-4" style="background: linear-gradient(transparent, rgba(10,11,14,0.9));">
                                <p class="mb-0 small fw-bold tracking-widest text-uppercase text-white">Gestión de Facturas</p>
                            </div>
                        </div>
                    </div>
                    <!-- Carousel Controls -->
                    <button class="carousel-control-prev" type="button" data-bs-target="#osCarousel" data-bs-slide="prev" style="width: 15%; z-index: 5;">
                        <span class="carousel-control-prev-icon glass-morphism rounded-circle p-3" aria-hidden="true" style="width: 45px; height: 45px; background-size: 50%;"></span>
                        <span class="visually-hidden">Anterior</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#osCarousel" data-bs-slide="next" style="width: 15%; z-index: 5;">
                        <span class="carousel-control-next-icon glass-morphism rounded-circle p-3" aria-hidden="true" style="width: 45px; height: 45px; background-size: 50%;"></span>
                        <span class="visually-hidden">Siguiente</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Blog Preview Section -->
<section class="bg-deep-black border-top border-white-5" style="padding: 7rem 0;">
    <div class="container py-5">
        <div class="row mb-5 align-items-end">
            <div class="col-md-8 mx-auto text-center mb-4">
                <h5 class="text-primary small fw-bold mb-3 text-uppercase tracking-widest">Ideas que anticipan el futuro
                    de los datos</h5>
                <h2 class="display-5 text-white mb-3">Insights & <span class="text-gradient">Tech Blog</span></h2>
                <p class="text-white-50 mx-auto mb-4" style="max-width: 500px;">Compartimos análisis, tendencias y
                    resúmenes de arquitecturas aplicables a la realidad de tu empresa.</p>
                <div class="d-flex flex-wrap justify-content-center gap-2">
                    <button
                        class="btn btn-sm rounded-pill px-4 py-2 uppercase fw-bold tracking-widest filter-btn active"
                        onclick="filterBlog('all')">Todos</button>
                    <?php foreach ($blogCategories as $bCat): ?>
                        <button class="btn btn-sm rounded-pill px-4 py-2 uppercase fw-bold tracking-widest filter-btn"
                            onclick="filterBlog('<?php echo $bCat['slug']; ?>')">
                            <?php echo $bCat['name']; ?>
                        </button>
                    <?php endforeach; ?>
                </div>
            </div>
        </div>

        <div class="row g-4" id="blog-grid">
            <?php foreach ($latestPosts as $post): ?>
                <div class="col-md-4 blog-item" data-category="<?php echo $post['slug']; ?>">
                    <div class="card h-100 border-white-10 bg-midnight overflow-hidden hover-lift transition-all">
                        <img src="<?php echo $post['featured_image']; ?>" class="card-img-top"
                            alt="<?php echo $post['title']; ?>" style="height: 200px; object-fit: cover;">
                        <div class="card-body p-4">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <span class="badge rounded-pill x-small"
                                    style="background-color: <?php echo $post['category_color']; ?>;"><?php echo $post['category_name']; ?></span>
                                <span
                                    class="text-white-50 x-small"><?php echo date('M d, Y', strtotime($post['published_at'])); ?></span>
                            </div>
                            <h5 class="text-white fw-bold h6 mb-3"><?php echo $post['title']; ?></h5>
                            <p class="text-white-50 x-small mb-4 line-clamp-2"><?php echo $post['excerpt']; ?></p>
                            <a href="<?php echo url('blog/post/' . $post['slug']); ?>"
                                class="text-primary text-decoration-none small fw-bold d-flex align-items-center gap-2">
                                Leer Más <span class="material-symbols-outlined fs-6">east</span>
                            </a>
                        </div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>

        <div class="text-center mt-5">
            <a href="<?php echo url('blog'); ?>"
                class="btn btn-primary px-4 py-3 shadow-gold fw-bold uppercase tracking-widest">Seguir leyendo</a>
        </div>
    </div>
</section>

<script>
    async function selectPillar(element) {
        const categoryId = element.dataset.id;
        const categoryName = element.dataset.name;

        // UI Update
        document.querySelectorAll('.pillar-card').forEach(c => c.classList.remove('active', 'border-primary'));
        element.classList.add('active', 'border-primary');

        // Summary
        const summary = document.getElementById('flow-summary');
        summary.classList.remove('d-none');
        document.getElementById('summary-pillar').textContent = categoryName;
        document.getElementById('summary-service').classList.add('d-none');
        document.getElementById('summary-arrow-1').classList.add('d-none');

        // Hide following steps
        document.getElementById('service-step').classList.add('d-none');
        document.getElementById('plan-step').classList.add('d-none');
        document.getElementById('form-step').classList.add('d-none');

        // Fetch Services
        try {
            const response = await fetch(`${window.APP_URL}/service/getByCategory/${categoryId}`);
            const services = await response.json();

            const container = document.getElementById('service-selection');
            container.innerHTML = '';

            services.forEach(service => {
                container.innerHTML += `
                <div class="col-md-4">
                    <div class="service-card glass-morphism rounded-5 p-4 transition-all cursor-pointer h-100 hover-lift" 
                         onclick="selectService(this, ${service.id}, '${service.name}')">
                        <div class="mb-3 d-inline-flex align-items-center justify-content-center rounded-circle bg-white-5 text-accent icon-container shadow-gold"
                            style="width: 55px; height: 55px;">
                            <span class="material-symbols-outlined fs-2">${service.icon || 'settings'}</span>
                        </div>
                        <h6 class="text-white fw-bold mb-3 tracking-wide">${service.name}</h6>
                        <p class="text-white-50 x-small mb-0" style="line-height: 1.6;">${service.short_description || ''}</p>
                    </div>
                </div>
            `;
            });

            document.getElementById('service-step').classList.remove('d-none');
            document.getElementById('service-step').scrollIntoView({ behavior: 'smooth', block: 'center' });
        } catch (error) {
            console.error('Error fetching services:', error);
        }
    }

    async function selectService(element, serviceId, serviceName) {
        // UI Update
        document.querySelectorAll('.service-card').forEach(c => c.classList.remove('active', 'border-primary'));
        element.classList.add('active', 'border-primary');

        // Summary
        document.getElementById('summary-service').textContent = serviceName;
        document.getElementById('summary-service').classList.remove('d-none');
        document.getElementById('summary-arrow-1').classList.remove('d-none');

        // Hide following
        document.getElementById('plan-step').classList.add('d-none');
        document.getElementById('form-step').classList.add('d-none');

        // Fetch Plans
        try {
            const response = await fetch(`${window.APP_URL}/service/getPlans/${serviceId}`);
            const plans = await response.json();

            const container = document.getElementById('plan-selection');
            container.innerHTML = '';

            plans.forEach(plan => {
                const priceHTML = parseFloat(plan.price) > 0
                    ? `<h4 class="text-white fw-bold mb-0 tracking-tight text-center px-2" style="font-size: 2rem; line-height: 1.4;">
                            $${parseFloat(plan.price).toLocaleString()} <span class="x-small text-white-50">u$d</span>
                           </h4>`
                    : '<p class="text-white small mb-0 italic text-center px-3" style="line-height: 1.4;">* El precio varía según complejidad del proyecto</p>';

                const buttonText = parseFloat(plan.price) === 0 ? 'Cotizar' : 'Seleccionar Plan';
                const isFeatured = plan.is_featured == 1;

                container.innerHTML += `
                    <div class="col-md-4">
                        <div class="plan-card glass-morphism rounded-5 p-4 transition-all cursor-pointer h-100 d-flex flex-column hover-lift ${isFeatured ? 'border-primary border-opacity-50' : ''}" 
                             onclick="selectPlan(this, ${plan.id}, '${serviceName} - ${plan.name}')">
                            
                            <div class="d-flex justify-content-between align-items-start mb-4">
                                <h6 class="text-primary fw-bold text-uppercase x-small tracking-widest mb-0 text-gradient">${plan.name}</h6>
                                ${isFeatured ? '<span class="material-symbols-outlined text-primary fs-5 animate-purity">stars</span>' : ''}
                            </div>
                            
                            <div class="mb-4 d-flex align-items-center justify-content-center bg-white-5 rounded-4 p-3" style="min-height: 5rem; border: 1px solid rgba(255,255,255,0.05);">
                                ${priceHTML}
                            </div>

                            <ul class="list-unstyled text-white-50 x-small mb-4 flex-grow-1" style="line-height: 1.8;">
                                ${(plan.features || []).slice(0, 4).map(f => `
                                    <li class="mb-2 d-flex align-items-start gap-2">
                                        <span class="material-symbols-outlined text-accent fs-6 mt-1">check_circle</span> 
                                        <span>${f}</span>
                                    </li>
                                `).join('')}
                            </ul>

                            <div class="mt-auto pt-2">
                                <button class="btn ${isFeatured ? 'btn-primary shadow-gold' : 'btn-muted-outline'} btn-sm w-100 rounded-pill fw-bold uppercase tracking-widest plan-action-btn">
                                    ${buttonText}
                                </button>
                            </div>
                        </div>
                    </div>
                `;
            });

            document.getElementById('plan-step').classList.remove('d-none');
            document.getElementById('plan-step').scrollIntoView({ behavior: 'smooth', block: 'center' });
        } catch (error) {
            console.error('Error fetching plans:', error);
        }
    }

    function selectPlan(element, planId, planFullTitle) {
        // UI Update
        document.querySelectorAll('.plan-card').forEach(c => c.classList.remove('active', 'border-primary'));
        element.classList.add('active', 'border-primary');

        document.getElementById('selected-plan-id').value = planId;
        document.getElementById('form-subject').value = `Solicitud: ${planFullTitle}`;

        document.getElementById('form-step').classList.remove('d-none');
        document.getElementById('form-step').scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    function filterBlog(categorySlug) {
        const items = document.querySelectorAll('.blog-item');
        const buttons = document.querySelectorAll('[onclick^="filterBlog"]');

        buttons.forEach(btn => {
            if (btn.getAttribute('onclick').includes(categorySlug)) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });

        items.forEach(item => {
            if (categorySlug === 'all' || item.dataset.category === categorySlug) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    }

    function animateMetric(element) {
        const value = element.querySelector('.metric-value');
        value.style.transform = 'scale(1.1) rotate(5deg)';
        value.style.display = 'inline-block';
        setTimeout(() => {
            value.style.transform = 'scale(1) rotate(0deg)';
        }, 300);
    }
</script>

<style>
    @keyframes flicker {

        0%,
        100% {
            opacity: 1;
        }

        50% {
            opacity: 0.4;
        }
    }

    @media (max-width: 768px) {
        .hero-badge {
            font-size: 0.65rem !important;
            letter-spacing: 0.1em !important;
            line-height: 1.4;
        }

        .hero-btns {
            max-width: 320px;
            margin: 0 auto;
        }

        .hero-btns .btn {
            width: 100%;
            font-size: 0.75rem !important;
            padding: 0.8rem 1rem !important;
        }
    }

    @keyframes purity {

        0%,
        100% {
            opacity: 1;
            filter: drop-shadow(0 0 2px var(--tech-blue));
        }

        50% {
            opacity: 0.7;
            filter: drop-shadow(0 0 8px var(--tech-blue));
        }
    }

    .animate-flicker {
        animation: flicker 2s infinite ease-in-out;
    }

    .animate-purity {
        animation: purity 3s infinite ease-in-out;
    }

    /* Section specific backgrounds */
    .hero-bg {
        background-color: var(--deep-black);
    }

    .cta-parallax-bg {
        background: linear-gradient(rgba(10, 10, 10, 0.7), rgba(10, 10, 10, 0.7)), url('<?php echo url('assets/images/hero_background.png'); ?>');
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
    }

    /* Selection Step Cards */
    .pillar-card,
    .service-card,
    .plan-card {
        border: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(255, 255, 255, 0.02);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .pillar-card:hover,
    .service-card:hover,
    .plan-card:hover {
        transform: translateY(-8px);
        background: rgba(255, 255, 255, 0.05);
        border-color: var(--tech-blue) !important;
        box-shadow: 0 15px 35px -10px rgba(0, 0, 0, 0.5);
    }

    .pillar-card.active,
    .service-card.active,
    .plan-card.active {
        background: rgba(48, 197, 255, 0.1);
        border-color: var(--tech-blue) !important;
        box-shadow: 0 0 20px rgba(48, 197, 255, 0.2);
    }

    /* Action Buttons in Selection */
    .btn-muted-outline {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.1) !important;
        color: rgba(255, 255, 255, 0.4) !important;
        transition: all 0.3s ease;
    }

    .plan-card:hover .btn-muted-outline {
        background: var(--tech-blue) !important;
        border-color: var(--tech-blue) !important;
        color: white !important;
        box-shadow: 0 0 15px rgba(48, 197, 255, 0.4);
    }

    .bg-midnight-blue-50 {
        background: rgba(27, 31, 59, 0.5);
    }

    .cursor-pointer {
        cursor: pointer;
    }



    /* OS Showcase Styles (E11-OS) */
    #dw-os-showcase .carousel-item img {
        transition: transform 10s ease-in-out;
    }
    #dw-os-showcase .carousel-item.active img {
        transform: scale(1.1);
    }
    #dw-os-showcase .carousel-indicators [data-bs-target] {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background-color: var(--primary);
        opacity: 0.3;
        margin: 0 5px;
        border: none;
    }
    #dw-os-showcase .carousel-indicators .active {
        opacity: 1;
        transform: scale(1.3);
        box-shadow: 0 0 10px var(--primary);
    }
    #dw-os-showcase .glass-morphism {
        backdrop-filter: blur(15px);
        background: rgba(255, 255, 255, 0.03);
    }

    /* Text Gradient & Effects */
    .shadow-gold {
        box-shadow: 0 0 25px rgba(212, 175, 55, 0.2);
    }

    /* Global Typography Harmony Overrides */
    .display-2 {
        font-weight: 900;
        letter-spacing: -0.03em;
    }

    .display-5 {
        font-weight: 900;
        letter-spacing: -0.02em;
    }

    /* Filter Buttons Matching Pillar Cards */
    .filter-btn {
        background: rgba(255, 255, 255, 0.02);
        border: 1px solid rgba(255, 255, 255, 0.1) !important;
        color: rgba(255, 255, 255, 0.5) !important;
        transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        font-size: 0.75rem;
    }

    .filter-btn:hover {
        transform: translateY(-3px);
        background: rgba(255, 255, 255, 0.05) !important;
        border-color: var(--tech-blue) !important;
        color: white !important;
    }

    .filter-btn.active {
        background-color: var(--steel-blue) !important;
        border-color: var(--steel-blue) !important;
        color: white !important;
        box-shadow: 0 0 15px rgba(51, 101, 138, 0.4);
        transform: scale(1.05);
    }

    .process-card {
        border: 1px solid rgba(255, 255, 255, 0.05);
        background: rgba(255, 255, 255, 0.01);
    }

    .hover-lift-sm:hover {
        transform: translateY(-5px);
        border-color: var(--tech-blue) !important;
        background: rgba(48, 197, 255, 0.05);
    }

    .step-number {
        opacity: 0.2;
        font-family: var(--font-heading);
        line-height: 1;
    }

    /* Responsive Refinements */
    @media (max-width: 768px) {
        section {
            padding: 4rem 0 !important;
        }

        .hero-bg {
            padding-top: 5rem !important;
        }

        .display-2 {
            font-size: 2.5rem !important;
        }

        .display-3 {
            font-size: 3rem !important;
        }

        .display-5 {
            font-size: 1.8rem !important;
        }

        .p-5 {
            padding: 2rem !important;
        }

        .pillar-card,
        .service-card,
        .plan-card {
            padding: 1.5rem !important;
        }

        .icon-container {
            width: 50px !important;
            height: 50px !important;
        }

        .icon-container span {
            font-size: 1.5rem !important;
        }

        /* Home specifically: improve dynamic flow layout on mobile */
        #dynamic-ticket-flow .row {
            --bs-gutter-x: 1rem;
        }

        #dynamic-ticket-flow .col-6 {
            padding: 0.5rem;
        }
    }

    @media (max-width: 576px) {
        .display-2 {
            font-size: 2.2rem !important;
        }

        .lead {
            font-size: 1rem !important;
        }

        .hero-bg .btn {
            padding: 0.8rem 1.5rem !important;
            font-size: 0.8rem !important;
        }
    }
</style>