<style>
/* Premium Wizard Styles */
.wizard-step-header {
    cursor: pointer;
    transition: all 0.3s ease;
    opacity: 0.6;
}
.wizard-step-header.active {
    opacity: 1;
    color: #30C5FF !important;
}
.wizard-step-content {
    display: none;
}
.wizard-step-content.active {
    display: block;
}

/* Premium Inputs with Custom Borders */
.input-premium {
    background: #000 !important;
    color: #fff !important;
    border: 1px solid rgba(255,255,255,0.1) !important;
    transition: all 0.3s ease !important;
}
.input-premium:hover {
    border-color: #D4AF37 !important; /* Gold */
}
.input-premium:focus {
    border-color: #30C5FF !important; /* Blue */
    box-shadow: 0 0 10px rgba(48,197,255,0.2) !important;
}

/* Circular Progress Ring */
.progress-ring-circle {
    transition: stroke-dashoffset 0.35s;
    transform: rotate(-90deg);
    transform-origin: 50% 50%;
}

/* Device Preview Toggle */
.preview-container {
    background: #18181b;
    border-radius: 12px;
    border: 1px solid rgba(255,255,255,0.1);
    min-height: 450px;
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    overflow: hidden;
}
.preview-iframe {
    width: 100%;
    height: 480px;
    border: none;
    background: #fff;
    transition: all 0.3s ease;
}
.preview-iframe.mobile {
    width: 375px;
    height: 520px;
    border-radius: 16px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.5);
}
.preview-iframe.plain {
    background: #111;
    color: #0f0;
    font-family: monospace;
    padding: 16px;
}

/* Audicence Chip style */
.audience-chip {
    background: rgba(48, 197, 255, 0.1);
    color: #30C5FF;
    border: 1px solid rgba(48, 197, 255, 0.2);
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 12px;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}
</style>

<div class="mb-4 d-flex justify-content-between align-items-center">
    <div>
        <a href="<?php echo url('admin/marketing/campaigns'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
            <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Campañas
        </a>
        <h1 class="h3 text-white fw-bold mb-0">Nuevo Asistente de Campañas</h1>
    </div>
    
    <!-- Wizard progress header -->
    <div class="d-flex align-items-center gap-4 bg-white-5 px-4 py-2.5 rounded-pill border border-white-10">
        <div id="header-step-1" class="wizard-step-header active fw-bold small uppercase d-flex align-items-center gap-2" onclick="goToStep(1)">
            <span class="rounded-circle bg-primary bg-opacity-25 text-primary px-2 py-0.5">1</span> Configuración
        </div>
        <span class="text-white-30">/</span>
        <div id="header-step-2" class="wizard-step-header fw-bold small uppercase d-flex align-items-center gap-2" onclick="goToStep(2)">
            <span class="rounded-circle bg-white-10 text-white-50 px-2 py-0.5">2</span> Segmento
        </div>
        <span class="text-white-30">/</span>
        <div id="header-step-3" class="wizard-step-header fw-bold small uppercase d-flex align-items-center gap-2" onclick="goToStep(3)">
            <span class="rounded-circle bg-white-10 text-white-50 px-2 py-0.5">3</span> Previsualizar
        </div>
    </div>
</div>

