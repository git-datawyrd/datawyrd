<div class="container-fluid max-w-1000 mx-auto">
    <div class="d-flex align-items-center justify-content-between mb-4 fade-in">
        <a href="<?php echo url('admin/jobs'); ?>" class="btn btn-outline-light btn-sm d-flex align-items-center gap-2 border-white-10">
            <span class="material-symbols-outlined fs-6">arrow_back</span> Volver
        </a>
        <h4 class="text-white fw-bold mb-0">Detalle de Postulante</h4>
    </div>

    <div class="row g-4 fade-in-up delay-100">
        <!-- Sidebar Perfil -->
        <div class="col-lg-4">
            <div class="glass-morphism rounded-4 p-4 border-white-10 text-center">
                <div class="rounded-circle bg-midnight d-flex align-items-center justify-content-center border border-gold mx-auto mb-3 text-primary h1 fw-bold shadow-gold" style="width: 100px; height: 100px;">
                    <?php echo strtoupper(substr($application['first_name'], 0, 1) . substr($application['last_name'], 0, 1)); ?>
                </div>
                <h4 class="text-white fw-bold mb-1"><?php echo htmlspecialchars($application['first_name'] . ' ' . $application['last_name']); ?></h4>
                <div class="text-white-50 small mb-3">Registrado: <?php echo date('d M, Y', strtotime($application['created_at'])); ?></div>
                
                <hr class="border-white-10 my-4">

                <div class="d-flex flex-column gap-3 text-start">
                    <div class="d-flex align-items-center gap-3">
                        <span class="material-symbols-outlined text-primary bg-primary bg-opacity-10 p-2 rounded-3">mail</span>
                        <div>
                            <div class="text-white-50 x-small uppercase tracking-widest">Email</div>
                            <div class="text-white small fw-bold">
                                <a href="mailto:<?php echo htmlspecialchars($application['email']); ?>" class="text-white hover-gold text-decoration-none">
                                    <?php echo htmlspecialchars($application['email']); ?>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <span class="material-symbols-outlined text-primary bg-primary bg-opacity-10 p-2 rounded-3">phone</span>
                        <div>
                            <div class="text-white-50 x-small uppercase tracking-widest">Teléfono</div>
                            <div class="text-white small fw-bold"><?php echo htmlspecialchars($application['phone']); ?></div>
                        </div>
                    </div>
                    <?php if (!empty($application['linkedin_url'])): ?>
                    <div class="d-flex align-items-center gap-3">
                        <span class="material-symbols-outlined text-primary bg-primary bg-opacity-10 p-2 rounded-3">link</span>
                        <div>
                            <div class="text-white-50 x-small uppercase tracking-widest">LinkedIn</div>
                            <div class="text-white small fw-bold">
                                <a href="<?php echo htmlspecialchars($application['linkedin_url']); ?>" target="_blank" class="text-white hover-gold text-decoration-none text-truncate d-block" style="max-width: 180px;">Abrir Perfil</a>
                            </div>
                        </div>
                    </div>
                    <?php endif; ?>
                </div>

                <hr class="border-white-10 my-4">

                <div class="text-start">
                    <p class="text-white-50 x-small uppercase tracking-widest mb-3">Descargar CV</p>
                    <a href="<?php echo url('admin/jobs/downloadCv/' . $application['id']); ?>" class="btn btn-primary w-100 d-flex align-items-center justify-content-center gap-2">
                        <span class="material-symbols-outlined">download</span> CV Adjunto
                    </a>
                </div>
            </div>
        </div>

        <!-- Contenido Central -->
        <div class="col-lg-8">
            <div class="glass-morphism rounded-4 p-4 p-md-5 border-white-10 h-100">
                <h5 class="text-white fw-bold mb-4 d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-primary">psychology</span> Habilidades Declaradas
                </h5>
                <div class="d-flex flex-wrap gap-2 mb-5">
                    <?php if (!empty($application['skills']) && is_array($application['skills'])): ?>
                        <?php foreach ($application['skills'] as $skill): ?>
                            <span class="badge border border-primary text-primary px-3 py-2 rounded-pill bg-primary bg-opacity-10 shadow-sm fw-medium">
                                <?php echo htmlspecialchars($skill); ?>
                            </span>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <span class="text-white-50 small">No se declararon habilidades específicas.</span>
                    <?php endif; ?>
                </div>

                <h5 class="text-white fw-bold mb-4 d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-primary">description</span> Carta de Presentación / Observaciones
                </h5>
                <div class="bg-deep-black p-4 rounded-3 border-white-5 text-white-50 fs-6 lh-lg font-monospace" style="min-height: 150px;">
                    <?php echo !empty($application['presentation_letter']) ? nl2br(htmlspecialchars($application['presentation_letter'])) : '<em>Sin observaciones adicionales.</em>'; ?>
                </div>
            </div>
        </div>
    </div>
</div>
