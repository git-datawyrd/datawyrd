<div class="hero-bg position-relative pt-5 pb-5">
    <div class="container pt-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="text-center mb-5 fade-in">
                    <span class="badge bg-gold bg-opacity-10 text-gold border border-gold border-opacity-25 px-3 py-2 rounded-pill uppercase tracking-widest small mb-3">Únete al Equipo</span>
                    <h1 class="display-5 text-white fw-bold mb-3 tracking-tight">Trabaja con <span class="text-gradient">Nosotros</span></h1>
                    <p class="text-white-50 lead mx-auto" style="max-width: 600px;">Buscamos mentes inquietas listas para domar la complejidad de los datos. Déjanos tus datos y nos pondremos en contacto.</p>
                </div>

                <div class="glass-morphism rounded-4 p-4 p-md-5 border-white-10 shadow-2xl fade-in-up delay-100">
                    <form action="<?php echo url('jobs/postulate'); ?>" method="POST" enctype="multipart/form-data">
                        <?php echo csrf_field(); ?>

                        <div class="row g-4 mb-4">
                            <div class="col-md-6">
                                <label class="form-label text-white-50 small tracking-widest uppercase">Nombre *</label>
                                <input type="text" name="first_name" class="form-control form-control-dark bg-deep-black border-white-10 text-white p-3 rounded-3" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-white-50 small tracking-widest uppercase">Apellido *</label>
                                <input type="text" name="last_name" class="form-control form-control-dark bg-deep-black border-white-10 text-white p-3 rounded-3" required>
                            </div>
                        </div>

                        <div class="row g-4 mb-4">
                            <div class="col-md-6">
                                <label class="form-label text-white-50 small tracking-widest uppercase">Correo Electrónico *</label>
                                <input type="email" name="email" class="form-control form-control-dark bg-deep-black border-white-10 text-white p-3 rounded-3" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-white-50 small tracking-widest uppercase">Teléfono *</label>
                                <input type="text" name="phone" class="form-control form-control-dark bg-deep-black border-white-10 text-white p-3 rounded-3" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label text-white-50 small tracking-widest uppercase">URL Perfil de LinkedIn</label>
                            <input type="url" name="linkedin_url" class="form-control form-control-dark bg-deep-black border-white-10 text-white p-3 rounded-3" placeholder="https://linkedin.com/in/tu-perfil">
                        </div>

                        <div class="mb-4">
                            <label class="form-label text-white-50 small tracking-widest uppercase mb-3">Habilidades Principales</label>
                            <div class="row g-3">
                                <?php 
                                $skillsList = ['Data Engineering', 'Machine Learning', 'Data Analysis', 'Web Development', 'DevOps', 'Cloud Architecture', 'Business Intelligence', 'Project Management'];
                                foreach ($skillsList as $sk): 
                                ?>
                                <div class="col-auto">
                                    <input type="checkbox" class="btn-check" name="skills[]" id="skill_<?php echo md5($sk); ?>" value="<?php echo $sk; ?>" autocomplete="off">
                                    <label class="btn btn-outline-light btn-sm rounded-pill px-3 py-2 border-white-10" for="skill_<?php echo md5($sk); ?>"><?php echo $sk; ?></label>
                                </div>
                                <?php endforeach; ?>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label text-white-50 small tracking-widest uppercase">Carta de Presentación / Observaciones</label>
                            <textarea name="presentation_letter" rows="4" class="form-control form-control-dark bg-deep-black border-white-10 text-white p-3 rounded-3" placeholder="Cuéntanos por qué quieres unirte a Data Wyrd..."></textarea>
                        </div>

                        <div class="mb-5">
                            <label class="form-label text-white-50 small tracking-widest uppercase">Currículum Vitae (CV) *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-deep-black border-white-10 text-white-50"><span class="material-symbols-outlined">upload_file</span></span>
                                <input type="file" name="cv" accept=".pdf,.doc,.docx" class="form-control form-control-dark bg-deep-black border-white-10 text-white" required>
                            </div>
                            <div class="form-text text-white-50 x-small mt-2">Formatos permitidos: PDF, DOCX. Tamaño máximo: 5MB.</div>
                        </div>

                        <button type="submit" id="submitBtn" class="btn btn-primary w-100 py-3 rounded-3 fw-bold tracking-widest uppercase shadow-gold d-flex align-items-center justify-content-center gap-2 transition-all hover-scale">
                            <span class="material-symbols-outlined">send</span> Enviar Postulación
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Candidato Recurrente -->
<div class="modal fade" id="recurringModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-morphism border-white-10">
            <div class="modal-header border-white-10">
                <h5 class="modal-title text-white fw-bold">¡Hola de nuevo!</h5>
            </div>
            <div class="modal-body text-white">
                <p id="recurringMsg">Ya tenemos tus datos registrados en nuestro sistema. ¿Deseas actualizar tu currículum o algún dato personal?</p>
            </div>
            <div class="modal-footer border-white-10">
                <button type="button" id="btnNoUpdate" class="btn btn-outline-light rounded-pill px-4">No por ahora</button>
                <button type="button" id="btnYesUpdate" class="btn btn-primary shadow-gold rounded-pill px-4 fw-bold">Sí, actualizar</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal OTP -->
