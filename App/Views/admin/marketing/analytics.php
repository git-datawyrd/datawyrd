<?php
$bounceRate    = (float)($metrics['bounce_rate']    ?? 0);
$complaintRate = ($metrics['total_sent'] ?? 0) > 0
    ? round(($metrics['complaints'] ?? 0) / $metrics['total_sent'] * 100, 2)
    : 0;
$openRate      = (float)($metrics['open_rate']      ?? 0);
$clickRate     = (float)($metrics['click_rate']     ?? 0);
$totalSent     = (int)  ($metrics['total_sent']     ?? 0);
$delivered     = (int)  ($metrics['delivered']      ?? $totalSent);
$unsubscribes  = (int)  ($metrics['unsubscribes']   ?? 0);
$complaints    = (int)  ($metrics['complaints']     ?? 0);
$bounces       = (int)  ($metrics['bounces']        ?? 0);

// Alertas de entregabilidad
$criticalBounce    = $bounceRate    >= 3.0;
$criticalComplaint = $complaintRate >= 0.1;
$warningBounce     = !$criticalBounce    && $bounceRate    >= 2.0;
$warningComplaint  = !$criticalComplaint && $complaintRate >= 0.05;
?>

<?php if ($criticalBounce || $criticalComplaint): ?>
<div class="alert d-flex align-items-start gap-3 border-0 mb-4"
     style="background:rgba(239,68,68,.12);border-left:4px solid #ef4444 !important;border-radius:8px;">
    <span class="material-symbols-outlined text-danger mt-1">warning</span>
    <div>
        <strong class="text-danger">Alerta crítica de entregabilidad</strong>
        <p class="mb-0 text-white-50 small mt-1">
            <?php if ($criticalBounce): ?>
                Tasa de rebote <strong class="text-danger"><?php echo $bounceRate; ?>%</strong> supera el umbral del 3%.
            <?php endif; ?>
            <?php if ($criticalComplaint): ?>
                Tasa de quejas <strong class="text-danger"><?php echo $complaintRate; ?>%</strong> supera el umbral del 0.1%.
            <?php endif; ?>
            Se recomienda pausar la campaña y revisar la lista de contactos.
        </p>
    </div>
</div>
<?php elseif ($warningBounce || $warningComplaint): ?>
<div class="alert d-flex align-items-start gap-3 border-0 mb-4"
     style="background:rgba(245,158,11,.10);border-left:4px solid #f59e0b !important;border-radius:8px;">
    <span class="material-symbols-outlined text-warning mt-1">info</span>
    <div>
        <strong class="text-warning">Advertencia de entregabilidad</strong>
        <p class="mb-0 text-white-50 small mt-1">
            <?php if ($warningBounce): ?>Tasa de rebote <strong><?php echo $bounceRate; ?>%</strong> se acerca al umbral del 3%.<?php endif; ?>
            <?php if ($warningComplaint): ?>Tasa de quejas <strong><?php echo $complaintRate; ?>%</strong> se acerca al umbral del 0.1%.<?php endif; ?>
        </p>
    </div>
</div>
<?php endif; ?>

<!-- HEADER -->
<div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
    <div>
        <a href="<?php echo url('admin/marketing/campaigns'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
            <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Campañas
        </a>
        <h1 class="h3 text-white fw-bold mb-1">Analytics: <?php echo htmlspecialchars($campaign['name']); ?></h1>
        <div class="d-flex align-items-center gap-3">
            <?php
            $statusColors = [
                'sent'      => 'bg-success',
                'sending'   => 'bg-primary',
                'scheduled' => 'bg-warning text-dark',
                'draft'     => 'bg-secondary',
                'paused'    => 'bg-danger',
            ];
            $sc = $statusColors[$campaign['status'] ?? ''] ?? 'bg-secondary';
            ?>
            <span class="badge <?php echo $sc; ?>"><?php echo ucfirst($campaign['status'] ?? ''); ?></span>
            <?php if (!empty($campaign['sent_at'])): ?>
            <span class="text-white-50 small">Enviado: <?php echo date('d M Y H:i', strtotime($campaign['sent_at'])); ?></span>
            <?php endif; ?>
        </div>
    </div>
    <div class="d-flex gap-2 flex-wrap">
        <a href="<?php echo url("admin/marketing/exportInteractions/{$campaign['id']}"); ?>"
           class="btn btn-outline-light d-flex align-items-center gap-2">
            <span class="material-symbols-outlined fs-6">download</span> Exportar CSV
        </a>
        <button onclick="window.print()" class="btn btn-outline-light d-flex align-items-center gap-2">
            <span class="material-symbols-outlined fs-6">print</span> Imprimir
        </button>
        <?php if (in_array($campaign['status'] ?? '', ['sending','scheduled'])): ?>
        <a href="<?php echo url("admin/marketing/pauseCampaign/{$campaign['id']}"); ?>"
           class="btn btn-danger d-flex align-items-center gap-2"
           onclick="return confirm('¿Pausar esta campaña?')">
            <span class="material-symbols-outlined fs-6">pause</span> Pausar
        </a>
        <?php endif; ?>
    </div>
