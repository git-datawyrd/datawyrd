<div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
    <div>
        <a href="<?php echo url('admin/marketing/campaigns'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
            <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Campañas
        </a>
        <div class="d-flex align-items-center gap-2">
            <h1 class="h3 text-white fw-bold mb-0"><?php echo htmlspecialchars($campaign['name']); ?></h1>
            <?php
            $statusBadges = [
                'draft'     => ['bg-secondary', 'Borrador'],
                'scheduled' => ['bg-info text-dark', 'Programada'],
                'sending'   => ['bg-warning text-dark', 'Enviando'],
                'sent'      => ['bg-success', 'Enviada'],
                'paused'    => ['bg-danger', 'Pausada'],
            ];
            [$badgeCls, $badgeLabel] = $statusBadges[$campaign['status']] ?? ['bg-secondary', $campaign['status']];
            ?>
            <span class="badge <?php echo $badgeCls; ?> rounded-pill px-2 py-1 x-small fw-bold uppercase tracking-wider"><?php echo $badgeLabel; ?></span>
        </div>
    </div>
    <div class="d-flex align-items-center gap-2 flex-wrap">
        <!-- Duplicar -->
        <a href="<?php echo url("admin/marketing/duplicateCampaign/{$campaign['id']}"); ?>" class="btn btn-outline-light d-flex align-items-center gap-2 px-3 rounded-pill" title="Duplicar esta campaña">
            <span class="material-symbols-outlined fs-5">content_copy</span> Duplicar
        </a>

        <!-- Eliminar -->
        <a href="<?php echo url("admin/marketing/deleteCampaign/{$campaign['id']}"); ?>" class="btn btn-outline-danger d-flex align-items-center gap-2 px-3 rounded-pill" onclick="return confirm('¿Seguro que deseas eliminar esta campaña? Esta acción no se puede deshacer.');">
            <span class="material-symbols-outlined fs-5">delete</span> Eliminar
        </a>

        <?php if ($campaign['status'] === 'draft' || $campaign['status'] === 'paused'): ?>
            <!-- Enviar Prueba -->
            <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2 px-3 rounded-pill text-white border-white-20" data-bs-toggle="modal" data-bs-target="#testSendModal" title="Enviar un correo de prueba">
                <span class="material-symbols-outlined fs-5">mail</span> Enviar Prueba
            </button>

            <!-- Editar -->
            <button type="button" class="btn btn-outline-info d-flex align-items-center gap-2 px-3 rounded-pill" data-bs-toggle="modal" data-bs-target="#editCampaignModal">
                <span class="material-symbols-outlined fs-5">edit</span> Editar
            </button>
        <?php endif; ?>

        <?php if ($campaign['status'] === 'draft'): ?>
            <!-- Programar -->
            <button type="button" class="btn btn-outline-warning d-flex align-items-center gap-2 px-3 rounded-pill" data-bs-toggle="modal" data-bs-target="#scheduleCampaignModal">
                <span class="material-symbols-outlined fs-5">calendar_month</span> Programar
            </button>

            <!-- Lanzar Ahora -->
            <form action="<?php echo url("admin/marketing/launchCampaign/{$campaign['id']}"); ?>" method="POST" class="d-inline">
                <?php echo csrf_field(); ?>
                <button type="submit" class="btn btn-success d-flex align-items-center gap-2 px-4 rounded-pill fw-bold text-white shadow-sm" style="background: linear-gradient(135deg, #10b981, #059669); border: none;">
                    <span class="material-symbols-outlined fs-5">rocket_launch</span> Lanzar Ahora
                </button>
            </form>
        <?php endif; ?>
    </div>
</div>

