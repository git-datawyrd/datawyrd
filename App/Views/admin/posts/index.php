<div class="row g-4">
    <!-- Panel Izquierdo: Preview del Canvas -->
    <div class="col-lg-8">
        <div class="glass-morphism rounded-4 p-4 p-md-5 mb-4 d-flex flex-column align-items-center justify-content-center min-vh-75 position-relative overflow-hidden" id="canvas-wrapper">
            <!-- Canvas Simulation -->
            <div id="social-canvas" class="bg-midnight shadow-2xl rounded-3 position-relative overflow-hidden transition-all duration-500" style="width: 500px; height: 500px;">
                <!-- Background Image Layer -->
                <div id="canvas-bg" class="position-absolute top-0 start-0 w-100 h-100 bg-size-cover bg-position-center d-none"></div>
                
                <!-- Placeholder / Empty State (Inside Canvas) -->
                <div id="drop-zone" class="position-absolute top-0 start-0 w-100 h-100 d-flex flex-column align-items-center justify-content-center text-white-50 p-4 text-center cursor-pointer transition-all hover-bg-light" style="z-index: 5;">
                    <input type="file" id="img-input" class="d-none" accept="image/*">
                    <div id="canvas-placeholder">
                        <span class="material-symbols-outlined fs-1 mb-3">cloud_upload</span>
                        <p class="mb-0 fw-medium">Arrastra o haz clic para subir imagen</p>
                        <small class="opacity-50 mt-2">JPG, PNG, WEBP (Máx 5MB)</small>
                    </div>
                </div>

                <!-- Text Overlays -->
                <div id="layer-title" class="draggable-text position-absolute text-white fw-bold fs-2 text-center px-4 d-none glass-text-container" style="top: 20%; left: 0; width: 100%; z-index: 10;">
                    <span contenteditable="true" id="editable-title"></span>
                </div>

                <div id="layer-subtitle" class="draggable-text position-absolute text-white text-center px-5 d-none glass-text-container" style="top: 40%; left: 0; width: 100%; z-index: 9; font-size: 1.25rem;">
                    <span contenteditable="true" id="editable-subtitle"></span>
                </div>

                <div id="layer-cta" class="draggable-text position-absolute text-center d-none" style="top: 80%; left: 0; width: 100%; z-index: 8;">
                    <span class="btn btn-primary rounded-pill px-4 py-2 fw-bold tracking-widest uppercase x-small shadow-gold" contenteditable="true" id="editable-cta"></span>
                </div>
            </div>

        </div>

        <!-- Canvas Controls (Sacados del área de trabajo para evitar montaje) -->
        <div class="glass-morphism rounded-4 p-3 d-flex justify-content-center gap-3 mt-4">
            <button type="button" id="replace-btn" class="btn btn-midnight d-none align-items-center gap-2 px-4 rounded-pill shadow-lg hover-scale transition-all border border-white-10">
                <span class="material-symbols-outlined fs-5">replay</span> Reemplazar
            </button>
            <button type="button" id="export-btn" class="btn btn-gold d-flex align-items-center gap-2 px-4 rounded-pill shadow-lg hover-scale transition-all">
                <span class="material-symbols-outlined">download</span> Exportar JPG
            </button>
        </div>

        <!-- 4. Herramientas Mágicas (Debajo del Workspace) -->
        <div class="glass-morphism rounded-4 p-4 d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-3">
                <span class="material-symbols-outlined text-primary fs-3">auto_fix_high</span>
                <div>
                    <h4 class="h6 text-white fw-bold mb-1">Efectos Premium</h4>
                    <p class="text-white-50 x-small mb-0">Selecciona texto en el preview o en los campos y pulsa el botón para aplicar el degradado oficial.</p>
                </div>
            </div>
            <button type="button" id="magic-gradient" class="btn btn-outline-primary rounded-pill px-4 py-2 fw-bold uppercase x-small tracking-widest">
                Aplicar Branding
            </button>
        </div>
    </div>

    <!-- Panel Derecho: Controles -->
    <div class="col-lg-4">
        <div class="glass-morphism rounded-4 p-4 shadow-lg sticky-top" style="top: 100px;">
            <h3 class="h6 text-white fw-bold mb-4 d-flex align-items-center gap-2 border-bottom border-white-10 pb-3">
                <span class="material-symbols-outlined text-primary">tune</span>
                Configuración del Post
            </h3>

            <!-- 1. Textos Editables -->
            <div class="mb-4">
                <label class="text-white-50 x-small tracking-widest uppercase mb-3 d-block">Contenido del Post</label>
                
                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label class="x-small text-white-50">Título</label>
                        <div class="btn-group btn-group-sm">
                            <button type="button" class="btn btn-link text-white-50 p-0 me-2 font-size-ctrl" data-target="title" data-dir="down"><span class="material-symbols-outlined fs-6">remove</span></button>
                            <button type="button" class="btn btn-link text-white-50 p-0 font-size-ctrl" data-target="title" data-dir="up"><span class="material-symbols-outlined fs-6">add</span></button>
                        </div>
                    </div>
                    <textarea id="input-title" class="form-control bg-deep-black border-white-10 text-white small" rows="2" placeholder="Escribe aquí..."></textarea>
                </div>
                
                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label class="x-small text-white-50">Subtítulo</label>
                        <div class="btn-group btn-group-sm">
                            <button type="button" class="btn btn-link text-white-50 p-0 me-2 font-size-ctrl" data-target="subtitle" data-dir="down"><span class="material-symbols-outlined fs-6">remove</span></button>
                            <button type="button" class="btn btn-link text-white-50 p-0 font-size-ctrl" data-target="subtitle" data-dir="up"><span class="material-symbols-outlined fs-6">add</span></button>
                        </div>
                    </div>
                    <textarea id="input-subtitle" class="form-control bg-deep-black border-white-10 text-white small" rows="3" placeholder="Añade una descripción..."></textarea>
                </div>

                <div class="mb-2">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label class="x-small text-white-50">CTA (Botón)</label>
                        <div class="btn-group btn-group-sm">
                            <button type="button" class="btn btn-link text-white-50 p-0 me-2 font-size-ctrl" data-target="cta" data-dir="down"><span class="material-symbols-outlined fs-6">remove</span></button>
                            <button type="button" class="btn btn-link text-white-50 p-0 font-size-ctrl" data-target="cta" data-dir="up"><span class="material-symbols-outlined fs-6">add</span></button>
                        </div>
                    </div>
                    <input type="text" id="input-cta" class="form-control bg-deep-black border-white-10 text-white small" value="" placeholder="Texto del botón">
                </div>
            </div>

            <!-- 2. Plataforma -->
            <div class="mb-4">
                <label class="text-white-50 x-small tracking-widest uppercase mb-2 d-block">Plataforma</label>
                <select id="platform-select" class="form-select bg-deep-black border-white-10 text-white">
                    <option value="instagram">Instagram</option>
                    <option value="linkedin">LinkedIn</option>
                    <option value="facebook">Facebook</option>
                </select>
            </div>

            <!-- 3. Formato -->
            <div class="mb-4">
                <label class="text-white-50 x-small tracking-widest uppercase mb-2 d-block">Tipo de Contenido</label>
                <div class="d-flex flex-wrap gap-2" id="format-options">
                    <button type="button" class="btn btn-outline-light btn-sm rounded-pill px-3 py-2 border-white-10 active" data-type="post">Publicación</button>
                    <button type="button" class="btn btn-outline-light btn-sm rounded-pill px-3 py-2 border-white-10" data-type="story" id="btn-story">Historia</button>
                    <button type="button" class="btn btn-outline-light btn-sm rounded-pill px-3 py-2 border-white-10" data-type="frame">Frame (Banner)</button>
                </div>
            </div>

            <hr class="border-white-10 my-4">
        </div>
    </div>
