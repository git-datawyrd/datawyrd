<?php
// Campos esperados por la base de datos y sus labels amigables
$dbFields = [
    'email'      => 'Email *',
    'first_name' => 'Nombre',
    'last_name'  => 'Apellido',
    'phone'      => 'Teléfono',
    'company'    => 'Compañía',
    'country'    => 'País',
    'industry'   => 'Industria',
    'tags'       => 'Tags (separados por coma)',
];
?>
<div class="mb-4 d-flex justify-content-between align-items-center">
    <div>
        <a href="<?php echo url('admin/marketing/lists'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
            <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Listas
        </a>
        <h1 class="h3 text-white fw-bold mb-0"><?php echo htmlspecialchars($list['name']); ?></h1>
        <p class="text-white-50 small mb-0 mt-1"><?php echo number_format($list['contact_count'] ?? 0); ?> contactos · Lista ID #<?php echo $list['id']; ?></p>
    </div>
    <div class="d-flex gap-2">
        <button type="button" class="btn btn-outline-light d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#addContactModal">
            <span class="material-symbols-outlined">person_add</span> Agregar Contacto
        </button>
        <button type="button" class="btn btn-success d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#importCsvModal">
            <span class="material-symbols-outlined">upload_file</span> Importar CSV
        </button>
    </div>
</div>

<!-- Filtros -->
<form method="GET" class="row g-2 mb-4 align-items-end">
    <div class="col-md-4">
        <input type="text" name="search" value="<?php echo htmlspecialchars($_GET['search'] ?? ''); ?>"
               class="form-control bg-black text-white border-white-10" placeholder="Buscar email, nombre...">
    </div>
    <div class="col-md-3">
        <select name="status" class="form-select bg-black text-white border-white-10">
            <option value="">Todos los estados</option>
            <option value="subscribed"   <?php if(($_GET['status']??'')==='subscribed')   echo 'selected'; ?>>Activos</option>
            <option value="unsubscribed" <?php if(($_GET['status']??'')==='unsubscribed') echo 'selected'; ?>>Desuscritos</option>
            <option value="bounced"      <?php if(($_GET['status']??'')==='bounced')      echo 'selected'; ?>>Rebotados</option>
            <option value="suppressed"   <?php if(($_GET['status']??'')==='suppressed')   echo 'selected'; ?>>Suprimidos</option>
        </select>
    </div>
    <div class="col-md-2">
        <button type="submit" class="btn btn-outline-light w-100">Filtrar</button>
    </div>
