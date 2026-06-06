<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="h3 text-white fw-bold mb-0">Campañas de Email</h1>
    <a href="<?php echo url('admin/marketing/campaigns/create'); ?>" class="btn btn-primary d-flex align-items-center gap-2">
        <span class="material-symbols-outlined">add</span> Nueva Campaña
    </a>
</div>

<div class="card glass-morphism border-0">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0 bg-transparent align-middle">
                <thead>
                    <tr>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Nombre</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Asunto</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Estado</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3 text-end">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($campaigns)): ?>
                        <?php foreach($campaigns as $camp): ?>
                        <tr>
                            <td class="border-bottom border-white-10 bg-transparent text-white fw-bold p-3">
                                <?php echo htmlspecialchars($camp['name']); ?>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent text-white-50 p-3">
                                <?php echo htmlspecialchars($camp['subject']); ?>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent p-3">
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
                            <td class="border-bottom border-white-10 bg-transparent p-3 text-end">
                                <a href="<?php echo url("admin/marketing/campaigns/{$camp['id']}"); ?>" class="btn btn-outline-light btn-sm rounded-circle p-1" title="Ver Detalle">
                                    <span class="material-symbols-outlined fs-6 d-block">visibility</span>
                                </a>
                                <?php if ($camp['status'] === 'sent'): ?>
                                <a href="<?php echo url("admin/marketing/campaigns/{$camp['id']}/analytics"); ?>" class="btn btn-outline-primary btn-sm rounded-circle p-1 ms-1" title="Analíticas">
                                    <span class="material-symbols-outlined fs-6 d-block">bar_chart</span>
                                </a>
                                <?php endif; ?>
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
