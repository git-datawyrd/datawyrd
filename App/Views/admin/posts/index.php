<div class="row g-4">
    <!-- Panel Izquierdo: Preview del Canvas -->
    <div class="col-lg-8">
        <div class="glass-morphism rounded-4 p-4 p-md-5 mb-4 d-flex flex-column align-items-center justify-content-center min-vh-75 position-relative overflow-hidden" id="canvas-wrapper">
            <!-- Canvas Simulation -->
            <div id="social-canvas" class="bg-midnight shadow-2xl rounded-3 position-relative overflow-hidden transition-all duration-500" style="width: 500px; height: 500px;">
                <!-- Background Image Layer -->
                <div id="canvas-bg" class="position-absolute top-0 start-0 w-100 h-100 bg-size-cover bg-position-center d-none"></div>
                
                <!-- Placeholder / Empty State -->
                <div id="canvas-placeholder" class="position-absolute top-0 start-0 w-100 h-100 d-flex flex-column align-items-center justify-content-center text-white-50 p-4 text-center">
                    <span class="material-symbols-outlined fs-1 mb-3">image_search</span>
                    <p class="mb-0 fw-medium">Sube una imagen para comenzar</p>
                    <small class="opacity-50 mt-2">Formatos sugeridos: JPG, PNG, WEBP</small>
                </div>

                <!-- Text Overlays -->
                <div id="layer-title" class="draggable-text position-absolute text-white fw-bold fs-2 text-center px-4" style="top: 20%; left: 0; width: 100%; cursor: move; z-index: 10;">
                    <span contenteditable="true" id="editable-title">TÍTULO DEL POST</span>
                </div>

                <div id="layer-subtitle" class="draggable-text position-absolute text-white-50 fs-5 text-center px-5" style="top: 40%; left: 0; width: 100%; cursor: move; z-index: 9;">
                    <span contenteditable="true" id="editable-subtitle">Subtítulo persuasivo para captar atención</span>
                </div>

                <div id="layer-cta" class="draggable-text position-absolute text-center" style="top: 80%; left: 0; width: 100%; cursor: move; z-index: 8;">
                    <span class="btn btn-primary rounded-pill px-4 py-2 fw-bold tracking-widest uppercase x-small shadow-gold" contenteditable="true" id="editable-cta">Saber más</span>
                </div>
            </div>

            <!-- Canvas Controls Overlay -->
            <div class="position-absolute bottom-0 start-0 w-100 p-4 d-flex justify-content-center gap-3">
                <button type="button" id="export-btn" class="btn btn-gold d-flex align-items-center gap-2 px-4 rounded-pill shadow-lg hover-scale transition-all">
                    <span class="material-symbols-outlined">download</span> Exportar PNG
                </button>
            </div>
        </div>
    </div>

    <!-- Panel Derecho: Controles -->
    <div class="col-lg-4">
        <div class="glass-morphism rounded-4 p-4 shadow-lg sticky-top" style="top: 100px;">
            <h3 class="h6 text-white fw-bold mb-4 d-flex align-items-center gap-2 border-bottom border-white-10 pb-3">
                <span class="material-symbols-outlined text-primary">tune</span>
                Configuración del Post
            </h3>

            <!-- 1. Imagen -->
            <div class="mb-4">
                <label class="text-white-50 x-small tracking-widest uppercase mb-2 d-block">Imagen de Fondo</label>
                <div id="drop-zone" class="border-2 border-dashed border-white-10 rounded-3 p-4 text-center hover-bg-light transition-all cursor-pointer">
                    <input type="file" id="img-input" class="d-none" accept="image/*">
                    <span class="material-symbols-outlined text-white-50 fs-2 mb-2">cloud_upload</span>
                    <p class="text-white-50 small mb-0">Arrastra o haz clic para subir</p>
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

            <!-- 4. Herramientas Mágicas -->
            <div class="mb-4">
                <label class="text-white-50 x-small tracking-widest uppercase mb-3 d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined fs-6 text-accent">auto_fix_high</span>
                    Efectos Premium
                </label>
                <div class="glass-morphism border border-white-10 p-3 rounded-3">
                    <p class="text-white-50 x-small mb-2">Selecciona texto en el preview y pulsa este botón para aplicar el degradado oficial.</p>
                    <button type="button" id="magic-gradient" class="btn btn-outline-primary btn-sm w-100 rounded-pill py-2">
                        Aplicar Branding (Varita)
                    </button>
                </div>
            </div>
            
            <div class="alert alert-info bg-primary bg-opacity-10 border-primary border-opacity-25 text-primary small d-flex gap-2">
                <span class="material-symbols-outlined fs-5">info</span>
                <span>Los textos son editables directamente sobre la imagen. Puedes arrastrarlos para posicionarlos.</span>
            </div>
        </div>
    </div>
