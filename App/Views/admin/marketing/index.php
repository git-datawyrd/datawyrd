<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="h3 text-white fw-bold mb-0">Dashboard de Email Marketing</h1>
    <div>
        <a href="<?php echo url('admin/marketing/createCampaign'); ?>" class="btn btn-primary d-flex align-items-center gap-2">
            <span class="material-symbols-outlined">add</span> Nueva Campaña
        </a>
    </div>
</div>

<div class="row g-4 mb-4">
    <div class="col-md-3">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="text-white-50 mb-0 uppercase tracking-widest x-small fw-bold">Campañas Totales</h6>
                    <span class="material-symbols-outlined text-primary">campaign</span>
                </div>
                <h3 class="text-white fw-bold mb-0"><?php echo $kpis['total_campaigns'] ?? 0; ?></h3>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="text-white-50 mb-0 uppercase tracking-widest x-small fw-bold">Campañas Activas</h6>
                    <span class="material-symbols-outlined text-warning">rocket_launch</span>
                </div>
                <h3 class="text-white fw-bold mb-0"><?php echo $kpis['active'] ?? 0; ?></h3>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="text-white-50 mb-0 uppercase tracking-widest x-small fw-bold">Contactos</h6>
                    <span class="material-symbols-outlined text-success">group</span>
                </div>
                <h3 class="text-white fw-bold mb-0"><?php echo $kpis['total_contacts'] ?? 0; ?></h3>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="text-white-50 mb-0 uppercase tracking-widest x-small fw-bold">Listas</h6>
                    <span class="material-symbols-outlined text-info">list_alt</span>
                </div>
                <h3 class="text-white fw-bold mb-0"><?php echo $kpis['total_lists'] ?? 0; ?></h3>
            </div>
        </div>
    </div>
</div>