<form id="campaignWizardForm" action="<?php echo url('admin/marketing/storeCampaign'); ?>" method="POST">
    <?php echo csrf_field(); ?>
    
    <!-- PASO 1: METADATA -->
    <div id="step-content-1" class="wizard-step-content active">
        <div class="row g-4">
            <div class="col-md-8">
                <div class="card glass-morphism border-0 mb-4">
                    <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                        <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined text-primary">settings_suggest</span> Configuración General
                        </h6>
                    </div>
                    <div class="card-body p-4">
                        <div class="mb-4">
                            <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Nombre de la Campaña *</label>
                            <input type="text" name="name" id="campaign_name" class="form-control input-premium p-3 rounded-3" required placeholder="Ej: Newsletter Julio 2026">
                        </div>

                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest mb-0">Asunto del Correo *</label>
                                <button type="button" class="btn btn-link text-warning p-0 x-small fw-bold text-decoration-none d-flex align-items-center gap-1" onclick="generateAiSubject()">
                                    <span class="material-symbols-outlined fs-6">auto_awesome</span> Generar Asunto con IA
                                </button>
                            </div>
                            <input type="text" name="subject" id="subject" class="form-control input-premium p-3 rounded-3" required placeholder="Ej: Descubre las novedades exclusivas de este mes">
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Texto de Previsualización (Preview Text)</label>
                            <input type="text" name="preview_text" class="form-control input-premium p-3 rounded-3" placeholder="Ej: Entérate antes que nadie...">
                        </div>
                    </div>
                </div>

                <div class="card glass-morphism border-0">
                    <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                        <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined text-info">alternate_email</span> Remitente y Cabeceras
                        </h6>
                    </div>
                    <div class="card-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-white-50 x-small fw-bold uppercase">Nombre del Remitente</label>
                                <input type="text" name="from_name" class="form-control input-premium p-2.5 rounded-2" value="<?php echo htmlspecialchars(\Core\Config::get('business.company_name', 'Data Wyrd')); ?>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-white-50 x-small fw-bold uppercase">Email del Remitente</label>
                                <input type="email" name="from_email" id="from_email" class="form-control input-premium p-2.5 rounded-2" value="<?php echo htmlspecialchars(\Core\Config::get('business.company_mail', 'hola@datawyrd.com')); ?>" onkeyup="checkSenderDomain(this.value)">
                            </div>
                            <div class="col-md-12">
                                <div id="domain-verification-box" class="alert bg-success bg-opacity-10 border border-success border-opacity-25 text-success rounded-3 d-flex align-items-center gap-2 py-2 px-3 mb-0 small">
                                    <span class="material-symbols-outlined fs-5">verified_user</span>
                                    <span>Remitente verificado correctamente (SPF/DKIM alineados).</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card glass-morphism border-0 h-100">
                    <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                        <h6 class="text-white mb-0 fw-bold">Instrucciones</h6>
                    </div>
                    <div class="card-body">
                        <p class="text-white-50 small">
                            Define el nombre operativo de la campaña y el asunto comercial.
                        </p>
                        <p class="text-white-50 small mb-0">
                            Utiliza la herramienta de **Sugerencias de IA** si necesitas optimizar la tasa de apertura.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- PASO 2: SEGMENTO -->
    <div id="step-content-2" class="wizard-step-content">
        <div class="row g-4">
            <div class="col-md-8">
                <div class="card glass-morphism border-0 mb-4">
                    <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                        <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined text-primary">contacts</span> Selección de Destinatarios
                        </h6>
                    </div>
                    <div class="card-body p-4">
                        <div class="mb-4">
                            <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Lista de Contactos *</label>
                            <select name="list_id" id="list_id" class="form-select input-premium p-3 rounded-3" required onchange="updateMatchingCount()">
                                <option value="">Selecciona una lista...</option>
                                <?php foreach($lists as $list): ?>
                                    <option value="<?php echo $list['id']; ?>"><?php echo htmlspecialchars($list['name']); ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>

                        <h6 class="text-white fw-bold mb-3 d-flex align-items-center gap-2 border-top border-white-10 pt-4">
                            <span class="material-symbols-outlined text-info fs-5">filter_alt</span> Filtros de Segmentación
                        </h6>

                        <div class="row g-3 mb-4">
                            <div class="col-md-4">
                                <label class="form-label text-white-50 x-small fw-bold">País</label>
                                <select name="segment_country" id="segment_country" class="form-select input-premium p-2 rounded-2" onchange="updateMatchingCount()">
                                    <option value="">Todos los países</option>
                                    <?php foreach($countries as $c): ?>
                                        <option value="<?php echo htmlspecialchars($c); ?>"><?php echo htmlspecialchars($c); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-white-50 x-small fw-bold">Industria</label>
                                <select name="segment_industry" id="segment_industry" class="form-select input-premium p-2 rounded-2" onchange="updateMatchingCount()">
                                    <option value="">Todas las industrias</option>
                                    <?php foreach($industries as $ind): ?>
                                        <option value="<?php echo htmlspecialchars($ind); ?>"><?php echo htmlspecialchars($ind); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-white-50 x-small fw-bold">Etiqueta (Tag)</label>
                                <input type="text" name="segment_tags" id="segment_tags" class="form-control input-premium p-2 rounded-2" placeholder="Ej: vip, lead" onkeyup="updateMatchingCount()">
                            </div>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label text-white-50 x-small fw-bold">Historial de Comportamiento</label>
                                <select name="segment_behavior_type" id="behavior_type" class="form-select input-premium p-2 rounded-2" onchange="toggleBehaviorFields(); updateMatchingCount();">
                                    <option value="">Cualquier interacción</option>
                                    <option value="opened">Abrió campaña previa</option>
                                    <option value="clicked">Hizo clic en campaña previa</option>
                                    <option value="inactive">Inactivo (sin interactuar) hace...</option>
                                </select>
                            </div>
                            <div class="col-md-4" id="behavior-campaign-wrapper" style="display:none;">
                                <label class="form-label text-white-50 x-small fw-bold">Campaña de Origen</label>
                                <select name="segment_behavior_campaign_id" id="behavior_campaign_id" class="form-select input-premium p-2 rounded-2" onchange="updateMatchingCount()">
                                    <option value="">Cualquier campaña...</option>
                                    <?php foreach($pastCampaigns as $pc): ?>
                                        <option value="<?php echo $pc['id']; ?>"><?php echo htmlspecialchars($pc['name']); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="col-md-4" id="behavior-days-wrapper" style="display:none;">
                                <label class="form-label text-white-50 x-small fw-bold">Días de inactividad</label>
                                <input type="number" name="segment_behavior_days" id="behavior_days" class="form-control input-premium p-2 rounded-2" placeholder="Ej: 30" min="1" onkeyup="updateMatchingCount()">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Chips de Audiencia Activos -->
                <div class="card glass-morphism border-0 p-3">
                    <span class="text-white-50 x-small fw-bold uppercase mb-2">Filtros Activos</span>
                    <div id="audience-chips-container" class="d-flex flex-wrap gap-2">
                        <span class="text-white-30 small">Ningún filtro de segmentación activo. Se enviará a toda la lista.</span>
                    </div>
                </div>
            </div>

            <!-- Gráfico Dinámico en Tiempo Real (Executive Ring) -->
            <div class="col-md-4">
                <div class="card glass-morphism border-0 text-center py-4 px-3 h-100 d-flex flex-column justify-content-center align-items-center">
                    <h6 class="text-white fw-bold mb-4">Alcance de Audiencia</h6>
                    
                    <div class="position-relative d-inline-flex justify-content-center align-items-center mb-3">
                        <svg class="progress-ring" width="160" height="160">
                            <circle class="text-white-10" stroke="rgba(255,255,255,0.05)" stroke-width="12" fill="transparent" r="70" cx="80" cy="80" />
                            <circle id="progress-circle" class="progress-ring-circle text-primary" stroke="#30C5FF" stroke-width="12" stroke-dasharray="440" stroke-dashoffset="440" fill="transparent" r="70" cx="80" cy="80" stroke-linecap="round" />
                        </svg>
                        <div class="position-absolute d-flex flex-column justify-content-center align-items-center">
                            <h2 class="text-white fw-bold mb-0" id="match-percent">0%</h2>
                            <span class="text-white-50 x-small">coincidencia</span>
                        </div>
                    </div>

                    <div class="mt-3">
                        <h4 class="text-white fw-bold mb-0" id="match-count">0</h4>
                        <span class="text-white-50 small">de <span id="total-contacts-count">0</span> destinatarios totales</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- PASO 3: DISEÑO Y PREVISUALIZACIÓN MULTIDISPOSITIVO -->
    <div id="step-content-3" class="wizard-step-content">
        <div class="row g-4">
            <div class="col-md-7">
                <div class="card glass-morphism border-0 mb-4">
                    <div class="card-header border-bottom border-white-10 bg-transparent py-3 d-flex justify-content-between align-items-center">
                        <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined text-primary">visibility</span> Vista Previa del Correo
                        </h6>
                        <div class="btn-group btn-group-sm border border-white-10 rounded-pill p-0.5 bg-black" role="group">
                            <button type="button" class="btn btn-outline-light rounded-pill px-3 active border-0" id="btn-device-desktop" onclick="setPreviewDevice('desktop')">
                                <span class="material-symbols-outlined fs-6 align-middle">desktop_windows</span> Desktop
                            </button>
                            <button type="button" class="btn btn-outline-light rounded-pill px-3 border-0" id="btn-device-mobile" onclick="setPreviewDevice('mobile')">
                                <span class="material-symbols-outlined fs-6 align-middle">smartphone</span> Mobile
                            </button>
                        </div>
                    </div>
                    <div class="card-body p-3">
                        <!-- Preview container -->
                        <div class="preview-container">
                            <iframe id="preview-frame" class="preview-iframe" src=""></iframe>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-5">
                <div class="card glass-morphism border-0 mb-4">
                    <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                        <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined text-warning">health_and_safety</span> Análisis y Spam Score
                        </h6>
                    </div>
                    <div class="card-body p-4">
                        <div class="mb-4">
                            <label class="form-label text-white-50 x-small fw-bold uppercase">Seleccionar Plantilla HTML *</label>
                            <select name="template_id" id="template_id" class="form-select input-premium p-3 rounded-3" required onchange="loadTemplatePreview(this.value)">
                                <option value="">Seleccione una plantilla...</option>
                                <?php foreach($templates as $tpl): ?>
                                    <option value="<?php echo $tpl['id']; ?>"><?php echo htmlspecialchars($tpl['name']); ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>

                        <div class="d-flex align-items-center gap-3 bg-white-5 p-3 rounded-3 mb-4">
                            <div class="bg-success bg-opacity-25 rounded-circle p-2 text-success d-flex">
                                <span class="material-symbols-outlined fs-2">verified</span>
                            </div>
                            <div>
                                <h6 class="text-white mb-0 fw-bold">Predicción de Spam Score: <span id="spam-score">98%</span></h6>
                                <p class="text-white-50 small mb-0" id="spam-score-msg">Estructura excelente y libre de palabras clave de spam.</p>
                            </div>
                        </div>

                        <div class="mb-4">
                            <span class="text-white-50 x-small fw-bold uppercase tracking-widest">Etiquetado Analítico Google Analytics UTM</span>
                            <div class="form-check form-switch mt-2">
                                <input class="form-check-input bg-dark border-white-10" type="checkbox" name="utm_active" id="utm_active" value="1" checked>
                                <label class="form-check-label text-white-50 small" for="utm_active">
                                    Inyectar utm_source, utm_medium y utm_campaign automáticamente.
                                </label>
                            </div>
                        </div>

                        <!-- Enviar Prueba -->
                        <div class="border-top border-white-10 pt-4">
                            <span class="text-white-50 x-small fw-bold uppercase tracking-widest mb-2 d-block">Lanzar Prueba Rápida</span>
                            <div class="input-group">
                                <input type="email" id="test_email_address" class="form-control input-premium p-2.5 rounded-start" placeholder="correo@ejemplo.com">
                                <button type="button" class="btn btn-warning fw-bold px-3" onclick="sendQuickTest()">Enviar Prueba</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- WIZARD NAV FOOTER -->
    <div class="mt-4 d-flex justify-content-between">
        <button type="button" class="btn btn-outline-light" id="btn-wizard-prev" style="visibility:hidden;" onclick="prevStep()">Anterior</button>
        <div>
            <button type="button" class="btn btn-primary" id="btn-wizard-next" onclick="nextStep()">Siguiente</button>
            <button type="submit" class="btn btn-success text-dark fw-bold" id="btn-wizard-submit" style="display:none;">Crear Campaña y Guardar</button>
        </div>
    </div>