</div>

<style>
.draggable-text {
    cursor: grab;
    transition: box-shadow 0.3s ease, border-color 0.3s ease;
    border: 1px solid transparent;
    border-radius: 8px;
}

.draggable-text:hover {
    border-color: rgba(212, 175, 55, 0.4);
    box-shadow: 0 0 15px rgba(212, 175, 55, 0.01);
}

.draggable-text.dragging {
    cursor: grabbing;
    opacity: 0.8;
}

.glass-text-container {
    background: transparent !important;
    backdrop-filter: none !important;
    -webkit-backdrop-filter: none !important;
    text-shadow: 
        0 1px 2px rgba(0,0,0,1), 
        0 2px 10px rgba(0,0,0,0.8),
        0 0 20px rgba(0,0,0,0.5);
    padding: 10px 40px;
    width: 100% !important;
    left: 0 !important;
    transform: none !important;
    border: none !important;
    pointer-events: none; /* Dejar que los eventos pasen al span si es necesario, pero daremos eventos al padre para drag con ALT */
}

.draggable-text {
    pointer-events: auto;
}

.draggable-text span {
    pointer-events: auto;
}

#social-canvas {
    background: #000;
}

.draggable-text span:focus {
    outline: 1px dashed var(--elegant-gold);
    padding: 2px 4px;
}

