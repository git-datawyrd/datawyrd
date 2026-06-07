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
