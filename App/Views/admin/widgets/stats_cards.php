<div class="row g-4">
    <!-- Skeleton Loaders -->
    <?php for ($i = 0; $i < 4; $i++): ?>
        <div class="col-6 col-md-3 skeleton-loader no-print">
            <div class="glass-morphism p-4 rounded-4 border-white-10 h-100">
                <div class="skeleton skeleton-text mb-3" style="width: 50%"></div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="skeleton skeleton-title mb-0" style="width: 40%"></div>
                    <div class="skeleton skeleton-text mb-0" style="width: 20%"></div>
                </div>
            </div>
        </div>
    <?php endfor; ?>

    <div class="col-6 col-md-3">
        <div class="glass-morphism p-4 rounded-4 border-white-10 h-100 position-relative overflow-hidden kpi-card">
            <div class="position-absolute top-0 end-0 p-3 opacity-10">
                <span class="material-symbols-outlined display-4 text-white">confirmation_number</span>
            </div>
            <p class="text-white-50 x-small fw-bold uppercase tracking-widest mb-1">Total Tickets</p>
            <div class="d-flex align-items-center justify-content-between">
                <h3 class="text-white fw-black mb-0 display-6 kpi-value">
                    <?php echo $stats['total_tickets']; ?>
                </h3>
                <span
                    class="text-white-50 x-small fw-bold border border-white-10 rounded-pill px-2 py-1 bg-white-5"><?php echo $stats['closed_tickets_pct']; ?>%
                    Cerrados</span>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-3">
        <div class="glass-morphism p-4 rounded-4 border-white-10 h-100 position-relative overflow-hidden kpi-card">
            <div class="position-absolute top-0 end-0 p-3 opacity-10">
                <span class="material-symbols-outlined display-4 text-white">pending</span>
            </div>
            <p class="text-white-50 x-small fw-bold uppercase tracking-widest mb-1">Pendientes</p>
            <div class="d-flex align-items-center justify-content-between">
                <h3 class="text-white fw-black mb-0 display-6 kpi-value">
                    <?php echo $stats['open_tickets']; ?>
                </h3>
                <span class="text-warning small fw-bold">Crit.</span>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-3">
        <div class="glass-morphism p-4 rounded-4 border-white-10 h-100 position-relative overflow-hidden kpi-card">
            <div class="position-absolute top-0 end-0 p-3 opacity-10">
                <span class="material-symbols-outlined display-4 text-white">hub</span>
            </div>
            <p class="text-white-50 x-small fw-bold uppercase tracking-widest mb-1">Servicios Activos</p>
            <div class="d-flex align-items-center justify-content-between">
                <h3 class="text-white fw-black mb-0 display-6 kpi-value">
                    <?php echo $stats['active_services']; ?>
                </h3>
                <span class="text-success x-small fw-bold border border-success-subtle rounded-pill px-2 py-1 bg-success bg-opacity-10"><?php echo $stats['paid_invoices_pct']; ?>% Pagado</span>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-3">
        <div class="glass-morphism p-4 rounded-4 border-white-10 h-100 position-relative overflow-hidden kpi-card">
            <div class="position-absolute top-0 end-0 p-3 opacity-10">
                <span class="material-symbols-outlined display-4 text-white">person_add</span>
            </div>
            <p class="text-white-50 x-small fw-bold uppercase tracking-widest mb-1">Total Usuarios</p>
            <div class="d-flex align-items-center justify-content-between">
                <h3 class="text-white fw-black mb-0 display-6 kpi-value">
                    <?php echo $stats['total_users']; ?>
                </h3>
                <div class="d-flex gap-1 x-small fw-bold">
                    <span class="text-white-50" title="Clientes"><span class="material-symbols-outlined fs-6 align-middle" style="font-size: 12px !important;">group</span> <?php echo $stats['users_breakdown']['client'] ?? 0; ?></span>
                    <span class="text-white-50" title="Staff"><span class="material-symbols-outlined fs-6 align-middle" style="font-size: 12px !important;">support_agent</span> <?php echo $stats['users_breakdown']['staff'] ?? 0; ?></span>
                    <span class="text-primary" title="Admins"><span class="material-symbols-outlined fs-6 align-middle" style="font-size: 12px !important;">shield_person</span> <?php echo ($stats['users_breakdown']['admin'] ?? 0) + ($stats['users_breakdown']['super_admin'] ?? 0); ?></span>
                </div>
            </div>
        </div>
    </div>
</div>