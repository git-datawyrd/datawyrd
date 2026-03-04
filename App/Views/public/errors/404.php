<div class="container-fluid min-vh-100 d-flex align-items-center justify-content-center p-0 overflow-hidden position-relative"
    style="background: #0A0A0A;">
    <!-- Abstract Background Ambient Light -->
    <div class="position-absolute top-0 start-0 w-100 h-100 opacity-20"
        style="background: radial-gradient(circle at 50% 50%, #30C5FF33 0%, transparent 70%);"></div>

    <div class="row g-0 w-100 align-items-center position-relative" style="z-index: 2;">
        <!-- Image Section -->
        <div class="col-lg-7 d-none d-lg-block">
            <div class="error-visual-container p-5 position-relative">
                <div class="glass-mask position-absolute w-100 h-100 top-0 start-0"
                    style="background: linear-gradient(90deg, #0A0A0A 0%, transparent 20%, transparent 80%, #0A0A0A 100%); z-index: 3;">
                </div>
                <img src="<?php echo url('assets/images/error_404.png'); ?>" alt="Digital Void 404"
                    class="img-fluid rounded-5 shadow-lg border-gold-glow animate-float">

                <!-- Relocated 404 Number -->
                <div class="position-absolute bottom-0 end-0 opacity-10 select-none pe-none p-4 text-end"
                    style="color: #D4AF37; z-index: 4; transform: translateY(-10px) translateX(-10px);">
                    <div style="font-size: 8rem; font-weight: 900; line-height: 0.7;">404</div>
                    <div
                        style="font-size: 2rem; font-weight: 700; letter-spacing: 0.5rem; text-transform: uppercase; margin-top: -0.5rem;">
                        Error</div>
                </div>
            </div>
        </div>

        <!-- Content Section -->
        <div class="col-lg-5 p-5">
            <div class="error-content text-start">
                <span
                    class="badge bg-gold-gradient text-black px-3 py-2 rounded-pill fw-black mb-3 small tracking-widest uppercase animate-slide-in">Error
                    404</span>
                <h1 class="display-1 fw-black text-white mb-0 tracking-tighter">
                    PÁGINA NO <span class="text-gold-gradient">ENCONTRADA</span>
                </h1>
                <p class="lead text-white-50 mt-4 mb-5 max-w-400 animate-fade-in">
                    La página que intentas acceder no existe o fue movida de lugar.
                </p>

                <div class="d-flex gap-3 animate-slide-up">
                    <a href="<?php echo url('/'); ?>"
                        class="btn btn-primary px-5 py-3 rounded-pill fw-bold shadow-gold d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined">home</span>
                        Volver al Inicio
                    </a>
                    <button onclick="window.history.back()"
                        class="btn btn-outline-light px-4 py-3 rounded-pill fw-bold border-white-10 d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined">arrow_back</span>
                        Regresar
                    </button>
                </div>

                <div
                    class="mt-5 pt-5 border-top border-white-10 text-white-10 d-flex align-items-center gap-4 animate-fade-in-slow">
                    <div class="d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-6">security</span>
                        <span class="x-small uppercase tracking-widest fw-bold">Audit Secure</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-6">hub</span>
                        <span class="x-small uppercase tracking-widest fw-bold">Nodes Verified</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<style>
    .text-gold-gradient {
        background: linear-gradient(135deg, #D4AF37 0%, #F9E29B 50%, #D4AF37 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    .bg-gold-gradient {
        background: linear-gradient(135deg, #D4AF37 0%, #F9E29B 100%);
    }

    .border-gold-glow {
        border: 1px solid rgba(212, 175, 55, 0.2);
        box-shadow: 0 0 50px rgba(0, 0, 0, 0.5), 0 0 20px rgba(212, 175, 55, 0.1);
    }

    .animate-float {
        animation: float 6s ease-in-out infinite;
    }

    @keyframes float {

        0%,
        100% {
            transform: translateY(0);
        }

        50% {
            transform: translateY(-20px);
        }
    }

    .animate-slide-in {
        animation: slideIn 0.8s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .animate-fade-in {
        animation: fadeIn 1.2s ease;
    }

    .animate-fade-in-slow {
        animation: fadeIn 2s ease;
    }

    .animate-slide-up {
        animation: slideUp 1s cubic-bezier(0.16, 1, 0.3, 1);
    }

    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateX(-30px);
        }

        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
        }

        to {
            opacity: 1;
        }
    }

    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(40px);
        }

        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .max-w-400 {
        max-width: 400px;
    }

    @media (max-width: 991px) {
        .display-1 {
            font-size: 4rem;
        }
    }
</style>