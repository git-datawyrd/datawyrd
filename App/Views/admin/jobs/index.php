<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-end mb-4 fade-in">
        <div>
            <h1 class="h3 text-white fw-bold d-flex align-items-center gap-3">
                <span class="material-symbols-outlined text-primary fs-2">work</span> Postulantes / RRHH
            </h1>
            <p class="text-white-50 mb-0">Gestión de talentos y aplicantes para posiciones en Data Wyrd.</p>
        </div>
        <div>
            <a href="<?php echo url('admin/jobs/export'); ?>" class="btn btn-outline-primary d-flex align-items-center gap-2">
                <span class="material-symbols-outlined fs-5">download</span> Exportar a CSV
            </a>
        </div>
    </div>

    <div class="glass-morphism rounded-4 overflow-hidden border-white-10 shadow-2xl fade-in-up delay-100">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0 align-middle">
                <thead>
                    <tr>
                        <th class="ps-4 text-white-50 x-small uppercase tracking-widest py-3 border-bottom border-white-10 text-center" style="width: 5%">ID</th>
                        <th class="text-white-50 x-small uppercase tracking-widest py-3 border-bottom border-white-10">Candidato</th>
                        <th class="text-white-50 x-small uppercase tracking-widest py-3 border-bottom border-white-10">Vacante</th>
                        <th class="text-white-50 x-small uppercase tracking-widest py-3 border-bottom border-white-10 text-center">Estado</th>
                        <th class="text-white-50 x-small uppercase tracking-widest py-3 border-bottom border-white-10 text-end pe-4" style="width: 10%">Acciones</th>
                    </tr>
                </thead>
                <tbody class="border-top-0">
                    <?php if (empty($applications)): ?>
                        <tr>
                            <td colspan="5" class="text-center py-5">
                                <div class="text-white-50 placeholder-text">
                                    <span class="material-symbols-outlined fs-1 mb-2 d-block">inbox</span>
                                    No hay postulaciones registradas aún.
                                </div>
                            </td>
                        </tr>
                    <?php else: ?>
                        <?php foreach ($applications as $jobApp): ?>
                            <tr class="transition-colors hover-bg-light">
                                <td class="ps-4 py-3 text-center text-white-50 x-small fw-bold border-bottom border-white-5">#<?php echo $jobApp['id']; ?></td>
                                <td class="py-3 border-bottom border-white-5">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-circle bg-midnight d-flex align-items-center justify-content-center border-white-10 text-primary small fw-bold" style="width: 40px; height: 40px;">
                                            <?php echo strtoupper(substr($jobApp['first_name'], 0, 1) . substr($jobApp['last_name'], 0, 1)); ?>
                                        </div>
                                        <div>
                                            <div class="text-white fw-medium"><?php echo htmlspecialchars($jobApp['first_name'] . ' ' . $jobApp['last_name']); ?></div>
                                            <div class="text-white-50 x-small d-flex align-items-center gap-1">
                                                <span class="material-symbols-outlined" style="font-size: 14px;">calendar_today</span> <?php echo date('d M Y, H:i', strtotime($jobApp['created_at'])); ?>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td class="py-3 border-bottom border-white-5">
                                    <div class="text-white small fw-bold mb-1">
                                        <?php echo htmlspecialchars($jobApp['vacancy_name']); ?>
                                    </div>
                                    <div class="text-white-50 x-small d-flex align-items-center gap-1">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">place</span>
                                        <?php echo !empty($jobApp['city']) || !empty($jobApp['country']) ? htmlspecialchars($jobApp['city'] . ', ' . $jobApp['country']) : 'Ubicación no especificada'; ?>
                                    </div>
                                </td>
                                <td class="py-3 text-center border-bottom border-white-5">
                                    <?php
                                    $statusColors = [
                                        'new' => 'bg-info text-info border-info',
                                        'reviewed' => 'bg-secondary text-secondary border-secondary',
                                        'contacted' => 'bg-primary text-primary border-primary',
                                        'unreachable' => 'bg-danger text-danger border-danger',
                                        'scheduled' => 'bg-warning text-warning border-warning',
                                        'technical_interview' => 'bg-warning text-warning border-warning',
                                        'shortlisted' => 'bg-success text-success border-success',
                                        'rejected' => 'bg-danger text-danger border-danger',
                                        'hired' => 'bg-success text-success border-success'
                                    ];
                                    $labels = [
                                        'new' => 'Nuevo',
                                        'reviewed' => 'Revisado',
                                        'contacted' => 'Contactado',
                                        'unreachable' => 'Ilocalizable',
                                        'scheduled' => 'Agendado',
                                        'technical_interview' => 'E. Técnica',
                                        'shortlisted' => 'Finalista',
                                        'rejected' => 'Descartado',
                                        'hired' => 'Contratado'
                                    ];
                                    $st = $jobApp['status'];
                                    $colorClass = $statusColors[$st] ?? 'bg-secondary text-secondary border-secondary';
                                    ?>
                                    <span class="badge <?php echo $colorClass; ?> bg-opacity-10 border border-opacity-25 px-3 py-2 rounded-pill uppercase tracking-widest x-small fw-bold">
                                        <?php echo $labels[$st] ?? $st; ?>
                                    </span>
                                    <?php if (!empty($jobApp['status_updated_at'])): ?>
                                    <div class="text-white-50 text-center mt-2" style="font-size: 10px;">
                                        <?php echo date('d M Y, H:i', strtotime($jobApp['status_updated_at'])); ?>
                                    </div>
                                    <?php endif; ?>
                                </td>
                                <td class="text-end pe-4 py-3 border-bottom border-white-5">
                                    <div class="d-flex justify-content-end gap-2">
                                        <a href="<?php echo url('admin/jobs/show/' . $jobApp['id']); ?>" class="btn btn-sm btn-outline-light rounded-circle shadow-sm border-white-10 d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;" title="Ver Perfil">
                                            <span class="material-symbols-outlined" style="font-size: 18px;">visibility</span>
                                        </a>
                                        <?php if (!empty($jobApp['linkedin_url'])): ?>
                                            <a href="<?php echo htmlspecialchars($jobApp['linkedin_url']); ?>" target="_blank" class="btn btn-sm btn-outline-primary rounded-circle shadow-sm d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;" title="Perfil de LinkedIn">
                                                <span class="material-symbols-outlined" style="font-size: 18px;">link</span>
                                            </a>
                                        <?php endif; ?>
                                    </div>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<style>
.hover-bg-light:hover {
    background-color: rgba(255,255,255,0.02);
}
</style>