<div class="modal fade" id="otpModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-morphism border-white-10">
            <div class="modal-header border-white-10">
                <h5 class="modal-title text-white fw-bold">Verificación de Seguridad</h5>
            </div>
            <div class="modal-body text-white text-center">
                <p>Te hemos enviado un código de 6 dígitos a tu email. Por favor, ingrésalo para desbloquear la edición de tus datos.</p>
                <div class="d-flex justify-content-center gap-2 mb-3">
                    <input type="text" maxlength="6" id="otpInput" class="form-control bg-deep-black border-white-10 text-white text-center fs-3 tracking-widest w-75 p-3 rounded-3" placeholder="000000">
                </div>
                <div id="otpError" class="text-danger small d-none">Código incorrecto o expirado.</div>
                <button type="button" id="btnResendOtp" class="btn btn-link text-white-50 x-small text-decoration-none mt-2">No recibí el código (Reenviar)</button>
            </div>
            <div class="modal-footer border-white-10">
                <button type="button" class="btn btn-outline-light rounded-pill px-4" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" id="btnVerifyOtp" class="btn btn-primary shadow-gold rounded-pill px-4 fw-bold">Validar Código</button>
            </div>
        </div>
    </div>
</div>

<style>
    .form-control-dark:focus {
        background-color: var(--midnight-blue);
        border-color: var(--elegant-gold);
        box-shadow: 0 0 0 0.25rem rgba(212, 175, 55, 0.25);
        color: white;
    }
    .btn-check:checked + .btn-outline-light {
        background-color: rgba(212, 175, 55, 0.2);
        color: var(--elegant-gold);
        border-color: var(--elegant-gold);
    }
    .hover-scale:hover {
        transform: scale(1.02);
    }
    .glass-morphism {
        background: rgba(10, 10, 30, 0.9) !important;
        backdrop-filter: blur(20px);
    }