<div class="row g-4">
    <!-- Columna Izquierda: Información -->
    <div class="col-lg-8">
        <div class="card glass-morphism border-0 mb-4">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                <h6 class="text-white mb-0 fw-bold">Detalles de la Campaña</h6>
            </div>
            <div class="card-body">
                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="text-white-50 x-small uppercase tracking-widest fw-bold mb-1">Nombre Interno</label>
                        <p class="text-white fw-bold mb-0"><?php echo htmlspecialchars($campaign['name']); ?></p>
                    </div>
                    <div class="col-md-6">
                        <label class="text-white-50 x-small uppercase tracking-widest fw-bold mb-1">Asunto del Correo</label>
                        <p class="text-white fw-bold mb-0"><?php echo htmlspecialchars($campaign['subject']); ?></p>
                    </div>
                    <div class="col-md-6">
                        <label class="text-white-50 x-small uppercase tracking-widest fw-bold mb-1">Remitente</label>
                        <p class="text-white mb-0"><?php echo htmlspecialchars($campaign['from_name']); ?> &lt;<?php echo htmlspecialchars($campaign['from_email']); ?>&gt;</p>
                    </div>
                    <div class="col-md-6">
                        <label class="text-white-50 x-small uppercase tracking-widest fw-bold mb-1">Lista de Destinatarios</label>
                        <p class="text-white mb-0">
                            <?php if (!empty($campaign['list_id'])): ?>
                                <a href="<?php echo url("admin/marketing/showList/{$campaign['list_id']}"); ?>" class="text-info text-decoration-none fw-bold">
                                    <?php echo htmlspecialchars($campaign['list_name'] ?? 'Lista ID #'.$campaign['list_id']); ?>
                                </a>
                            <?php else: ?>
                                <span class="text-white-50">Sin Lista Asignada</span>
                            <?php endif; ?>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card glass-morphism border-0">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3 d-flex justify-content-between align-items-center">
                <h6 class="text-white mb-0 fw-bold">Plantilla: <?php echo htmlspecialchars($campaign['template_name'] ?? 'Sin Plantilla'); ?></h6>
                <?php if ($campaign['template_id'] && ($campaign['status'] === 'draft' || $campaign['status'] === 'paused')): ?>
                    <a href="<?php echo url("admin/marketing/editTemplate/{$campaign['template_id']}"); ?>" class="btn btn-sm d-flex align-items-center gap-1 rounded-pill px-3 fw-bold" style="background:#D4AF37; color:#000; border:none;">
                        <span class="material-symbols-outlined fs-6">edit</span> EDITAR DISEÑO
                    </a>
                <?php elseif ($campaign['status'] === 'draft' || $campaign['status'] === 'paused'): ?>
                    <button type="button" class="btn btn-sm d-flex align-items-center gap-1 rounded-pill px-3 fw-bold" style="background:#D4AF37; color:#000; border:none;" data-bs-toggle="modal" data-bs-target="#editCampaignModal">
                        <span class="material-symbols-outlined fs-6">add</span> ASIGNAR PLANTILLA
                    </button>
                <?php endif; ?>
            </div>
            <div class="card-body p-0">
                <iframe srcdoc="<?php echo htmlspecialchars($campaign['html_body'] ?? '<p class="text-white-50 p-4">Sin contenido asignado. Edita la campaña para vincular una plantilla.</p>'); ?>" 
                        style="width: 100%; height: 400px; border: none; background: #fff;" class="rounded-bottom"></iframe>
            </div>
        </div>
    </div>

    <!-- Columna Derecha: Métricas Rápidas -->
    <div class="col-lg-4">
        <div class="card glass-morphism border-0 mb-4 position-relative overflow-hidden">
            <div style="position:absolute;top:-20px;right:-20px;width:100px;height:100px;border-radius:50%;background:#6366f1;opacity:.1;"></div>
            <div class="card-body">
                <h6 class="text-white-50 mb-3 uppercase tracking-widest x-small fw-bold">Rendimiento Resumido</h6>
                
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-white">Enviados</span>
                    <span class="fw-bold text-primary fs-5"><?php echo number_format($metrics['total_sent'] ?? 0); ?></span>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-white">Aperturas</span>
                    <span class="fw-bold text-info fs-5"><?php echo number_format($metrics['unique_opens'] ?? 0); ?> <small class="text-white-50 fs-6">(<?php echo number_format($metrics['open_rate'] ?? 0, 1); ?>%)</small></span>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-white">Clics</span>
                    <span class="fw-bold text-success fs-5"><?php echo number_format($metrics['unique_clicks'] ?? 0); ?> <small class="text-white-50 fs-6">(<?php echo number_format($metrics['click_rate'] ?? 0, 1); ?>%)</small></span>
                </div>
                
                <hr class="border-white-10 my-3">
                
                <?php if ($campaign['status'] === 'sent' || $campaign['status'] === 'sending'): ?>
                    <div class="mt-3">
                        <a href="<?php echo url("admin/marketing/analytics/{$campaign['id']}"); ?>" class="btn btn-outline-primary btn-sm w-100 rounded-pill">Ver Analytics Completos</a>
                    </div>
                <?php else: ?>
                <div class="text-center text-white-50 py-4">
                    <span class="material-symbols-outlined fs-1 mb-2 opacity-50">query_stats</span>
                    <p class="small mb-0">Las métricas estarán disponibles una vez que se lance la campaña.</p>
                </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<!-- ==================== MODAL EDITAR CAMPAÑA ==================== -->