</form>

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
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">Compañía</th>
                        <th class="text-white-50 font-weight-normal border-bottom border-white-10 x-small uppercase tracking-widest bg-transparent p-3">País</th>
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
                            <td class="border-bottom border-white-10 bg-transparent text-white-50 p-3">
                                <?php echo htmlspecialchars($contact['company'] ?? '—'); ?>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent text-white-50 p-3">
                                <?php echo htmlspecialchars($contact['country'] ?? '—'); ?>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent p-3">
                                <?php
                                $statusMap = [
                                    'subscribed'   => ['bg-success',   'Activo'],
                                    'unsubscribed' => ['bg-secondary', 'Desuscrito'],
                                    'bounced'      => ['bg-danger',    'Rebotado'],
                                    'suppressed'   => ['bg-warning text-dark', 'Suprimido'],
                                ];
                                [$cls, $label] = $statusMap[$contact['status']] ?? ['bg-secondary', $contact['status']];
                                ?>
                                <span class="badge <?php echo $cls; ?>"><?php echo $label; ?></span>
                            </td>
                            <td class="border-bottom border-white-10 bg-transparent text-white-50 small p-3 text-end">
                                <?php echo date('d M, Y', strtotime($contact['created_at'])); ?>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="6" class="text-center text-white-50 p-5 bg-transparent">
                                <span class="material-symbols-outlined d-block mb-2" style="font-size:40px;opacity:.3;">group</span>
                                Esta lista aún no tiene contactos. ¡Importa tu primer CSV!
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- ==================== MODAL IMPORT CSV (2 pasos) ==================== -->
<div class="modal fade" id="importCsvModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content bg-midnight border-white-10 glass-morphism">

      <!-- PASO 1: Subir archivo -->
      <div id="csvStep1">
        <div class="modal-header border-white-10">
          <h5 class="modal-title text-white d-flex align-items-center gap-2">
            <span class="material-symbols-outlined">upload_file</span> Importar Contactos — Paso 1 de 2
          </h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="alert d-flex align-items-start gap-2 border-0" style="background:rgba(59,130,246,.1);color:#93c5fd;">
            <span class="material-symbols-outlined mt-1 fs-5">info</span>
            <div>
              <strong>Detección automática de columnas:</strong> Si tu CSV tiene los nombres de campos 
              iguales a los de la base de datos (<code>email</code>, <code>first_name</code>, etc.), 
              se mapearán automáticamente. De lo contrario, podrás asignar cada columna manualmente.
            </div>
          </div>
          <div class="mb-3 d-flex justify-content-between align-items-center">
            <label class="form-label text-white-50 x-small fw-bold uppercase mb-0">Archivo CSV o Excel (.csv)</label>
            <a href="<?php echo url('admin/marketing/downloadCsvTemplate'); ?>" class="btn btn-outline-info btn-sm d-flex align-items-center gap-1 py-1 px-2" style="font-size: 11px;">
              <span class="material-symbols-outlined fs-6">download</span> Descargar Plantilla .CSV
            </a>
          </div>
          <div class="mb-3">
            <input type="file" id="csvFileInput" accept=".csv" class="form-control bg-black text-white border-white-10">
          </div>
          <div id="csvPreviewArea" class="d-none">
            <p class="text-white-50 small mb-2">Columnas detectadas en el archivo:</p>
            <div id="csvColumnBadges" class="d-flex flex-wrap gap-2 mb-3"></div>
            <div id="csvAutoDetectMsg" class="d-none alert border-0 mb-0" style="background:rgba(16,185,129,.1);color:#6ee7b7;"></div>
          </div>
        </div>
        <div class="modal-footer border-white-10">
          <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
          <button type="button" id="btnNextStep" class="btn btn-primary d-flex align-items-center gap-2" disabled>
            Siguiente <span class="material-symbols-outlined">arrow_forward</span>
          </button>
        </div>
      </div>

      <!-- PASO 2: Mapeo de columnas -->
      <div id="csvStep2" class="d-none">
        <form id="csvImportForm" action="<?php echo url("admin/marketing/importContacts/{$list['id']}"); ?>"
              method="POST" enctype="multipart/form-data">
          <?php echo csrf_field(); ?>
          <input type="hidden" name="column_map" id="hiddenColumnMap">
          <input type="hidden" name="fixed_values" id="hiddenFixedValues">
          <div id="step2FileHolder"></div><!-- Para re-adjuntar el file input aquí -->

          <div class="modal-header border-white-10">
            <h5 class="modal-title text-white d-flex align-items-center gap-2">
              <span class="material-symbols-outlined">table_chart</span> Mapear Columnas — Paso 2 de 2
            </h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <p class="text-white-50 small mb-3">
              Asigna cada columna de tu archivo a un campo de la base de datos.
              El campo <strong>Email</strong> es obligatorio.
            </p>
            <div id="mappingTable" class="row g-3"></div>
          </div>
          <div class="modal-footer border-white-10">
            <button type="button" id="btnBackStep" class="btn btn-outline-light d-flex align-items-center gap-1">
              <span class="material-symbols-outlined">arrow_back</span> Atrás
            </button>
            <button type="submit" id="btnImport" class="btn btn-success d-flex align-items-center gap-2">
              <span class="material-symbols-outlined">upload</span> Importar ahora
            </button>
          </div>
        </form>
      </div>

    </div><!-- /.modal-content -->
  </div>
</div>