<div class="row g-4">
    <div class="col-md-8">
        <div class="card glass-morphism border-0 mb-4 h-100">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3 d-flex justify-content-between align-items-center">
                <h6 class="text-white mb-0 fw-bold">Campañas Recientes</h6>
                <a href="<?php echo url('admin/marketing/campaigns'); ?>" class="btn btn-link text-primary p-0 text-decoration-none x-small fw-bold">Ver Todas</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-dark table-hover mb-0 bg-transparent align-middle">
                        <thead>
                            <tr>
                                <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent">Nombre</th>
                                <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent">Estado</th>
                                <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent">Programación</th>
                                <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent text-end">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($campaigns)): ?>
                                <?php foreach(array_slice($campaigns, 0, 5) as $camp): ?>
                                <tr>
                                    <td class="border-bottom border-white-10 bg-transparent text-white fw-bold">
                                        <?php echo htmlspecialchars($camp['name']); ?>
                                        <div class="x-small text-white-50 fw-normal"><?php echo htmlspecialchars($camp['subject']); ?></div>
                                    </td>
                                    <td class="border-bottom border-white-10 bg-transparent">
                                        <?php if($camp['status'] === 'draft'): ?>
                                            <span class="badge bg-secondary">Borrador</span>
                                        <?php elseif($camp['status'] === 'scheduled'): ?>
                                            <span class="badge bg-info">Programada</span>
                                        <?php elseif($camp['status'] === 'sending'): ?>
                                            <span class="badge bg-warning text-dark">Enviando</span>
                                        <?php elseif($camp['status'] === 'sent'): ?>
                                            <span class="badge bg-success">Enviada</span>
                                        <?php else: ?>
                                            <span class="badge bg-secondary"><?php echo htmlspecialchars($camp['status']); ?></span>
                                        <?php endif; ?>
                                    </td>
                                    <td class="border-bottom border-white-10 bg-transparent text-white-50 small">
                                        <?php echo $camp['scheduled_at'] ? date('d M, Y H:i', strtotime($camp['scheduled_at'])) : '-'; ?>
                                    </td>
                                    <td class="border-bottom border-white-10 bg-transparent text-end">
                                        <a href="<?php echo url("admin/marketing/showCampaign/{$camp['id']}"); ?>" class="btn btn-outline-light btn-sm rounded-circle p-1">
                                            <span class="material-symbols-outlined fs-6 d-block">visibility</span>
                                        </a>
                                    </td>
                                </tr>

                                <?php endforeach; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="4" class="text-center text-white-50 p-4 bg-transparent">No hay campañas registradas.</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card glass-morphism border-0 mb-4 h-100">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                <h6 class="text-white mb-0 fw-bold">Accesos Rápidos</h6>
            </div>
            <div class="card-body">
                <div class="d-flex flex-column gap-3">
                    <a href="<?php echo url('admin/marketing/lists'); ?>" class="d-flex align-items-center gap-3 p-3 rounded-3 bg-white-5 text-decoration-none transition-all hover-bg-white-10">
                        <div class="rounded-circle bg-primary bg-opacity-25 p-2 text-primary d-flex">
                            <span class="material-symbols-outlined">contacts</span>
                        </div>
                        <div>
                            <h6 class="text-white mb-0 fw-bold">Listas de Contactos</h6>
                            <p class="text-white-50 x-small mb-0">Gestiona tus audiencias y suscriptores.</p>
                        </div>
                    </a>
                    
                    <a href="<?php echo url('admin/marketing/templates'); ?>" class="d-flex align-items-center gap-3 p-3 rounded-3 bg-white-5 text-decoration-none transition-all hover-bg-white-10">
                        <div class="rounded-circle bg-warning bg-opacity-25 p-2 text-warning d-flex">
                            <span class="material-symbols-outlined">design_services</span>
                        </div>
                        <div>
                            <h6 class="text-white mb-0 fw-bold">Plantillas de Email</h6>
                            <p class="text-white-50 x-small mb-0">Diseña mensajes reutilizables.</p>
                        </div>
                    </a>
                    
                    <a href="<?php echo url('admin/marketing/campaigns'); ?>" class="d-flex align-items-center gap-3 p-3 rounded-3 bg-white-5 text-decoration-none transition-all hover-bg-white-10">
                        <div class="rounded-circle bg-success bg-opacity-25 p-2 text-success d-flex">
                            <span class="material-symbols-outlined">bar_chart</span>
                        </div>
                        <div>
                            <h6 class="text-white mb-0 fw-bold">Ver Todas las Campañas</h6>
                            <p class="text-white-50 x-small mb-0">Analiza el rendimiento de tus envíos.</p>
                        </div>
                    </a>

                    <a href="<?php echo url('admin/marketing/automations'); ?>" class="d-flex align-items-center gap-3 p-3 rounded-3 bg-white-5 text-decoration-none transition-all hover-bg-white-10">
                        <div class="rounded-circle bg-info bg-opacity-25 p-2 text-info d-flex">
                            <span class="material-symbols-outlined">smart_toy</span>
                        </div>
                        <div>
                            <h6 class="text-white mb-0 fw-bold">Flujos Automatizados</h6>
                            <p class="text-white-50 x-small mb-0">Configura respuestas automáticas y welcome series.</p>
                        </div>
                    </a>

                    <a href="<?php echo url('admin/marketing/settings'); ?>" class="d-flex align-items-center gap-3 p-3 rounded-3 bg-white-5 text-decoration-none transition-all hover-bg-white-10 border border-primary border-opacity-25">
                        <div class="rounded-circle bg-primary bg-opacity-25 p-2 text-primary d-flex">
                            <span class="material-symbols-outlined">domain_verification</span>
                        </div>
                        <div>
                            <h6 class="text-white mb-0 fw-bold">Entregabilidad (DNS)</h6>
                            <p class="text-white-50 x-small mb-0">Revisa tu SPF y DKIM para no caer en Spam.</p>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