<div class="modal fade" id="editCampaignModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <form action="<?php echo url("admin/marketing/updateCampaign/{$campaign['id']}"); ?>" method="POST" class="modal-content bg-midnight border-white-10 glass-morphism">
      <?php echo csrf_field(); ?>
      <div class="modal-header border-white-10">
        <h5 class="modal-title text-white d-flex align-items-center gap-2">
          <span class="material-symbols-outlined text-info">edit</span> Editar Detalles de Campaña
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body text-start">
        <?php
        $filters = !empty($campaign['segment_filters']) ? json_decode($campaign['segment_filters'], true) : [];
        $utm = $filters['utm'] ?? [];
        $utmEnabled = $utm['enabled'] ?? false;
        $behavior = $filters['behavior'] ?? [];
        ?>
        <div class="row g-3">
          <div class="col-12">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Nombre Interno de la Campaña *</label>
            <input type="text" name="name" class="form-control bg-black text-white border-white-10 p-2 rounded-2" required value="<?php echo htmlspecialchars($campaign['name'] ?? ''); ?>">
          </div>
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Asunto del Email *</label>
            <input type="text" name="subject" class="form-control bg-black text-white border-white-10 p-2 rounded-2" required value="<?php echo htmlspecialchars($campaign['subject'] ?? ''); ?>">
          </div>
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Texto de Vista Previa (Preview Text)</label>
            <input type="text" name="preview_text" class="form-control bg-black text-white border-white-10 p-2 rounded-2" value="<?php echo htmlspecialchars($campaign['preview_text'] ?? ''); ?>">
          </div>
          <div class="col-md-4">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Nombre Remitente</label>
            <input type="text" name="from_name" class="form-control bg-black text-white border-white-10 p-2 rounded-2" value="<?php echo htmlspecialchars($campaign['from_name'] ?? ''); ?>">
          </div>
          <div class="col-md-4">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Email Remitente</label>
            <input type="email" name="from_email" class="form-control bg-black text-white border-white-10 p-2 rounded-2" value="<?php echo htmlspecialchars($campaign['from_email'] ?? ''); ?>">
          </div>
          <div class="col-md-4">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Responder A (Reply-To)</label>
            <input type="email" name="reply_to" class="form-control bg-black text-white border-white-10 p-2 rounded-2" value="<?php echo htmlspecialchars($campaign['reply_to'] ?? ''); ?>">
          </div>
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Lista de Destinatarios *</label>
            <select name="list_id" class="form-select bg-black text-white border-white-10 p-2 rounded-2" required>
              <option value="">Seleccione una lista...</option>
              <?php if(!empty($lists)): foreach($lists as $lst): ?>
                <option value="<?php echo $lst['id']; ?>" <?php echo ($campaign['list_id'] == $lst['id']) ? 'selected' : ''; ?>>
                  <?php echo htmlspecialchars($lst['name']); ?>
                </option>
              <?php endforeach; endif; ?>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Plantilla HTML *</label>
            <select name="template_id" class="form-select bg-black text-white border-white-10 p-2 rounded-2" required>
              <option value="">Seleccione una plantilla...</option>
              <?php if(!empty($templates)): foreach($templates as $tpl): ?>
                <option value="<?php echo $tpl['id']; ?>" <?php echo ($campaign['template_id'] == $tpl['id']) ? 'selected' : ''; ?>>
                  <?php echo htmlspecialchars($tpl['name']); ?>
                </option>
              <?php endforeach; endif; ?>
            </select>
          </div>

          <!-- SEGMENTACIÓN DE AUDIENCIA -->
          <div class="col-12 mt-4">
            <div class="card bg-black border-white-10 p-3 rounded-3 text-start">
                <h6 class="text-white fw-bold mb-3 d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-primary fs-5">filter_alt</span> Segmentación de Audiencia (Opcional)
                </h6>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label text-white-50 x-small fw-bold uppercase">Filtrar por País</label>
                        <select name="segment_country" class="form-select bg-black text-white border-white-10 p-2 rounded-2">
                            <option value="">Todos los países...</option>
                            <?php foreach($countries as $c): ?>
                                <option value="<?php echo htmlspecialchars($c); ?>" <?php echo (isset($filters['country']) && $filters['country'] === $c) ? 'selected' : ''; ?>>
                                    <?php echo htmlspecialchars($c); ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-white-50 x-small fw-bold uppercase">Filtrar por Industria</label>
                        <select name="segment_industry" class="form-select bg-black text-white border-white-10 p-2 rounded-2">
                            <option value="">Todas las industrias...</option>
                            <?php foreach($industries as $ind): ?>
                                <option value="<?php echo htmlspecialchars($ind); ?>" <?php echo (isset($filters['industry']) && $filters['industry'] === $ind) ? 'selected' : ''; ?>>
                                    <?php echo htmlspecialchars($ind); ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-white-50 x-small fw-bold uppercase">Filtrar por Tag / Etiqueta</label>
                        <input type="text" name="segment_tags" class="form-control bg-black text-white border-white-10 p-2 rounded-2" 
                               placeholder="Ej: cliente, vip" value="<?php echo htmlspecialchars($filters['tags'] ?? ''); ?>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-white-50 x-small fw-bold uppercase">Comportamiento del Receptor</label>
                        <select name="segment_behavior_type" id="edit_behavior_type" class="form-select bg-black text-white border-white-10 p-2 rounded-2">
                            <option value="">Cualquier comportamiento...</option>
                            <option value="opened" <?php echo (isset($behavior['type']) && $behavior['type'] === 'opened') ? 'selected' : ''; ?>>Abrió la campaña...</option>
                            <option value="clicked" <?php echo (isset($behavior['type']) && $behavior['type'] === 'clicked') ? 'selected' : ''; ?>>Hizo clic en la campaña...</option>
                            <option value="inactive" <?php echo (isset($behavior['type']) && $behavior['type'] === 'inactive') ? 'selected' : ''; ?>>Inactivo (sin abrir/clic) durante...</option>
                        </select>
                    </div>
                    <div class="col-md-4" id="edit_behavior_campaign_col" style="display:none;">
                        <label class="form-label text-white-50 x-small fw-bold uppercase">Campaña de Referencia</label>
                        <select name="segment_behavior_campaign_id" class="form-select bg-black text-white border-white-10 p-2 rounded-2">
                            <option value="">Seleccione campaña...</option>
                            <?php foreach($pastCampaigns as $pc): ?>
                                <option value="<?php echo $pc['id']; ?>" <?php echo (isset($behavior['campaign_id']) && $behavior['campaign_id'] == $pc['id']) ? 'selected' : ''; ?>>
                                    <?php echo htmlspecialchars($pc['name']); ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="col-md-4" id="edit_behavior_days_col" style="display:none;">
                        <label class="form-label text-white-50 x-small fw-bold uppercase">Días de Inactividad</label>
                        <input type="number" name="segment_behavior_days" class="form-control bg-black text-white border-white-10 p-2 rounded-2" 
                               placeholder="Ej: 30" min="1" value="<?php echo htmlspecialchars($behavior['days'] ?? ''); ?>">
                    </div>
                </div>
            </div>
          </div>

          <!-- GOOGLE ANALYTICS UTMS -->
          <div class="col-12 mt-3">
            <div class="card bg-black border-white-10 p-3 rounded-3 text-start">
                <div class="form-check form-switch mb-3">
                    <input class="form-check-input" type="checkbox" name="utm_enabled" id="edit_utm_enabled" value="1" <?php echo $utmEnabled ? 'checked' : ''; ?>>
                    <label class="form-check-label text-white fw-bold d-flex align-items-center gap-2" for="edit_utm_enabled">
                        <span class="material-symbols-outlined text-success fs-5">link</span> Habilitar Parámetros Google Analytics UTM
                    </label>
                </div>
                <div class="row g-3" id="edit_utm_fields_row" style="display:none;">
                    <div class="col-md-4">
                        <label class="form-label text-white-50 x-small fw-bold uppercase">UTM Source (Fuente) *</label>
                        <input type="text" name="utm_source" id="edit_utm_source" class="form-control bg-black text-white border-white-10 p-2 rounded-2" value="<?php echo htmlspecialchars($utm['source'] ?? 'email'); ?>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-white-50 x-small fw-bold uppercase">UTM Medium (Medio) *</label>
                        <input type="text" name="utm_medium" id="edit_utm_medium" class="form-control bg-black text-white border-white-10 p-2 rounded-2" value="<?php echo htmlspecialchars($utm['medium'] ?? 'email'); ?>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-white-50 x-small fw-bold uppercase">UTM Campaign (Campaña)</label>
                        <input type="text" name="utm_campaign" id="edit_utm_campaign" class="form-control bg-black text-white border-white-10 p-2 rounded-2" placeholder="Opcional" value="<?php echo htmlspecialchars($utm['campaign'] ?? ''); ?>">
                    </div>
                </div>
            </div>
          </div>

          <script>
          document.addEventListener('DOMContentLoaded', function() {
              const behaviorType = document.getElementById('edit_behavior_type');
              const campaignCol = document.getElementById('edit_behavior_campaign_col');
              const daysCol = document.getElementById('edit_behavior_days_col');
              
              function toggleBehaviorCols() {
                  if (!behaviorType) return;
                  const val = behaviorType.value;
                  if (val === 'opened' || val === 'clicked') {
                      campaignCol.style.display = '';
                      daysCol.style.display = 'none';
                  } else if (val === 'inactive') {
                      campaignCol.style.display = 'none';
                      daysCol.style.display = '';
                  } else {
                      campaignCol.style.display = 'none';
                      daysCol.style.display = 'none';
                  }
              }
              
              if (behaviorType) {
                  behaviorType.addEventListener('change', toggleBehaviorCols);
                  toggleBehaviorCols();
              }

              // UTM toggling
              const utmSwitch = document.getElementById('edit_utm_enabled');
              const utmFields = document.getElementById('edit_utm_fields_row');
              
              function toggleUtmFields() {
                  if (utmSwitch && utmSwitch.checked) {
                      utmFields.style.display = '';
                  } else if (utmFields) {
                      utmFields.style.display = 'none';
                  }
              }
              
              if (utmSwitch) {
                  utmSwitch.addEventListener('change', toggleUtmFields);
                  toggleUtmFields();
              }
          });
          </script>
        </div>
      </div>
      <div class="modal-footer border-white-10">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
        <button type="submit" class="btn fw-bold px-4 text-white" style="background:linear-gradient(135deg,#6366f1,#D4AF37);border:none;">Guardar Cambios</button>
      </div>
    </form>
  </div>
