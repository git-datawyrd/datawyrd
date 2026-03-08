<div class="row g-4 mb-5" id="adminDashboardContent">
    <div class="col-12 d-flex align-items-center justify-content-between mb-2 no-print">
        <div>
            <h2 class="text-white fw-black mb-1">Cerebro Central Admin 🧠</h2>
            <p class="text-white-50">Control total de las operaciones de Data Wyrd.</p>
        </div>
        <div class="d-flex gap-2">
            <button type="button"
                class="btn btn-outline-light btn-sm px-4 rounded-pill fw-bold border-white-10 d-flex align-items-center gap-2"
                data-bs-toggle="modal" data-bs-target="#configDashboardModal">
                <span class="material-symbols-outlined fs-6">settings</span>
                Personalizar
            </button>
            <a href="<?php echo url('ticket'); ?>"
                class="btn btn-primary btn-sm px-4 rounded-pill fw-bold shadow-gold d-flex align-items-center gap-2">
                <span class="material-symbols-outlined fs-6">confirmation_number</span>
                Ver Tickets
            </a>
        </div>
    </div>

    <!-- Modal de Configuración -->
    <div class="modal fade" id="configDashboardModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content glass-morphism border-white-10 text-white">
                <div class="modal-header border-white-10">
                    <h5 class="modal-title fw-black">Configurar Widgets</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="<?php echo url('dashboard/updateConfig'); ?>" method="POST">
                    <?php echo csrf_field(); ?>
                    <div class="modal-body">
                        <p class="text-white-50 small mb-4">Selecciona qué paneles deseas ver en tu centro de control.
                        </p>

                        <?php foreach ($widget_config as $key => $config): ?>
                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input" type="checkbox"
                                    name="widgets[<?php echo $key; ?>][is_visible]" id="widget_<?php echo $key; ?>" <?php echo $config['is_visible'] ? 'checked' : ''; ?>>
                                <label class="form-check-label" for="widget_<?php echo $key; ?>">
                                    <?php echo ucwords(str_replace('_', ' ', $key)); ?>
                                </label>
                                <input type="hidden" name="widgets[<?php echo $key; ?>][sort_order]"
                                    value="<?php echo $config['sort_order']; ?>">
                            </div>
                        <?php endforeach; ?>
                    </div>
                    <div class="modal-footer border-white-10">
                        <button type="button" class="btn btn-outline-light rounded-pill px-4"
                            data-bs-dismiss="modal">Cerrar</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Dynamic Widget Rendering based on Sort Order -->
    <div class="col-12">
        <div class="row g-4" id="dashboard-widgets-container">
            <?php
            // Sort widget config by sort_order
            $sortedWidgets = $widget_config;
            uasort($sortedWidgets, function ($a, $b) {
                return ($a['sort_order'] ?? 0) <=> ($b['sort_order'] ?? 0);
            });

            foreach ($sortedWidgets as $key => $config):
                if (!$config['is_visible'])
                    continue;

                // Capture widget HTML
                $widgetPath = "widgets/{$key}.php";
                $widgetHTML = '';

                // Absolute path check for safety
                $fullPath = dirname(__FILE__) . DIRECTORY_SEPARATOR . $widgetPath;

                if (file_exists($fullPath)) {
                    ob_start();
                    include $fullPath;
                    $widgetHTML = ob_get_clean();
                }

                if (!empty($widgetHTML)):
                    ?>
                    <div class="widget-wrapper col-12 <?php
                    // Dynamic column widths based on widget type
                    echo in_array($key, ['performance_chart']) ? 'col-lg-8' :
                        (in_array($key, ['resource_dist']) ? 'col-lg-4' : 'col-12');
                    ?>" data-widget-id="<?php echo $key; ?>">
                        <div class="widget-container h-100 position-relative">
                            <!-- Drag Handle -->
                            <div class="widget-drag-handle position-absolute top-0 start-50 translate-middle-x p-2 no-print"
                                style="cursor: grab; z-index: 10; opacity: 0.3; transition: opacity 0.3s;">
                                <span class="material-symbols-outlined fs-5">drag_indicator</span>
                            </div>
                            <?php echo $widgetHTML; ?>
                        </div>
                    </div>
                    <?php
                endif;
            endforeach;
            ?>
        </div>
    </div>
</div>

