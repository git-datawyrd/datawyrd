<div class="row g-4">
    <div class="col-12 d-flex align-items-center justify-content-between mb-2">
        <div>
            <h2 class="text-white fw-black mb-1">Mis Solicitudes 🎫</h2>
            <p class="text-white-50">Gestiona y consulta el estado de tus servicios contratados.</p>
        </div>
        <a href="<?php echo url('ticket/request'); ?>"
            class="btn btn-primary btn-sm px-4 fw-bold rounded-pill shadow-gold">Nueva Solicitud</a>
    </div>

    <!-- Tickets Table -->
    <div class="col-12">
        <div class="glass-morphism rounded-5 border-white-10 overflow-hidden shadow-2xl">
            <div class="p-4 border-bottom border-white-10 bg-white-5 d-flex align-items-center justify-content-between">
                <h5 class="text-white h6 mb-0 fw-bold uppercase tracking-widest">Historial de Tickets</h5>
            </div>
            <div class="table-responsive">
                <table class="table table-dark table-hover mb-0 align-middle">
                    <thead class="bg-deep-black">
                        <tr class="x-small uppercase text-white-50 tracking-widest">
                            <th class="p-4 border-0">Nº Ticket</th>
                            <th class="p-4 border-0">Asunto</th>
                            <th class="p-4 border-0">Plan</th>
                            <th class="p-4 border-0">Estado</th>
                            <th class="p-4 border-0">Fecha</th>
                            <th class="p-4 border-0 text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($tickets as $t): ?>
                            <tr>
                                <td class="p-4">
                                    <span class="fw-black text-primary font-monospace">
                                        <?php echo $t['ticket_number']; ?>
                                    </span>
                                </td>
                                <td class="p-4">
                                    <span class="text-white small fw-bold">
                                        <?php echo $t['subject']; ?>
                                    </span>
                                </td>
                                <td class="p-4">
                                    <span class="x-small text-white-50 uppercase">
                                        <?php echo $t['plan_name']; ?>
                                    </span>
                                </td>
                                <td class="p-4">
                                    <?php
                                    $statusClassClient = [
                                        'open' => 'bg-danger-subtle',
                                        'in_analysis' => 'bg-warning-subtle',
                                        'budget_sent' => 'bg-info-subtle',
                                        'budget_approved' => 'bg-success-subtle',
                                        'budget_rejected' => 'bg-danger-subtle',
                                        'invoiced' => 'bg-info-subtle',
                                        'payment_pending' => 'bg-warning-subtle',
                                        'active' => 'bg-success-subtle',
                                        'resolved' => 'bg-success-subtle',
                                        'closed' => 'bg-secondary-subtle'
                                    ];
                                    $cls = $statusClassClient[$t['status']] ?? 'bg-white-10';
                                    ?>
                                    <span
                                        class="badge <?php echo $cls; ?> x-small uppercase fw-bold tracking-tighter px-2 py-1">
                                        <?php echo translateStatus($t['status']); ?>
                                    </span>
                                </td>
                                <td class="p-4">
                                    <span class="text-white-50 x-small">
                                        <?php echo date('d/m/Y H:i', strtotime($t['created_at'])); ?>
                                    </span>
                                </td>
                                <td class="p-4 text-end">
                                    <a href="<?php echo url('ticket/detail/' . $t['id']); ?>"
                                        class="btn btn-outline-white btn-sm rounded-pill px-3 border-white-10 x-small uppercase fw-bold">
                                        Ver Detalles
                                    </a>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                        <?php if (empty($tickets)): ?>
                            <tr>
                                <td colspan="6" class="p-5 text-center text-white-50 italic">
                                    Aún no tienes tickets registrados. <a href="<?php echo url('ticket/request'); ?>"
                                        class="text-primary decoration-none">¡Crea el primero aquí!</a>
                                </td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
            <div class="p-4 bg-white-5 border-top border-white-10 text-center">
                <span class="text-white-50 x-small uppercase tracking-widest">
                    Total:
                    <?php echo count($tickets); ?> tickets
                </span>
            </div>
        </div>
    </div>
</div>