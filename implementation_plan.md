# Plan de Evolución del Módulo de RRHH (Fase 2)

El objetivo es permitir que un candidato tenga múltiples postulaciones, agregar datos geográficos al perfil del candidato y enriquecer el ciclo de vida de la postulación con nuevos estados y seguimiento de fechas.

## Proposed Changes

### 1. Base de Datos (Normalización)
Se requiere separar la entidad `Candidato` de la `Postulación`.

#### [NEW] `database/migrations/hr_evolution.sql`
- **Crear tabla `candidates`**:
  - `id` (INT PK)
  - `first_name`, `last_name`, `email` (UNIQUE), `phone`, `linkedin_url`
  - `city`, `country`, `address` (Nuevos campos)
  - `created_at`, `updated_at`
- **Modificar tabla `job_applications`**:
  - Añadir `candidate_id` (FK a candidates.id)
  - Añadir `vacancy_name` (VARCHAR)
  - Añadir `status_updated_at` (TIMESTAMP)
  - Actualizar `status` ENUM: `'new', 'reviewed', 'contacted', 'unreachable', 'scheduled', 'technical_interview', 'rejected', 'hired'`.
  - Migrar datos existentes (si los hay) de `job_applications` a `candidates`.
  - Eliminar columnas redundantes de `job_applications` (`first_name`, `last_name`, `email`, `phone`, `linkedin_url`).

---

### 2. Modelos (Models)
#### [NEW] `App/Models/Candidate.php`
- Gestionar CRUD de la tabla `candidates`.
- Método `findByEmail($email)` para evitar duplicados al postular.

#### [MODIFY] `App/Models/JobApplication.php`
- Ajustar métodos `findAll` y `findById` para hacer `JOIN` con `candidates`.
- Actualizar `create()` para usar `candidate_id` e insertar `vacancy_name`.
- Actualizar `updateStatus()` para registrar la fecha en `status_updated_at`.

---

### 3. Controladores (Controllers)
#### [MODIFY] `App/Controllers/JobsController.php` (Público)
- Modificar `$validator->postulate()` para buscar al candidato por email. Si no existe, crearlo. Si existe, actualizarlo (opcional).
- Asignar `candidate_id` a la nueva `job_application`.
- (Opcional): Añadir campo oculto o select en el frontend de `vacancy_name` (por ej: "Candidatura Espontánea" por defecto).

#### [MODIFY] `App/Controllers/Admin/JobsCMSController.php` (Admin)
- Actualizar listado `index()` para usar los nuevos estados y mapear nombres de candidato mediante la relación.
- Proveer un método para actualizar el estado, registrando la fecha (`status_updated_at`).
- Proveer método para actualizar `vacancy_name` y campos geográficos (`city`, `country`, `address`).

---

### 4. Vistas (Views)
#### [MODIFY] `App/Views/public/jobs/index.php`
- Agregar al formulario público los nuevos campos (Opcionales por ahora o Requeridos): `Ciudad`, `País`, `Dirección`.
- Agregar un campo (puede ser un `select` oculto o estático) para `Vacante` (vacancy_name).

#### [MODIFY] `App/Views/admin/jobs/index.php`
- Actualizar el diccionario de colores para los nuevos estados: `contacted` (Contacto), `unreachable` (Ilocalizable), `scheduled` (Agendado), `technical_interview` (Tecnica).
- Mostrar la "Vacante".

#### [MODIFY] `App/Views/admin/jobs/view.php` (Detalle de Postulación/Candidato)
- Crear un layout tabulado o dos columnas para mostrar el "Perfil del Candidato" (donde se puede editar País, Ciudad, Dirección, etc) separado de la "Postulación Actual" (donde se edita la Vacante y el Estado).
- Añadir Dropdown/Select para cambiar el estado de la postulación (Ajax o Formulario Tradicional).

## User Review Required
- ¿Deseas que los campos geo (País, Ciudad, Dirección) sean obligatorios en el formulario público, o que sean solo opcionales y el Administrador los pueda llenar/editar después?
- ¿El candidato postula a una "Vacante" en específico que elegirá en un select en el sitio web, o por defecto entran como "Candidatura Espontánea" y el Admin se la asigna adentro?

## Verification Plan
1. Ejecutar script de migración SQL de forma segura sin pérdida de datos.
2. Realizar perfil de prueba (postular dos veces con el mismo correo y verificar que se generen 2 postulaciones pero 1 solo candidato).
3. Entrar como Admin, cambiar vacante, cambiar estado, y verificar `status_updated_at`.
