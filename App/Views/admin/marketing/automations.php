<div class="mb-4 d-flex align-items-center justify-content-between">
    <div>
        <a href="<?php echo url('admin/marketing'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
            <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Dashboard
        </a>
        <h1 class="h3 text-white fw-bold mb-0">Flujos Automatizados</h1>
    </div>
    <button class="btn btn-primary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#createAutomationModal">
        <span class="material-symbols-outlined">add</span> Nuevo Flujo
    </button>
</div>

<div class="row g-4">
    <div class="col-md-12">
        <div class="card glass-morphism border-0">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-info">auto_settings</span> Automatizaciones Activas y Borradores
                </h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-dark table-hover mb-0 align-middle">
                        <thead>
                            <tr class="text-white-50 border-bottom border-white-10 fs-7 uppercase tracking-wider">
                                <th class="ps-4 py-3">Nombre del Flujo</th>
                                <th>Disparador (Trigger)</th>
                                <th>Estado</th>
                                <th>Fecha Creación</th>
                                <th class="text-end pe-4">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (empty($automations)): ?>
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-white-50">
                                        <div class="mb-2">
                                            <span class="material-symbols-outlined fs-1 text-white-30">smart_toy</span>
                                        </div>
                                        <p class="mb-0">No has creado ningún flujo automatizado aún.</p>
                                        <p class="x-small text-white-30">Haz clic en "Nuevo Flujo" para comenzar a automatizar tus campañas.</p>
                                    </td>
                                </tr>
                            <?php else: ?>
                                <?php foreach ($automations as $auto): ?>
                                    <tr class="border-bottom border-white-5">
                                        <td class="ps-4 py-3">
                                            <a href="<?php echo url("admin/marketing/showAutomation/{$auto['id']}"); ?>" class="text-white fw-bold text-decoration-none hover-text-primary">
                                                <?php echo htmlspecialchars($auto['name']); ?>
                                            </a>
                                        </td>
                                        <td>
                                            <?php 
                                                $trigger = $auto['trigger_type'];
                                                $triggerData = json_decode($auto['trigger_data'] ?? '{}', true);
                                                
                                                if ($trigger === 'signup') {
                                                    $listName = 'Cualquier Lista';
                                                    if (isset($triggerData['list_id'])) {
                                                        foreach ($lists as $l) {
                                                            if ($l['id'] == $triggerData['list_id']) {
                                                                $listName = $l['name'];
                                                                break;
                                                            }
                                                        }
                                                    }
                                                    echo '<span class="badge bg-primary bg-opacity-25 text-primary border border-primary border-opacity-50">Registro en: ' . htmlspecialchars($listName) . '</span>';
                                                } elseif ($trigger === 'campaign_open') {
                                                    echo '<span class="badge bg-info bg-opacity-25 text-info border border-info border-opacity-50">Apertura de Email</span>';
                                                } elseif ($trigger === 'campaign_click') {
                                                    echo '<span class="badge bg-success bg-opacity-25 text-success border border-success border-opacity-50">Clic en Enlace</span>';
                                                } else {
                                                    echo '<span class="badge bg-secondary">' . htmlspecialchars($trigger) . '</span>';
                                                }
                                            ?>
                                        </td>
                                        <td>
                                            <?php if ($auto['status'] === 'active'): ?>
                                                <span class="badge bg-success text-dark fw-bold">Activo</span>
                                            <?php elseif ($auto['status'] === 'paused'): ?>
                                                <span class="badge bg-warning text-dark fw-bold">Pausado</span>
                                            <?php else: ?>
                                                <span class="badge bg-secondary text-white fw-bold">Borrador</span>
                                            <?php endif; ?>
                                        </td>
                                        <td class="text-white-50 small">
                                            <?php echo date('d/m/Y H:i', strtotime($auto['created_at'])); ?>
                                        </td>
                                        <td class="text-end pe-4">
                                            <a href="<?php echo url("admin/marketing/showAutomation/{$auto['id']}"); ?>" class="btn btn-outline-light btn-sm rounded-circle p-1 d-inline-flex align-items-center justify-content-center me-1" title="Ver Pasos" style="width:30px; height:30px;">
                                                <span class="material-symbols-outlined fs-6">insights</span>
                                            </a>
                                            <a href="<?php echo url("admin/marketing/deleteAutomation/{$auto['id']}"); ?>" class="btn btn-outline-danger btn-sm rounded-circle p-1 d-inline-flex align-items-center justify-content-center" title="Eliminar" style="width:30px; height:30px;" onclick="return confirm('¿Seguro que deseas eliminar esta automatización? Esta acción no afectará a los correos que ya hayan sido enviados.');">
                                                <span class="material-symbols-outlined fs-6">delete</span>
                                            </a>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal para Crear Nueva Automatización -->
<div class="modal fade" id="createAutomationModal" tabindex="-1" aria-labelledby="createAutomationModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-morphism border-white-10 text-white" style="background: rgba(15,15,20,0.95); backdrop-filter: blur(10px);">
            <div class="modal-header border-bottom border-white-10">
                <h5 class="modal-title fw-bold" id="createAutomationModalLabel">Crear Nuevo Flujo Automatizado</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<?php echo url('admin/marketing/storeAutomation'); ?>" method="POST">
                <?php echo csrf_field(); ?>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="name" class="form-label text-white-50">Nombre del Flujo</label>
                        <input type="text" class="form-control bg-dark border-white-10 text-white" id="name" name="name" required placeholder="Ej: Secuencia de Bienvenida">
                    </div>
                    
                    <div class="mb-3">
                        <label for="trigger_type" class="form-label text-white-50">Disparador (Trigger)</label>
                        <select class="form-select bg-dark border-white-10 text-white" id="trigger_type" name="trigger_type" onchange="toggleTriggerSettings(this.value)">
                            <option value="signup">Cuando un usuario se suscribe a una lista (Signup)</option>
                            <option value="campaign_open">Cuando abre cualquier campaña (Email Open)</option>
                            <option value="campaign_click">Cuando hace clic en cualquier enlace (Email Click)</option>
                        </select>
                    </div>

                    <div class="mb-3" id="trigger-list-wrapper">
                        <label for="list_id" class="form-label text-white-50">Lista Seleccionada</label>
                        <select class="form-select bg-dark border-white-10 text-white" id="list_id" name="list_id">
                            <option value="">Cualquier Lista de Contactos</option>
                            <?php foreach ($lists as $l): ?>
                                <option value="<?php echo $l['id']; ?>"><?php echo htmlspecialchars($l['name']); ?></option>
                            <?php endforeach; ?>
                        </select>
                        <div class="form-text text-white-30">Solo se ejecutará el flujo cuando el registro ocurra en la lista indicada.</div>
                    </div>
                </div>
                <div class="modal-footer border-top border-white-10">
                    <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Crear Flujo</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function toggleTriggerSettings(val) {
    const listWrapper = document.getElementById('trigger-list-wrapper');
    if (val === 'signup') {
        listWrapper.style.display = 'block';
    } else {
        listWrapper.style.display = 'none';
    }
}
</script>