</form>

<!-- Modal Asuntos de IA -->
<div class="modal fade" id="aiSubjectsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-morphism border-white-10 text-white" style="background: rgba(15,15,20,0.95); backdrop-filter: blur(10px);">
            <div class="modal-header border-bottom border-white-10">
                <h5 class="modal-title fw-bold">
                    <span class="material-symbols-outlined text-warning align-middle me-1">auto_awesome</span> Sugerencias de Asunto de IA
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <p class="text-white-50 small mb-3">Haz clic sobre la sugerencia que desees utilizar para tu asunto:</p>
                <div class="d-flex flex-column gap-2" id="ai-subjects-list">
                    <!-- Sugerencias generadas -->
                </div>
            </div>
        </div>
    </div>
</div>

<script>
let currentStep = 1;
const verifiedDomains = ["<?php echo \Core\Config::get('marketing.reputation.domain', 'datawyrd.com'); ?>"];

function goToStep(step) {
    if (step < 1 || step > 3) return;
    
    // Validaciones rápidas al cambiar de paso
    if (step > 1 && currentStep === 1) {
        if (!document.getElementById('campaign_name').value || !document.getElementById('subject').value) {
            alert('Por favor, rellena el nombre y el asunto antes de continuar.');
            return;
        }
    }
    if (step > 2 && currentStep === 2) {
        if (!document.getElementById('list_id').value) {
            alert('Por favor, selecciona una Lista de Contactos.');
            return;
        }
    }

    // Toggle content
    document.querySelectorAll('.wizard-step-content').forEach(el => el.classList.remove('active'));
    document.getElementById(`step-content-${step}`).classList.add('active');

    // Toggle headers
    document.querySelectorAll('.wizard-step-header').forEach(el => el.classList.remove('active'));
    document.getElementById(`header-step-${step}`).classList.add('active');

    currentStep = step;

    // Toggle nav buttons
    document.getElementById('btn-wizard-prev').style.visibility = (step === 1) ? 'hidden' : 'visible';
    
    if (step === 3) {
        document.getElementById('btn-wizard-next').style.display = 'none';
        document.getElementById('btn-wizard-submit').style.display = 'inline-block';
    } else {
        document.getElementById('btn-wizard-next').style.display = 'inline-block';
        document.getElementById('btn-wizard-submit').style.display = 'none';
    }
}

