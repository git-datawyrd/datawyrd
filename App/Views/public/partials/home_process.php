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
