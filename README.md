
# DataWyrd 🌐

**DataWyrd** es una plataforma web desarrollada con **Django 5.2** y **PostgreSQL**, diseñada para ofrecer soluciones tecnológicas orientadas a Business Intelligence, Ingeniería de Datos y Optimización de Procesos.

---

## 🧱 Estructura del Proyecto

```
DATAWYRD/
├── venv/                   # Entorno virtual (no incluido en Git)
├── datawyrd/               # Proyecto Django
│   ├── manage.py
│   ├── .env                # Variables de entorno (no se incluye en el repo)
│   ├── requirements.txt    # Dependencias
│   ├── core/               # App principal (páginas públicas)
│   ├── contacto/           # App para contacto y formularios
│   └── datawyrd/           # Configuración global (settings, urls, wsgi)
└── media/                  # Archivos subidos por el usuario
```

---

## ⚙️ Instalación

1. **Clonar el repositorio:**

```bash
git clone https://github.com/git-datawyrd/datawyrd.git
cd datawyrd
```

2. **Crear y activar el entorno virtual:**

```bash
python -m venv venv
venv\Scripts\activate     # En Windows
# source venv/bin/activate  # En Linux/Mac
```

3. **Instalar dependencias:**

```bash
pip install -r requirements.txt
```

4. **Crear el archivo `.env`:**

```env
SECRET_KEY=tu_clave_django
DB_NAME=datawyrd_db
DB_USER=postgres
DB_PASSWORD=tu_clave
DB_HOST=localhost
DB_PORT=5432
```

5. **Migrar y levantar el servidor:**

```bash
python manage.py migrate
python manage.py runserver
```

---

## 🚀 Funcionalidades Actuales

- Home, Nosotros, Servicios y Contacto (App `core`)
- Formulario de contacto funcional (App `contacto`)
- Administración de contenidos vía Panel de Admin
- Carga de archivos multimedia
- Separación de configuración sensible mediante `.env`

---

## 🧪 Pruebas Locales

Antes de realizar cambios, asegurate de tener el entorno virtual activo. Luego:

```bash
python manage.py runserver
```

---

## 📦 Buenas prácticas

- El archivo `.env` está **ignorado por Git**.
- Se incluye `requirements.txt` actualizado.
- Estructura modular y lista para escalar.

---

## 🧑‍💻 Autor

**DataWyrd Team**  
[https://github.com/git-datawyrd]

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.