<!-- SortableJS for Drag-and-Drop -->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // --- 1. Drag and Drop Implementation ---
        const container = document.getElementById('dashboard-widgets-container');
        if (container) {
            new Sortable(container, {
                animation: 150,
                handle: '.widget-drag-handle',
                ghostClass: 'glass-morphism-ghost',
                onEnd: function () {
                    const order = Array.from(container.querySelectorAll('.widget-wrapper'))
                        .map(el => el.dataset.widgetId);

                    saveWidgetOrder(order);
                }
            });
        }

        function saveWidgetOrder(order) {
            const formData = new FormData();
            order.forEach(id => formData.append('order[]', id));

            fetch('<?php echo url('dashboard/saveOrder'); ?>', {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRF-TOKEN': '<?php echo \Core\Session::get('csrf_token'); ?>'
                }
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        showToast('Orden guardado correctamente');
                    }
                });
        }

        function showToast(message) {
            // Simple toast implementation or use bootstrap toast if available
            const toast = document.createElement('div');
            toast.className = 'position-fixed bottom-0 end-0 p-3 no-print';
            toast.style.zIndex = '1080';
            toast.innerHTML = `
                <div class="glass-morphism border-white-10 p-3 rounded-3 text-white shadow-lg d-flex align-items-center gap-2" style="backdrop-filter: blur(20px);">
                    <span class="material-symbols-outlined text-success">check_circle</span>
                    <span class="small fw-bold">${message}</span>
                </div>
            `;
            document.body.appendChild(toast);
            setTimeout(() => {
                toast.style.opacity = '0';
                toast.style.transition = 'opacity 0.5s ease';
                setTimeout(() => toast.remove(), 500);
            }, 3000);
        }

        // --- 2. Chart and Stats Logic ---
        // Real data from PHP
        const dailyPerf = <?php echo json_encode($daily_perf); ?>;
        const monthlyPerf = <?php echo json_encode($monthly_perf); ?>;
        const resourceStats = <?php echo json_encode($resource_stats); ?>;

        const perfEl = document.getElementById('performanceChart');
        const resEl = document.getElementById('resourceChart');
        const periodSelect = document.getElementById('periodSelect');

        let performanceChart;

        const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
        const days = ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'];

        function getChartContent(period) {
            let labels = [];
            let dataset1 = []; // Tickets
            let dataset2 = []; // Usuarios
            let dataset3 = []; // Clientes

            let filtered = [];
            if (period === '7d') filtered = dailyPerf.slice(-7);
            else if (period === '30d') filtered = dailyPerf.slice(-30);
            else if (period === '3m') filtered = monthlyPerf.slice(-3);
            else filtered = monthlyPerf;

            filtered.forEach(item => {
                if (item.date) {
                    const date = new Date(item.date + 'T00:00:00');
                    if (period === '7d') {
                        labels.push(days[date.getDay()]);
                    } else {
                        labels.push(`${date.getDate()} ${months[date.getMonth()]}`);
                    }
                } else if (item.month) {
                    const parts = item.month.split('-');
                    const date = new Date(parts[0], parts[1] - 1, 1);
                    labels.push(`${months[date.getMonth()]}-${date.getFullYear().toString().substr(-2)}`);
                }

                dataset1.push(item.tickets);
                dataset2.push(item.users);
                dataset3.push(item.clients);
            });

            return { labels, dataset1, dataset2, dataset3 };
        }

        function initPerformanceChart(period) {
            if (!perfEl) return;
            const perfCtx = perfEl.getContext('2d');
            const { labels, dataset1, dataset2, dataset3 } = getChartContent(period);

            if (performanceChart) performanceChart.destroy();

            performanceChart = new Chart(perfCtx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Tickets',
                        data: dataset1,
                        borderColor: '#D4AF37',
                        backgroundColor: 'rgba(212, 175, 55, 0.1)',
                        fill: true,
                        tension: 0.4,
                        pointRadius: 4,
                    }, {
                        label: 'Usuarios',
                        data: dataset2,
                        borderColor: '#30C5FF',
                        fill: false,
                        tension: 0.4,
                        pointRadius: 4,
                    }, {
                        label: 'Clientes',
                        data: dataset3,
                        borderColor: '#5C4D7D',
                        fill: false,
                        tension: 0.4,
                        pointRadius: 4,
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { labels: { color: 'rgba(255,255,255,0.7)', font: { family: 'var(--font-heading)' } } }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { color: 'rgba(255,255,255,0.05)' },
                            ticks: { color: 'rgba(255,255,255,0.5)', stepSize: 1 }
                        },
                        x: { grid: { display: false }, ticks: { color: 'rgba(255,255,255,0.5)' } }
                    }
                }
            });
        }

        // Initial Chart
        if (perfEl) initPerformanceChart('7d');

        // Period Change Listener
        if (periodSelect) {
            periodSelect.addEventListener('change', function () {
                initPerformanceChart(this.value);
            });
        }

        // 2. Resource Chart (Stacked Bar grouped by Pillar and Status)
        if (resEl) {
            const resCtx = resEl.getContext('2d');

            const categories = Object.keys(resourceStats);
            const statusMap = {
                'open': { label: 'Abierto', color: '#30C5FF' },          // Tech Blue
                'in_analysis': { label: 'En Análisis', color: '#5C4D7D' }, // Accent Purple
                'budget_sent': { label: 'P. Enviado', color: '#9d8437' },   // Dark Gold
                'budget_approved': { label: 'P. Aprobado', color: '#D4AF37' }, // Elegant Gold
                'budget_rejected': { label: 'P. Rechazado', color: '#dc3545' }, // Danger (Keep for semantics)
                'invoiced': { label: 'Facturado', color: '#1B1F3B' },       // Main Surface Dark
                'payment_pending': { label: 'P. Pendiente', color: '#e6c86e' }, // Light Gold
                'active': { label: 'Activo', color: '#10b981' },           // Emerald Branding
                'resolved': { label: 'Resuelto', color: '#059669' },       // Emerald Dark
                'closed': { label: 'Cerrado', color: '#0A0A0A' },          // Deep Black
                'void': { label: 'Anulado', color: '#4b5563' }             // Gray
            };

            const allStatusesFound = new Set();
            categories.forEach(cat => {
                Object.keys(resourceStats[cat]).forEach(st => allStatusesFound.add(st));
            });

            const datasets = [];
            Array.from(allStatusesFound).forEach(status => {
                const data = categories.map(cat => resourceStats[cat][status] || 0);
                datasets.push({
                    label: statusMap[status] ? statusMap[status].label : status,
                    data: data,
                    backgroundColor: statusMap[status] ? statusMap[status].color : 'rgba(255,255,255,0.2)',
                    borderWidth: 0,
                    borderRadius: 4
                });
            });

            new Chart(resCtx, {
                type: 'bar',
                data: {
                    labels: categories,
                    datasets: datasets
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: true, position: 'bottom', labels: { color: 'rgba(255,255,255,0.7)', font: { family: 'var(--font-heading)', size: 10 } } }
                    },
                    scales: {
                        x: { stacked: true, grid: { display: false }, ticks: { color: 'rgba(255,255,255,0.5)', font: { size: 10 } } },
                        y: { stacked: true, beginAtZero: true, grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: 'rgba(255,255,255,0.5)', stepSize: 1 } }
                    }
                }
            });
        }

        // 3. Search
        const searchInput = document.getElementById('adminSearchInput');
        const rows = document.querySelectorAll('.ticket-row');
        if (searchInput) {
            searchInput.addEventListener('input', function () {
                const query = this.value.toLowerCase();
                rows.forEach(row => {
                    row.style.display = row.dataset.search.includes(query) ? '' : 'none';
                });
            });
        }

        // --- Sprint 4: Skeleton Screen Polish ---
        setTimeout(() => {
            document.querySelectorAll('.skeleton-loader, .skeleton-row').forEach(el => {
                el.style.transition = 'opacity 0.4s ease';
                el.style.opacity = '0';
                setTimeout(() => el.remove(), 400);
            });
        }, 600); // Artificial delay to WOW the user with the smooth transition
    });