</div>

<!-- KPI CARDS -->
<div class="row g-3 mb-4">
    <?php
    $kpis = [
        ['label'=>'Total Enviados',    'value'=>number_format($totalSent),          'icon'=>'send',          'color'=>'#6366f1', 'sub'=>null],
        ['label'=>'Tasa de Apertura',  'value'=>$openRate.'%',                      'icon'=>'mail_open',     'color'=>'#06b6d4', 'sub'=>number_format($metrics['unique_opens']??0).' únicos'],
        ['label'=>'Tasa de Clics',     'value'=>$clickRate.'%',                     'icon'=>'ads_click',     'color'=>'#10b981', 'sub'=>number_format($metrics['unique_clicks']??0).' únicos'],
        ['label'=>'Tasa de Rebote',    'value'=>$bounceRate.'%',                    'icon'=>'error_outline', 'color'=>$criticalBounce?'#ef4444':'#f59e0b', 'sub'=>number_format($bounces).' rebotes'],
        ['label'=>'Bajas',             'value'=>number_format($unsubscribes),        'icon'=>'person_remove', 'color'=>'#8b5cf6', 'sub'=>null],
        ['label'=>'Conversiones',      'value'=>number_format($metrics['conversions']??0),'icon'=>'trending_up', 'color'=>'#f59e0b', 'sub'=>null],
    ];
    foreach ($kpis as $k):
    ?>
    <div class="col-lg-2 col-md-4 col-6">
        <div class="card glass-morphism border-0 h-100 position-relative overflow-hidden">
            <div style="position:absolute;top:-10px;right:-10px;width:60px;height:60px;border-radius:50%;background:<?php echo $k['color']; ?>;opacity:.12;"></div>
            <div class="card-body p-3">
                <span class="material-symbols-outlined mb-2" style="color:<?php echo $k['color']; ?>;font-size:22px;"><?php echo $k['icon']; ?></span>
                <h4 class="fw-bold mb-0" style="color:<?php echo $k['color']; ?>;"><?php echo $k['value']; ?></h4>
                <p class="text-white-50 x-small fw-bold uppercase mb-0 mt-1"><?php echo $k['label']; ?></p>
                <?php if ($k['sub']): ?><p class="text-white-50 x-small mb-0"><?php echo $k['sub']; ?></p><?php endif; ?>
            </div>
        </div>
    </div>
    <?php endforeach; ?>
</div>

<!-- GRÁFICOS -->
<div class="row g-4 mb-4">
    <!-- Donut: distribución de estados -->
    <div class="col-lg-4">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3 px-4">
                <h6 class="text-white mb-0 fw-bold">Distribución de Resultados</h6>
            </div>
            <div class="card-body d-flex align-items-center justify-content-center p-4">
                <canvas id="donutChart" height="220"></canvas>
            </div>
        </div>
    </div>

    <!-- Barras: Funnel de engagement -->
    <div class="col-lg-8">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3 px-4">
                <h6 class="text-white mb-0 fw-bold">Funnel de Engagement</h6>
            </div>
            <div class="card-body p-4">
                <canvas id="funnelChart" height="200"></canvas>
            </div>
        </div>
    </div>
</div>