</div>

<!-- ==================== MODAL PROGRAMAR CAMPAÑA ==================== -->
<div class="modal fade" id="scheduleCampaignModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <form action="<?php echo url("admin/marketing/launchCampaign/{$campaign['id']}"); ?>" method="POST" class="modal-content bg-midnight border-white-10 glass-morphism">
      <?php echo csrf_field(); ?>
      <div class="modal-header border-white-10">
        <h5 class="modal-title text-white d-flex align-items-center gap-2">
          <span class="material-symbols-outlined text-warning">calendar_month</span> Programar Envío de Campaña
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body text-start">
        <div class="mb-3">
          <label class="form-label text-white-50 x-small fw-bold uppercase">Fecha y Hora de Lanzamiento *</label>
          <input type="datetime-local" name="scheduled_at" class="form-control bg-black text-white border-white-10 p-3 rounded-3" required min="<?php echo date('Y-m-d\TH:i'); ?>">
          <div class="form-text text-white-50 small mt-2">La campaña se colocará en cola y comenzará a enviarse automáticamente a partir de la fecha seleccionada.</div>
        </div>
      </div>
      <div class="modal-footer border-white-10">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
        <button type="submit" class="btn fw-bold px-4 text-white" style="background:linear-gradient(135deg,#6366f1,#D4AF37);border:none;">Programar Envío</button>
      </div>
    </form>
  </div>
