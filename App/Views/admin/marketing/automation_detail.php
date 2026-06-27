<div class="mb-4 d-flex align-items-center justify-content-between">
    <div>
        <a href="<?php echo url('admin/marketing/automations'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
            <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Automatizaciones
        </a>
        <div class="d-flex align-items-center gap-3">
            <h1 class="h3 text-white fw-bold mb-0"><?php echo htmlspecialchars($automation['name']); ?></h1>
            <?php if ($automation['status'] === 'active'): ?>
                <span class="badge bg-success text-dark fw-bold uppercase">Activo</span>
            <?php elseif ($automation['status'] === 'paused'): ?>
                <span class="badge bg-warning text-dark fw-bold uppercase">Pausado</span>
            <?php else: ?>
                <span class="badge bg-secondary text-white fw-bold uppercase">Borrador</span>
            <?php endif; ?>
        </div>
    </div>
    
    <div>
        <a href="<?php echo url("admin/marketing/toggleAutomationStatus/{$automation['id']}"); ?>" class="btn <?php echo ($automation['status'] === 'active') ? 'btn-outline-warning' : 'btn-success text-dark'; ?> fw-bold">
            <?php echo ($automation['status'] === 'active') ? 'Pausar Flujo' : 'Activar Flujo'; ?>
        </a>
    </div>
</div>

