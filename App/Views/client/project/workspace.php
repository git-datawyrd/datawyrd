<div class="row g-4 mb-5">
    <div class="col-12">
        <h2 class="text-white fw-black mb-1">Centro de Entregables 📂</h2>
        <p class="text-white-50">Accede a todos los resultados de tus proyectos de ingeniería de datos.</p>
    </div>

    <?php if (empty($services)): ?>
        <div class="col-12">
            <div class="glass-morphism p-5 text-center rounded-5">
                <span class="material-symbols-outlined display-1 text-white-10 mb-3">folder_open</span>
                <h4 class="text-white fw-bold">No hay servicios activos aún</h4>
                <p class="text-white-50">Tus entregables aparecerán aquí una vez que tus servicios sean activados.</p>
                <a href="<?php echo url('dashboard'); ?>" class="btn btn-primary rounded-pill px-4 mt-2">Ir al Dashboard</a>
            </div>
        </div>
    <?php else: ?>
        <?php foreach ($services as $service): ?>
            <div class="col-12">
                <div class="glass-morphism rounded-5 border-white-10 overflow-hidden mb-4">
                    <div
                        class="p-4 bg-white-5 d-flex align-items-start justify-content-between border-bottom border-white-10 flex-wrap gap-3">
                        <div>
                            <span class="badge bg-gold text-black x-small fw-black uppercase tracking-widest mb-2">
                                <?php echo $service['plan_name']; ?>
                            </span>
                            <h4 class="text-white fw-bold mb-0">
                                <?php echo $service['name']; ?>
                            </h4>
                        </div>
                        <div class="text-end">
                            <div class="d-flex align-items-center gap-3 mb-1">
                                <div class="text-end">
                                    <span class="text-white-50 x-small d-block">Progreso del Proyecto</span>
                                    <span class="text-white small fw-bold"><?php echo $service['progress_percent']; ?>%</span>
                                </div>
                                <div class="progress bg-white-5" style="width: 100px; height: 8px;">
                                    <div class="progress-bar bg-accent" role="progressbar"
                                        style="width: <?php echo $service['progress_percent']; ?>%"
                                        aria-valuenow="<?php echo $service['progress_percent']; ?>" aria-valuemin="0"
                                        aria-valuemax="100"></div>
                                </div>
                            </div>
                            <span class="text-white-50 x-small d-block mt-2">Activado el:
                                <?php echo date('d M, Y', strtotime($service['start_date'])); ?></span>
                        </div>
                    </div>

                    <?php
                    $invoiceTotal = (float) $service['invoice_total'];
                    $invoicePaid = (float) $service['invoice_paid'];
                    $invoicePending = (float) $service['invoice_pending'];
                    $payPercent = $invoiceTotal > 0 ? round(($invoicePaid / $invoiceTotal) * 100) : 100;
                    $invoiceStatus = $service['invoice_status'];
                    ?>
                    <?php if ($invoiceStatus !== 'paid'): ?>
                        <div class="px-4 pt-3 pb-0">
                            <div class="rounded-4 p-3 border border-white-10 bg-white-5">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span
                                        class="x-small uppercase tracking-widest text-white-50 fw-bold d-flex align-items-center gap-1">
                                        <span class="material-symbols-outlined fs-6">payments</span>
                                        Estado de Pago
                                    </span>
                                    <a href="<?php echo url('invoice/show/' . $service['invoice_id_ref']); ?>"
                                        class="x-small text-primary text-decoration-none hover-gold transition-all">
                                        Ver factura <span class="material-symbols-outlined fs-6 align-middle">arrow_forward</span>
                                    </a>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="x-small text-white-50">Pagado: <span
                                            class="text-success fw-bold">$<?php echo number_format($invoicePaid, 2); ?></span></span>
                                    <span class="x-small text-white-50">Pendiente: <span
                                            class="text-warning fw-bold">$<?php echo number_format($invoicePending, 2); ?></span></span>
                                </div>
                                <div class="progress bg-white-5 rounded-pill" style="height: 6px;">
                                    <div class="progress-bar bg-success" role="progressbar"
                                        style="width: <?php echo $payPercent; ?>%" aria-valuenow="<?php echo $payPercent; ?>"
                                        aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <div class="d-flex justify-content-between mt-2">
                                    <span class="x-small text-white-50">Total:
                                        $<?php echo number_format($invoiceTotal, 2); ?></span>
                                    <span class="x-small text-white-50"><?php echo $payPercent; ?>% abonado</span>
                                </div>
                            </div>
                        </div>
                    <?php else: ?>
                        <div class="px-4 pt-3 pb-0">
                            <div
                                class="rounded-4 p-2 px-3 border border-success border-opacity-25 bg-success bg-opacity-10 d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined text-success fs-5">check_circle</span>
                                <span class="x-small text-success fw-bold">Pago Completo —
                                    $<?php echo number_format($invoiceTotal, 2); ?></span>
                            </div>
                        </div>
                    <?php endif; ?>

                    <div class="p-4">
                        <div class="row g-3">
                            <?php if (isset($deliverables[$service['id']]) && !empty($deliverables[$service['id']])): ?>
                                <?php foreach ($deliverables[$service['id']] as $file): ?>
                                    <div class="col-md-6 col-lg-4">
                                        <div class="p-3 rounded-4 bg-steel border border-white-5 h-100 hover-lift transition-all">
                                            <div class="d-flex align-items-center gap-3 mb-3">
                                                <div class="rounded-3 bg-white-5 p-2 d-flex align-items-center justify-content-center text-accent"
                                                    style="width: 48px; height: 48px;">
                                                    <span class="material-symbols-outlined fs-2">
                                                        <?php
                                                        switch ($file['file_type']) {
                                                            case 'document':
                                                                echo 'description';
                                                                break;
                                                            case 'code':
                                                                echo 'terminal';
                                                                break;
                                                            case 'data':
                                                                echo 'database';
                                                                break;
                                                            case 'image':
                                                                echo 'image';
                                                                break;
                                                            default:
                                                                echo 'draft';
                                                        }
                                                        ?>
                                                    </span>
                                                </div>
                                                <div class="flex-grow-1 overflow-hidden">
                                                    <h6 class="text-white fw-bold mb-0 text-truncate">
                                                        <?php echo $file['title']; ?>
                                                    </h6>
                                                    <span class="text-white-50 x-small">v
                                                        <?php echo $file['version']; ?> |
                                                        <?php echo number_format($file['file_size'] / 1024, 1); ?> KB
                                                    </span>
                                                </div>
                                            </div>
                                            <p class="text-white-50 x-small mb-4 line-clamp-2">
                                                <?php echo $file['description']; ?>
                                            </p>
                                            <a href="<?php echo url('project/download/' . $file['id']); ?>"
                                                class="btn btn-outline-light btn-sm w-100 rounded-pill border-white-10 fw-bold">
                                                <span class="material-symbols-outlined fs-6 align-middle me-1">download</span> Descargar
                                            </a>
                                        </div>
                                    </div>
                                <?php endforeach; ?>
                            <?php else: ?>
                                <div class="col-12 py-4 text-center">
                                    <p class="text-white-50 italic x-small mb-0">El equipo técnico aún está procesando los
                                        entregables finales para este servicio.</p>
                                </div>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    <?php endif; ?>
</div>

<style>
    .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .hover-lift:hover {
        transform: translateY(-5px);
        border-color: rgba(212, 175, 55, 0.4) !important;
        background: rgba(255, 255, 255, 0.05);
    }
</style>