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
            <div class="col-lg-5 text-center text-lg-start">
                <h6 class="text-primary fw-bold text-uppercase tracking-widest mb-3">Producto Exclusivo</h6>
                <h2 class="display-5 fw-bold text-white mb-4">Data Wyrd <span class="text-gradient">OS</span></h2>
                <p class="text-white-50 mb-5">Un ecosistema digital completo. No solo creamos tu web, te entregamos la infraestructura necesaria para escalar y dominar tu operación diaria.</p>
                
                <div class="d-inline-flex flex-column text-start gap-4 mb-5">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-white-5 p-2 text-primary d-flex align-items-center justify-content-center flex-shrink-0" style="width: 45px; height: 45px;">
                            <span class="material-symbols-outlined fs-4">groups</span>
                        </div>
                        <div>
                            <h6 class="text-white mb-1 fw-bold small">Gestión de usuarios y roles</h6>
                            <p class="text-white-50 x-small mb-0">Control total de accesos y permisos para tu equipo.</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-white-5 p-2 text-primary d-flex align-items-center justify-content-center flex-shrink-0" style="width: 45px; height: 45px;">
                            <span class="material-symbols-outlined fs-4">chat</span>
                        </div>
                        <div>
                            <h6 class="text-white mb-1 fw-bold small">Chat en vivo</h6>
                            <p class="text-white-50 x-small mb-0">Conexión instantánea con tus clientes en tiempo real.</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-white-5 p-2 text-primary d-flex align-items-center justify-content-center flex-shrink-0" style="width: 45px; height: 45px;">
                            <span class="material-symbols-outlined fs-4">article</span>
                        </div>
                        <div>
                            <h6 class="text-white mb-1 fw-bold small">Gestor de contenidos</h6>
                            <p class="text-white-50 x-small mb-0">Publica y actualiza información sin depender de terceros.</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-white-5 p-2 text-primary d-flex align-items-center justify-content-center flex-shrink-0" style="width: 45px; height: 45px;">
                            <span class="material-symbols-outlined fs-4">receipt_long</span>
                        </div>
                        <div>
                            <h6 class="text-white mb-1 fw-bold small">Gestión de Facturas</h6>
                            <p class="text-white-50 x-small mb-0">Control financiero y facturación profesional integrada.</p>
                        </div>
                    </div>
                </div>

                <a href="<?php echo url('service/detail/sistemas-web-complejos?preselect=Data Wyrd OS Pro'); ?>" class="btn btn-primary px-4 py-3 shadow-gold fw-bold uppercase tracking-widest">
                    Quiero mi Data Wyrd OS
                </a>
            </div>
            
            <div class="col-lg-7 d-none d-lg-block">
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
