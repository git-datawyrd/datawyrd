<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="text-white fw-bold mb-0">Logs de Auditoría</h2>
    <div class="d-flex gap-2">
        <select class="form-select bg-midnight border-white-10 text-white w-auto rounded-3" id="filter-level">
            <option value="">Todos los niveles</option>
            <option value="INFO">INFO</option>
            <option value="WARN">WARN</option>
            <option value="ERROR">ERROR</option>
        </select>
        <button class="btn btn-outline-light rounded-3" onclick="location.reload()">
            <span class="material-symbols-outlined fs-5 align-middle">refresh</span>
        </button>
    </div>
</div>

<div class="glass-morphism rounded-4 border-white-10 overflow-hidden shadow-lg">
    <div class="table-responsive">
        <table class="table table-dark table-hover mb-0 align-middle">
            <thead class="bg-white-10 text-white-50 x-small uppercase tracking-widest">
                <tr>
                    <th class="ps-4">Fecha</th>
                    <th>Usuario</th>
                    <th>Acción</th>
                    <th>Detalles</th>
                    <th>Nivel</th>
                    <th>IP</th>
                    <th class="pe-4">Método</th>
                </tr>
            </thead>
            <tbody class="text-white-50 small">
                <?php foreach ($logs as $log): ?>
                    <tr>
                        <td class="ps-4">
                            <div class="text-white fw-bold">
                                <?php echo date('d M, H:i:s', strtotime($log['created_at'])); ?>
                            </div>
                            <div class="x-small text-white-50">
                                <?php echo date('Y', strtotime($log['created_at'])); ?>
                            </div>
                        </td>
                        <td>
                            <div class="text-white">
                                <?php echo $log['user_email']; ?>
                            </div>
                            <div class="x-small uppercase text-accent">
                                <?php echo $log['user_role']; ?>
                            </div>
                        </td>
                        <td>
                            <span class="badge bg-white-10 text-white border border-white-10 rounded-pill px-2 py-1">
                                <?php echo $log['action']; ?>
                            </span>
                        </td>
                        <td>
                            <div class="text-truncate" style="max-width: 200px;" title='<?php echo htmlspecialchars($log['details']); ?>'>
                                <?php
                                $details = json_decode($log['details'], true);
                                if ($details && isset($details['message'])) {
                                    echo htmlspecialchars($details['message']);
                                } else {
                                    echo htmlspecialchars($log['details']);
                                }
                                ?>
                            </div>
                        </td>
                        <td>
                            <?php
                            $levelClass = 'bg-info';
                            if ($log['level'] === 'WARN')
                                $levelClass = 'bg-warning';
                            if ($log['level'] === 'ERROR')
                                $levelClass = 'bg-danger';
                            ?>
                            <span
                                class="badge <?php echo $levelClass; ?> bg-opacity-10 <?php echo str_replace('bg-', 'text-', $levelClass); ?> border <?php echo str_replace('bg-', 'border-', $levelClass); ?> border-opacity-25 rounded-pill px-2">
                                <?php echo $log['level']; ?>
                            </span>
                        </td>
                        <td>
                            <?php echo $log['ip_address']; ?>
                        </td>
                        <td class="pe-4">
                            <span class="x-small fw-bold px-2 py-1 bg-deep-black rounded border border-white-10">
                                <?php echo $log['request_method']; ?>
                            </span>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>

<script>
    document.getElementById('filter-level').addEventListener('change', function () {
        const val = this.value;
        const url = new URL(window.location.href);
        if (val) {
            url.searchParams.set('level', val);
        } else {
            url.searchParams.delete('level');
        }
        window.location.href = url.toString();
    });

    // Set initial value from URL
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('level')) {
        document.getElementById('filter-level').value = urlParams.get('level');
    }
</script>