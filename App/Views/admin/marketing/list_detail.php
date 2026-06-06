<div class="mb-4 d-flex justify-content-between align-items-center">
    <div>
        <a href="<?php echo url('admin/marketing/lists'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
            <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Listas
        </a>
        <h1 class="h3 text-white fw-bold mb-0"><?php echo htmlspecialchars($list['name']); ?></h1>
    </div>
    <div>
        <button type="button" class="btn btn-success d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#importCsvModal">
            <span class="material-symbols-outlined">upload_file</span> Importar CSV
        </button>
    </div>
</div>

<div class="card glass-morphism border-0 mb-4">
    <div class="card-header border-bottom border-white-10 bg-transparent py-3">
        <h6 class="text-white mb-0 fw-bold">Contactos Suscritos</h6>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0 bg-transparent align-middle">
                <thead>
                    <tr>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Email</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Nombre</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Estado</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3 text-end">Suscrito el</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($contacts)): ?>
                        <?php foreach($contacts as $contact): ?>
                        <tr>
                            <td class="border-bottom border-white-10 bg-transparent text-white fw-bold p-3">
                                <?php echo htmlspecialchars($contact['email']); ?>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent text-white-50 p-3">
                                <?php echo htmlspecialchars(trim(($contact['first_name']??'').' '.($contact['last_name']??''))); ?>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent p-3">
                                <?php if($contact['status'] === 'subscribed'): ?>
                                    <span class="badge bg-success">Activo</span>
                                <?php elseif($contact['status'] === 'unsubscribed'): ?>
                                    <span class="badge bg-secondary">Desuscrito</span>
                                <?php elseif($contact['status'] === 'bounced'): ?>
                                    <span class="badge bg-danger">Rebotado</span>
                                <?php endif; ?>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent text-white-50 small p-3 text-end">
                                <?php echo date('d M, Y', strtotime($contact['created_at'])); ?>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="4" class="text-center text-white-50 p-4 bg-transparent">Esta lista aún no tiene contactos.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Import CSV -->
<div class="modal fade" id="importCsvModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <form action="<?php echo url("admin/marketing/lists/{$list['id']}/import"); ?>" method="POST" enctype="multipart/form-data" class="modal-content bg-midnight border-white-10 glass-morphism">
      <?php echo csrf_field(); ?>
      <div class="modal-header border-white-10">
        <h5 class="modal-title text-white">Importar Contactos (CSV)</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="alert alert-info bg-primary bg-opacity-10 border-primary border-opacity-25 text-primary small">
            El archivo CSV debe contener obligatoriamente las columnas: <strong>email</strong>, <strong>first_name</strong>, <strong>last_name</strong>.
        </div>
        <div class="mb-3">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Archivo CSV</label>
            <input type="file" name="csv_file" accept=".csv" class="form-control bg-black text-white border-white-10" required>
        </div>
      </div>
      <div class="modal-footer border-white-10">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
        <button type="submit" class="btn btn-success">Importar</button>
      </div>
    </form>
  </div>
</div>
