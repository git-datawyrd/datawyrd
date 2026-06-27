<div class="mb-4">
    <a href="<?php echo url('admin/marketing'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
        <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Dashboard
    </a>
    <h1 class="h3 text-white fw-bold mb-0">Configuración & Entregabilidad</h1>
</div>

<ul class="nav nav-tabs border-white-10 mb-4" id="marketingSettingsTab" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link active bg-transparent text-white border-0 border-bottom border-primary border-3 fw-bold px-4 py-3" id="dns-tab" data-bs-toggle="tab" data-bs-target="#dns-pane" type="button" role="tab" aria-controls="dns-pane" aria-selected="true">
            <span class="d-flex align-items-center gap-2">
                <span class="material-symbols-outlined fs-5">dns</span> DNS & Entregabilidad
            </span>
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link bg-transparent text-white border-0 fw-bold px-4 py-3" id="blacklist-tab" data-bs-toggle="tab" data-bs-target="#blacklist-pane" type="button" role="tab" aria-controls="blacklist-pane" aria-selected="false">
            <span class="d-flex align-items-center gap-2">
                <span class="material-symbols-outlined fs-5">block</span> Lista Negra Global
            </span>
        </button>
    </li>
</ul>

<div class="tab-content" id="marketingSettingsTabContent">
    <!-- TAB 1: DNS -->
    <div class="tab-pane fade show active" id="dns-pane" role="tabpanel" aria-labelledby="dns-tab">
        <div class="row g-4">
            <div class="col-md-5">
                <div class="card glass-morphism border-0 h-100">
                    <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                        <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined text-primary">domain_verification</span> Consultar Dominio
                        </h6>
                    </div>
                    <div class="card-body">
                        <p class="text-white-50 small mb-4">
                            Para que tus correos lleguen a la bandeja de entrada y no a Spam, es obligatorio configurar los registros TXT de SPF y DKIM en tu proveedor de dominio (Ej: Cloudflare, GoDaddy).
                        </p>
                        
                        <form action="<?php echo url('admin/marketing/settings'); ?>" method="POST">
                            <?php echo csrf_field(); ?>
                            <input type="hidden" name="action" value="validate_dns">
                            <div class="mb-3">
                                <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Dominio de Envío</label>
                                <input type="text" name="domain" class="form-control bg-black text-white border-white-10 p-3 rounded-3" value="<?php echo htmlspecialchars($domain ?? ''); ?>" placeholder="ejemplo.com" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Selector DKIM</label>
                                <input type="text" name="dkim_selector" class="form-control bg-black text-white border-white-10 p-3 rounded-3" value="<?php echo htmlspecialchars($selector ?? 'mail'); ?>" placeholder="mail" required>
                                <div class="form-text text-white-50 x-small mt-1">Suele ser 'mail', 'zmail' o 'zeptomail' dependiendo de tu proveedor SMTP.</div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 d-flex align-items-center justify-content-center gap-2">
                                <span class="material-symbols-outlined">search</span> Validar DNS Ahora
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <?php if(isset($spfResult)): ?>
                    <!-- Resultados SPF -->
                    <div class="card glass-morphism border-0 mb-4 <?php echo $spfResult['status'] ? 'border-success' : 'border-danger'; ?>" style="border-left: 4px solid !important;">
                        <div class="card-body">
                            <div class="d-flex align-items-start gap-3">
                                <span class="material-symbols-outlined fs-2 <?php echo $spfResult['status'] ? 'text-success' : 'text-danger'; ?>">
                                    <?php echo $spfResult['status'] ? 'check_circle' : 'error'; ?>
                                </span>
                                <div>
                                    <h6 class="text-white fw-bold mb-1">Registro SPF</h6>
                                    <p class="text-white-50 small mb-2"><?php echo htmlspecialchars($spfResult['message']); ?></p>
                                    <?php if($spfResult['raw']): ?>
                                        <code class="bg-black p-2 rounded-2 d-block text-success small border border-white-10">
                                            <?php echo htmlspecialchars($spfResult['raw']); ?>
                                        </code>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Resultados DKIM -->
                    <div class="card glass-morphism border-0 <?php echo $dkimResult['status'] ? 'border-success' : 'border-danger'; ?>" style="border-left: 4px solid !important;">
                        <div class="card-body">
                            <div class="d-flex align-items-start gap-3">
                                <span class="material-symbols-outlined fs-2 <?php echo $dkimResult['status'] ? 'text-success' : 'text-danger'; ?>">
                                    <?php echo $dkimResult['status'] ? 'check_circle' : 'error'; ?>
                                </span>
                                <div>
                                    <h6 class="text-white fw-bold mb-1">Registro DKIM (<?php echo htmlspecialchars($selector); ?>._domainkey)</h6>
                                    <p class="text-white-50 small mb-2"><?php echo htmlspecialchars($dkimResult['message']); ?></p>
                                    <?php if($dkimResult['raw']): ?>
                                        <code class="bg-black p-2 rounded-2 d-block text-success small border border-white-10" style="word-break: break-all;">
                                            <?php echo htmlspecialchars($dkimResult['raw']); ?>
                                        </code>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <?php if(!$spfResult['status'] || !$dkimResult['status']): ?>
                        <div class="alert alert-warning bg-warning bg-opacity-10 border-warning border-opacity-25 text-warning mt-4 d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined">warning</span>
                            <span class="small">Tus correos podrían ser marcados como SPAM. Corrige los registros en tu DNS y espera hasta 24 horas para que los cambios se propaguen.</span>
                        </div>
                    <?php else: ?>
                        <div class="alert alert-success bg-success bg-opacity-10 border-success border-opacity-25 text-success mt-4 d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined">verified</span>
                            <span class="small">¡Excelente! Tu dominio está autenticado correctamente. Estás listo para lanzar campañas con alta entregabilidad.</span>
                        </div>
                    <?php endif; ?>
                <?php else: ?>
                    <div class="h-100 d-flex flex-column align-items-center justify-content-center text-white-50 p-5 bg-white-5 rounded-4 border border-white-10 border-dashed">
                        <span class="material-symbols-outlined fs-1 mb-3 opacity-50">dns</span>
                        <h6 class="fw-bold mb-1">Sin Validar</h6>
                        <p class="small text-center mb-0">Ingresa tu dominio y selector a la izquierda para verificar el estado de la entregabilidad.</p>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- TAB 2: BLACKLIST -->
    <div class="tab-pane fade" id="blacklist-pane" role="tabpanel" aria-labelledby="blacklist-tab">
        <div class="row g-4">
            <!-- Agregar a lista negra -->
            <div class="col-md-5">
                <div class="card glass-morphism border-0">
                    <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                        <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined text-danger">person_add_disabled</span> Añadir Correo a Lista Negra
                        </h6>
                    </div>
                    <div class="card-body shadow-sm">
                        <p class="text-white-50 small mb-4">
                            Los correos electrónicos en la lista negra se excluirán automáticamente de cualquier envío de campaña (incluso si están suscritos en las listas).
                        </p>
                        <form action="<?php echo url('admin/marketing/settings'); ?>" method="POST">
                            <?php echo csrf_field(); ?>
                            <input type="hidden" name="action" value="add_blacklist">
                            <div class="mb-3">
                                <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Correo Electrónico *</label>
                                <input type="email" name="email" class="form-control bg-black text-white border-white-10 p-3 rounded-3" placeholder="ejemplo@dominio.com" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Motivo de la Supresión</label>
                                <input type="text" name="reason" class="form-control bg-black text-white border-white-10 p-3 rounded-3" placeholder="Ej: Rebote duro, solicitud del cliente" value="Añadido manualmente">
                            </div>
                            <button type="submit" class="btn btn-danger w-100 d-flex align-items-center justify-content-center gap-2 text-white" style="background: linear-gradient(135deg, #ef4444, #b91c1c); border: none;">
                                <span class="material-symbols-outlined">block</span> Bloquear Correo
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Listado y Búsqueda -->
            <div class="col-md-7">
                <div class="card glass-morphism border-0 h-100 shadow-sm">
                    <div class="card-header border-bottom border-white-10 bg-transparent py-3 d-flex align-items-center justify-content-between flex-wrap gap-2">
                        <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined text-warning">format_list_bulleted</span> Correos Bloqueados
                        </h6>
                        <form action="<?php echo url('admin/marketing/settings'); ?>" method="GET" class="d-flex align-items-center gap-2">
                            <input type="hidden" name="tab" value="blacklist">
                            <input type="text" name="search" class="form-control form-control-sm bg-black text-white border-white-10 px-3 py-2 rounded-pill" placeholder="Buscar email..." value="<?php echo htmlspecialchars($search ?? ''); ?>">
                            <button type="submit" class="btn btn-sm btn-outline-light rounded-pill px-3">Buscar</button>
                        </form>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-dark table-hover mb-0 align-middle">
                                <thead>
                                    <tr class="text-white-50 border-white-10 x-small fw-bold uppercase">
                                        <th class="ps-4">Email</th>
                                        <th>Motivo</th>
                                        <th>Fecha</th>
                                        <th class="pe-4 text-end">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if(empty($blacklist)): ?>
                                        <tr>
                                            <td colspan="4" class="text-center text-white-50 py-5">
                                                <span class="material-symbols-outlined fs-2 mb-2 opacity-50">search_off</span>
                                                <p class="small mb-0">No se encontraron correos en la lista negra.</p>
                                            </td>
                                        </tr>
                                    <?php else: foreach($blacklist as $entry): ?>
                                        <tr class="border-white-10">
                                            <td class="ps-4 text-white font-monospace small"><?php echo htmlspecialchars($entry['email']); ?></td>
                                            <td>
                                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 small px-2 py-1 rounded">
                                                    <?php echo htmlspecialchars($entry['reason'] ?? 'Sin motivo'); ?>
                                                </span>
                                            </td>
                                            <td class="text-white-50 small"><?php echo date('Y-m-d H:i', strtotime($entry['created_at'])); ?></td>
                                            <td class="pe-4 text-end">
                                                <a href="<?php echo url("admin/marketing/settings?action=remove_blacklist&id={$entry['id']}"); ?>" 
                                                   class="btn btn-link btn-sm text-danger d-inline-flex align-items-center p-0 text-decoration-none" 
                                                   onclick="return confirm('¿Seguro que deseas eliminar este correo de la lista negra? Volverá a recibir correos si está en alguna lista de suscripción.');">
                                                    <span class="material-symbols-outlined">delete</span>
                                                </a>
                                            </td>
                                        </tr>
                                    <?php endforeach; endif; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Preserve active tab on redirect / reload
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('tab') === 'blacklist') {
        const blacklistTab = document.getElementById('blacklist-tab');
        if (blacklistTab) {
            // Remove active class from DNS
            document.getElementById('dns-tab').classList.remove('active');
            document.getElementById('dns-pane').classList.remove('show', 'active');
            
            // Add active class to Blacklist
            blacklistTab.classList.add('active');
            document.getElementById('blacklist-pane').classList.add('show', 'active');
        }
    }
});
</script>
