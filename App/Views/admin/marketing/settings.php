<div class="mb-4">
    <a href="<?php echo url('admin/marketing'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
        <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Dashboard
    </a>
    <h1 class="h3 text-white fw-bold mb-0">Entregabilidad (SPF / DKIM)</h1>
</div>

<div class="row g-4">
    <div class="col-md-5">
        <div class="card glass-morphism border-0 h-100">
            <div class="card-header border-bottom border-white-10 bg-transparent py-3">
                <h6 class="text-white mb-0 fw-bold d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-primary">domain_verification</span> Consultar Dominio
                </h6>
            </div>
            <div class="card-body">
                <p class="text-white-50 small mb-4">
                    Para que tus correos lleguen a la bandeja de entrada y no a Spam, es obligatorio configurar los registros TXT de SPF y DKIM en tu proveedor de dominio (Ej: Cloudflare, GoDaddy).
                </p>
                
                <form action="<?php echo url('admin/marketing/settings'); ?>" method="POST">
                    <?php echo csrf_field(); ?>
                    <div class="mb-3">
                        <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Dominio de Envío</label>
                        <input type="text" name="domain" class="form-control bg-black text-white border-white-10 p-3 rounded-3" value="<?php echo htmlspecialchars($domain ?? ''); ?>" placeholder="ejemplo.com" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Selector DKIM</label>
                        <input type="text" name="dkim_selector" class="form-control bg-black text-white border-white-10 p-3 rounded-3" value="<?php echo htmlspecialchars($selector ?? 'mail'); ?>" placeholder="mail" required>
                        <div class="form-text text-white-50 x-small mt-1">Suele ser 'mail', 'zmail' o 'zeptomail' dependiendo de tu proveedor SMTP.</div>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 d-flex align-items-center justify-content-center gap-2">
                        <span class="material-symbols-outlined">search</span> Validar DNS Ahora
                    </button>
                </form>
            </div>
        </div>
    </div>

    <div class="col-md-7">
        <?php if(isset($spfResult)): ?>
            <!-- Resultados SPF -->
            <div class="card glass-morphism border-0 mb-4 <?php echo $spfResult['status'] ? 'border-success' : 'border-danger'; ?>" style="border-left: 4px solid !important;">
                <div class="card-body">
                    <div class="d-flex align-items-start gap-3">
                        <span class="material-symbols-outlined fs-2 <?php echo $spfResult['status'] ? 'text-success' : 'text-danger'; ?>">
                            <?php echo $spfResult['status'] ? 'check_circle' : 'error'; ?>
                        </span>
                        <div>
                            <h6 class="text-white fw-bold mb-1">Registro SPF</h6>
                            <p class="text-white-50 small mb-2"><?php echo htmlspecialchars($spfResult['message']); ?></p>
                            <?php if($spfResult['raw']): ?>
                                <code class="bg-black p-2 rounded-2 d-block text-success small border border-white-10">
                                    <?php echo htmlspecialchars($spfResult['raw']); ?>
                                </code>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Resultados DKIM -->
            <div class="card glass-morphism border-0 <?php echo $dkimResult['status'] ? 'border-success' : 'border-danger'; ?>" style="border-left: 4px solid !important;">
                <div class="card-body">
                    <div class="d-flex align-items-start gap-3">
                        <span class="material-symbols-outlined fs-2 <?php echo $dkimResult['status'] ? 'text-success' : 'text-danger'; ?>">
                            <?php echo $dkimResult['status'] ? 'check_circle' : 'error'; ?>
                        </span>
                        <div>
                            <h6 class="text-white fw-bold mb-1">Registro DKIM (<?php echo htmlspecialchars($selector); ?>._domainkey)</h6>
                            <p class="text-white-50 small mb-2"><?php echo htmlspecialchars($dkimResult['message']); ?></p>
                            <?php if($dkimResult['raw']): ?>
                                <code class="bg-black p-2 rounded-2 d-block text-success small border border-white-10" style="word-break: break-all;">
                                    <?php echo htmlspecialchars($dkimResult['raw']); ?>
                                </code>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>
            </div>
            
            <?php if(!$spfResult['status'] || !$dkimResult['status']): ?>
                <div class="alert alert-warning bg-warning bg-opacity-10 border-warning border-opacity-25 text-warning mt-4 d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined">warning</span>
                    <span class="small">Tus correos podrían ser marcados como SPAM. Corrige los registros en tu DNS y espera hasta 24 horas para que los cambios se propaguen.</span>
                </div>
            <?php else: ?>
                <div class="alert alert-success bg-success bg-opacity-10 border-success border-opacity-25 text-success mt-4 d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined">verified</span>
                    <span class="small">¡Excelente! Tu dominio está autenticado correctamente. Estás listo para lanzar campañas con alta entregabilidad.</span>
                </div>
            <?php endif; ?>
        <?php else: ?>
            <div class="h-100 d-flex flex-column align-items-center justify-content-center text-white-50 p-5 bg-white-5 rounded-4 border border-white-10 border-dashed">
                <span class="material-symbols-outlined fs-1 mb-3 opacity-50">dns</span>
                <h6 class="fw-bold mb-1">Sin Validar</h6>
                <p class="small text-center mb-0">Ingresa tu dominio y selector a la izquierda para verificar el estado de la entregabilidad.</p>
            </div>
        <?php endif; ?>
    </div>
</div>
