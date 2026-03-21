# Evolución del Módulo de RRHH (Fase 2)

## Tareas de Planificación (Planning)
- [x] Analizar requisitos de normalización (Candidato vs Postulación).
- [x] Escribir `implementation_plan.md`.
- [x] Confirmar opciones (campos públicos vs admin) con el cliente.

## Tareas de Desarrollo (Execution)
- [ ] Crear script SQL de migración y evolución `hr_evolution.sql`.
- [ ] Crear Modelo `Candidate` y actualizar `JobApplication` (Queries JOIN).
- [ ] Modificar formulario público en `App/Views/public/jobs/index.php` con selección de Pais/Ciudad.
- [ ] Modificar `JobsController` para manejar inserción dual (Candidato -> Postulación).
- [ ] Construir Backend - Vista Detalle (`view.php`) con separador Perfil/Postulación.
- [ ] Habilitar endpoints de edición para Perfil y Postulación en `JobsCMSController`.
- [ ] Ajustar Vista Listado (`index.php`) con las nuevas etiquetas de estado y formato.
- [ ] Testear funcionalidad end-to-end.