<!-- ==================== MODAL ADD INDIVIDUAL CONTACT ==================== -->
<div class="modal fade" id="addContactModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <form action="<?php echo url("admin/marketing/storeContact/{$list['id']}"); ?>" method="POST" class="modal-content bg-midnight border-white-10 glass-morphism">
      <?php echo csrf_field(); ?>
      <div class="modal-header border-white-10">
        <h5 class="modal-title text-white d-flex align-items-center gap-2">
          <span class="material-symbols-outlined">person_add</span> Agregar Contacto Individual
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="row g-3">
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Correo Electrónico *</label>
            <input type="email" name="email" class="form-control bg-black text-white border-white-10 p-2 rounded-2" required placeholder="ejemplo@correo.com">
          </div>
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Teléfono</label>
            <input type="text" name="phone" class="form-control bg-black text-white border-white-10 p-2 rounded-2" placeholder="+34 600 000 000">
          </div>
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Nombre</label>
            <input type="text" name="first_name" class="form-control bg-black text-white border-white-10 p-2 rounded-2" placeholder="Juan">
          </div>
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Apellido</label>
            <input type="text" name="last_name" class="form-control bg-black text-white border-white-10 p-2 rounded-2" placeholder="Pérez">
          </div>
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Compañía</label>
            <input type="text" name="company" class="form-control bg-black text-white border-white-10 p-2 rounded-2" placeholder="Mi Empresa S.A.">
          </div>
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">País</label>
            <input type="text" name="country" class="form-control bg-black text-white border-white-10 p-2 rounded-2" placeholder="España">
          </div>
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Industria</label>
            <input type="text" name="industry" class="form-control bg-black text-white border-white-10 p-2 rounded-2" placeholder="Tecnología">
          </div>
          <div class="col-md-6">
            <label class="form-label text-white-50 x-small fw-bold uppercase">Tags (separados por coma)</label>
            <input type="text" name="tags" class="form-control bg-black text-white border-white-10 p-2 rounded-2" placeholder="cliente, leads, 2026">
          </div>
        </div>
      </div>
      <div class="modal-footer border-white-10">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
        <button type="submit" class="btn btn-primary fw-bold px-4" style="background:linear-gradient(135deg,#6366f1,#D4AF37);color:#fff;border:none;">Agregar</button>
      </div>
    </form>
  </div>
</div>