</div>

<style>
#social-canvas {
    background: #0a0a0d;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.draggable-text span:focus {
    outline: 1px dashed var(--elegant-gold);
    padding: 2px 4px;
}

.text-gradient-active {
    background: linear-gradient(135deg, #fff 0%, #d4af37 50%, #00d2ff 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    display: inline;
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

<!-- Librería para Captura de Canvas -->
<script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>

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
            // Disable specific unsupported formats (like LinkedIn Story)
            showToast('Formato no disponible para esta plataforma', 'warning');
            return;
        }

        const [w, h] = dims;
        // Calculate proportional scale to fit in screen
        const maxDisplayWidth = window.innerWidth > 992 ? 500 : 300;
        const scale = maxDisplayWidth / w;
        
        canvas.style.width = (w * scale) + 'px';
        canvas.style.height = (h * scale) + 'px';
    }

    // Platform Change
    platformSelect.addEventListener('change', () => {
        const btnStory = document.getElementById('btn-story');
        if (platformSelect.value === 'linkedin') {
            btnStory.classList.add('d-none');
            // If Story was active, switch to Post
            if (document.querySelector('#format-options .active').dataset.type === 'story') {
                formatButtons[0].click();
            }
        } else {
            btnStory.classList.remove('d-none');
        }
        updateCanvasSize();
    });

    // Format Change
    formatButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            formatButtons.forEach(b => b.classList.remove('active', 'btn-primary'));
            formatButtons.forEach(b => b.classList.add('btn-outline-light'));
            btn.classList.add('active', 'btn-primary');
            btn.classList.remove('btn-outline-light');
            updateCanvasSize();
        });
    });

    // Image Upload
    dropZone.addEventListener('click', () => imgInput.click());
    
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
            canvasPlaceholder.classList.add('d-none');
            showToast('Imagen cargada correctamente', 'success');
        };
        reader.readAsDataURL(file);
    }

    // Drag & Drop for Image
    dropZone.addEventListener('dragover', (e) => { e.preventDefault(); dropZone.classList.add('drag-active'); });
    dropZone.addEventListener('dragleave', () => dropZone.classList.remove('drag-active'));
    dropZone.addEventListener('drop', (e) => {
        e.preventDefault();
        dropZone.classList.remove('drag-active');
        const file = e.dataTransfer.files[0];
        handleImage(file);
    });

    // Drag & Drop for Text Layers (Simple Implementation)
    let activeLayer = null;
    let offset = [0, 0];

    document.querySelectorAll('.draggable-text').forEach(layer => {
        layer.addEventListener('mousedown', (e) => {
            if (e.target.hasAttribute('contenteditable') && document.activeElement === e.target) return;
            activeLayer = layer;
            const parentRect = canvas.getBoundingClientRect();
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
        
        // Bounds checking
        if (top < 0) top = 0;
        if (top > parentRect.height - activeLayer.offsetHeight) top = parentRect.height - activeLayer.offsetHeight;

        activeLayer.style.top = top + 'px';
    });

    document.addEventListener('mouseup', () => activeLayer = null);

    // Magic Wand Gradient
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

    // Export PNG
    document.getElementById('export-btn').addEventListener('click', () => {
        const platform = platformSelect.value;
        const type = document.querySelector('#format-options .active').dataset.type;
        const date = new Date().toISOString().split('T')[0];
        
        showToast('Generando imagen de alta calidad...', 'info');

        // We temporarily set scale to 1 for high-res export
        const platformDims = dimensions[platform][type];
        const originalWidth = canvas.style.width;
        const originalHeight = canvas.style.height;
        
        // Use html2canvas
        html2canvas(canvas, {
            scale: 2, // Doubling resolution for sharpness (Retina-like)
            backgroundColor: null,
            useCORS: true,
            logging: false
        }).then(exportCanvas => {
            const link = document.createElement('a');
            link.download = `${platform}_${type}_${date}.png`;
            link.href = exportCanvas.toDataURL('image/png', 1.0);
            link.click();
            showToast('¡Exportación completada!', 'success');
        });
    });

    // Init
    updateCanvasSize();
});
</script>