<div class="row g-4">
    <!-- Configuración del Disparador (Trigger) -->
    <div class="col-md-4">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-warning">bolt</span> Origen del Disparador
                </h6>
            </div>
            <div class="card-body">
                <div class="mb-4">
                    <span class="text-white-50 x-small fw-bold uppercase tracking-widest">Evento Gatillo</span>
                    <h5 class="text-white mt-1 fw-bold">
                        <?php 
                            if ($automation['trigger_type'] === 'signup') {
                                echo "Registro de Contacto (Signup)";
                            } elseif ($automation['trigger_type'] === 'campaign_open') {
                                echo "Apertura de Campaña (Open)";
                            } elseif ($automation['trigger_type'] === 'campaign_click') {
                                echo "Clic en Enlace de Campaña (Click)";
                            } else {
                                echo htmlspecialchars($automation['trigger_type']);
                            }
                        ?>
                    </h5>
                </div>
                
                <div class="mb-4">
                    <span class="text-white-50 x-small fw-bold uppercase tracking-widest">Configuración del Trigger</span>
                    <p class="text-white small mt-1">
                        <?php
                            $tData = json_decode($automation['trigger_data'] ?? '{}', true);
                            if ($automation['trigger_type'] === 'signup') {
                                echo isset($tData['list_id']) ? "Filtrado por List ID: <strong>#{$tData['list_id']}</strong>" : "Escucha a todas las listas de contactos.";
                            } else {
                                echo "Filtro dinámico de interacciones generales.";
                            }
                        ?>
                    </p>
                </div>

                <hr class="border-white-10 my-4">

                <h6 class="text-white-50 small mb-3 fw-bold">Añadir Acción al Flujo</h6>
                <div class="d-flex flex-column gap-2">
                    <button class="btn btn-outline-light text-start d-flex align-items-center gap-2 py-2.5" data-bs-toggle="modal" data-bs-target="#addEmailStepModal">
                        <span class="material-symbols-outlined text-primary">mail</span>
                        <div>
                            <div class="fw-bold small text-white">Enviar Email</div>
                            <div class="x-small text-white-50">Dispara una plantilla preconfigurada</div>
                        </div>
                    </button>
                    
                    <button class="btn btn-outline-light text-start d-flex align-items-center gap-2 py-2.5" data-bs-toggle="modal" data-bs-target="#addTagStepModal">
                        <span class="material-symbols-outlined text-warning">label</span>
                        <div>
                            <div class="fw-bold small text-white">Modificar Etiqueta (Tag)</div>
                            <div class="x-small text-white-50">Añadir o remover tags del contacto</div>
                        </div>
                    </button>

                    <button class="btn btn-outline-light text-start d-flex align-items-center gap-2 py-2.5" data-bs-toggle="modal" data-bs-target="#addWebhookStepModal">
                        <span class="material-symbols-outlined text-success">webhook</span>
                        <div>
                            <div class="fw-bold small text-white">Notificar Webhook</div>
                            <div class="x-small text-white-50">Lanzar una llamada HTTP POST a tu API</div>
                        </div>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Pasos del Flujo Secuencial -->
    <div class="col-md-8">
        <div class="card glass-morphism border-0">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-primary">timeline</span> Línea de Tiempo del Flujo
                </h6>
            </div>
            <div class="card-body">
                <?php if (empty($steps)): ?>
                    <div class="text-center py-5 text-white-50">
                        <div class="mb-2">
                            <span class="material-symbols-outlined fs-1 text-white-30">arrow_downward</span>
                        </div>
                        <p class="mb-0">Este flujo no tiene ningún paso de ejecución.</p>
                        <p class="x-small text-white-30">Utiliza el panel de la izquierda para agregar tu primera acción.</p>
                    </div>
                <?php else: ?>
                    <div class="position-relative ps-4" style="border-left: 2px dashed rgba(255,255,255,0.15); margin-left: 20px;">
                        <?php foreach ($steps as $index => $step): ?>
                            <div class="position-relative mb-4">
                                <!-- Indicador del número del paso -->
                                <div class="position-absolute rounded-circle bg-dark border border-white-20 text-white d-flex align-items-center justify-content-center fw-bold" 
                                     style="width: 32px; height: 32px; left: -42px; top: 0; font-size: 13px;">
                                    <?php echo $step['step_order']; ?>
                                </div>
                                
                                <div class="card border-0 bg-white-5 p-3 rounded-3 d-flex flex-row align-items-center justify-content-between">
                                    <div class="d-flex align-items-center gap-3">
                                        <?php 
                                            $sConfig = json_decode($step['step_config'] ?? '{}', true);
                                            if ($step['step_type'] === 'send_email'): 
                                                $tplName = 'Plantilla no encontrada';
                                                foreach ($templates as $t) {
                                                    if ($t['id'] == ($sConfig['template_id'] ?? 0)) {
                                                        $tplName = $t['name'];
                                                        break;
                                                    }
                                                }
                                        ?>
                                            <div class="rounded-circle bg-primary bg-opacity-25 p-2 text-primary d-flex">
                                                <span class="material-symbols-outlined">mail</span>
                                            </div>
                                            <div>
                                                <h6 class="text-white mb-0 fw-bold">Enviar Correo Electrónico</h6>
                                                <p class="text-white-50 x-small mb-0">Plantilla: <strong><?php echo htmlspecialchars($tplName); ?></strong></p>
                                            </div>
                                        <?php elseif ($step['step_type'] === 'tag'): ?>
                                            <div class="rounded-circle bg-warning bg-opacity-25 p-2 text-warning d-flex">
                                                <span class="material-symbols-outlined">label</span>
                                            </div>
                                            <div>
                                                <h6 class="text-white mb-0 fw-bold">Actualizar Etiqueta (Tag)</h6>
                                                <p class="text-white-50 x-small mb-0">Acción: <strong><?php echo ($sConfig['action'] === 'add') ? 'Agregar' : 'Remover'; ?></strong> tag <strong>"<?php echo htmlspecialchars($sConfig['tag_name'] ?? ''); ?>"</strong></p>
                                            </div>
                                        <?php elseif ($step['step_type'] === 'webhook'): ?>
                                            <div class="rounded-circle bg-success bg-opacity-25 p-2 text-success d-flex">
                                                <span class="material-symbols-outlined">webhook</span>
                                            </div>
                                            <div>
                                                <h6 class="text-white mb-0 fw-bold">Llamada Webhook (POST)</h6>
                                                <p class="text-white-50 x-small mb-0">URL: <code class="text-info"><?php echo htmlspecialchars($sConfig['url'] ?? ''); ?></code></p>
                                            </div>
                                        <?php endif; ?>
                                    </div>
                                    
                                    <a href="<?php echo url("admin/marketing/deleteStep/{$step['id']}"); ?>" class="btn btn-outline-danger btn-sm rounded-circle p-1 d-inline-flex align-items-center justify-content-center" title="Eliminar Paso" style="width:30px; height:30px;" onclick="return confirm('¿Seguro que deseas eliminar este paso del flujo?');">
                                        <span class="material-symbols-outlined fs-6">close</span>
                                    </a>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<!-- Modal paso: Enviar Email -->
