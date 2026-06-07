<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="h3 text-white fw-bold mb-0">Listas de Contactos</h1>
    <button type="button" class="btn btn-primary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#createListModal">
        <span class="material-symbols-outlined">add</span> Nueva Lista
    </button>
</div>

<div class="card glass-morphism border-0">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0 bg-transparent align-middle">
                <thead>
                    <tr>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Nombre</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Contactos</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3 text-end">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($lists)): ?>
                        <?php foreach($lists as $list): ?>
                        <tr>
                            <td class="border-bottom border-white-10 bg-transparent text-white fw-bold p-3">
                                <?php echo htmlspecialchars($list['name']); ?>
                                <div class="x-small text-white-50 fw-normal"><?php echo htmlspecialchars($list['description']); ?></div>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent text-white-50 p-3">
                                <span class="badge bg-primary rounded-pill"><?php echo $list['contacts_count'] ?? 0; ?></span>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent p-3 text-end">
                                <a href="<?php echo url("admin/marketing/showList/{$list['id']}"); ?>" class="btn btn-outline-light btn-sm rounded-circle p-1 d-inline-flex align-items-center justify-content-center me-1" title="Gestionar Contactos" style="width:30px; height:30px;">
                                    <span class="material-symbols-outlined fs-6">group</span>
                                </a>
                                <a href="<?php echo url("admin/marketing/deleteList/{$list['id']}"); ?>" class="btn btn-outline-danger btn-sm rounded-circle p-1 d-inline-flex align-items-center justify-content-center" title="Eliminar Lista" style="width:30px; height:30px;" onclick="return confirm('¿Estás seguro de que deseas eliminar esta lista y todos sus contactos? Esta acción no se puede deshacer.');">
                                    <span class="material-symbols-outlined fs-6">delete</span>
                                </a>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="3" class="text-center text-white-50 p-4 bg-transparent">No hay listas registradas.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="createListModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <form action="<?php echo url('admin/marketing/storeList'); ?>" method="POST" class="modal-content bg-midnight border-white-10 glass-morphism">
      <?php echo csrf_field(); ?>
      <div class="modal-header border-white-10">
        <h5 class="modal-title text-white">Nueva Lista</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="mb-3">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Nombre *</label>
            <input type="text" name="name" class="form-control bg-black text-white border-white-10" required>
        </div>
        <div class="mb-3">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Descripción</label>
            <textarea name="description" class="form-control bg-black text-white border-white-10"></textarea>
        </div>
      </div>
      <div class="modal-footer border-white-10">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
        <button type="submit" class="btn btn-primary">Crear</button>
      </div>
    </form>
  </div>
</div>
