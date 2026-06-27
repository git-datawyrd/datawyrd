<?php
$isEdit     = !empty($template);
$tId        = $isEdit ? (int)$template['id'] : 0;
$actionUrl  = $isEdit
    ? url("admin/marketing/updateTemplate/{$tId}")
    : url('admin/marketing/storeTemplate');
?>
<style>
/* ============================================================
   EDITOR DE PLANTILLAS — ESTILOS
   ============================================================ */
#editor-canvas {
    min-height: 500px;
    background: repeating-linear-gradient(
        0deg, transparent, transparent 39px,
        rgba(255,255,255,.04) 39px, rgba(255,255,255,.04) 40px
    ),
    repeating-linear-gradient(
        90deg, transparent, transparent 39px,
        rgba(255,255,255,.04) 39px, rgba(255,255,255,.04) 40px
    );
    background-size: 40px 40px;
}
.block-item {
    position: relative;
    border: 1px solid transparent;
    border-radius: 6px;
    transition: border-color .2s;
    cursor: grab;
}
.block-item:hover   { border-color: rgba(99,102,241,.5); }
.block-item.selected { border-color: #6366f1 !important; box-shadow: 0 0 0 2px rgba(99,102,241,.25); }
.block-controls {
    position: absolute;
    top: 6px; right: 6px;
    display: none;
    gap: 4px;
    z-index: 10;
}
.block-item:hover .block-controls,
.block-item.selected .block-controls { display: flex; }
.block-btn {
    width: 26px; height: 26px;
    border: none; border-radius: 4px;
    background: rgba(0,0,0,.7);
    color: #fff; font-size: 14px;
    cursor: pointer; display: flex; align-items: center; justify-content: center;
}
.block-btn:hover { background: #6366f1; }
.sidebar-block {
    background: rgba(255,255,255,.06);
    border: 1px dashed rgba(255,255,255,.15);
    border-radius: 8px;
    padding: 10px;
    cursor: grab;
    text-align: center;
    font-size: 11px;
    color: rgba(255,255,255,.6);
    transition: background .2s, border-color .2s;
    user-select: none;
}
.sidebar-block:hover {
    background: rgba(99,102,241,.15);
    border-color: #6366f1;
    color: #fff;
}
.tag-chip {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 20px;
    background: rgba(99,102,241,.2);
    border: 1px solid rgba(99,102,241,.4);
    font-size: 11px;
    color: #a5b4fc;
    cursor: pointer;
    transition: background .2s;
}
.tag-chip:hover { background: rgba(99,102,241,.4); color: #fff; }
#ai-modal .modal-content { border-radius: 16px; }

/* === AI Improve Button === */
.ai-improve-btn {
    background: none;
    border: none;
    padding: 0 4px;
    cursor: pointer;
    color: #a5b4fc;
    line-height: 1;
    transition: color .2s, transform .2s;
    vertical-align: middle;
}
.ai-improve-btn:hover { color: #D4AF37; transform: scale(1.15); }
.ai-improve-btn.spinning span { animation: spin-icon 0.8s linear infinite; display: inline-block; }
@keyframes spin-icon { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }

/* === Rebranding Gradient === */
.text-gradient-branding {
    background: linear-gradient(90deg, #D4AF37 0%, #30C5FF 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    font-weight: 700;
}
</style>

<div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
    <div>
        <a href="<?php echo url('admin/marketing/templates'); ?>" class="text-white-50 text-decoration-none d-flex align-items-center gap-1 x-small fw-bold uppercase tracking-widest mb-2">
            <span class="material-symbols-outlined fs-6">arrow_back</span> Volver a Plantillas
        </a>
        <h1 class="h3 text-white fw-bold mb-0"><?php echo $isEdit ? 'Editar Plantilla' : 'Nueva Plantilla'; ?></h1>
    </div>
    <div class="d-flex gap-2 flex-wrap">
        <button type="button" id="btnToggleMode" class="btn btn-outline-light d-flex align-items-center gap-1" title="Alternar vista HTML / Visual">
            <span class="material-symbols-outlined fs-5">code</span> Vista HTML
        </button>
        <button type="button" id="btnRebranding" class="btn btn-outline-light d-flex align-items-center gap-1" title="Reemplazar palabra en todo el contenido"
                data-bs-toggle="modal" data-bs-target="#rebrandingModal">
            <span class="material-symbols-outlined fs-5">find_replace</span> Rebranding
        </button>
        <button type="button" id="btnAiCopilot" class="btn d-flex align-items-center gap-1"
                style="background:linear-gradient(135deg,#6366f1,#D4AF37);color:#fff;font-weight:700;"
                data-bs-toggle="modal" data-bs-target="#ai-modal">
            <span class="material-symbols-outlined fs-5">auto_awesome</span> Copilot IA
        </button>
        <button type="submit" form="templateForm" class="btn btn-primary d-flex align-items-center gap-2 fw-bold">
            <span class="material-symbols-outlined fs-5">save</span> Guardar
        </button>
    </div>
</div>

<form id="templateForm" action="<?php echo $actionUrl; ?>" method="POST">
    <?php echo csrf_field(); ?>
    <!-- Campos meta -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Nombre Interno *</label>
            <input type="text" name="name" class="form-control bg-black text-white border-white-10 p-3 rounded-3"
                   required placeholder="Ej: Newsletter Junio"
                   value="<?php echo htmlspecialchars($template['name'] ?? ''); ?>">
        </div>
        <div class="col-md-3">
            <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Categoría</label>
            <input type="text" name="category" class="form-control bg-black text-white border-white-10 p-3 rounded-3"
                   placeholder="Ej: Promociones"
                   value="<?php echo htmlspecialchars($template['category'] ?? ''); ?>">
        </div>
        <div class="col-md-5">
            <label class="form-label text-white-50 x-small fw-bold uppercase tracking-widest">Asunto</label>
            <input type="text" name="subject" class="form-control bg-black text-white border-white-10 p-3 rounded-3"
                   placeholder="Ej: ¡Descubre nuestra oferta especial!"
                   value="<?php echo htmlspecialchars($template['subject'] ?? ''); ?>">
        </div>
    </div>

    <!-- Variables disponibles (tags) -->
    <div class="d-flex align-items-center flex-wrap gap-2 mb-3">
        <span class="text-white-50 x-small fw-bold uppercase tracking-widest me-1">Variables:</span>
        <?php
        $vars = ['{first_name|Estimado cliente}', '{last_name}', '{email}', '{company}', '{phone}', '{full_name|Cliente}'];
        foreach ($vars as $v):
        ?>
        <span class="tag-chip" onclick="insertTag('<?php echo $v; ?>')"><?php echo $v; ?></span>
        <?php endforeach; ?>
    </div>

    <!-- Editor principal: 2 paneles -->
    <div class="row g-3">
        <!-- Sidebar de bloques -->
        <div class="col-lg-2 col-md-3" id="blockSidebar">
            <div class="card glass-morphism border-0 h-100">
                <div class="card-header border-bottom border-white-10 bg-transparent py-2 px-3">
                    <h6 class="text-white-50 x-small fw-bold uppercase mb-0">Bloques</h6>
                </div>
                <div class="card-body p-2 d-flex flex-column gap-2">
                    <div class="sidebar-block" draggable="true" data-type="heading">
                        <span class="material-symbols-outlined d-block mb-1" style="font-size:22px;">title</span>
                        Título
                    </div>
                    <div class="sidebar-block" draggable="true" data-type="text">
                        <span class="material-symbols-outlined d-block mb-1" style="font-size:22px;">notes</span>
                        Párrafo
                    </div>
                    <div class="sidebar-block" draggable="true" data-type="button">
                        <span class="material-symbols-outlined d-block mb-1" style="font-size:22px;">smart_button</span>
                        Botón
                    </div>
                    <div class="sidebar-block" draggable="true" data-type="image">
                        <span class="material-symbols-outlined d-block mb-1" style="font-size:22px;">image</span>
                        Imagen
                    </div>
                    <div class="sidebar-block" draggable="true" data-type="divider">
                        <span class="material-symbols-outlined d-block mb-1" style="font-size:22px;">horizontal_rule</span>
                        Divisor
                    </div>
                    <div class="sidebar-block" draggable="true" data-type="columns">
                        <span class="material-symbols-outlined d-block mb-1" style="font-size:22px;">view_column</span>
                        2 Columnas
                    </div>
                    <div class="sidebar-block" draggable="true" data-type="html">
                        <span class="material-symbols-outlined d-block mb-1" style="font-size:22px;">code</span>
                        HTML libre
                    </div>
                </div>
            </div>
        </div>

        <!-- Canvas del editor visual -->
        <div class="col-lg-7 col-md-9" id="editorCol">
            <div class="card glass-morphism border-0">
                <div class="card-header border-bottom border-white-10 bg-transparent py-2 px-3 d-flex justify-content-between align-items-center">
                    <h6 class="text-white-50 x-small fw-bold uppercase mb-0">Canvas — arrastra bloques aquí</h6>
                    <button type="button" id="btnPreview" class="btn btn-sm btn-outline-light d-flex align-items-center gap-1">
                        <span class="material-symbols-outlined fs-6">visibility</span> Preview
                    </button>
                </div>
                <div class="card-body p-3">
                    <!-- Canvas visual -->
                    <div id="editor-canvas" class="p-3 rounded-3" style="min-height:500px;"></div>
                    <!-- textarea oculto que sincroniza el HTML compilado -->
                    <textarea name="html_body" id="html_body_field" class="form-control bg-black text-white border-white-10 p-3 rounded-3 font-monospace d-none"
                              rows="20" placeholder="<html>...</html>"><?php echo htmlspecialchars($template['html_body'] ?? ''); ?></textarea>
                </div>
            </div>
        </div>

        <!-- Panel de propiedades -->
        <div class="col-lg-3" id="propsPanel">
            <div class="card glass-morphism border-0">
                <div class="card-header border-bottom border-white-10 bg-transparent py-2 px-3">
                    <h6 class="text-white-50 x-small fw-bold uppercase mb-0">Propiedades</h6>
                </div>
                <div class="card-body p-3" id="propsContent">
                    <p class="text-white-50 small text-center mt-4">Selecciona un bloque para editar sus propiedades.</p>
                </div>
            </div>
        </div>
    </div>
</form>

<!-- ==================== MODAL COPILOT IA ==================== -->
<div class="modal fade" id="ai-modal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content glass-morphism border-white-10">
      <div class="modal-header border-white-10" style="background:linear-gradient(135deg,rgba(99,102,241,.15),rgba(212,175,55,.1));">
        <h5 class="modal-title text-white d-flex align-items-center gap-2">
          <span class="material-symbols-outlined" style="color:#D4AF37;">auto_awesome</span>
          <span>Copilot IA</span>
          <span class="badge ms-1" style="background:linear-gradient(135deg,#6366f1,#D4AF37);font-size:10px;">BETA</span>
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="mb-3">
          <label class="form-label text-white-50 x-small fw-bold uppercase">¿Qué email quieres generar?</label>
          <textarea id="aiBrief" class="form-control bg-black text-white border-white-10 p-3 rounded-3" rows="4"
                    placeholder="Ej: Email de bienvenida para nuevos clientes de una agencia de marketing digital. Tono profesional, con oferta del 20% en el primer mes. Incluir CTA a la plataforma."></textarea>
        </div>
        <div id="aiVariantsArea" class="d-none">
          <p class="text-white-50 x-small fw-bold uppercase mb-2">Elige una variante:</p>
          <div id="aiVariants" class="row g-3"></div>
        </div>
        <div id="aiSpinner" class="text-center py-4 d-none">
          <div class="spinner-border" style="color:#D4AF37;" role="status"></div>
          <p class="text-white-50 mt-2 small">Generando variantes con IA...<br><small class="opacity-50">Esto puede tardar unos segundos.</small></p>
        </div>
        <div id="aiError" class="d-none mt-3 p-3 rounded-3" style="background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.3);color:#fca5a5;"></div>
      </div>
      <div class="modal-footer border-white-10">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" id="btnGenerateAI" class="btn fw-bold d-flex align-items-center gap-2"
                style="background:linear-gradient(135deg,#6366f1,#D4AF37);color:#fff;">
          <span class="material-symbols-outlined">auto_awesome</span> Generar con IA
        </button>
      </div>
    </div>
  </div>
</div>

<!-- ==================== MODAL REBRANDING ==================== -->
<div class="modal fade" id="rebrandingModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content glass-morphism border-white-10">
      <div class="modal-header border-white-10" style="background:rgba(212,175,55,.08);">
        <h5 class="modal-title text-white d-flex align-items-center gap-2">
          <span class="material-symbols-outlined" style="color:#D4AF37;">find_replace</span> Rebranding — Buscar y Reemplazar
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="alert border-0 mb-3 d-flex align-items-start gap-2 p-3" style="background:rgba(99,102,241,.1);color:#a5b4fc;border-radius:10px;">
          <span class="material-symbols-outlined mt-1 fs-6">info</span>
          <span class="small">Reemplaza una palabra o frase en <strong>todo el contenido HTML</strong> del email. Útil para actualizar el nombre de tu empresa, producto o URL.</span>
        </div>
        <div class="mb-3">
          <label class="form-label text-white-50 x-small fw-bold uppercase">Buscar (texto actual)</label>
          <input type="text" id="rebrandFind" class="form-control bg-black text-white border-white-10 p-3 rounded-3" placeholder="Ej: Empresa Antigua">
        </div>
        <div class="mb-3">
          <label class="form-label text-white-50 x-small fw-bold uppercase">Reemplazar con</label>
          <input type="text" id="rebrandReplace" class="form-control bg-black text-white border-white-10 p-3 rounded-3" placeholder="Ej: Data Wyrd">
        </div>
        <div id="rebrandResult" class="d-none small py-2 px-3 rounded-3" style="background:rgba(34,197,94,.1);color:#86efac;"></div>
      </div>
      <div class="modal-footer border-white-10">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" id="btnReplace" class="btn btn-primary fw-bold d-flex align-items-center gap-2">
          <span class="material-symbols-outlined fs-5">find_replace</span> Aplicar Reemplazo
        </button>
      </div>
    </div>
  </div>
</div>

<!-- ==================== MODAL PREVIEW ==================== -->
<div class="modal fade" id="previewModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-xl">
    <div class="modal-content bg-white border-0 rounded-4">
      <div class="modal-header bg-light">
        <h6 class="modal-title text-dark">Preview del Email</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body p-0">
        <iframe id="previewFrame" style="width:100%;height:600px;border:none;"></iframe>
      </div>
    </div>
  </div>
</div>

<script>
/* ================================================================
   EDITOR DRAG-AND-DROP — Motor
   ================================================================ */
(function () {

    // ---- Estado del editor ----
    let blocks    = [];   // Array de objetos {id, type, props}
    let selectedId = null;
    let isDirty   = false;
    let htmlMode  = false;

    const canvas     = document.getElementById('editor-canvas');
    const htmlField  = document.getElementById('html_body_field');
    const propsPanel = document.getElementById('propsContent');

    // --- Generador de IDs únicos ---
    const uid = () => Math.random().toString(36).substr(2, 9);

    /* ============================================================
       DEFINICIÓN DE BLOQUES
       ============================================================ */
    const BLOCK_DEFAULTS = {
        heading: {
            tag:   'h2',
            text:  'Tu título aquí',
            color: '#ffffff',
            align: 'center',
            size:  '28px',
        },
        text: {
            text:  'Escribe tu párrafo aquí. Puedes usar variables como {first_name|Estimado cliente} para personalizar.',
            color: '#cccccc',
            align: 'left',
            size:  '15px',
        },
        button: {
            text:   'Haz clic aquí',
            url:    'https://',
            color:  '#ffffff',
            bg:     '#6366f1',
            align:  'center',
        },
        image: {
            src:    'https://via.placeholder.com/600x200/1e1b4b/ffffff?text=Tu+Imagen',
            alt:    'Imagen del email',
            width:  '100%',
            align:  'center',
            url:    '',
        },
        divider: { color: '#333333', height: '1px', margin: '20px' },
        columns: {
            col1: 'Columna izquierda',
            col2: 'Columna derecha',
            color: '#cccccc',
        },
        html: { code: '<p style="color:#ccc;">HTML personalizado</p>' },
    };

    /* ============================================================
       RENDERIZADO DE BLOQUE A HTML
       ============================================================ */
    function blockToHtml(b) {
        const p = b.props;
        switch (b.type) {
            case 'heading':
                return `<${p.tag} style="color:${p.color};text-align:${p.align};font-size:${p.size};font-family:Arial,sans-serif;margin:0 0 16px;">${p.text}</${p.tag}>`;
            case 'text':
                return `<p style="color:${p.color};text-align:${p.align};font-size:${p.size};font-family:Arial,sans-serif;line-height:1.7;margin:0 0 16px;">${p.text}</p>`;
            case 'button':
                return `<div style="text-align:${p.align};margin:20px 0;">
                    <a href="${p.url}" style="background:${p.bg};color:${p.color};padding:12px 28px;border-radius:6px;text-decoration:none;font-family:Arial,sans-serif;font-size:15px;font-weight:bold;display:inline-block;">${p.text}</a>
                  </div>`;
            case 'image':
                if (p.url && p.url.trim() !== '') {
                    return `<div style="text-align:${p.align};margin:16px 0;">
                        <a href="${p.url}" target="_blank" style="display:inline-block;width:${p.width};">
                            <img src="${p.src}" alt="${p.alt}" width="100%" style="max-width:100%;border-radius:4px;border:none;display:block;">
                        </a>
                    </div>`;
                }
                return `<div style="text-align:${p.align};margin:16px 0;"><img src="${p.src}" alt="${p.alt}" width="${p.width}" style="max-width:100%;border-radius:4px;"></div>`;
            case 'divider':
                return `<hr style="border:none;border-top:${p.height} solid ${p.color};margin:${p.margin} 0;">`;
            case 'columns':
                return `<table width="100%" cellpadding="12" cellspacing="0" style="margin:12px 0;">
                    <tr>
                      <td width="50%" valign="top" style="color:${p.color};font-family:Arial,sans-serif;font-size:14px;">${p.col1}</td>
                      <td width="50%" valign="top" style="color:${p.color};font-family:Arial,sans-serif;font-size:14px;">${p.col2}</td>
                    </tr>
                  </table>`;
            case 'html':
                return p.code;
            default: return '';
        }
    }

    /* ============================================================
       RENDER DEL CANVAS
       ============================================================ */
    function render() {
        canvas.innerHTML = '';
        blocks.forEach(b => {
            const wrapper = document.createElement('div');
            wrapper.className = 'block-item p-2 mb-2' + (b.id === selectedId ? ' selected' : '');
            wrapper.dataset.id = b.id;

            const controls = document.createElement('div');
            controls.className = 'block-controls';
            controls.innerHTML = `
              <button type="button" class="block-btn" data-action="up"    title="Subir">▲</button>
              <button type="button" class="block-btn" data-action="down"  title="Bajar">▼</button>
              <button type="button" class="block-btn" data-action="dup"   title="Duplicar">⧉</button>
              <button type="button" class="block-btn" data-action="del"   title="Eliminar" style="background:rgba(239,68,68,.7);">✕</button>`;
            wrapper.appendChild(controls);

            const content = document.createElement('div');
            content.innerHTML = blockToHtml(b);
            wrapper.appendChild(content);

            // Drag de reordenamiento
            wrapper.draggable = true;
            wrapper.addEventListener('dragstart', e => {
                e.dataTransfer.setData('moveId', b.id);
            });
            wrapper.addEventListener('dragover',  e => { e.preventDefault(); wrapper.style.borderColor = '#6366f1'; });
            wrapper.addEventListener('dragleave', () => { wrapper.style.borderColor = ''; });
            wrapper.addEventListener('drop', e => {
                e.preventDefault();
                e.stopPropagation();
                wrapper.style.borderColor = '';
                const moveId = e.dataTransfer.getData('moveId');
                const type   = e.dataTransfer.getData('blockType');
                if (moveId && moveId !== b.id) {
                    const fromIdx = blocks.findIndex(x => x.id === moveId);
                    const toIdx   = blocks.findIndex(x => x.id === b.id);
                    const [moved] = blocks.splice(fromIdx, 1);
                    blocks.splice(toIdx, 0, moved);
                    render(); syncHtml();
                } else if (type) {
                    const toIdx = blocks.findIndex(x => x.id === b.id);
                    const newBlock = {
                        id: uid(),
                        type,
                        props: JSON.parse(JSON.stringify(BLOCK_DEFAULTS[type] ?? {})),
                    };
                    blocks.splice(toIdx, 0, newBlock);
                    selectedId = newBlock.id;
                    render();
                    showProps(newBlock);
                    isDirty = true;
                }
            });

            // Seleccionar
            wrapper.addEventListener('click', e => {
                if (e.target.closest('.block-controls')) return;
                selectedId = b.id;
                render();
                showProps(b);
            });

            // Acciones de control
            controls.addEventListener('click', e => {
                const btn = e.target.closest('[data-action]');
                if (!btn) return;
                const action = btn.dataset.action;
                const idx = blocks.findIndex(x => x.id === b.id);
                if (action === 'up'  && idx > 0)               { [blocks[idx-1], blocks[idx]] = [blocks[idx], blocks[idx-1]]; }
                if (action === 'down'&& idx < blocks.length-1) { [blocks[idx], blocks[idx+1]] = [blocks[idx+1], blocks[idx]]; }
                if (action === 'dup')                           { blocks.splice(idx+1, 0, {...b, id: uid(), props: {...b.props}}); }
                if (action === 'del')                           { blocks.splice(idx, 1); selectedId = null; propsPanel.innerHTML = '<p class="text-white-50 small text-center mt-4">Selecciona un bloque.</p>'; }
                render(); syncHtml();
            });

            canvas.appendChild(wrapper);
        });

        // Drop zone al final del canvas
        canvas.ondragover = e => e.preventDefault();
        canvas.ondrop = e => {
            e.preventDefault();
            const type = e.dataTransfer.getData('blockType');
            if (type) {
                addBlock(type);
            }
        };

        syncHtml();
    }

    /* ============================================================
       PANEL DE PROPIEDADES
       ============================================================ */
    function showProps(b) {
        const p = b.props;
        // Helper: adds an AI-improve button after a textarea or text input
        const aiBtn = (propName) =>
            `<button type="button" class="ai-improve-btn" data-ai-prop="${propName}" title="Mejorar texto con IA">
               <span class="material-symbols-outlined" style="font-size:18px;">magic_button</span>
             </button>`;

        const field = (label, name, val, type = 'text') =>
            `<div class="mb-2">
               <div class="d-flex align-items-center justify-content-between mb-1">
                 <label class="form-label text-white-50 x-small mb-0">${label}</label>
                 ${(name === 'text' || name === 'col1' || name === 'col2' || name === 'code') ? aiBtn(name) : ''}
               </div>
               <input type="${type}" class="form-control form-control-sm bg-black text-white border-white-10 prop-field"
                      data-prop="${name}" value="${escHtml(String(val ?? ''))}">  
             </div>`;

        const textarea = (label, name, val) =>
            `<div class="mb-2">
               <div class="d-flex align-items-center justify-content-between mb-1">
                 <label class="form-label text-white-50 x-small mb-0">${label}</label>
                 ${aiBtn(name)}
               </div>
               <textarea class="form-control form-control-sm bg-black text-white border-white-10 prop-field" rows="4"
                         data-prop="${name}">${escHtml(String(val ?? ''))}</textarea>
             </div>`;

        const color = (label, name, val) =>
            `<div class="mb-2 d-flex align-items-center gap-2">
               <label class="form-label text-white-50 x-small mb-0 flex-grow-1">${label}</label>
               <input type="color" class="form-control form-control-color border-white-10 prop-field"
                      data-prop="${name}" value="${val ?? '#ffffff'}" style="width:40px;height:32px;">
             </div>`;

        const select = (label, name, val, options) =>
            `<div class="mb-2">
               <label class="form-label text-white-50 x-small mb-1">${label}</label>
               <select class="form-select form-select-sm bg-black text-white border-white-10 prop-field" data-prop="${name}">
                 ${options.map(o => `<option value="${o}" ${val===o?'selected':''}>${o}</option>`).join('')}
               </select>
             </div>`;

        switch (b.type) {
            case 'heading':
                html = field('Texto', 'text', p.text)
                     + select('Tag HTML', 'tag', p.tag, ['h1','h2','h3','h4'])
                     + field('Tamaño (px)', 'size', p.size)
                     + select('Alineación', 'align', p.align, ['left','center','right'])
                     + color('Color', 'color', p.color);
                break;
            case 'text':
                html = textarea('Texto', 'text', p.text)
                     + field('Tamaño (px)', 'size', p.size)
                     + select('Alineación', 'align', p.align, ['left','center','right'])
                     + color('Color', 'color', p.color);
                break;
            case 'button':
                html = field('Texto del botón', 'text', p.text)
                     + field('URL', 'url', p.url, 'url')
                     + select('Alineación', 'align', p.align, ['left','center','right'])
                     + color('Color texto', 'color', p.color)
                     + color('Color fondo', 'bg', p.bg);
                break;
            case 'image':
                html = field('URL de imagen', 'src', p.src, 'url')
                     + field('Texto alternativo', 'alt', p.alt)
                     + field('Enlace (URL al hacer clic)', 'url', p.url || '', 'url')
                     + field('Ancho', 'width', p.width)
                     + select('Alineación', 'align', p.align, ['left','center','right']);
                break;
            case 'divider':
                html = color('Color', 'color', p.color)
                     + field('Altura', 'height', p.height)
                     + field('Margen vertical', 'margin', p.margin);
                break;
            case 'columns':
                html = textarea('Columna izquierda (HTML)', 'col1', p.col1)
                     + textarea('Columna derecha (HTML)', 'col2', p.col2)
                     + color('Color texto', 'color', p.color);
                break;
            case 'html':
                html = textarea('Código HTML', 'code', p.code);
                break;
        }

        propsPanel.innerHTML = `
          <p class="text-white-50 x-small fw-bold uppercase mb-3">${b.type.toUpperCase()}</p>
          ${html}
          <hr class="border-white-10 my-3">
          <p class="text-white-50 x-small fw-bold uppercase mb-2">Atajos</p>
          <div class="d-flex flex-wrap gap-1">
            <?php
            $vars = ['{first_name|Estimado cliente}', '{last_name}', '{email}', '{company}'];
            foreach ($vars as $v): ?>
            <span class="tag-chip" onclick="injectTagToBlock('<?php echo $v; ?>')">{'<?php echo $v; ?>'}</span>
            <?php endforeach; ?>
          </div>`;

        // Escuchar cambios en tiempo real
        propsPanel.querySelectorAll('.prop-field').forEach(el => {
            el.addEventListener('input', () => {
                const prop = el.dataset.prop;
                b.props[prop] = el.value;
                render();
            });
        });

        // AI improve buttons
        propsPanel.querySelectorAll('.ai-improve-btn').forEach(btn => {
            btn.addEventListener('click', async () => {
                const propName = btn.dataset.aiProp;
                const field = propsPanel.querySelector(`[data-prop="${propName}"]`);
                if (!field || !field.value.trim()) return;

                const origIcon = btn.innerHTML;
                btn.classList.add('spinning');
                btn.disabled = true;

                try {
                    const resp = await fetch('<?php echo url("admin/marketing/improveText"); ?>', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-Requested-With': 'XMLHttpRequest',
                            'X-CSRF-TOKEN': document.querySelector('input[name="_token"]')?.value || ''
                        },
                        body: JSON.stringify({ text: field.value })
                    });
                    const data = await resp.json();
                    if (data.improved) {
                        field.value = data.improved;
                        field.dispatchEvent(new Event('input'));
                        field.style.borderColor = '#22c55e';
                        setTimeout(() => field.style.borderColor = '', 1200);
                    } else {
                        alert(data.error || 'No se pudo mejorar el texto.');
                    }
                } catch(e) {
                    alert('Error de conexión con el servicio de IA.');
                } finally {
                    btn.classList.remove('spinning');
                    btn.disabled = false;
                    btn.innerHTML = origIcon;
                }
            });
        });
    }  // end showProps

    function escHtml(str) {
        return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    /* ============================================================
       AÑADIR BLOQUE
       ============================================================ */
    function addBlock(type) {
        const b = {
            id: uid(),
            type,
            props: JSON.parse(JSON.stringify(BLOCK_DEFAULTS[type] ?? {})),
        };
        blocks.push(b);
        selectedId = b.id;
        render();
        showProps(b);
        isDirty = true;
    }

    /* ============================================================
       SINCRONIZAR HTML → TEXTAREA
       ============================================================ */
    function syncHtml() {
        const inner = blocks.map(blockToHtml).join('\n');
        const full = `<!DOCTYPE html>
<html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head>
<body style="background:#0f0e17;margin:0;padding:24px;font-family:Arial,sans-serif;">
<div style="max-width:600px;margin:0 auto;background:#1a1a2e;border-radius:8px;padding:32px;">
${inner}
</div>
</body></html>`;
        htmlField.value = full;
    }

    /* ============================================================
       SIDEBAR DRAG — desde bloques laterales al canvas
       ============================================================ */
    document.querySelectorAll('.sidebar-block').forEach(el => {
        el.addEventListener('dragstart', e => {
            e.dataTransfer.setData('blockType', el.dataset.type);
        });
        el.addEventListener('click', () => addBlock(el.dataset.type));
    });

    /* ============================================================
       TOGGLE MODO HTML / VISUAL
       ============================================================ */
    const btnToggle = document.getElementById('btnToggleMode');
    btnToggle.addEventListener('click', () => {
        htmlMode = !htmlMode;
        if (htmlMode) {
            canvas.classList.add('d-none');
            document.getElementById('blockSidebar').classList.add('d-none');
            document.getElementById('propsPanel').classList.add('d-none');
            htmlField.classList.remove('d-none');
            htmlField.style.minHeight = '600px';
            btnToggle.innerHTML = '<span class="material-symbols-outlined">view_quilt</span> Vista Visual';
        } else {
            canvas.classList.remove('d-none');
            document.getElementById('blockSidebar').classList.remove('d-none');
            document.getElementById('propsPanel').classList.remove('d-none');
            htmlField.classList.add('d-none');
            btnToggle.innerHTML = '<span class="material-symbols-outlined">code</span> Vista HTML';
        }
    });

    /* ============================================================
       PREVIEW MODAL
       ============================================================ */
    document.getElementById('btnPreview').addEventListener('click', () => {
        syncHtml();
        const previewModal = new bootstrap.Modal(document.getElementById('previewModal'));
        document.getElementById('previewFrame').srcdoc = htmlField.value;
        previewModal.show();
    });

    /* ============================================================
       INJECT TAG INTO ACTIVE BLOCK (used by props panel shortcuts)
       ============================================================ */
    window.injectTagToBlock = function(tag) {
        if (!selectedId) return;
        const b = blocks.find(x => x.id === selectedId);
        if (!b) return;
        // Append to whichever text field is primary for this block type
        const propKey = ['heading'].includes(b.type) ? 'text' :
                        b.type === 'columns' ? 'col1' :
                        b.type === 'html' ? 'code' : 'text';
        if (b.props[propKey] !== undefined) {
            b.props[propKey] += ' ' + tag;
            render();
            showProps(b);
        }
    };

    /* ============================================================
       CARGAR CONTENIDO EXISTENTE (modo edición)
       ============================================================ */
    const existingHtml = htmlField.value.trim();
    if (existingHtml) {
        // En modo edición, mostrar directamente el HTML en modo código
        // (el canvas visual empieza vacío; el usuario puede alternar)
        // Extraer contenido del div central si es posible
        const match = existingHtml.match(/<div[^>]*>([\s\S]*?)<\/div>\s*<\/body>/);
        if (!match) {
            // Si el HTML tiene estructura propia, ir directo a modo HTML
            htmlMode = true;
            canvas.classList.add('d-none');
            document.getElementById('blockSidebar').classList.add('d-none');
            document.getElementById('propsPanel').classList.add('d-none');
            htmlField.classList.remove('d-none');
            htmlField.style.minHeight = '600px';
            btnToggle.innerHTML = '<span class="material-symbols-outlined">view_quilt</span> Vista Visual';
        }
    } else {
        // Nueva plantilla: iniciar con bloque de heading por defecto
        addBlock('heading');
        addBlock('text');
    }

    /* ============================================================
       COPILOT IA
       ============================================================ */
    document.getElementById('btnGenerateAI').addEventListener('click', function () {
        const brief = document.getElementById('aiBrief').value.trim();
        if (!brief) { alert('Por favor, describe el email que quieres generar.'); return; }

        const spinner  = document.getElementById('aiSpinner');
        const variants = document.getElementById('aiVariants');
        const area     = document.getElementById('aiVariantsArea');
        const errEl    = document.getElementById('aiError');

        spinner.classList.remove('d-none');
        area.classList.add('d-none');
        errEl.classList.add('d-none');
        this.disabled = true;

        fetch('<?php echo url('admin/marketing/generateAiEmail'); ?>', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
            body: JSON.stringify({ brief }),
        })
        .then(r => {
            if (!r.ok) return r.json().then(e => { throw new Error(e.error || `HTTP ${r.status}`) });
            return r.json();
        })
        .then(data => {
            spinner.classList.add('d-none');
            this.disabled = false;
            if (data.error) {
                errEl.innerHTML = `<strong>Error:</strong> ${data.error}`;
                errEl.classList.remove('d-none');
                return;
            }
            const list = Array.isArray(data.variants) ? data.variants : [data.variants];
            variants.innerHTML = '';
            list.forEach((v, i) => {
                const col = document.createElement('div');
                col.className = 'col-12';
                col.innerHTML = `
                  <div class="card border-white-10 glass-morphism p-3" style="cursor:pointer;border-radius:12px;">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                      <strong class="text-white">Variante ${i+1}</strong>
                      <button type="button" class="btn btn-sm fw-bold use-variant" style="background:linear-gradient(135deg,#6366f1,#D4AF37);color:#fff;border-radius:8px;">Usar esta</button>
                    </div>
                    <p class="text-white-50 small mb-1"><strong>Asunto:</strong> ${escHtmlLocal(v.subject || '')}</p>
                    <div class="text-white-50 small" style="max-height:80px;overflow:hidden;">${v.html_body || v.body || ''}</div>
                  </div>`;
                col.querySelector('.use-variant').addEventListener('click', () => {
                    if (v.subject) {
                        const subjectInput = document.querySelector('input[name="subject"]');
                        if (subjectInput) subjectInput.value = v.subject;
                    }
                    htmlField.value = v.html_body || v.body || '';
                    if (!htmlMode) btnToggle.click();
                    bootstrap.Modal.getInstance(document.getElementById('ai-modal')).hide();
                });
                variants.appendChild(col);
            });
            area.classList.remove('d-none');
        })
        .catch((err) => {
            spinner.classList.add('d-none');
            this.disabled = false;
            errEl.innerHTML = `<strong>Error:</strong> ${err.message || 'No se pudo conectar con el servicio de IA. Verifica la configuración del API Key.'}`;
            errEl.classList.remove('d-none');
        });
    });

    /* ============================================================
       REBRANDING — Buscar y Reemplazar en el HTML
       ============================================================ */
    const btnReplace = document.getElementById('btnReplace');
    if (btnReplace) {
        btnReplace.addEventListener('click', () => {
            const findText    = document.getElementById('rebrandFind').value.trim();
            const replaceText = document.getElementById('rebrandReplace').value;
            const resultEl    = document.getElementById('rebrandResult');

            if (!findText) {
                resultEl.textContent = 'Por favor escribe el texto a buscar.';
                resultEl.style.background = 'rgba(239,68,68,.1)';
                resultEl.style.color = '#fca5a5';
                resultEl.classList.remove('d-none');
                return;
            }

            const regex = new RegExp(findText.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'gi');
            let count = 0;

            if (htmlMode) {
                // Modo HTML: reemplazar directo en el textarea
                const original = htmlField.value;
                count = (original.match(regex) || []).length;
                if (count > 0) {
                    htmlField.value = original.replace(regex, replaceText);
                }
            } else {
                // Modo Visual: reemplazar en las propiedades de los bloques y re-renderizar
                blocks.forEach(b => {
                    Object.keys(b.props).forEach(key => {
                        if (typeof b.props[key] === 'string') {
                            const matches = (b.props[key].match(regex) || []).length;
                            if (matches > 0) {
                                count += matches;
                                b.props[key] = b.props[key].replace(regex, replaceText);
                            }
                        }
                    });
                });
                if (count > 0) {
                    render();
                    if (selectedId) {
                        const activeBlock = blocks.find(x => x.id === selectedId);
                        if (activeBlock) showProps(activeBlock);
                    }
                }
            }

            if (count === 0) {
                resultEl.textContent = `No se encontró "${findText}" en el contenido.`;
                resultEl.style.background = 'rgba(239,68,68,.1)';
                resultEl.style.color = '#fca5a5';
                resultEl.classList.remove('d-none');
                return;
            }

            resultEl.textContent = `✓ Se reemplazaron ${count} ocurrencia(s) de "${findText}" por "${replaceText}".`;
            resultEl.style.background = 'rgba(34,197,94,.1)';
            resultEl.style.color = '#86efac';
            resultEl.classList.remove('d-none');

            // Auto-close modal after 1.8s
            setTimeout(() => {
                bootstrap.Modal.getInstance(document.getElementById('rebrandingModal'))?.hide();
                resultEl.classList.add('d-none');
                document.getElementById('rebrandFind').value = '';
                document.getElementById('rebrandReplace').value = '';
            }, 1800);
        });
    }

    function escHtmlLocal(s) { return s.replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

})();
</script>