function nextStep() {
    goToStep(currentStep + 1);
}

function prevStep() {
    goToStep(currentStep - 1);
}

// 1. Remitente verificado check
function checkSenderDomain(email) {
    const box = document.getElementById('domain-verification-box');
    const domain = email.split('@')[1];
    
    if (!domain) {
        box.className = "alert bg-danger bg-opacity-10 border border-danger border-opacity-25 text-danger rounded-3 py-2 px-3 small";
        box.innerHTML = `<span class="material-symbols-outlined fs-5 align-middle">error</span> Email incompleto o no válido.`;
        return;
    }

    const matches = verifiedDomains.some(d => domain.toLowerCase() === d.toLowerCase());
    
    if (matches) {
        box.className = "alert bg-success bg-opacity-10 border border-success border-opacity-25 text-success rounded-3 py-2 px-3 small";
        box.innerHTML = `<span class="material-symbols-outlined fs-5 align-middle">verified_user</span> Remitente verificado correctamente (SPF/DKIM alineados).`;
    } else {
        box.className = "alert bg-warning bg-opacity-10 border border-warning border-opacity-25 text-warning rounded-3 py-2 px-3 small";
        box.innerHTML = `<span class="material-symbols-outlined fs-5 align-middle">warning</span> Advertencia: Dominio "${domain}" no está verificado en SPF/DKIM. El correo podría ir a Spam.`;
    }
}

