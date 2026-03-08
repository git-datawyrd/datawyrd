<div class="glass-morphism rounded-5 border-white-10 overflow-hidden h-100">
    <div class="p-4 border-bottom border-white-10 d-flex align-items-center justify-content-between bg-white-5">
        <h2 class="text-white h5 fw-black mb-0">Solicitudes Recientes</h2>
        <div class="input-group input-group-sm w-auto">
            <span class="input-group-text bg-midnight border-white-10 text-white-50">
                <span class="material-symbols-outlined fs-6">search</span>
            </span>
            <input type="text" id="adminSearchInput" class="form-control bg-steel border-white-10 text-white"
                placeholder="Filtrar...">
        </div>
    </div>
    <div class="table-responsive">
        <table class="table table-dark table-hover mb-0 align-middle">
            <thead class="bg-deep-black">
                <tr>
                    <th class="p-4 small uppercase tracking-widest text-white-50">Acciones</th>
                    <th class="p-4 small uppercase tracking-widest text-white-50">Ticket</th>
                    <th class="p-4 small uppercase tracking-widest text-white-50">Cliente</th>
                </tr>
            </thead>
            <tbody id="adminTicketsTable">
                <!-- Skeleton Loader Rows (Removed via JS) -->
                <?php for ($i = 0; $i < 5; $i++): ?>
                    <tr class="skeleton-row no-print">
                        <td class="p-4">
                            <div class="skeleton skeleton-text" style="width: 40%"></div>
                            <div class="skeleton skeleton-text" style="width: 80%"></div>
                        </td>
                        <td class="p-4">
                            <div class="skeleton skeleton-text" style="width: 60%"></div>
                        </td>
                        <td class="p-4 text-end">
                            <div class="skeleton skeleton-btn ms-auto"></div>
                        </td>
                    </tr>
                <?php endfor; ?>

                <?php foreach ($tickets as $ticket): ?>
                    <tr class="ticket-row"
                        data-search="<?php echo strtolower($ticket['ticket_number'] . ' ' . $ticket['client_name'] . ' ' . $ticket['subject']); ?>">
                        <td class="p-4">
                            <a href="<?php echo url('ticket/detail/' . $ticket['id']); ?>"
                                class="btn btn-outline-primary btn-sm rounded-3 d-inline-flex align-items-center gap-1 fw-bold">
                                <span class="material-symbols-outlined fs-6">settings</span> Gestionar
                            </a>
                        </td>
                        <td class="p-4">
                            <span class="text-white fw-bold d-block">
                                <?php echo htmlspecialchars($ticket['ticket_number']); ?>
                            </span>
                            <span class="x-small text-white-50">
                                <?php echo htmlspecialchars(substr($ticket['subject'], 0, 30)); ?>...
                            </span>
                        </td>
                        <td class="p-4">
                            <div class="d-flex align-items-center gap-2">
                                <span class="text-white small fw-bold">
                                    <?php echo htmlspecialchars($ticket['client_name']); ?>
                                </span>
                                <?php
                                $score = $ticket['lead_score'] ?? 0;
                                $scoreClass = $score >= 75 ? 'bg-gold text-deep-black' : ($score >= 40 ? 'bg-primary' : 'bg-white-10 text-white-50');
                                ?>
                                <span class="badge <?php echo $scoreClass; ?> rounded-pill x-small px-2 py-1 fw-bold"
                                    style="font-size: 0.65rem;" title="Lead Intelligence Score">
                                    <?php echo $score; ?> pts
                                    <?php if ($score >= 75): ?> 🔥<?php endif; ?>
                                </span>
                            </div>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>