</style>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const mainForm = document.querySelector('form');
    const emailInput = document.querySelector('input[name="email"]');
    const submitBtn = document.getElementById('submitBtn');
    const csrfToken = mainForm.querySelector('input[name="_token"]')?.value;
    
    let candidateData = null;
    let recurringModal = new bootstrap.Modal(document.getElementById('recurringModal'));
    let otpModal = new bootstrap.Modal(document.getElementById('otpModal'));

    // 1. Interceptar submit para verificar email
    mainForm.addEventListener('submit', async (e) => {
        // Si ya está verificado, dejamos que el form siga su curso
        if (mainForm.dataset.verified === 'true') return;

        e.preventDefault();
        const email = emailInput.value;
        
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Verificando...';

        try {
            const formData = new FormData();
            formData.append('email', email);
            if (csrfToken) formData.append('_token', csrfToken);

            const res = await fetch('jobs/checkEmail', {
                method: 'POST',
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                body: formData
            });
            const data = await res.json();

            if (data.exists) {
                candidateData = data;
                document.getElementById('recurringMsg').innerHTML = `¡Hola <strong>${data.name}</strong>! Ya tenemos tus datos en nuestro sistema. ¿Deseas actualizar tu currículum o algún dato personal para esta postulación?`;
                recurringModal.show();
            } else {
                // Candidato nuevo, procesar normal
                mainForm.dataset.verified = 'true';
                mainForm.submit();
            }
        } catch (err) {
            console.error('CheckEmail Error:', err);
            // No enviamos el form si el check falla, para evitar duplicados por errores técnicos
            const errorMsg = 'Error al verificar correo. Por favor, revisa tu conexión o intenta más tarde.';
            if (window.toast) {
                window.toast(errorMsg, 'danger');
            } else {
                alert(errorMsg);
            }
        } finally {
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<span class="material-symbols-outlined">send</span> Enviar Postulación';
        }
    });

    // 2. Manejo No Actualizar -> Redirigir con mensaje
    document.getElementById('btnNoUpdate').addEventListener('click', () => {
        window.location.href = '<?php echo url('jobs/alreadyRegistered'); ?>';
    });

    // 3. Manejo Sí Actualizar -> Pedir OTP
    document.getElementById('btnYesUpdate').addEventListener('click', async () => {
        recurringModal.hide();
        const ok = await requestOtp();
        if (ok) otpModal.show();
    });

    async function requestOtp() {
        const formData = new FormData();
        formData.append('candidate_id', candidateData.candidateId);
        if (csrfToken) formData.append('_token', csrfToken);

        const res = await fetch('jobs/requestUpdateCode', {
            method: 'POST',
            body: formData
        });
        const data = await res.json();
        if (!data.success) {
            alert(data.message || 'Error al enviar código');
            return false;
        }
        return true;
    }

    document.getElementById('btnResendOtp').addEventListener('click', requestOtp);

    // 4. Validar OTP
    document.getElementById('btnVerifyOtp').addEventListener('click', async () => {
        const token = document.getElementById('otpInput').value;
        const btn = document.getElementById('btnVerifyOtp');
        
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Validando...';

        const formData = new FormData();
        formData.append('candidate_id', candidateData.candidateId);
        formData.append('token', token);
        if (csrfToken) formData.append('_token', csrfToken);

        try {
            const res = await fetch('jobs/verifyUpdateCode', {
                method: 'POST',
                body: formData
            });
            const data = await res.json();

            if (data.success) {
                otpModal.hide();
                
                // Cambiamos el action del form para que use la ruta de actualización
                mainForm.action = '<?php echo url('jobs/updateCandidate'); ?>';
                
                // Inyectamos el ID oculto del candidato
                if (!document.querySelector('input[name="candidate_id"]')) {
                    const inputId = document.createElement('input');
                    inputId.type = 'hidden';
                    inputId.name = 'candidate_id';
                    inputId.value = candidateData.candidateId;
                    mainForm.appendChild(inputId);
                }

                // Ya no bloqueamos el submit
                mainForm.dataset.verified = 'true';
                
                // Mostrar mensaje de carga antes del submit final
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Procesando Actualización...';
                
                // ENVIAR EL FORMULARIO AUTOMÁTICAMENTE
                mainForm.submit();
            } else {
                document.getElementById('otpError').classList.remove('d-none');
                document.getElementById('otpError').innerText = data.message;
            }
        } catch (err) {
            console.error('Verify OTP Error:', err);
            document.getElementById('otpError').classList.remove('d-none');
            document.getElementById('otpError').innerText = 'Error de conexión con el servidor.';
        } finally {
            btn.disabled = false;
            btn.innerHTML = 'Validar Código';
        }
    });

});
</script>