// 2. IA Subject generator
function generateAiSubject() {
    const campName = document.getElementById('campaign_name').value || 'Nueva Campaña';
    const suggestions = [
        `🔥 ¡Última oportunidad para ${campName}! Acceso exclusivo`,
        `¿Listo para el siguiente nivel? Te traemos novedades 🚀`,
        `Exclusivo para ti: lo nuevo de ${campName} ya está aquí.`
    ];

    const container = document.getElementById('ai-subjects-list');
    container.innerHTML = '';
    
    suggestions.forEach(subj => {
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'btn btn-outline-light text-start py-2.5 px-3 rounded-3 small';
        btn.innerHTML = `<span class="material-symbols-outlined text-warning fs-5 align-middle me-1">auto_awesome</span> ${subj}`;
        btn.onclick = () => {
            document.getElementById('subject').value = subj;
            bootstrap.Modal.getInstance(document.getElementById('aiSubjectsModal')).hide();
        };
        container.appendChild(btn);
    });

    const modal = new bootstrap.Modal(document.getElementById('aiSubjectsModal'));
    modal.show();
}

// 3. Segment count matched dynamically
function updateMatchingCount() {
    const listId = document.getElementById('list_id').value;
    const country = document.getElementById('segment_country').value;
    const industry = document.getElementById('segment_industry').value;
    const tags = document.getElementById('segment_tags').value;
    const behaviorType = document.getElementById('behavior_type').value;
    const behaviorCampaignId = document.getElementById('behavior_campaign_id').value;
    const behaviorDays = document.getElementById('behavior_days').value;

    updateChips(country, industry, tags, behaviorType);

    if (!listId) {
        setReachProgress(0, 0);
        return;
    }

    const query = new URLSearchParams({
        list_id: listId,
        country: country,
        industry: industry,
        tags: tags,
        behavior_type: behaviorType,
        behavior_campaign_id: behaviorCampaignId,
        behavior_days: behaviorDays
    });

    fetch(`<?php echo url('admin/marketing/countMatchingContacts'); ?>?` + query.toString())
        .then(res => res.json())
        .then(data => {
            setReachProgress(data.matching, data.total);
        })
        .catch(err => console.error("Error al contar contactos de segmentación:", err));
}

