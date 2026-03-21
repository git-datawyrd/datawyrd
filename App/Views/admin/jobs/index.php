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
                        <th class="text-white-50 x-small uppercase tracking-widest py-3 border-bottom border-white-10">Contacto</th>
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
                        <?php foreach ($applications as $app): ?>
                            <tr class="transition-colors hover-bg-light">
                                <td class="ps-4 py-3 text-center text-white-50 x-small fw-bold border-bottom border-white-5">#<?php echo $app['id']; ?></td>
                                <td class="py-3 border-bottom border-white-5">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-circle bg-midnight d-flex align-items-center justify-content-center border-white-10 text-primary small fw-bold" style="width: 40px; height: 40px;">
                                            <?php echo strtoupper(substr($app['first_name'], 0, 1) . substr($app['last_name'], 0, 1)); ?>
                                        </div>
                                        <div>
                                            <div class="text-white fw-medium"><?php echo htmlspecialchars($app['first_name'] . ' ' . $app['last_name']); ?></div>
                                            <div class="text-white-50 x-small d-flex align-items-center gap-1">
                                                <span class="material-symbols-outlined" style="font-size: 14px;">calendar_today</span> <?php echo date('d M Y', strtotime($app['created_at'])); ?>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td class="py-3 border-bottom border-white-5">
                                    <div class="text-white small d-flex align-items-center gap-2 mb-1">
                                        <span class="material-symbols-outlined text-white-50" style="font-size: 14px;">mail</span>
                                        <a href="mailto:<?php echo htmlspecialchars($app['email']); ?>" class="text-white-50 hover-gold text-decoration-none"><?php echo htmlspecialchars($app['email']); ?></a>
                                    </div>
                                    <div class="text-white-50 small d-flex align-items-center gap-2">
                                        <span class="material-symbols-outlined text-white-50" style="font-size: 14px;">phone</span>
                                        <?php echo htmlspecialchars($app['phone']); ?>
                                    </div>
                                </td>
                                <td class="py-3 text-center border-bottom border-white-5">
                                    <?php
                                    $statusColors = [
                                        'new' => 'bg-info text-info border-info',
                                        'reviewed' => 'bg-warning text-warning border-warning',
                                        'shortlisted' => 'bg-primary text-primary border-primary',
                                        'rejected' => 'bg-danger text-danger border-danger',
                                        'hired' => 'bg-success text-success border-success'
                                    ];
                                    $labels = [
                                        'new' => 'Nuevo',
                                        'reviewed' => 'Revisado',
                                        'shortlisted' => 'Seleccionado',
                                        'rejected' => 'Descartado',
                                        'hired' => 'Contratado'
                                    ];
                                    $st = $app['status'];
                                    $colorClass = $statusColors[$st] ?? 'bg-secondary text-secondary border-secondary';
                                    ?>
                                    <span class="badge <?php echo $colorClass; ?> bg-opacity-10 border border-opacity-25 px-3 py-2 rounded-pill uppercase tracking-widest x-small fw-bold">
                                        <?php echo $labels[$st] ?? $st; ?>
                                    </span>
                                </td>
                                <td class="text-end pe-4 py-3 border-bottom border-white-5">
                                    <div class="d-flex justify-content-end gap-2">
                                        <a href="<?php echo url('admin/jobs/show/' . $app['id']); ?>" class="btn btn-sm btn-outline-light rounded-circle shadow-sm border-white-10 d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;" title="Ver Perfil">
                                            <span class="material-symbols-outlined" style="font-size: 18px;">visibility</span>
                                        </a>
                                        <?php if (!empty($app['linkedin_url'])): ?>
                                            <a href="<?php echo htmlspecialchars($app['linkedin_url']); ?>" target="_blank" class="btn btn-sm btn-outline-primary rounded-circle shadow-sm d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;" title="Perfil de LinkedIn">
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
