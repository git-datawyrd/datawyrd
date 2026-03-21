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

                        <div class="row g-4 mb-4">
                            <div class="col-md-4">
                                <label class="form-label text-white-50 small tracking-widest uppercase">País (Opcional)</label>
                                <input type="text" name="country" class="form-control form-control-dark bg-deep-black border-white-10 text-white p-3 rounded-3" placeholder="Ej: Argentina">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-white-50 small tracking-widest uppercase">Ciudad (Opcional)</label>
                                <input type="text" name="city" class="form-control form-control-dark bg-deep-black border-white-10 text-white p-3 rounded-3" placeholder="Ej: Bue. Aires">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-white-50 small tracking-widest uppercase">Dirección (Opcional)</label>
                                <input type="text" name="address" class="form-control form-control-dark bg-deep-black border-white-10 text-white p-3 rounded-3" placeholder="Ej: Av. Principal 123">
                            </div>
                        </div>

                        <div class="row g-4 mb-4">
                            <div class="col-md-6">
                                <label class="form-label text-white-50 small tracking-widest uppercase">URL Perfil de LinkedIn</label>
                                <input type="url" name="linkedin_url" class="form-control form-control-dark bg-deep-black border-white-10 text-white p-3 rounded-3" placeholder="https://linkedin.com/in/tu-perfil">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-white-50 small tracking-widest uppercase">Vacante (Opcional)</label>
                                <select name="vacancy_name" class="form-select form-control-dark bg-deep-black border-white-10 text-white p-3 rounded-3">
                                    <option value="Candidatura Espontánea">Candidatura Espontánea</option>
                                    <option value="Data Engineer Semi-Senior">Data Engineer Ssr.</option>
                                    <option value="Data Analyst Junior">Data Analyst Jr.</option>
                                    <option value="Arquitecto Cloud AWS">Arquitecto Cloud AWS</option>
                                    <option value="Fullstack PHP Developer">Fullstack PHP Developer</option>
                                </select>
                            </div>
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

                        <button type="submit" class="btn btn-primary w-100 py-3 rounded-3 fw-bold tracking-widest uppercase shadow-gold d-flex align-items-center justify-content-center gap-2 transition-all hover-scale">
                            <span class="material-symbols-outlined">send</span> Enviar Postulación
                        </button>
                    </form>
                </div>
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
</style>
