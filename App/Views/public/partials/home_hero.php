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
            <a href="#contacto" class="btn btn-primary px-4 py-3 shadow-gold fw-bold uppercase tracking-widest">Iniciar Diagnóstico</a>
            <a href="#como-trabajamos" class="btn btn-outline-light px-4 py-3 fw-bold uppercase tracking-widest">Ver
                Cómo Generamos Impacto</a>
        </div>

    </div>
</section>
