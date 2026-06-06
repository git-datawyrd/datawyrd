<div class="mb-4 d-flex justify-content-between align-items-center">
    <div>
        <a href="<?php echo url('admin/marketing/campaigns'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
            <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Campañas
        </a>
        <h1 class="h3 text-white fw-bold mb-0"><?php echo htmlspecialchars($campaign['name']); ?></h1>
    </div>
    <div>
        <?php if($campaign['status'] === 'draft'): ?>
            <form action="<?php echo url("admin/marketing/campaigns/{$campaign['id']}/launch"); ?>" method="POST" class="d-inline">
                <?php echo csrf_field(); ?>
                <button type="submit" class="btn btn-success d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined">send</span> Lanzar Ahora
                </button>
            </form>
        <?php endif; ?>
    </div>
</div>

<div class="row g-4">
    <div class="col-md-8">
        <div class="card glass-morphism border-0 mb-4">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                <h6 class="text-white mb-0 fw-bold">Detalles de la Campaña</h6>
            </div>
            <div class="card-body">
                <div class="row g-4">
                    <div class="col-sm-6">
                        <label class="text-white-50 x-small fw-bold uppercase tracking-widest d-block mb-1">Estado</label>
                        <?php if($campaign['status'] === 'draft'): ?>
                            <span class="badge bg-secondary">Borrador</span>
                        <?php elseif($campaign['status'] === 'scheduled'): ?>
                            <span class="badge bg-info">Programada</span>
                        <?php elseif($campaign['status'] === 'sending'): ?>
                            <span class="badge bg-warning text-dark">Enviando</span>
                        <?php elseif($campaign['status'] === 'sent'): ?>
                            <span class="badge bg-success">Enviada</span>
                        <?php else: ?>
                            <span class="badge bg-secondary"><?php echo htmlspecialchars($campaign['status']); ?></span>
                        <?php endif; ?>
                    </div>
                    <div class="col-sm-6">
                        <label class="text-white-50 x-small fw-bold uppercase tracking-widest d-block mb-1">Asunto</label>
                        <span class="text-white fw-bold"><?php echo htmlspecialchars($campaign['subject']); ?></span>
                    </div>
                    <div class="col-sm-6">
                        <label class="text-white-50 x-small fw-bold uppercase tracking-widest d-block mb-1">Remitente</label>
                        <span class="text-white"><?php echo htmlspecialchars($campaign['from_name']); ?> &lt;<?php echo htmlspecialchars($campaign['from_email']); ?>&gt;</span>
                    </div>
                    <div class="col-sm-6">
                        <label class="text-white-50 x-small fw-bold uppercase tracking-widest d-block mb-1">Programación</label>
                        <span class="text-white"><?php echo $campaign['scheduled_at'] ? date('d M, Y H:i', strtotime($campaign['scheduled_at'])) : 'Inmediato'; ?></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="card glass-morphism border-0 mb-4 h-100">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                <h6 class="text-white mb-0 fw-bold">Rendimiento Básico</h6>
            </div>
            <div class="card-body">
                <?php if($campaign['status'] === 'sent' || $campaign['status'] === 'sending'): ?>
                <div class="d-flex flex-column gap-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-white-50 small">Enviados</span>
                        <span class="text-white fw-bold"><?php echo $metrics['total_sent'] ?? 0; ?></span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-white-50 small">Aperturas Únicas</span>
                        <span class="text-white fw-bold"><?php echo $metrics['unique_opens'] ?? 0; ?></span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-white-50 small">Clics Únicos</span>
                        <span class="text-white fw-bold"><?php echo $metrics['unique_clicks'] ?? 0; ?></span>
                    </div>
                    <hr class="border-white-10 my-1">
                    <div class="text-center mt-2">
                        <a href="<?php echo url("admin/marketing/campaigns/{$campaign['id']}/analytics"); ?>" class="btn btn-outline-primary btn-sm w-100">Ver Analytics Completos</a>
                    </div>
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
