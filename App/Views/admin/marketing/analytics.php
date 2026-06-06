<div class="mb-4">
    <a href="<?php echo url('admin/marketing/campaigns'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
        <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Campañas
    </a>
    <h1 class="h3 text-white fw-bold mb-0">Analytics: <?php echo htmlspecialchars($campaign['name']); ?></h1>
</div>

<div class="row g-4 mb-4">
    <div class="col-md-3">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-body">
                <h6 class="text-white-50 x-small fw-bold uppercase tracking-widest mb-2">Tasa de Apertura</h6>
                <div class="d-flex align-items-end gap-2">
                    <h3 class="text-primary fw-bold mb-0"><?php echo $metrics['open_rate'] ?? 0; ?>%</h3>
                    <span class="text-white-50 small mb-1">(<?php echo $metrics['unique_opens'] ?? 0; ?> únicos)</span>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-body">
                <h6 class="text-white-50 x-small fw-bold uppercase tracking-widest mb-2">Tasa de Clics (CTR)</h6>
                <div class="d-flex align-items-end gap-2">
                    <h3 class="text-success fw-bold mb-0"><?php echo $metrics['click_rate'] ?? 0; ?>%</h3>
                    <span class="text-white-50 small mb-1">(<?php echo $metrics['unique_clicks'] ?? 0; ?> únicos)</span>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-body">
                <h6 class="text-white-50 x-small fw-bold uppercase tracking-widest mb-2">Tasa de Rebote</h6>
                <div class="d-flex align-items-end gap-2">
                    <h3 class="text-danger fw-bold mb-0"><?php echo $metrics['bounce_rate'] ?? 0; ?>%</h3>
                    <span class="text-white-50 small mb-1">(<?php echo $metrics['bounces'] ?? 0; ?> rebotados)</span>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-body">
                <h6 class="text-white-50 x-small fw-bold uppercase tracking-widest mb-2">Total Enviados</h6>
                <div class="d-flex align-items-end gap-2">
                    <h3 class="text-white fw-bold mb-0"><?php echo $metrics['total_sent'] ?? 0; ?></h3>
                </div>
            </div>
        </div>
    </div>
</div>
