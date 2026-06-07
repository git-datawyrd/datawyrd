<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="h3 text-white fw-bold mb-0">Plantillas de Email</h1>
    <a href="<?php echo url('admin/marketing/createTemplate'); ?>" class="btn btn-primary d-flex align-items-center gap-2">
        <span class="material-symbols-outlined">add</span> Nueva Plantilla
    </a>
</div>

<div class="card glass-morphism border-0">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0 bg-transparent align-middle">
                <thead>
                    <tr>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Nombre</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Categoría</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3 text-end">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($templates)): ?>
                        <?php foreach($templates as $tpl): ?>
                        <tr>
                            <td class="border-bottom border-white-10 bg-transparent text-white fw-bold p-3">
                                <?php echo htmlspecialchars($tpl['name']); ?>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent text-white-50 p-3">
                                <span class="badge bg-secondary"><?php echo htmlspecialchars($tpl['category'] ?? 'General'); ?></span>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent p-3 text-end">
                                <a href="<?php echo url("admin/marketing/editTemplate/{$tpl['id']}"); ?>" class="btn btn-outline-light btn-sm rounded-circle p-1" title="Editar">
                                    <span class="material-symbols-outlined fs-6 d-block">edit</span>
                                </a>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="3" class="text-center text-white-50 p-4 bg-transparent">No hay plantillas registradas.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>