[contenteditable="true"] {
    cursor: text;
}

.text-gradient-active {
    background: linear-gradient(to right, #D4AF37, #30C5FF) !important;
    -webkit-background-clip: text !important;
    -webkit-text-fill-color: transparent !important;
    background-clip: text !important;
    display: inline;
    font-weight: 800;
    text-shadow: none !important;
}

#drop-zone.drag-active {
    border-color: var(--elegant-gold) !important;
    background: rgba(212, 175, 55, 0.05);
}

.bg-size-cover { background-size: cover; }
.bg-position-center { background-position: center; }
.min-vh-75 { min-height: 75vh; }
.shadow-2xl { shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); }
.cursor-pointer { cursor: pointer; }
</style>

<!-- Motor de Captura Nativo (Sin Dependencias Externas) -->
<style>
#social-canvas-render { display: none; } /* Canvas oculto para renderizado de alta calidad */
</style>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const canvas = document.getElementById('social-canvas');
    const platformSelect = document.getElementById('platform-select');
    const formatButtons = document.querySelectorAll('#format-options .btn');
    const imgInput = document.getElementById('img-input');
    const dropZone = document.getElementById('drop-zone');
    const canvasBg = document.getElementById('canvas-bg');
    const canvasPlaceholder = document.getElementById('canvas-placeholder');
    const magicWand = document.getElementById('magic-gradient');
    const replaceBtn = document.getElementById('replace-btn');

    // Inputs
    const inputTitle = document.getElementById('input-title');
    const inputSubtitle = document.getElementById('input-subtitle');
    const inputCta = document.getElementById('input-cta');
    
    // Canvas Elements
    const editableTitle = document.getElementById('editable-title');
    const editableSubtitle = document.getElementById('editable-subtitle');
    const editableCta = document.getElementById('editable-cta');

    // Sync: Screen -> Input
    const syncScreenToInput = (el, input, layer) => {
        el.addEventListener('input', () => {
            input.value = el.innerText;
            if (el.innerText.trim() === '') layer.classList.add('d-none');
            else layer.classList.remove('d-none');
        });
    };

    syncScreenToInput(editableTitle, inputTitle, document.getElementById('layer-title'));
    syncScreenToInput(editableSubtitle, inputSubtitle, document.getElementById('layer-subtitle'));
    syncScreenToInput(editableCta, inputCta, document.getElementById('layer-cta'));

    // Sync: Input -> Screen
    const syncInputToScreen = (input, el, layer) => {
        input.addEventListener('input', () => {
            el.innerText = input.value;
            if (input.value.trim() === '') layer.classList.add('d-none');
            else layer.classList.remove('d-none');
        });
    };

    syncInputToScreen(inputTitle, editableTitle, document.getElementById('layer-title'));
    syncInputToScreen(inputSubtitle, editableSubtitle, document.getElementById('layer-subtitle'));
    syncInputToScreen(inputCta, editableCta, document.getElementById('layer-cta'));

    // Font Size Controls Corrected
    document.querySelectorAll('.font-size-ctrl').forEach(btn => {
        btn.addEventListener('click', () => {
            const target = btn.dataset.target;
            const dir = btn.dataset.dir;
            
            // Apuntamos directo al elemento que tiene el texto configurable
            let el;
            if (target === 'title') el = editableTitle;
            else if (target === 'subtitle') el = editableSubtitle;
            else el = editableCta;
            
            // Obtenemos el tamaño actual del SPAN o elemento interno
            let currentSize = parseFloat(window.getComputedStyle(el).fontSize);
            const step = 2;
            const newSize = dir === 'up' ? currentSize + step : currentSize - step;
            
            // Aplicamos al elemento (que heredará su contenedor si es necesario, 
            // pero mejor aplicar al elemento que renderiza el texto)
            el.style.fontSize = newSize + 'px';
            
            // Si es el título o subtítulo, también aplicamos al contenedor para que el line-height se ajuste
            if (target !== 'cta') {
                el.parentElement.style.fontSize = newSize + 'px';
            }
        });
    });

    // Configuration Map
    const dimensions = {
        instagram: { post: [1080, 1080], story: [1080, 1920], frame: [1080, 566] },
        linkedin: { post: [1200, 1200], story: null, frame: [1200, 627] },
        facebook: { post: [1200, 1200], story: [1080, 1920], frame: [1200, 630] }
    };

    function updateCanvasSize() {
        const platform = platformSelect.value;
        const type = document.querySelector('#format-options .active').dataset.type;
        const dims = dimensions[platform][type];

        if (!dims) {
            showToast('Formato no disponible para esta plataforma', 'warning');
            return;
        }

        const [w, h] = dims;
        const maxDisplayWidth = window.innerWidth > 992 ? 500 : 300;
        const scale = maxDisplayWidth / w;
        
        canvas.style.width = (w * scale) + 'px';
        canvas.style.height = (h * scale) + 'px';

        // Reset positions to keep them visible when canvas changes ratio
        document.getElementById('layer-title').style.top = '20%';
        document.getElementById('layer-subtitle').style.top = '40%';
        document.getElementById('layer-cta').style.top = '80%';
    }

    platformSelect.addEventListener('change', () => {
        const btnStory = document.getElementById('btn-story');
        if (platformSelect.value === 'linkedin') {
            btnStory.classList.add('d-none');
            if (document.querySelector('#format-options .active').dataset.type === 'story') {
                formatButtons[0].click();
            }
        } else {
            btnStory.classList.remove('d-none');
        }
        updateCanvasSize();
    });

    formatButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            formatButtons.forEach(b => b.classList.remove('active', 'btn-primary'));
            formatButtons.forEach(b => b.classList.add('btn-outline-light'));
            btn.classList.add('active', 'btn-primary');
            btn.classList.remove('btn-outline-light');
            updateCanvasSize();
        });
    });

    // Image Upload Logic
    dropZone.addEventListener('click', () => {
        if (canvasBg.classList.contains('d-none')) {
            imgInput.click();
        }
    });
    
    replaceBtn.addEventListener('click', () => imgInput.click());

    imgInput.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (file) handleImage(file);
    });

    function handleImage(file) {
        if (!file.type.match('image.*')) {
            showToast('Por favor sube una imagen válida', 'error');
            return;
        }
        const reader = new FileReader();
        reader.onload = (e) => {
            canvasBg.style.backgroundImage = `url(${e.target.result})`;
            canvasBg.classList.remove('d-none');
            
            // UI Updates
            dropZone.classList.add('d-none'); // Hide the drop zone completely
            replaceBtn.classList.remove('d-none');
            replaceBtn.classList.add('d-flex');

            showToast('Imagen cargada correctamente', 'success');
        };
        reader.readAsDataURL(file);
    }

    dropZone.addEventListener('dragover', (e) => { e.preventDefault(); dropZone.classList.add('drag-active'); });
    dropZone.addEventListener('dragleave', () => dropZone.classList.remove('drag-active'));
    dropZone.addEventListener('drop', (e) => {
        e.preventDefault();
        dropZone.classList.remove('drag-active');
        const file = e.dataTransfer.files[0];
        handleImage(file);
    });

    // Drag & Drop for Text Layers
    let activeLayer = null;
    let offset = [0, 0];

    document.querySelectorAll('.draggable-text').forEach(layer => {
        layer.addEventListener('mousedown', (e) => {
            // Permitir selección si se hace clic derecho o si ya tiene el foco y no estamos en modo "mover"
            // Para diferenciar, usamos la tecla Shift o simplemente detectamos si el clic fue en el borde
            if (e.target.hasAttribute('contenteditable')) {
                // Si el usuario mantiene pulsado ALT, movemos. Si no, dejamos que edite/seleccione.
                if (!e.altKey) return; 
            }
            
            activeLayer = layer;
            const layerRect = layer.getBoundingClientRect();
            offset = [
                e.clientX - layerRect.left,
                e.clientY - layerRect.top
            ];
            e.preventDefault();
        });
    });

    document.addEventListener('mousemove', (e) => {
        if (!activeLayer) return;
        const parentRect = canvas.getBoundingClientRect();
        let top = e.clientY - parentRect.top - offset[1];
        
        if (top < 0) top = 0;
        if (top > parentRect.height - activeLayer.offsetHeight) top = parentRect.height - activeLayer.offsetHeight;

        activeLayer.style.top = top + 'px';
    });

    document.addEventListener('mouseup', () => activeLayer = null);

    magicWand.addEventListener('click', () => {
        const selection = window.getSelection();
        if (!selection || selection.rangeCount === 0 || selection.toString().trim() === '') {
            showToast('Selecciona primero un fragmento de texto en el canvas', 'warning');
            return;
        }

        const range = selection.getRangeAt(0);
        const span = document.createElement('span');
        span.className = 'text-gradient-active';
        range.surroundContents(span);
        showToast('Branding aplicado', 'success');
    });

    // --- Motor de Exportación Nativo Data Wyrd ---
    document.getElementById('export-btn').addEventListener('click', async () => {
        showToast('Procesando imagen...', 'info');
        
        const renderCanvas = document.createElement('canvas');
        const ctx = renderCanvas.getContext('2d');
        const platform = platformSelect.value;
        const typeTag = document.querySelector('#format-options .active').dataset.type;
        const date = new Date().toISOString().split('T')[0];

        // Dimensiones del lienzo visible
        renderCanvas.width = canvas.offsetWidth;
        renderCanvas.height = canvas.offsetHeight;

        // 1. Fondo negro base
        ctx.fillStyle = '#000000';
        ctx.fillRect(0, 0, renderCanvas.width, renderCanvas.height);

        // 2. Dibujar imagen de fondo (si existe)
        const bgStyle = canvasBg.style.backgroundImage;
        if (bgStyle && bgStyle !== 'none' && bgStyle !== '') {
            // Extraer URL correctamente (puede tener comillas simples o dobles)
            const url = bgStyle.replace(/^url\(["']?/, '').replace(/["']?\)$/, '');
            
            await new Promise((resolve) => {
                const bgImg = new Image();
                // Solo usamos crossOrigin para URLs externas, no para data:
                if (!url.startsWith('data:')) {
                    bgImg.crossOrigin = 'anonymous';
                }
                bgImg.onload = () => {
                    const imgRatio = bgImg.naturalWidth / bgImg.naturalHeight;
                    const canvasRatio = renderCanvas.width / renderCanvas.height;
                    let drawWidth, drawHeight, drawX, drawY;
                    if (imgRatio > canvasRatio) {
                        drawHeight = renderCanvas.height;
                        drawWidth = drawHeight * imgRatio;
                        drawX = (renderCanvas.width - drawWidth) / 2;
                        drawY = 0;
                    } else {
                        drawWidth = renderCanvas.width;
                        drawHeight = drawWidth / imgRatio;
                        drawX = 0;
                        drawY = (renderCanvas.height - drawHeight) / 2;
                    }
                    ctx.drawImage(bgImg, drawX, drawY, drawWidth, drawHeight);
                    resolve();
                };
                bgImg.onerror = (err) => {
                    console.warn('No se pudo cargar la imagen de fondo:', err);
                    resolve();
                };
                bgImg.src = url;
            });
        }

        // 3. Dibujar Textos — Usar IDs correctos (bug crítico anterior: titleTag no estaba definido)
        const layerDefs = [
            { layer: document.getElementById('layer-title'),    el: editableTitle },
            { layer: document.getElementById('layer-subtitle'), el: editableSubtitle },
            { layer: document.getElementById('layer-cta'),      el: editableCta }
        ];

        const canvasRect = canvas.getBoundingClientRect();

        layerDefs.forEach(({ layer, el }) => {
            if (!el || !el.innerText.trim()) return;
            if (layer.classList.contains('d-none')) return;

            const rect = el.getBoundingClientRect();
            const x = (rect.left - canvasRect.left) + (rect.width / 2);
            const y = (rect.top - canvasRect.top);

            ctx.save();
            const computedStyle = window.getComputedStyle(el);
            const fontSize = computedStyle.fontSize;
            const fontWeight = computedStyle.fontWeight;
            ctx.font = `${fontWeight} ${fontSize} Outfit, sans-serif`;
            ctx.textAlign = 'center';
            ctx.textBaseline = 'top';
            ctx.shadowColor = 'rgba(0,0,0,0.85)';
            ctx.shadowBlur = 12;
            ctx.shadowOffsetY = 3;

            // Verificar si tiene efecto branding
            const brandSpan = el.querySelector('.text-gradient-active');
            if (brandSpan) {
                const grad = ctx.createLinearGradient(x - 150, 0, x + 150, 0);
                grad.addColorStop(0, '#D4AF37');
                grad.addColorStop(1, '#30C5FF');
                ctx.fillStyle = grad;
            } else {
                ctx.fillStyle = '#FFFFFF';
            }

            ctx.fillText(el.innerText, x, y);
            ctx.restore();
        });

        // 4. Descargar como JPG
        try {
            const dataUrl = renderCanvas.toDataURL('image/jpeg', 0.92);
            const link = document.createElement('a');
            link.download = `DataWyrd_${platform}_${typeTag}_${date}.jpg`;
            link.href = dataUrl;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            showToast('¡Imagen descargada correctamente!', 'success');
        } catch (e) {
            console.error('Error en exportación:', e);
            showToast('Error al generar el archivo. Ver consola para detalles.', 'error');
        }
    });

    updateCanvasSize();
});
</script>
