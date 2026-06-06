# Evolución del Módulo de RRHH (Fase 2)

## Tareas de Planificación (Planning)
- [x] Analizar requisitos de normalización (Candidato vs Postulación).
- [x] Escribir `implementation_plan.md`.
- [x] Confirmar opciones (campos públicos vs admin) con el cliente.

## Tareas de Desarrollo (Execution)
- [x] Crear script SQL de migración y evolución `hr_evolution.sql`.
- [x] Crear Modelo `Candidate` y actualizar `JobApplication` (Queries JOIN).
- [x] Modificar formulario público en `App/Views/public/jobs/index.php` con selección de Pais/Ciudad.
- [x] Modificar `JobsController` para manejar inserción dual (Candidato -> Postulación).
- [x] Construir Backend - Vista Detalle (`view.php`) con separador Perfil/Postulación.
- [x] Habilitar endpoints de edición para Perfil y Postulación en `JobsCMSController`.
- [x] Ajustar Vista Listado (`index.php`) con las nuevas etiquetas de estado y formato.
- [x] Testear funcionalidad end-to-end.
