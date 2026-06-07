# Pasos de Despliegue en Producción (Post-Auditoría)

Este documento detalla los pasos exactos y mínimos necesarios para estabilizar el sistema Data Wyrd OS en el entorno de producción, tras las correciones surgidas de la Auditoría 360°.

## 1. Actualización de Código
Asegúrate de traer los últimos cambios desde GitHub en tu servidor de producción:
```bash
git pull origin main
```

## 2. Actualización de Base de Datos (¡CRÍTICO!)
Para solucionar el `FATAL ERROR 1054 (Unknown column 'two_factor_enabled')` que bloquea el perfil de los usuarios, debes ejecutar el siguiente script SQL en tu base de datos de producción:

**Archivo a ejecutar:** `database/migration_add_2fa.sql`

**Contenido del script:**
```sql
ALTER TABLE `users` 
ADD COLUMN `two_factor_enabled` TINYINT(1) NOT NULL DEFAULT 0 AFTER `password`,
ADD COLUMN `two_factor_secret` VARCHAR(255) NULL AFTER `two_factor_enabled`;
```
Puedes ejecutar esto directamente en phpMyAdmin, o vía consola si tienes acceso SSH al servidor MySQL:
```bash
mysql -u tu_usuario -p tu_base_de_datos < database/migration_add_2fa.sql
```

## 3. Revisión de Variables de Entorno (.env)
Asegúrate de que en producción tu archivo `.env` contenga:
```env
ENVIRONMENT=production
# Si vas a usar MercadoPago, cambia el placeholder por tu token real:
MP_ACCESS_TOKEN=tu-access-token-real
# Habilita los correos para presupuestos/notificaciones
MAIL_ENABLED=true
```

## 4. Limpiar Caché (Opcional pero recomendado)
Si tu servidor utiliza OPcache, se recomienda reiniciarlo para asegurar que los nuevos controladores despiezados (`MarketingCampaignController`, etc.) y la limpieza de `die()` sean reconocidos inmediatamente.

## 5. Verificación
Ingresa a `https://tu-dominio.com/profile/settings` y verifica que la pantalla cargue correctamente sin el error SQL de 2FA.