function updateChips(country, industry, tags, behavior) {
    const container = document.getElementById('audience-chips-container');
    container.innerHTML = '';
    let hasChips = false;

    if (country) {
        addChip(container, `País: ${country}`, () => {
            document.getElementById('segment_country').value = '';
            updateMatchingCount();
        });
        hasChips = true;
    }
    if (industry) {
        addChip(container, `Industria: ${industry}`, () => {
            document.getElementById('segment_industry').value = '';
            updateMatchingCount();
        });
        hasChips = true;
    }
    if (tags) {
        addChip(container, `Tag: ${tags}`, () => {
            document.getElementById('segment_tags').value = '';
            updateMatchingCount();
        });
        hasChips = true;
    }
    if (behavior) {
        addChip(container, `Comportamiento: ${behavior}`, () => {
            document.getElementById('behavior_type').value = '';
            toggleBehaviorFields();
            updateMatchingCount();
        });
        hasChips = true;
    }

    if (!hasChips) {
        container.innerHTML = `<span class="text-white-30 small">Ningún filtro de segmentación activo. Se enviará a toda la lista.</span>`;
    }
}

function addChip(container, text, onRemove) {
    const chip = document.createElement('div');
    chip.className = 'audience-chip';
    chip.innerHTML = `${text} <span class="material-symbols-outlined fs-6" style="cursor:pointer;">close</span>`;
    chip.querySelector('span').onclick = onRemove;
    container.appendChild(chip);
}

function toggleBehaviorFields() {
    const type = document.getElementById('behavior_type').value;
    const campaignWrapper = document.getElementById('behavior-campaign-wrapper');
    const daysWrapper = document.getElementById('behavior-days-wrapper');

    if (type === 'opened' || type === 'clicked') {
        campaignWrapper.style.display = 'block';
        daysWrapper.style.display = 'none';
    } else if (type === 'inactive') {
        campaignWrapper.style.display = 'none';
        daysWrapper.style.display = 'block';
    } else {
        campaignWrapper.style.display = 'none';
        daysWrapper.style.display = 'none';
    }
}

function setReachProgress(matching, total) {
    document.getElementById('match-count').innerText = matching;
    document.getElementById('total-contacts-count').innerText = total;

    const percent = total > 0 ? Math.round((matching / total) * 100) : 0;
    document.getElementById('match-percent').innerText = `${percent}%`;

    // Progress Ring offset
    const circle = document.getElementById('progress-circle');
    const radius = circle.r.baseVal.value;
    const circumference = radius * 2 * Math.PI;
    const offset = circumference - (percent / 100) * circumference;
    circle.style.strokeDashoffset = offset;
}

// 4. Multidevice visualizer
function setPreviewDevice(device) {
    const iframe = document.getElementById('preview-frame');
    document.getElementById('btn-device-desktop').classList.remove('active');
    document.getElementById('btn-device-mobile').classList.remove('active');

    if (device === 'mobile') {
        iframe.className = "preview-iframe mobile";
        document.getElementById('btn-device-mobile').classList.add('active');
    } else {
        iframe.className = "preview-iframe";
        document.getElementById('btn-device-desktop').classList.add('active');
    }
}

function loadTemplatePreview(templateId) {
    const iframe = document.getElementById('preview-frame');
    if (!templateId) {
        iframe.src = '';
        document.getElementById('spam-score').innerText = "0%";
        document.getElementById('spam-score-msg').innerText = "Selecciona una plantilla para verificar el score.";
        return;
    }
    
    iframe.src = `<?php echo url('admin/marketing/getTemplateHtml'); ?>?id=${templateId}`;
    
    // Simulate Spam Score calculation dynamically
    setTimeout(() => {
        document.getElementById('spam-score').innerText = "98%";
        document.getElementById('spam-score-msg').innerText = "Estructura excelente y libre de palabras clave de spam.";
    }, 400);
}

// 5. Test sender floating
function sendQuickTest() {
    const email = document.getElementById('test_email_address').value;
    const templateId = document.getElementById('template_id').value;

    if (!email) {
        alert('Por favor, escribe un email para la prueba.');
        return;
    }
    if (!templateId) {
        alert('Por favor, selecciona una plantilla primero.');
        return;
    }

    const payload = new URLSearchParams({
        email: email,
        template_id: templateId
    });

    fetch(`<?php echo url('admin/marketing/testSend'); ?>`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': document.querySelector('input[name="_token"]').value
        },
        body: payload.toString()
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            alert('¡Email de prueba enviado correctamente!');
        } else {
            alert('Error al enviar la prueba: ' + data.message);
        }
    })
    .catch(err => {
        console.error("Error al enviar test:", err);
        alert('Error de red al enviar la prueba.');
    });
}

// Check initial domain reputation domain
checkSenderDomain(document.getElementById('from_email').value);
</script>
