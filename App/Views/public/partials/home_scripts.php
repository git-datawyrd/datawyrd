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