<script>
(function () {
    // Campos de la BD y sus aliases comunes para autodetect
    const DB_FIELDS = {
        email:      { label: 'Email *',                  aliases: ['email','e-mail','correo','mail'] },
        first_name: { label: 'Nombre',                   aliases: ['first_name','firstname','nombre','name'] },
        last_name:  { label: 'Apellido',                 aliases: ['last_name','lastname','apellido','surname'] },
        phone:      { label: 'Teléfono',                 aliases: ['phone','telefono','tel','mobile','celular'] },
        company:    { label: 'Compañía',                 aliases: ['company','empresa','compania','organization'] },
        country:    { label: 'País',                     aliases: ['country','pais','país'] },
        industry:   { label: 'Industria',                aliases: ['industry','industria','sector'] },
        tags:       { label: 'Tags (coma separados)',    aliases: ['tags','etiquetas','labels'] },
    };

    let csvHeaders   = [];
    let autoMap      = {};   // dbField → csvColumn (autodetectado)
    let csvFile      = null;

    const fileInput      = document.getElementById('csvFileInput');
    const previewArea    = document.getElementById('csvPreviewArea');
    const badgesEl       = document.getElementById('csvColumnBadges');
    const autoDetectMsg  = document.getElementById('csvAutoDetectMsg');
    const btnNext        = document.getElementById('btnNextStep');
    const step1          = document.getElementById('csvStep1');
    const step2          = document.getElementById('csvStep2');
    const mappingTable   = document.getElementById('mappingTable');
    const hiddenMap      = document.getElementById('hiddenColumnMap');
    const step2FileHolder= document.getElementById('step2FileHolder');
    const btnBack        = document.getElementById('btnBackStep');
    const importForm     = document.getElementById('csvImportForm');

    /* -------- Leer cabecera del CSV en el navegador -------- */
    fileInput.addEventListener('change', function () {
        csvFile = this.files[0];
        if (!csvFile) return;

        const reader = new FileReader();
        reader.onload = (e) => {
            const firstLine = e.target.result.split('\n')[0] || '';
            // Detectar separador (coma, punto-y-coma o tab)
            const sep = firstLine.includes(';') ? ';' : firstLine.includes('\t') ? '\t' : ',';
            csvHeaders = firstLine.split(sep).map(h => h.trim().replace(/^"|"$/g,'').trim());

            // Mostrar badges
            badgesEl.innerHTML = '';
            csvHeaders.forEach(h => {
                const b = document.createElement('span');
                b.className = 'badge bg-white bg-opacity-10 text-white fw-normal';
                b.textContent = h;
                badgesEl.appendChild(b);
            });

            // Autodetect
            autoMap = {};
            Object.entries(DB_FIELDS).forEach(([field, info]) => {
                const match = csvHeaders.find(h =>
                    info.aliases.includes(h.toLowerCase().replace(/[\s-]/g,'_'))
                    || info.aliases.includes(h.toLowerCase())
                );
                if (match) autoMap[field] = match;
            });

            const matched = Object.keys(autoMap).length;
            if (autoMap.email) {
                autoDetectMsg.className = 'alert border-0 mb-0';
                autoDetectMsg.style.cssText = 'background:rgba(16,185,129,.1);color:#6ee7b7;';
                autoDetectMsg.textContent = `✓ Se detectaron ${matched} columna(s) automáticamente. Puedes ajustar el mapeo en el siguiente paso.`;
            } else {
                autoDetectMsg.className = 'alert border-0 mb-0';
                autoDetectMsg.style.cssText = 'background:rgba(245,158,11,.1);color:#fcd34d;';
                autoDetectMsg.textContent = 'No se pudo autodetectar el campo Email. Por favor, asígnalo manualmente en el siguiente paso.';
            }
            autoDetectMsg.classList.remove('d-none');
            previewArea.classList.remove('d-none');
            btnNext.disabled = false;
        };
        reader.readAsText(csvFile, 'UTF-8');
    });

    /* -------- Paso 1 → Paso 2 -------- */
    btnNext.addEventListener('click', function () {
        // Construir tabla de mapeo
        mappingTable.innerHTML = '';
        Object.entries(DB_FIELDS).forEach(([field, info]) => {
            const currentVal = autoMap[field] || '';
            const col = document.createElement('div');
            col.className = 'col-md-6';
            col.innerHTML = `
              <label class="form-label text-white-50 x-small fw-bold uppercase mb-1 d-block">${info.label}</label>
              <div class="input-group">
                <select class="form-select bg-black text-white border-white-10 text-truncate" data-dbfield="${field}" id="map_${field}" style="max-width: 55%;">
                  <option value="">— Columna CSV —</option>
                  ${csvHeaders.map(h =>
                      `<option value="${h}" ${h === currentVal ? 'selected' : ''}>${h}</option>`
                  ).join('')}
                </select>
                <span class="input-group-text bg-dark border-white-10 text-white-50 x-small px-2">o</span>
                <input type="text" class="form-control bg-black text-white border-white-10" data-fixedfield="${field}" id="fixed_${field}" placeholder="Valor Fijo" style="font-size: 13px;">
              </div>`;
            mappingTable.appendChild(col);
        });

        // Mover el file input al formulario de paso 2
        step2FileHolder.innerHTML = '';
        // No podemos mover el input por seguridad; crearemos un DataTransfer
        const dt = new DataTransfer();
        dt.items.add(csvFile);
        const hiddenFile = document.createElement('input');
        hiddenFile.type = 'file';
        hiddenFile.name = 'csv_file';
        hiddenFile.style.display = 'none';
        hiddenFile.files; // trigger
        step2FileHolder.appendChild(hiddenFile);
        // Usar objeto FileList
        try { hiddenFile.files = dt.files; } catch(e) {}

        step1.classList.add('d-none');
        step2.classList.remove('d-none');
    });

    /* -------- Paso 2 → Paso 1 -------- */
    btnBack.addEventListener('click', function () {
        step2.classList.add('d-none');
        step1.classList.remove('d-none');
    });

    /* -------- Submit: serializar el mapeo + adjuntar el file via FormData -------- */
    importForm.addEventListener('submit', function (e) {
        e.preventDefault();

        // Leer el mapeo actual desde los selects
        const map = {};
        document.querySelectorAll('[data-dbfield]').forEach(sel => {
            if (sel.value) map[sel.dataset.dbfield] = sel.value;
        });

        // Leer valores fijos
        const fixedValues = {};
        document.querySelectorAll('[data-fixedfield]').forEach(inp => {
            const val = inp.value.trim();
            if (val) fixedValues[inp.dataset.fixedfield] = val;
        });

        if (!map.email && !fixedValues.email) {
            alert('El campo Email es obligatorio. Por favor, asígnalo a una columna del CSV o escribe un valor fijo.');
            return;
        }

        hiddenMap.value = JSON.stringify(map);
        document.getElementById('hiddenFixedValues').value = JSON.stringify(fixedValues);

        // Construir un FormData con el File original + los campos del form
        const fd = new FormData(importForm);
        // Quitar el input file vacío y añadir el archivo real
        fd.delete('csv_file');
        fd.append('csv_file', csvFile, csvFile.name);

        // Mostrar spinner
        const btn = document.getElementById('btnImport');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Importando...';

        fetch(importForm.action, {
            method: 'POST',
            body: fd,
        }).then(r => {
            // El servidor redirige, seguimos la redirección
            window.location.href = r.url || window.location.href;
        }).catch(() => {
            importForm.submit();
        });
    });
})();
</script>