</script>

<style>
    /* Drag and Drop Feedback */
    .glass-morphism-ghost {
        opacity: 0.4;
        background: rgba(212, 175, 55, 0.05) !important;
        border: 2px dashed rgba(212, 175, 55, 0.3) !important;
    }

    .widget-wrapper {
        transition: transform 0.2s ease;
    }

    .widget-container:hover .widget-drag-handle {
        opacity: 0.8 !important;
    }

    .widget-drag-handle:active {
        cursor: grabbing !important;
    }

    /* Clean styles, removed all print complexity */
    .nav-link-custom {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.75rem 1rem;
        color: rgba(255, 255, 255, 0.7);
        text-decoration: none;
        border-radius: 0.75rem;
        transition: all 0.3s ease;
        font-weight: 500;
        margin-bottom: 0.25rem;
    }

    .nav-link-custom:hover {
        background: rgba(212, 175, 55, 0.1);
        color: var(--elegant-gold);
    }

    .nav-link-custom.active {
        background: var(--elegant-gold);
        color: var(--deep-black);
        font-weight: 700;
        box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
    }

    /* Dashboard Mobile Refinements */
    @media (max-width: 768px) {
        .display-6.kpi-value {
            font-size: 1.25rem !important;
        }

        .kpi-card {
            padding: 1.25rem !important;
        }

        .analytics-card {
            padding: 1.5rem !important;
        }

        h2.h5 {
            font-size: 1rem !important;
        }

        .table th,
        .table td {
            padding: 1rem !important;
            font-size: 0.8rem !important;
        }

        #adminDashboardContent {
            --bs-gutter-x: 1rem;
            --bs-gutter-y: 1rem;
        }
    }
</style>