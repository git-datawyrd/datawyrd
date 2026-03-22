<div class="container-fluid">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <a href="<?php echo url('admin/jobs'); ?>" class="btn btn-link text-white-50 p-0 text-decoration-none d-flex align-items-center gap-2 hover-gold transition-all mb-2">
                <span class="material-symbols-outlined fs-5">arrow_back</span>
                Volver al listado
            </a>
            <h1 class="h3 fw-bold text-white mb-1"><span class="text-gradient">Postulación:</span> <?php echo htmlspecialchars($jobApp['vacancy_name']); ?></h1>
            <p class="text-white-50 small mb-0">Enviada el <?php echo date('d M Y, H:i', strtotime($jobApp['created_at'])); ?></p>
        </div>
        <div>
            <a href="<?php echo url('admin/jobs/downloadCv/' . $jobApp['id']); ?>" class="btn btn-primary d-flex align-items-center gap-2 fw-bold uppercase tracking-widest rounded-3 px-4 py-2 shadow-gold transition-all hover-scale">
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

                <form method="POST" action="<?php echo url('admin/jobs/updateProfile/' . $jobApp['candidate_id']); ?>">
                    <?php echo csrf_field(); ?>
                    
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <label class="text-white-50 x-small tracking-widest uppercase mb-1">Nombre Completo</label>
                            <div class="text-white fs-5 mb-0 fw-bold"><?php echo htmlspecialchars($jobApp['first_name'] . ' ' . $jobApp['last_name']); ?></div>
                        </div>
                        <div class="col-md-6">
                            <label class="text-white-50 x-small tracking-widest uppercase mb-1">Contacto</label>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <span class="material-symbols-outlined text-white-50" style="font-size: 16px;">mail</span>
                                <a href="mailto:<?php echo htmlspecialchars($jobApp['email']); ?>" class="text-white hover-gold text-decoration-none"><?php echo htmlspecialchars($jobApp['email']); ?></a>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined text-white-50" style="font-size: 16px;">phone</span>
                                <a href="tel:<?php echo htmlspecialchars($jobApp['phone']); ?>" class="text-white hover-gold text-decoration-none"><?php echo htmlspecialchars($jobApp['phone']); ?></a>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="text-white-50 x-small tracking-widest uppercase mb-1">Ciudad</label>
                            <input type="text" name="city" class="form-control bg-deep-black border-white-10 text-white" value="<?php echo htmlspecialchars($jobApp['city'] ?? ''); ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="text-white-50 x-small tracking-widest uppercase mb-1">País</label>
                            <input type="text" name="country" class="form-control bg-deep-black border-white-10 text-white" value="<?php echo htmlspecialchars($jobApp['country'] ?? ''); ?>">
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="text-white-50 x-small tracking-widest uppercase mb-1">Dirección</label>
                        <input type="text" name="address" class="form-control bg-deep-black border-white-10 text-white" value="<?php echo htmlspecialchars($jobApp['address'] ?? ''); ?>">
                    </div>

                    <?php if (!empty($jobApp['linkedin_url'])): ?>
                    <div class="mb-4">
                        <a href="<?php echo htmlspecialchars($jobApp['linkedin_url']); ?>" target="_blank" class="btn btn-outline-light border-white-10 d-inline-flex align-items-center gap-2 hover-gold transition-all">
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

                <form method="POST" action="<?php echo url('admin/jobs/updateApplication/' . $jobApp['id']); ?>">
                    <?php echo csrf_field(); ?>
                    
                    <div class="mb-4">
                        <label class="text-white-50 x-small tracking-widest uppercase mb-2">Vacante Actual (Perfil Aplicado)</label>
                        <div class="input-group">
                            <input type="text" id="vacancyInput" name="vacancy_name" class="form-control bg-deep-black border-white-10 text-white" value="<?php echo htmlspecialchars($jobApp['vacancy_name'] ?? ''); ?>" placeholder="Sin postular a vacante">
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
                                $selected = $jobApp['status'] === $key ? 'selected' : '';
                                echo "<option value=\"{$key}\" {$selected}>{$label}</option>";
                            }
                            ?>
                        </select>
                        <?php if (!empty($jobApp['status_updated_at'])): ?>
                            <div class="text-white-50 mt-2 x-small">
                                <span class="material-symbols-outlined x-small align-middle me-1">update</span>
                                Último cambio: <?php echo date('d M Y, H:i', strtotime($jobApp['status_updated_at'])); ?>
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
                <?php if (!empty($jobApp['presentation_letter'])): ?>
                    <p class="text-white-50 small" style="white-space: pre-wrap; line-height: 1.7;"><?php echo htmlspecialchars($jobApp['presentation_letter']); ?></p>
                <?php else: ?>
                    <p class="text-white-50 small fst-italic">El candidato no incluyó una carta de presentación.</p>
                <?php endif; ?>

                <?php if (!empty($jobApp['skills'])): ?>
                    <h3 class="h6 text-white fw-bold mb-3 mt-4 d-flex align-items-center gap-2 border-top border-white-10 pt-4">
                        <span class="material-symbols-outlined text-white-50">psychology</span>
                        Competencias y Skills
                    </h3>
                    <div class="d-flex flex-wrap gap-2">
                        <?php foreach ($jobApp['skills'] as $skill): ?>
                            <span class="badge border border-white-20 text-white bg-dark px-3 py-2 rounded-pill font-monospace small">
                                <?php echo htmlspecialchars($skill); ?>
                            </span>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Nueva Fila: Línea de Tiempo y Histórico -->
    <div class="row g-4 mt-2">
        <!-- Historial de Estatus (Timeline) -->
        <div class="col-lg-6">
            <div class="glass-morphism rounded-4 p-4 h-100">
                <h3 class="h6 text-white fw-bold mb-4 d-flex align-items-center gap-2 border-bottom border-white-10 pb-3">
                    <span class="material-symbols-outlined text-info">history_edu</span>
                    Historial de Estados (Timeline)
                </h3>
                
                <?php if (!empty($statusLogs)): ?>
                    <div class="timeline-container ps-3 border-start border-white-10">
                        <?php foreach ($statusLogs as $log): ?>
                            <div class="timeline-item position-relative mb-4">
                                <span class="position-absolute top-0 start-0 translate-middle rounded-circle bg-accent" style="width: 10px; height: 10px; left: -16px !important; margin-top: 6px;"></span>
                                <div class="text-white-50 x-small mb-1 uppercase tracking-widest fw-bold">
                                    <?php echo date('d M Y, H:i', strtotime($log['created_at'])); ?>
                                </div>
                                <div class="text-white small">
                                    Cambio de 
                                    <span class="text-white-50 text-decoration-line-through"><?php echo htmlspecialchars($log['old_status'] ?? 'inicio'); ?></span>
                                    a 
                                    <span class="text-accent fw-bold"><?php echo htmlspecialchars($log['new_status']); ?></span>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                <?php else: ?>
                    <p class="text-white-50 small fst-italic">No hay cambios de estado registrados para esta postulación.</p>
                <?php endif; ?>
            </div>
        </div>

        <!-- Histórico de Postulaciones -->
        <div class="col-lg-6">
            <div class="glass-morphism rounded-4 p-4 h-100">
                <h3 class="h6 text-white fw-bold mb-4 d-flex align-items-center gap-2 border-bottom border-white-10 pb-3">
                    <span class="material-symbols-outlined text-gold">recent_actors</span>
                    Histórico de Postulaciones (Índice)
                </h3>
                
                <div class="list-group list-group-flush bg-transparent">
                    <?php foreach ($candidateHistory as $hist): ?>
                        <div class="list-group-item bg-transparent border-white-5 py-3 px-0">
                            <div class="d-flex justify-content-between align-items-start gap-3">
                                <div class="flex-grow-1 overflow-hidden">
                                    <h4 class="text-white small fw-bold mb-1 text-truncate">
                                        <?php echo htmlspecialchars($hist['vacancy_name'] ?? 'Candidatura Espontánea'); ?>
                                    </h4>
                                    <div class="text-white-50 x-small d-flex align-items-center gap-1">
                                        <span class="material-symbols-outlined x-small">calendar_today</span>
                                        <?php echo date('d M Y', strtotime($hist['created_at'])); ?>
                                    </div>
                                </div>
                                <div class="text-end">
                                    <span class="badge bg-primary bg-opacity-10 border border-primary border-opacity-25 text-primary x-small px-2 py-1 mb-2 d-block">
                                        <?php echo htmlspecialchars($hist['status']); ?>
                                    </span>
                                    <?php if ($hist['id'] != $jobApp['id']): ?>
                                        <a href="<?php echo url('admin/jobs/show/' . $hist['id']); ?>" class="btn btn-link text-accent p-0 x-small text-decoration-none fw-bold hover-gold">Ver Detalle</a>
                                    <?php else: ?>
                                        <span class="badge bg-white-10 text-white-50 x-small px-2 py-1">Actual</span>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.text-accent { color: var(--tech-blue) !important; }
.border-white-5 { border-color: rgba(255, 255, 255, 0.05) !important; }
</style>

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
