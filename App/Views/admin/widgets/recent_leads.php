<div class="glass-morphism rounded-5 border-white-10 overflow-hidden h-100">
    <div class="p-4 border-bottom border-white-10 bg-white-5">
        <h2 class="text-white h5 fw-black mb-0">Lead Intelligence 🧠</h2>
    </div>
    <div class="p-4">
        <?php foreach ($recent_leads as $lead): ?>
            <div class="mb-4 pb-4 border-bottom border-white-5 last-child-no-border">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <div>
                        <h4 class="text-white small fw-bold mb-0">
                            <?php echo htmlspecialchars($lead['name']); ?>
                        </h4>
                        <p class="text-white-50 x-small mb-0">
                            <?php echo htmlspecialchars($lead['company'] ?: $lead['email']); ?>
                        </p>
                    </div>
                    <span
                        class="badge <?php echo $lead['score'] > 60 ? 'bg-success' : ($lead['score'] > 30 ? 'bg-warning' : 'bg-danger'); ?> rounded-pill">
                        <?php echo (int)$lead['score']; ?> pts
                    </span>
                </div>
                <div class="progress bg-white-5" style="height: 4px;">
                    <div class="progress-bar <?php echo $lead['score'] > 60 ? 'bg-success' : ($lead['score'] > 30 ? 'bg-warning' : 'bg-danger'); ?>"
                        role="progressbar" style="width: <?php echo $lead['score']; ?>%"></div>
                </div>
                <div class="d-flex justify-content-between mt-2">
                    <span class="text-white-50 x-small">
                        <?php echo $lead['ticket_count']; ?> Solicitudes
                    </span>
                    <a href="<?php echo url('admin/user/detail/' . $lead['id']); ?>"
                        class="text-accent x-small text-decoration-none fw-bold">Ver Perfil</a>
                </div>
            </div>
        <?php endforeach; ?>

        <?php if (empty($recent_leads)): ?>
            <div class="text-center py-4">
                <span class="material-symbols-outlined display-4 text-white-10 mb-2">person_search</span>
                <p class="text-white-50 small">No hay prospectos recientes.</p>
            </div>
        <?php endif; ?>
    </div>
</div>