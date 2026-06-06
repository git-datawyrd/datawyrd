<div class="mb-4">
    <a href="<?php echo url('admin/marketing/campaigns'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
        <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Campañas
    </a>
    <h1 class="h3 text-white fw-bold mb-0">Nueva Campaña</h1>
</div>

<div class="card glass-morphism border-0 max-w-800 mx-auto">
    <div class="card-body p-4">
        <form action="<?php echo url('admin/marketing/campaigns/store'); ?>" method="POST">
            <?php echo csrf_field(); ?>
            
            <div class="mb-4">
                <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Nombre Interno de la Campaña *</label>
                <input type="text" name="name" class="form-control bg-black text-white border-white-10 p-3 rounded-3" required placeholder="Ej: Promo de Invierno 2026">
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Asunto del Email *</label>
                    <input type="text" name="subject" class="form-control bg-black text-white border-white-10 p-3 rounded-3" required placeholder="Ej: 50% Off en tu Próximo Proyecto">
                </div>
                <div class="col-md-6">
                    <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Texto de Vista Previa (Preview Text)</label>
                    <input type="text" name="preview_text" class="form-control bg-black text-white border-white-10 p-3 rounded-3" placeholder="Ej: No te pierdas esta oportunidad...">
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Nombre del Remitente</label>
                    <input type="text" name="from_name" class="form-control bg-black text-white border-white-10 p-3 rounded-3" value="<?php echo \Core\Config::get('business.company_name'); ?>">
                </div>
                <div class="col-md-4">
                    <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Email del Remitente</label>
                    <input type="email" name="from_email" class="form-control bg-black text-white border-white-10 p-3 rounded-3" value="<?php echo \Core\Config::get('business.company_mail'); ?>">
                </div>
                <div class="col-md-4">
                    <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Responder A (Reply-To)</label>
                    <input type="email" name="reply_to" class="form-control bg-black text-white border-white-10 p-3 rounded-3" value="<?php echo \Core\Config::get('business.company_mail'); ?>">
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Lista de Contactos *</label>
                    <select name="list_id" class="form-select bg-black text-white border-white-10 p-3 rounded-3" required>
                        <option value="">Seleccione una lista...</option>
                        <?php if(!empty($lists)): foreach($lists as $list): ?>
                            <option value="<?php echo $list['id']; ?>"><?php echo htmlspecialchars($list['name']); ?></option>
                        <?php endforeach; endif; ?>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Plantilla *</label>
                    <select name="template_id" class="form-select bg-black text-white border-white-10 p-3 rounded-3" required>
                        <option value="">Seleccione una plantilla HTML...</option>
                        <?php if(!empty($templates)): foreach($templates as $tpl): ?>
                            <option value="<?php echo $tpl['id']; ?>"><?php echo htmlspecialchars($tpl['name']); ?></option>
                        <?php endforeach; endif; ?>
                    </select>
                </div>
            </div>

            <div class="text-end mt-5">
                <button type="submit" class="btn btn-primary d-inline-flex align-items-center gap-2 px-4 py-2">
                    <span class="material-symbols-outlined">save</span> Guardar Borrador
                </button>
            </div>
        </form>
    </div>
</div>