<!-- TABLA DE INTERACCIONES -->
<div class="card glass-morphism border-0 mb-4">
    <div class="card-header border-bottom border-white-10 bg-transparent py-3 px-4 d-flex justify-content-between align-items-center">
        <h6 class="text-white mb-0 fw-bold">Desglose de Interacciones</h6>
        <input type="text" id="interactionSearch" class="form-control form-control-sm bg-black text-white border-white-10"
               style="max-width:220px;" placeholder="Filtrar por email...">
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0 bg-transparent align-middle" id="interactionsTable">
                <thead>
                    <tr>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Email</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Nombre</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Evento</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Fecha</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">URL / Detalle</th>
                    </tr>
                </thead>
                <tbody id="interactionsBody">
                    <?php if (!empty($interactions)): ?>
                        <?php foreach ($interactions as $ev): ?>
                        <?php
                        $evMap = [
                            'open'       => ['bg-info text-dark',    'Apertura'],
                            'click'      => ['bg-success',           'Clic'],
                            'bounce'     => ['bg-danger',            'Rebote'],
                            'complaint'  => ['bg-danger',            'Queja'],
                            'unsub'      => ['bg-secondary',         'Baja'],
                            'delivered'  => ['bg-success bg-opacity-50','Entregado'],
                            'conversion' => ['bg-warning text-dark', 'Conversión'],
                        ];
                        [$evCls, $evLabel] = $evMap[$ev['event_type']] ?? ['bg-secondary', $ev['event_type']];
                        ?>
                        <tr class="interaction-row">
                            <td class="border-bottom border-white-10 bg-transparent text-white fw-bold p-3">
                                <?php echo htmlspecialchars($ev['email'] ?? '—'); ?>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent text-white-50 p-3">
                                <?php echo htmlspecialchars(trim(($ev['first_name']??'').' '.($ev['last_name']??''))); ?>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent p-3">
                                <span class="badge <?php echo $evCls; ?>"><?php echo $evLabel; ?></span>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent text-white-50 small p-3">
                                <?php echo $ev['occurred_at'] ? date('d M Y H:i', strtotime($ev['occurred_at'])) : '—'; ?>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent text-white-50 small p-3">
                                <?php if (!empty($ev['url_clicked'])): ?>
                                    <a href="<?php echo htmlspecialchars($ev['url_clicked']); ?>" target="_blank"
                                       class="text-primary text-truncate d-inline-block" style="max-width:200px;">
                                        <?php echo htmlspecialchars($ev['url_clicked']); ?>
                                    </a>
                                <?php else: ?>&mdash;<?php endif; ?>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="5" class="text-center text-white-50 p-5 bg-transparent">
                                <span class="material-symbols-outlined d-block mb-2" style="font-size:40px;opacity:.3;">analytics</span>
                                Aún no hay interacciones registradas para esta campaña.
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
(function () {
    Chart.defaults.color = 'rgba(255,255,255,0.5)';
    Chart.defaults.borderColor = 'rgba(255,255,255,0.05)';

    /* ---- Donut: distribución de resultados ---- */
    const donutCtx = document.getElementById('donutChart').getContext('2d');
    new Chart(donutCtx, {
        type: 'doughnut',
        data: {
            labels: ['Aperturas únicas', 'Clics únicos', 'Rebotes', 'Bajas', 'Sin interacción'],
            datasets: [{
                data: [
                    <?php echo (int)($metrics['unique_opens']  ?? 0); ?>,
                    <?php echo (int)($metrics['unique_clicks'] ?? 0); ?>,
                    <?php echo $bounces; ?>,
                    <?php echo $unsubscribes; ?>,
                    <?php echo max(0, $totalSent - ($metrics['unique_opens']??0) - $bounces - $unsubscribes); ?>,
                ],
                backgroundColor: ['#06b6d4','#10b981','#ef4444','#8b5cf6','rgba(255,255,255,0.07)'],
                borderColor:     ['#0e7490','#059669','#b91c1c','#6d28d9','transparent'],
                borderWidth: 2,
                hoverOffset: 8,
            }],
        },
        options: {
            cutout: '68%',
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { padding: 12, font: { size: 11 }, usePointStyle: true },
                },
                tooltip: { callbacks: {
                    label: ctx => ` ${ctx.label}: ${ctx.parsed.toLocaleString()} (${
                        <?php echo $totalSent ?: 1; ?> > 0
                            ? (ctx.parsed / <?php echo $totalSent ?: 1; ?> * 100).toFixed(1) + '%'
                            : '—'
                    })`,
                }},
            },
        },
    });

    /* ---- Barras horizontales: funnel de engagement ---- */
    const funnelCtx = document.getElementById('funnelChart').getContext('2d');
    new Chart(funnelCtx, {
        type: 'bar',
        data: {
            labels: ['Enviados', 'Entregados', 'Aperturas', 'Clics', 'Conversiones'],
            datasets: [{
                label: 'Contactos',
                data: [
                    <?php echo $totalSent; ?>,
                    <?php echo $delivered; ?>,
                    <?php echo (int)($metrics['unique_opens']  ?? 0); ?>,
                    <?php echo (int)($metrics['unique_clicks'] ?? 0); ?>,
                    <?php echo (int)($metrics['conversions']   ?? 0); ?>,
                ],
                backgroundColor: [
                    'rgba(99,102,241,0.7)',
                    'rgba(6,182,212,0.7)',
                    'rgba(16,185,129,0.7)',
                    'rgba(245,158,11,0.7)',
                    'rgba(139,92,246,0.7)',
                ],
                borderColor: [
                    '#6366f1','#06b6d4','#10b981','#f59e0b','#8b5cf6',
                ],
                borderWidth: 2,
                borderRadius: 6,
            }],
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: { callbacks: {
                    label: ctx => ` ${ctx.parsed.x.toLocaleString()} contactos`,
                }},
            },
            scales: {
                x: {
                    grid: { color: 'rgba(255,255,255,0.05)' },
                    ticks: { color: 'rgba(255,255,255,0.4)', font: { size: 11 } },
                },
                y: {
                    grid: { display: false },
                    ticks: { color: 'rgba(255,255,255,0.7)', font: { size: 12 } },
                },
            },
        },
    });

    /* ---- Filtro rápido en tabla ---- */
    document.getElementById('interactionSearch').addEventListener('input', function () {
        const q = this.value.toLowerCase();
        document.querySelectorAll('#interactionsTable .interaction-row').forEach(row => {
            row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
        });
    });
})();
</script>

<style>
@media print {
    .btn, nav, aside, .sidebar, #interactionSearch { display: none !important; }
    .card { border: 1px solid #ccc !important; }
    body { background: white !important; }
}
</style>
