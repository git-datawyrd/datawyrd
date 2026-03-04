<section class="min-vh-60 d-flex align-items-center position-relative overflow-hidden pt-5 pb-5">
    <!-- Brand Background -->
    <div class="position-absolute top-0 start-0 w-100 h-100 zoom-parallax"
        style="background: linear-gradient(rgba(10, 11, 14, 0.8), rgba(10, 11, 14, 0.9)), url('<?php echo url('assets/images/hero_background.png'); ?>') center/cover no-repeat; z-index: 0;">
    </div>

    <div class="container pt-5 text-center position-relative" style="z-index: 1;">
        <h1 class="display-5 fw-black text-white mb-4 tracking-tighter">Inicia tu <span
                class="text-gradient">Transformación</span></h1>
        <p class="lead text-white-50 mx-auto" style="max-width: 700px;">
            Cuéntanos sobre tu proyecto y nuestro equipo de expertos diseñará la solución ideal para ti.
        </p>
    </div>
</section>

<style>
    .min-vh-60 {
        min-height: 60vh;
    }

    .zoom-parallax {
        animation: subtleZoom 20s infinite alternate linear;
    }

    @keyframes subtleZoom {
        from {
            transform: scale(1.05);
        }

        to {
            transform: scale(1.15);
        }
    }

    .tracking-tighter {
        letter-spacing: -2px;
    }
</style>

<section class="py-5 brand-bg">
    <div class="container py-5">
        <div class="row justify-content-center text-start">
            <div class="col-lg-10">
                <div class="glass-morphism p-4 p-lg-5 rounded-5 border-white-10 shadow-2xl">
                    <form action="<?php echo url('ticket/submit'); ?>" method="POST">
                        <?php echo csrf_field(); ?>
                        <div class="row g-4">
                            <!-- Personal Info -->
                            <div class="col-md-6">
                                <label class="text-white-50 x-small mb-2 text-uppercase tracking-widest fw-bold">Nombre
                                    Completo</label>
                                <input type="text" name="name" class="form-control p-2 small"
                                    placeholder="Ej: Juan Pérez" required>
                            </div>
                            <div class="col-md-6">
                                <label class="text-white-50 x-small mb-2 text-uppercase tracking-widest fw-bold">Correo
                                    Electrónico</label>
                                <input type="email" name="email" class="form-control p-2 small"
                                    placeholder="tu@email.com" required>
                            </div>
                            <div class="col-md-6">
                                <label
                                    class="text-white-50 x-small mb-2 text-uppercase tracking-widest fw-bold">Empresa</label>
                                <input type="text" name="company" class="form-control p-2 small"
                                    placeholder="Nombre de tu empresa">
                            </div>
                            <div class="col-md-6">
                                <label
                                    class="text-white-50 x-small mb-2 text-uppercase tracking-widest fw-bold">Teléfono</label>
                                <input type="text" name="phone" class="form-control p-2 small" placeholder="+1 234...">
                            </div>

                            <!-- Project Info -->
                            <div class="col-12">
                                <hr class="border-white-10 my-4">
                                <label
                                    class="text-white-50 x-small mb-2 text-uppercase tracking-widest fw-bold">Servicio
                                    de Interés</label>
                                <select name="service_id" class="form-select p-2 small" required>
                                    <option value="" disabled selected>Selecciona un servicio...</option>
                                    <?php
                                    $current_cat = '';
                                    foreach ($services as $s):
                                        if ($current_cat !== $s['category_name']):
                                            if ($current_cat !== '')
                                                echo '</optgroup>';
                                            $current_cat = $s['category_name'];
                                            echo '<optgroup label="' . htmlspecialchars($current_cat) . '">';
                                        endif;
                                        ?>
                                        <option value="<?php echo $s['id']; ?>" <?php echo (isset($_GET['service']) && $_GET['service'] == $s['id']) ? 'selected' : ''; ?>>
                                            <?php echo $s['service_name']; ?>
                                        </option>
                                    <?php endforeach; ?>
                                    <?php if ($current_cat !== '')
                                        echo '</optgroup>'; ?>
                                </select>
                            </div>
                            <div class="col-12">
                                <label
                                    class="text-white-50 x-small mb-2 text-uppercase tracking-widest fw-bold">Asunto</label>
                                <input type="text" name="subject" class="form-control p-2 small"
                                    placeholder="Ej: Consulta sobre Pipeline de Datos" required>
                            </div>
                            <div class="col-12">
                                <label
                                    class="text-white-50 x-small mb-2 text-uppercase tracking-widest fw-bold">Descripción
                                    del Proyecto</label>
                                <textarea name="description" class="form-control p-2 small" rows="5"
                                    placeholder="Cuéntanos los detalles, objetivos y desafíos de tu solicitud..."
                                    required></textarea>
                            </div>

                            <div class="col-12 mt-5">
                                <button type="submit"
                                    class="btn btn-primary btn-sm w-100 py-3 shadow-gold fw-bold uppercase">
                                    Enviar Solicitud <span class="material-symbols-outlined ms-2 fs-6">send</span>
                                </button>
                                <p class="text-center text-white-50 x-small mt-4 mb-0">
                                    Al enviar, un representante de Data Wyrd se contactará contigo en menos de 24 horas.
                                </p>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>