</div>

<!-- ==================== MODAL ENVÍO DE PRUEBA ==================== -->
<div class="modal fade" id="testSendModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <form action="<?php echo url("admin/marketing/testSend/{$campaign['id']}"); ?>" method="POST" class="modal-content bg-midnight border-white-10 glass-morphism">
      <?php echo csrf_field(); ?>
      <div class="modal-header border-white-10">
        <h5 class="modal-title text-white d-flex align-items-center gap-2">
          <span class="material-symbols-outlined text-secondary">mail</span> Enviar Correo de Prueba
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body text-start">
        <div class="mb-3">
          <label class="form-label text-white-50 x-small fw-bold uppercase">Correo de Destino *</label>
          <input type="email" name="email" class="form-control bg-black text-white border-white-10 p-3 rounded-3" required 
                 value="<?php echo htmlspecialchars(\Core\Auth::user()['email'] ?? ''); ?>" placeholder="ejemplo@correo.com">
          <div class="form-text text-white-50 small mt-2">Se enviará el correo renderizado con datos simulados de un cliente de prueba, incluyendo un banner informativo al final.</div>
        </div>
      </div>
      <div class="modal-footer border-white-10">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
        <button type="submit" class="btn fw-bold px-4 text-white" style="background:linear-gradient(135deg,#30C5FF,#D4AF37);border:none;">Enviar Prueba</button>
      </div>
    </form>
  </div>
</div>
