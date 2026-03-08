# 🌐 Data Wyrd OS

<div align="center">

![Version](https://img.shields.io/badge/version-2.3.0-blue.svg)
![PHP](https://img.shields.io/badge/PHP-8.0+-purple.svg)
![MySQL](https://img.shields.io/badge/MySQL-8.0+-orange.svg)
![License](https://img.shields.io/badge/license-Proprietary-red.svg)
![Status](https://img.shields.io/badge/status-Zero--Hardcode%20Certified-brightgreen.svg)
![Security](https://img.shields.io/badge/security-Enterprise--Hardened-success.svg)

**Plataforma Enterprise Certificada para Gestión de Servicios de Ingeniería de Datos**

[Características](#-características-principales) • [Instalación](#-instalación) • [Deployment](#-deployment) • [Documentación](#-documentación)

</div>

---

## 📖 Descripción

**Data Wyrd OS** es una plataforma web completa diseñada para gestionar el ciclo de vida completo de servicios de ingeniería de datos, desde la captación de clientes hasta la entrega de proyectos. Integra un CMS dinámico, sistema de tickets, gestión financiera y workspaces colaborativos.

### 🎯 Casos de Uso

- **Empresas de Consultoría de Datos**: Gestión de proyectos de BI, ETL, y Data Warehousing
- **Agencias de Desarrollo**: Seguimiento de proyectos web y aplicaciones
- **Servicios Profesionales**: Cualquier negocio B2B que requiera gestión de tickets y facturación

---

## ✨ Características Principales

### 🏠 Ecosistema Público

- ✅ **Landing Page Premium** con video background y efectos parallax.
- ✅ **Flujo Dinámico de Servicios** (Pilar → Servicio → Plan → Ticket).
- ✅ **Blog Corporativo High-End**:
  - Hero Parallax con separación de imagen y contenido para legibilidad superior.
  - Filtros unificados con la estética de "Pilares" (colores corporativos Steel/Tech Blue).
  - Sistema de gestión de imágenes optimizado con nomenclatura `ID_SLUG`.
  - Paginación automática y sistema de comentarios inteligente.
- ✅ **CMS Visual** para gestión de servicios, planes e imágenes.
- ✅ **Formularios Inteligentes** con pre-poblado automático.

### 👥 Sistema Multi-Rol

#### 👑 Panel de Administrador
- Dashboard con analítica en tiempo real (Chart.js)
- Gestión completa de usuarios (Admin/Staff/Clientes)
- Control total del CMS (Servicios, Planes, Blog)
- Generación de presupuestos y facturas en PDF
- Monitoreo de tickets y asignación de staff

#### 👨‍💼 Panel de Staff
- Vista de tickets asignados con priorización
- Chat bidireccional con clientes
- Carga de entregables al workspace
- Actualización de estados de tickets

#### 👤 Panel de Cliente
- Vista de servicios activos
- Seguimiento de tickets en tiempo real
- Chat con el equipo de soporte
- Descarga de entregables desde workspace
- Historial de facturas y pagos

### 💼 Gestión Operativa

- ✅ **Sistema de Tickets** con estados dinámicos
- ✅ **Chat Integrado** para comunicación cliente-staff
- ✅ **Generación de Presupuestos** con items personalizables y referencia explícita de Servicio
- ✅ **Facturación Automática** con tracking de pagos y herencia de metadatos de servicio
- ✅ **Workspace de Proyectos** para intercambio de archivos
- ✅ **Identidad Corporativa Estandarizada** desde variables de entorno (.env)

### 🔒 Seguridad Enterprise
- ✅ **Protección CSRF Global**: Filtro automático en el router para todas las peticiones POST.
- ✅ **Hardening de Sesiones**: Cookies seguras (HttpOnly, Secure, SameSite) y regeneración de ID.
- ✅ **Validación MIME Estricta**: Verificación de contenido real en subida de archivos.
- ✅ **Blindaje de Directorios**: Acceso prohibido vía `.htaccess` a `/App`, `/Core` y `/storage`.
- ✅ **Zero-Hardcode Infrastructure**: Configuración 100% dinâmica vía `.env` sin fallbacks locales.
- ✅ **Logging Seguro**: Errores registrados silenciosamente fuera de la raíz pública.
- ✅ **Prepared Statements**: Protección total contra SQL Injection.

---

## 🛠️ Stack Tecnológico

### Backend
- **PHP 8.0+** - Lenguaje principal
- **MySQL 8.0+** - Base de datos relacional
- **Composer** - Gestión de dependencias y Autoloading PSR-4
- **firebase/php-jwt** - Protocolo de seguridad para API
- **PHPUnit** - Suite de pruebas automatizadas
- **PDO** - Capa de abstracción de base de datos
- **Custom MVC Framework** - Arquitectura propia balanceada con eventos

### Frontend
- **HTML5 / CSS3** - Estructura y estilos
- **Bootstrap 5** - Framework CSS
- **JavaScript Vanilla** - Interactividad
- **Chart.js** - Visualización de datos
- **Material Symbols** - Iconografía

### Infraestructura
- **Apache / Nginx** - Servidor web
- **Hostinger** - Hosting recomendado
- **Zoho Mail** - Servicio de email SMTP
- **Let's Encrypt** - SSL/TLS

---

## 📋 Requisitos

### Servidor

- PHP >= 8.0
- MySQL >= 8.0
- Apache/Nginx con mod_rewrite
- SSL/HTTPS habilitado
- Extensiones PHP:
  - `pdo_mysql`
  - `mbstring`
  - `openssl`
  - `json`
  - `fileinfo`
  - `curl`

### Desarrollo Local

- XAMPP / WAMP / MAMP
- Composer (opcional)
- Git
- Editor de código (VS Code recomendado)

---

## 🚀 Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/datawyrd.git
cd datawyrd
```

### 2. Configurar Base de Datos

```bash
# Crear base de datos
mysql -u root -p
CREATE DATABASE datawyrd CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;

# Importar esquema
mysql -u root -p datawyrd < database/schema.sql
# ... ejecutar migraciones secuenciales en database/migrations/ ...
```

### 3. Instalar Dependencias
```bash
composer install
```

### 3. Configurar Variables de Entorno

```bash
# Copiar archivo de ejemplo
cp .env.example .env

# Editar .env con tus credenciales
nano .env
```

**Variable Clave:**
- `ENVIRONMENT`: Define el comportamiento del sistema (`local`, `demo`, `production`).

**Configuración mínima (.env):**
```env
ENVIRONMENT=local
APP_NAME="Data Wyrd OS"
DB_HOST=localhost
DB_DATABASE=datawyrd
DB_USERNAME=root
DB_PASSWORD=
```

### 4. Arquitectura de Configuración
El sistema utiliza una arquitectura jerárquica en `/config` gestionada por la clase `Core\Config`:
- `app.php`: Configuración común.
- `{ENVIRONMENT}.php`: Overrides por entorno (URLs, Debug, Email).

**Acceso unificado:**
```php
use Core\Config;
$val = Config::get('clave.subclave');
```

### 4. Configurar Servidor Web

**Apache (.htaccess ya incluido):**

```apache
# Asegúrate de que mod_rewrite esté habilitado
sudo a2enmod rewrite
sudo service apache2 restart
```

**Nginx:**

```nginx
server {
    listen 80;
    server_name localhost;
    root /path/to/datawyrd/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }
}
```

### 5. Configurar Permisos

```bash
chmod -R 755 storage
chmod -R 777 storage/logs
chmod -R 777 public/storage/uploads
chmod 600 .env
```

### 6. Acceder a la Aplicación

```
http://localhost/datawyrd
```

**Credenciales por defecto:**

```
Admin:
Email: admin@datawyrd.com
Password: admin123

Staff:
Email: staff@datawyrd.com
Password: staff123

Cliente:
Email: cliente@datawyrd.com
Password: cliente123
```

⚠️ **IMPORTANTE:** Cambiar estas contraseñas inmediatamente en producción.

---

## 🌐 Deployment

Para desplegar en producción (Hostinger + Zoho Mail), consulta la guía completa:

📘 **[docs/DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md)**

### Checklist Rápido

- [ ] Configurar `.env` para producción (`APP_DEBUG=false`)
- [ ] Configurar base de datos en Hostinger
- [ ] Subir archivos por FTP/SFTP
- [ ] Configurar Zoho Mail SMTP
- [ ] Habilitar SSL/HTTPS
- [ ] Verificar permisos de archivos
- [ ] Probar todas las funcionalidades

---

## 📚 Documentación

Encuentra todos los detalles técnicos y de configuración en el nuevo ecosistema de documentación `/docs`.

### Índice Principal
📘 **[docs/README.md](docs/README.md)**

### Documentos Core
| Documento | Descripción |
|-----------|-------------|
| [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) | Resumen completo del proyecto (estado del arte). |
| [docs/DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md) | Guía paso a paso para deployment en Hostinger. |
| [docs/CODE_ANALYSIS.md](docs/CODE_ANALYSIS.md) | Análisis profundo del código y la arquitectura. |
| [docs/SECURITY.md](docs/SECURITY.md) | Manual de mejores prácticas de seguridad. |
| [docs/ENV_CONFIGURATION_GUIDE.md](docs/ENV_CONFIGURATION_GUIDE.md) | Guía de variables de entorno. |
| [docs/MERCADOPAGO_INTEGRATION.md](docs/MERCADOPAGO_INTEGRATION.md) | Manual técnico para incorporar llaves y webhooks de MP. |

---

## 🏗️ Arquitectura

### Estructura de Directorios

```
datawyrd/
├── App/
│   ├── Controllers/        # Controladores MVC (Delgados)
│   ├── Domain/             # Capa de Dominio (Pure Logic)
│   │   ├── ActiveService/
│   │   ├── Ticket/
│   │   └── Invoice/
│   ├── Services/           # Servicios de Negocio y Orquestación
│   ├── Validators/         # Validadores especializados
│   ├── Policies/           # Políticas de Autorización centralizada
│   ├── UI/                 # Design System (PHP Components)
│   ├── Models/            # Modelos de datos (Persistencia)
│   └── Views/             # Vistas inteligentes organizadas por rol
│       ├── admin/
│       ├── staff/
│       ├── client/
│       ├── public/
│       └── layouts/
├── config/                # Configuración Jerárquica
│   ├── app.php            # Común
│   ├── local.php          # Desarrollo
│   ├── demo.php           # Pre-producción
│   └── production.php     # Producción
├── Core/                  # Framework core (Case-Sensitive)
│   ├── App.php           # Router principal
│   ├── Auth.php          # Autenticación
│   ├── Config.php        # Gestor de configuración
│   ├── Controller.php    # Controlador base
│   ├── Database.php      # Singleton de BD
│   ├── Mail.php          # Sistema de emails
│   ├── Model.php         # Modelo base
│   ├── Session.php       # Gestión de sesiones
│   ├── Validator.php     # Validación y sanitización
│   └── View.php          # Renderizado de vistas
├── database/             # Esquemas y migraciones
├── public/               # Raíz pública
│   ├── assets/
│   ├── storage/          # Uploads públicos (symlink)
│   ├── .htaccess
│   └── index.php         # Entry point & Global Helpers
├── storage/              # Almacenamiento privado
```
```

### Flujo de Peticiones

```
1. Usuario → public/index.php
2. Autoloader carga clases necesarias
3. Config::load() carga variables de entorno
4. Session::start() inicia sesión
5. App::__construct() parsea URL
6. Router determina Controller y Method
7. Controller ejecuta lógica de negocio
8. View renderiza respuesta HTML
9. Respuesta → Usuario
```

---

## 🔧 Desarrollo

### Añadir un Nuevo Controlador

```php
<?php
namespace App\Controllers;

use Core\Controller;
use Core\Auth;

class MiControlador extends Controller
{
    public function __construct()
    {
        // Verificar autenticación si es necesario
        if (!Auth::check()) {
            $this->redirect('/auth/login');
        }
    }

    public function index()
    {
        $data = ['title' => 'Mi Página'];
        $this->viewLayout('mi-vista', 'admin', $data);
    }
}
```

### Añadir una Nueva Ruta

Las rutas se mapean automáticamente:

```
URL: /mi-controlador/metodo/param1
Mapea a: MiControladorController->metodo($param1)
```

### Validar Inputs

```php
use Core\Validator;

$validator = new Validator();
$validator->validate($_POST, [
    'email' => 'required|email',
    'name' => 'required|min:3|max:100',
    'age' => 'numeric'
]);

if ($validator->fails()) {
    Session::flash('errors', $validator->errors());
    $this->redirect('/form');
}

// Sanitizar
$email = Validator::sanitizeEmail($_POST['email']);
$name = Validator::sanitizeString($_POST['name']);
```

### Proteger Formularios con CSRF

```php
// En la vista
<form method="POST">
    <?= csrf_field() ?>
    <!-- campos del formulario -->
</form>

// La validación es AUTOMÁTICA en Core\App.php
```

---

## 🧪 Testing

El proyecto incorpora un entorno base para testing unitario automatizado utilizando PHPUnit.

```bash
# Ejecutar tests
php vendor/bin/phpunit tests/Unit/InvoiceServiceTest.php

# Instalar PHPUnit (si no está instalado)
composer require --dev phpunit/phpunit

# Estructura de tests
tests/
├── Unit/
│   ├── AuthTest.php
│   └── ValidatorTest.php
└── Feature/
    ├── LoginTest.php
    └── TicketTest.php
```

---

## 🤝 Contribución

Este es un proyecto propietario. Para contribuir:

1. Crear una rama feature: `git checkout -b feature/nueva-funcionalidad`
2. Commit de cambios: `git commit -m 'Añadir nueva funcionalidad'`
3. Push a la rama: `git push origin feature/nueva-funcionalidad`
4. Crear Pull Request

### Estándares de Código

- Seguir PSR-1 y PSR-2
- Documentar funciones con docblocks
- Nombres de variables en español (consistencia con el proyecto)
- Nombres de métodos y clases en inglés

---

## 🐛 Solución de Problemas

### Error 500 - Internal Server Error

```bash
# Verificar logs
tail -f storage/logs/error.log

# Verificar permisos
chmod -R 755 storage
```

### Base de Datos No Conecta

```bash
# Verificar credenciales en .env
# Verificar que MySQL esté corriendo
sudo service mysql status
```

### Emails No Se Envían

```bash
# Verificar configuración SMTP en .env
# Ver logs de email
tail -f storage/logs/mail.log
```

Para más soluciones, consulta la Sección 10 de [docs/DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md)

---

## 📊 Roadmap

- [x] Evolución 2.0 a 2.6.0: Premium Admin UI, Executive Design & FinOps integration.
- [x] Estandarización de Identidad Corporativa (Branding Dinámico vía `.env`).
- [x] Implementación de Referencia de Servicio (Pilar-Servicio) en flujo comercial.
- [x] Auditoría visual de grillas y armonía UX en vistas de Budget/Invoice.
- [x] Hardening de Seguridad: CSP, HSTS, Rate Limiting y Zero-Hardcode Certified.

### 🔮 Versión 3.0 (Próxima)
- [ ] Aplicación Móvil Companion.
- [ ] Integración con Pasarelas de Pago Globales.
- [ ] Dashboard de Business Intelligence.

---

## 📄 Licencia

Este proyecto es **propietario** y confidencial. Todos los derechos reservados.

© 2026 Data Wyrd. Prohibida su distribución sin autorización.

---

## 👥 Equipo

**Desarrollado por:** Data Wyrd Team  
**Contacto:** contacto@datawyrd.com  
**Website:** https://www.datawyrd.com

---

## 🙏 Agradecimientos

- Bootstrap Team por el framework CSS
- Chart.js por las visualizaciones
- Material Design por los iconos
- Comunidad PHP por las mejores prácticas

---

<div align="center">

**[⬆ Volver arriba](#-data-wyrd-os)**

Hecho con ❤️ por el equipo de Data Wyrd

</div>