<div class="modal fade" id="addEmailStepModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-morphism border-white-10 text-white" style="background: rgba(15,15,20,0.95);">
            <div class="modal-header border-bottom border-white-10">
                <h5 class="modal-title fw-bold">Añadir Acción: Enviar Email</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<?php echo url("admin/marketing/addStep/{$automation['id']}"); ?>" method="POST">
                <?php echo csrf_field(); ?>
                <input type="hidden" name="step_type" value="send_email">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="template_id" class="form-label text-white-50">Plantilla de Correo</label>
                        <select class="form-select bg-dark border-white-10 text-white" id="template_id" name="template_id" required>
                            <option value="">Selecciona una plantilla...</option>
                            <?php foreach ($templates as $t): ?>
                                <option value="<?php echo $t['id']; ?>"><?php echo htmlspecialchars($t['name']); ?></option>
                            <?php endforeach; ?>
                        </select>
                        <div class="form-text text-white-30">El correo utilizará los datos del contacto suscripto para parsear de forma dinámica las etiquetas de personalización.</div>
                    </div>
                </div>
                <div class="modal-footer border-top border-white-10">
                    <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Añadir Acción</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal paso: Modificar Tag -->
<div class="modal fade" id="addTagStepModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-morphism border-white-10 text-white" style="background: rgba(15,15,20,0.95);">
            <div class="modal-header border-bottom border-white-10">
                <h5 class="modal-title fw-bold">Añadir Acción: Actualizar Tag</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<?php echo url("admin/marketing/addStep/{$automation['id']}"); ?>" method="POST">
                <?php echo csrf_field(); ?>
                <input type="hidden" name="step_type" value="tag">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="tag_action" class="form-label text-white-50">Acción</label>
                        <select class="form-select bg-dark border-white-10 text-white" id="tag_action" name="tag_action" required>
                            <option value="add">Asignar / Agregar Etiqueta</option>
                            <option value="remove">Remover / Quitar Etiqueta</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="tag_name" class="form-label text-white-50">Nombre de la Etiqueta (Tag)</label>
                        <input type="text" class="form-control bg-dark border-white-10 text-white" id="tag_name" name="tag_name" required placeholder="Ej: lead_bienvenida_completado">
                    </div>
                </div>
                <div class="modal-footer border-top border-white-10">
                    <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Añadir Acción</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal paso: Webhook -->
<div class="modal fade" id="addWebhookStepModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-morphism border-white-10 text-white" style="background: rgba(15,15,20,0.95);">
            <div class="modal-header border-bottom border-white-10">
                <h5 class="modal-title fw-bold">Añadir Acción: Notificar Webhook</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<?php echo url("admin/marketing/addStep/{$automation['id']}"); ?>" method="POST">
                <?php echo csrf_field(); ?>
                <input type="hidden" name="step_type" value="webhook">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="webhook_url" class="form-label text-white-50">URL del endpoint de Destino (POST)</label>
                        <input type="url" class="form-control bg-dark border-white-10 text-white" id="webhook_url" name="webhook_url" required placeholder="https://api.tudominio.com/leads/notify">
                        <div class="form-text text-white-30">El sistema enviará una petición POST con los datos estructurados en formato JSON del contacto suscrito de forma asíncrona.</div>
                    </div>
                </div>
                <div class="modal-footer border-top border-white-10">
                    <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Añadir Acción</button>
                </div>
            </form>
        </div>
    </div>
</div>
