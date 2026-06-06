<div class="mb-4">
    <a href="<?php echo url('admin/marketing/templates'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
        <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Plantillas
    </a>
    <h1 class="h3 text-white fw-bold mb-0">Nueva Plantilla</h1>
</div>

<div class="card glass-morphism border-0 max-w-800 mx-auto">
    <div class="card-body p-4">
        <form action="<?php echo url('admin/marketing/templates/store'); ?>" method="POST">
            <?php echo csrf_field(); ?>
            
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Nombre Interno *</label>
                    <input type="text" name="name" class="form-control bg-black text-white border-white-10 p-3 rounded-3" required placeholder="Ej: Newsletter General">
                </div>
                <div class="col-md-6">
                    <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Categoría</label>
                    <input type="text" name="category" class="form-control bg-black text-white border-white-10 p-3 rounded-3" placeholder="Ej: Promociones">
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Código HTML *</label>
                <div class="alert alert-info bg-primary bg-opacity-10 border-primary border-opacity-25 text-primary small mb-2">
                    Variables disponibles: <code>{{email}}</code>, <code>{{first_name}}</code>, <code>{{last_name}}</code>
                </div>
                <textarea name="html_body" class="form-control bg-black text-white border-white-10 p-3 rounded-3 font-monospace" rows="15" required placeholder="<html>...</html>"></textarea>
            </div>

            <div class="text-end mt-4">
                <button type="submit" class="btn btn-primary px-4 py-2">Guardar Plantilla</button>
            </div>
        </form>
    </div>
</div>
