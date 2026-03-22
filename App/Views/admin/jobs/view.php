<div class="container-fluid">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <a href="<?php echo url('admin/jobs'); ?>" class="btn btn-link text-white-50 p-0 text-decoration-none d-flex align-items-center gap-2 hover-gold transition-all mb-2">
                <span class="material-symbols-outlined fs-5">arrow_back</span>
                Volver al listado
            </a>
            <h1 class="h3 fw-bold text-white mb-1"><span class="text-gradient">Postulación:</span> <?php echo htmlspecialchars($app['vacancy_name']); ?></h1>
            <p class="text-white-50 small mb-0">Enviada el <?php echo date('d M Y, H:i', strtotime($app['created_at'])); ?></p>
        </div>
        <div>
            <a href="<?php echo url('admin/jobs/downloadCv/' . $app['id']); ?>" class="btn btn-primary d-flex align-items-center gap-2 fw-bold uppercase tracking-widest rounded-3 px-4 py-2 shadow-gold transition-all hover-scale">
                <span class="material-symbols-outlined fs-5">download</span>
                Descargar CV
            </a>
        </div>
    </div>

    <!-- Mensajes Flash -->
    <?php if ($msg = \Core\Session::flash('success')): ?>
        <div class="alert alert-success bg-success bg-opacity-10 border-success text-success d-flex align-items-center gap-2">
            <span class="material-symbols-outlined">check_circle</span>
            <?php echo $msg; ?>
        </div>
    <?php endif; ?>
    <?php if ($msg = \Core\Session::flash('error')): ?>
        <div class="alert alert-danger bg-danger bg-opacity-10 border-danger text-danger d-flex align-items-center gap-2">
            <span class="material-symbols-outlined">error</span>
            <?php echo $msg; ?>
        </div>
    <?php endif; ?>

    <div class="row g-4">
        <!-- Columna Izquierda: Perfil del Candidato -->
        <div class="col-lg-7">
            <div class="glass-morphism rounded-4 p-4 p-md-5 mb-4 position-relative overflow-hidden h-100">
                <div class="position-absolute top-0 end-0 p-4 opacity-25 pointer-events-none">
                    <span class="material-symbols-outlined text-white" style="font-size: 120px;">person</span>
                </div>
                
                <h3 class="h5 text-white fw-bold mb-4 border-bottom border-white-10 pb-3 d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-accent">badge</span>
                    Perfil del Candidato
                </h3>

                <form method="POST" action="<?php echo url('admin/jobs/updateProfile/' . $app['candidate_id']); ?>">
                    <?php echo csrf_field(); ?>
                    
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <label class="text-white-50 x-small tracking-widest uppercase mb-1">Nombre Completo</label>
                            <div class="text-white fs-5 mb-0 fw-bold"><?php echo htmlspecialchars($app['first_name'] . ' ' . $app['last_name']); ?></div>
                        </div>
                        <div class="col-md-6">
                            <label class="text-white-50 x-small tracking-widest uppercase mb-1">Contacto</label>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <span class="material-symbols-outlined text-white-50" style="font-size: 16px;">mail</span>
                                <a href="mailto:<?php echo htmlspecialchars($app['email']); ?>" class="text-white hover-gold text-decoration-none"><?php echo htmlspecialchars($app['email']); ?></a>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined text-white-50" style="font-size: 16px;">phone</span>
                                <a href="tel:<?php echo htmlspecialchars($app['phone']); ?>" class="text-white hover-gold text-decoration-none"><?php echo htmlspecialchars($app['phone']); ?></a>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="text-white-50 x-small tracking-widest uppercase mb-1">Ciudad</label>
                            <input type="text" name="city" class="form-control bg-deep-black border-white-10 text-white" value="<?php echo htmlspecialchars($app['city'] ?? ''); ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="text-white-50 x-small tracking-widest uppercase mb-1">País</label>
                            <input type="text" name="country" class="form-control bg-deep-black border-white-10 text-white" value="<?php echo htmlspecialchars($app['country'] ?? ''); ?>">
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="text-white-50 x-small tracking-widest uppercase mb-1">Dirección</label>
                        <input type="text" name="address" class="form-control bg-deep-black border-white-10 text-white" value="<?php echo htmlspecialchars($app['address'] ?? ''); ?>">
                    </div>

                    <?php if (!empty($app['linkedin_url'])): ?>
                    <div class="mb-4">
                        <a href="<?php echo htmlspecialchars($app['linkedin_url']); ?>" target="_blank" class="btn btn-outline-light border-white-10 d-inline-flex align-items-center gap-2 hover-gold transition-all">
                            <span class="material-symbols-outlined fs-5">link</span>
                            Ver Perfil de LinkedIn
                        </a>
                    </div>
                    <?php endif; ?>

                    <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill px-4">Guardar Perfil</button>
                </form>
            </div>
        </div>

        <!-- Columna Derecha: Detalles de Postulación -->
        <div class="col-lg-5">
            <div class="glass-morphism rounded-4 p-4 mb-4">
                <h3 class="h6 text-white fw-bold mb-4 border-bottom border-white-10 pb-3 d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-gold">work</span>
                    Manejo de Postulación
                </h3>

                <form method="POST" action="<?php echo url('admin/jobs/updateApplication/' . $app['id']); ?>">
                    <?php echo csrf_field(); ?>
                    
                    <div class="mb-4">
                        <label class="text-white-50 x-small tracking-widest uppercase mb-2">Vacante Actual (Perfil Aplicado)</label>
                        <div class="input-group">
                            <input type="text" id="vacancyInput" name="vacancy_name" class="form-control bg-deep-black border-white-10 text-white" value="<?php echo htmlspecialchars($app['vacancy_name'] ?? ''); ?>" placeholder="Sin postular a vacante">
                            <button type="submit" id="saveVacancyBtn" class="btn btn-outline-success d-none d-flex align-items-center" title="Guardar Cambios">
                                <span class="material-symbols-outlined fs-6">check</span>
                            </button>
                        </div>
                        <div class="text-white-50 mt-1" style="font-size: 11px;">Escribe el cargo para postular manualmente, o deja en blanco.</div>
                    </div>

                    <div class="mb-4">
                        <label class="text-white-50 x-small tracking-widest uppercase mb-2">Estado del Proceso</label>
                        <select name="status" class="form-select bg-deep-black border-white-10 text-white">
                            <?php
                            $states = [
                                'new' => 'Nuevo Ingreso',
                                'reviewed' => 'CV Revisado',
                                'contacted' => 'Contactado',
                                'unreachable' => 'Ilocalizable',
                                'scheduled' => 'Entrevista Agendada',
                                'technical_interview' => 'Entrevista Técnica',
                                'shortlisted' => 'Finalista Seleccionado',
                                'rejected' => 'Descartado / Rechazado',
                                'hired' => '¡Contratado!'
                            ];
                            foreach ($states as $key => $label) {
                                $selected = $app['status'] === $key ? 'selected' : '';
                                echo "<option value=\"{$key}\" {$selected}>{$label}</option>";
                            }
                            ?>
                        </select>
                        <?php if (!empty($app['status_updated_at'])): ?>
                            <div class="text-white-50 mt-2 x-small">
                                <span class="material-symbols-outlined x-small align-middle me-1">update</span>
                                Último cambio: <?php echo date('d M Y, H:i', strtotime($app['status_updated_at'])); ?>
                            </div>
                        <?php endif; ?>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 rounded-3 py-2 fw-bold tracking-widest uppercase shadow-gold">Actualizar Postulación</button>
                </form>
            </div>

            <!-- Presentación -->
            <div class="glass-morphism rounded-4 p-4">
                <h3 class="h6 text-white fw-bold mb-3 d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-white-50">description</span>
                    Carta de Presentación
                </h3>
                <?php if (!empty($app['presentation_letter'])): ?>
                    <p class="text-white-50 small" style="white-space: pre-wrap; line-height: 1.7;"><?php echo htmlspecialchars($app['presentation_letter']); ?></p>
                <?php else: ?>
                    <p class="text-white-50 small fst-italic">El candidato no incluyó una carta de presentación.</p>
                <?php endif; ?>

                <?php if (!empty($app['skills'])): ?>
                    <h3 class="h6 text-white fw-bold mb-3 mt-4 d-flex align-items-center gap-2 border-top border-white-10 pt-4">
                        <span class="material-symbols-outlined text-white-50">psychology</span>
                        Competencias y Skills
                    </h3>
                    <div class="d-flex flex-wrap gap-2">
                        <?php foreach ($app['skills'] as $skill): ?>
                            <span class="badge border border-white-20 text-white bg-dark px-3 py-2 rounded-pill font-monospace small">
                                <?php echo htmlspecialchars($skill); ?>
                            </span>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const vacancyInput = document.getElementById('vacancyInput');
    const saveVacancyBtn = document.getElementById('saveVacancyBtn');
    if (vacancyInput && saveVacancyBtn) {
        const originalValue = vacancyInput.value;
        vacancyInput.addEventListener('input', () => {
            if (vacancyInput.value !== originalValue) {
                saveVacancyBtn.classList.remove('d-none');
            } else {
                saveVacancyBtn.classList.add('d-none');
            }
        });
    }
});
</script>
