# Aplicación Móvil de Cursos Online (Flutter)

## Descripción del Proyecto

Aplicación móvil multiplataforma desarrollada en **Flutter** que consume una API REST construida en **Django REST Framework**. El sistema permite la gestión completa de cursos online con diferentes niveles de acceso según el rol del usuario (Estudiante, Instructor, Administrador).

### Características Principales de la App

**Sistema de Autenticación:**

- Login con email o username
- Registro de nuevos usuarios
- Autenticación JWT (JSON Web Tokens)
- Almacenamiento seguro de credenciales con `flutter_secure_storage`
- Manejo automático de tokens en todas las peticiones
- Sesión persistente entre reinicios de la app

**Control de Acceso por Roles:**

- **Estudiante**: Explorar cursos, inscribirse, ver contenido, seguir progreso
- **Instructor**: Crear y gestionar cursos propios, ver inscripciones, gestionar reseñas
- **Administrador**: Acceso completo a gestión de cursos, usuarios, estadísticas globales

**Gestión de Cursos:**

- Listado y búsqueda de cursos públicos
- Detalle completo de cada curso con módulos y secciones
- Creación y edición de cursos (Instructor/Admin)
- Activación/desactivación de cursos (Admin)
- Organización por categorías y niveles

**Módulos Implementados (CRUD Completo):**

1. **Cursos**: Listar, crear, editar, eliminar, activar/desactivar
2. **Inscripciones**: Ver inscritos, crear inscripciones, gestionar progreso
3. **Usuarios**: Gestión completa (solo Admin)
4. **Reseñas**: Crear, listar, eliminar, responder
5. **Avisos**: Crear, listar, actualizar, eliminar, marcar como leído
6. **Módulos y Secciones**: CRUD completo para contenido de cursos

**Interfaz de Usuario:**

- Navegación adaptativa según rol del usuario
- Bottom navigation personalizado por perfil
- Indicadores de carga en operaciones asíncronas
- Mensajes de éxito/error con SnackBars
- Validaciones en formularios
- Pull-to-refresh en listados
- Responsive design

---

## Arquitectura del Proyecto

Este proyecto implementa **Clean Architecture** combinada con **BLoC Pattern** para garantizar:

- Separación de responsabilidades
- Testabilidad del código
- Mantenibilidad a largo plazo
- Escalabilidad

### Estructura del Proyecto

El proyecto está organizado en capas siguiendo Clean Architecture. A continuación se muestra cómo se mapea con la estructura recomendada:

```
lib/
├── core/                           # Configuración y utilidades globales
│   ├── config/                    # Configuración de tema, constantes
│   ├── constants/                 # API endpoints, valores constantes
│   ├── di/                        # Inyección de dependencias (GetIt)
│   │   └── injection.dart        # Registro de dependencias
│   ├── error/                     # Manejo centralizado de errores
│   ├── network/                   # Cliente HTTP (services/api)
│   │   └── api_client.dart       # Cliente Dio con interceptores
│   ├── router/                    # Navegación con GoRouter
│   │   └── app_router.dart       # Definición de rutas
│   └── widgets/                   # Widgets reutilizables globales
│
└── features/                       # Módulos por funcionalidad
    ├── auth/                      # Autenticación
    │   ├── data/
    │   │   ├── datasources/      # services/api - Llamadas HTTP
    │   │   │   ├── auth_remote_datasource.dart
    │   │   │   └── auth_local_datasource.dart
    │   │   ├── models/           # models - DTOs y serialización JSON
    │   │   │   ├── user_model.dart
    │   │   │   └── auth_response_model.dart
    │   │   └── repositories/     # Implementación de repositorios
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/         # Entidades de negocio (POJOs)
    │   │   │   ├── user.dart
    │   │   │   └── auth_response.dart
    │   │   ├── repositories/     # Interfaces de repositorios
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/         # Casos de uso (lógica de negocio)
    │   │       ├── login_usecase.dart
    │   │       ├── logout_usecase.dart
    │   │       └── register_usecase.dart
    │   └── presentation/
    │       ├── bloc/             # providers/bloc - Estado con BLoC
    │       │   ├── auth_bloc.dart
    │       │   ├── auth_event.dart
    │       │   └── auth_state.dart
    │       ├── pages/            # screens - Pantallas de la app
    │       │   ├── login_page.dart
    │       │   └── register_page.dart
    │       └── widgets/          # widgets - Componentes reutilizables
    │
    ├── courses/                   # Cursos, Módulos, Secciones
    │   ├── data/
    │   │   ├── datasources/      # services/api
    │   │   │   ├── course_remote_datasource.dart
    │   │   │   ├── module_remote_datasource.dart
    │   │   │   └── section_remote_datasource.dart
    │   │   ├── models/           # models
    │   │   │   ├── course_model.dart
    │   │   │   ├── module_model.dart
    │   │   │   └── section_model.dart
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   └── presentation/
    │       ├── bloc/             # providers/bloc
    │       │   ├── course_bloc.dart
    │       │   ├── module_bloc.dart
    │       │   ├── section_bloc.dart
    │       │   └── global_stats_bloc.dart
    │       ├── pages/            # screens
    │       │   ├── courses_page.dart
    │       │   ├── course_detail_page.dart
    │       │   ├── admin_courses_page.dart
    │       │   └── global_stats_page.dart
    │       └── widgets/          # widgets
    │
    ├── enrollments/               # Inscripciones
    ├── reviews/                   # Reseñas
    ├── notices/                   # Avisos/Notificaciones
    ├── admin/                     # Funciones de administración
    └── home/                      # Pantallas principales
        └── presentation/
            └── pages/            # screens
                ├── adaptive_main_layout.dart  # Selector de layout por rol
                ├── main_layout.dart           # Layout para estudiantes
                ├── instructor_main_layout.dart # Layout para instructores
                └── admin_main_layout.dart      # Layout para administradores
```

### Mapeo con Estructura Recomendada

| Requerimiento      | Implementación en el Proyecto                        |
| ------------------ | ---------------------------------------------------- |
| **screens**        | `features/*/presentation/pages/`                     |
| **widgets**        | `features/*/presentation/widgets/` + `core/widgets/` |
| **services/api**   | `features/*/data/datasources/` + `core/network/`     |
| **models**         | `features/*/data/models/`                            |
| **providers/bloc** | `features/*/presentation/bloc/`                      |

### Capas de Clean Architecture

**1. Presentation Layer (UI)**

- **Ubicación**: `features/*/presentation/`
- **Componentes**: BLoC (estado), Pages (pantallas), Widgets (componentes UI)
- **Responsabilidad**: Renderizar UI y manejar interacciones del usuario

**2. Domain Layer (Lógica de Negocio)**

- **Ubicación**: `features/*/domain/`
- **Componentes**: Entities (POJOs), UseCases (casos de uso), Repository Interfaces
- **Responsabilidad**: Reglas de negocio independientes del framework

**3. Data Layer (Datos)**

- **Ubicación**: `features/*/data/`
- **Componentes**: DataSources (API/local), Models (DTOs), Repository Implementations
- **Responsabilidad**: Obtener y persistir datos desde/hacia fuentes externas

---

## Tecnologías y Dependencias Principales

```yaml
dependencies:
  flutter_bloc: ^8.1.6 # Gestión de estado con BLoC
  equatable: ^2.0.7 # Comparación de objetos
  dartz: ^0.10.1 # Programación funcional (Either)
  get_it: ^8.0.3 # Inyección de dependencias
  dio: ^5.7.0 # Cliente HTTP
  flutter_secure_storage: ^9.2.2 # Almacenamiento seguro de tokens
  shared_preferences: ^2.3.3 # Persistencia de datos simples
  go_router: ^14.6.2 # Navegación declarativa
  intl: ^0.19.0 # Internacionalización y formatos
  fl_chart: ^0.69.2 # Gráficas y estadísticas
```

---

## Instalación y Configuración

### Requisitos Previos

- **Flutter SDK**: 3.19.0 o superior
- **Dart**: 3.3.0 o superior
- **Android Studio** o **Xcode** (para emuladores)
- **Git**: Para clonar el repositorio

### Pasos de Instalación

1. **Clonar el repositorio:**

```bash
git clone https://github.com/tu-usuario/front_movil.git
cd front_movil
```

2. **Instalar dependencias:**

```bash
flutter pub get
```

3. **Verificar la instalación de Flutter:**

```bash
flutter doctor
```

4. **Configurar la URL de la API:**

Edita el archivo `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  // Cambia esta URL por la de tu API
  static const String baseUrl = 'https://cursos-online-api.desarrollo-software.xyz';

  // O para desarrollo local:
  // static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // iOS simulator
}
```

5. **Ejecutar la aplicación:**

Para Android:

```bash
flutter run
```

Para dispositivo específico:

```bash
flutter devices                    # Ver dispositivos disponibles
flutter run -d <device-id>        # Ejecutar en dispositivo específico
```

Para release mode:

```bash
flutter run --release
```

---

## 🔑 Credenciales de Prueba

La aplicación se conecta a una API en producción con los siguientes usuarios de prueba:

### 👑 Administrador

```
Username: admin
Password: admin123
Email: admin0@admin.com
```

**Permisos:**

- Gestión completa de cursos
- Ver estadísticas globales de la plataforma
- Crear, editar y eliminar usuarios
- Activar/desactivar cursos
- Gestión de inscripciones de cualquier usuario

### 👨‍🏫 Instructor

```
Username: instructor2
Password: (solicitar al docente)
Email: instructor2@example.com
```

**Permisos:**

- Crear y gestionar sus propios cursos
- Ver inscripciones a sus cursos
- Responder a reseñas
- Ver estadísticas de sus cursos

### 🎓 Estudiante

```
Username: estudiante4
Password: (solicitar al docente)
Email: estudiante4@test.com
```

**Permisos:**

- Explorar catálogo de cursos
- Inscribirse a cursos activos
- Ver contenido de cursos inscritos
- Dejar reseñas en cursos
- Ver su progreso

**Nota:** Si necesitas crear nuevos usuarios, usa la opción de registro en la pantalla de login o solicita al administrador que cree la cuenta.

---

## Funcionalidades por Rol

### 🎓 Estudiante

**Pantallas disponibles:**

- **Explorar**: Catálogo completo de cursos con búsqueda y filtros
- **Mis Cursos**: Cursos en los que está inscrito
- **Perfil**: Información personal y configuración

**Acciones:**

- Ver detalle de cursos
- Inscribirse a cursos disponibles
- Ver contenido de módulos y secciones
- Marcar secciones como completadas
- Dejar reseñas (1-5 estrellas con comentario)
- Actualizar perfil

### 👨‍🏫 Instructor

**Pantallas disponibles:**

- **Mis Cursos**: Gestión de cursos creados
- **Dashboard**: Estadísticas de sus cursos
- **Reseñas**: Gestión de comentarios de estudiantes
- **Perfil**: Información personal

**Acciones:**

- Crear nuevos cursos
- Editar cursos existentes
- Agregar módulos y secciones
- Ver inscripciones a sus cursos
- Responder a reseñas
- Ver estadísticas de rendimiento

### 👑 Administrador

**Pantallas disponibles:**

- **Gestión de Cursos**: CRUD completo de todos los cursos
- **Estadísticas Globales**: Métricas de toda la plataforma
- **Usuarios**: Gestión completa de usuarios (CRUD)
- **Inscripciones**: Ver y gestionar todas las inscripciones
- **Perfil**: Configuración de cuenta

**Acciones:**

- Todas las acciones de Instructor
- Activar/desactivar cursos de cualquier instructor
- Crear, editar y eliminar usuarios
- Ver estadísticas globales (total de cursos, usuarios, ingresos)
- Gestionar inscripciones de cualquier usuario
- Eliminar cursos de cualquier instructor

---

## 🧪 Guía de Pruebas Funcionales

### Pruebas de Autenticación

1. **Login exitoso:**
   - Abrir app → Ingresar credenciales → Verificar redirección según rol

2. **Manejo de errores:**
   - Intentar login con credenciales incorrectas → Verificar mensaje de error
   - Intentar acceder a ruta protegida sin token → Verificar redirección a login

3. **Persistencia de sesión:**
   - Login exitoso → Cerrar app → Abrir app → Verificar sesión activa

4. **Logout:**
   - Login → Ir a Perfil → Cerrar sesión → Verificar limpieza de token

### Pruebas de Roles y Permisos

1. **Estudiante:**
   - Login como estudiante
   - Verificar que solo ve: Explorar, Mis Cursos, Perfil
   - Intentar crear curso → No debe tener la opción
   - Ver curso → Inscribirse → Verificar inscripción exitosa

2. **Instructor:**
   - Login como instructor
   - Verificar que ve: Mis Cursos, Dashboard, Reseñas, Perfil
   - Crear nuevo curso → Verificar formulario de creación
   - Editar curso propio → Verificar actualización
   - Intentar eliminar curso → No debe poder (solo admin)

3. **Administrador:**
   - Login como admin
   - Verificar que ve: Cursos, Estadísticas, Usuarios, Perfil
   - Ver estadísticas globales → Verificar datos reales
   - Activar/desactivar curso → Verificar cambio de estado
   - Eliminar curso → Verificar confirmación y eliminación

### Pruebas de CRUD

**Cursos (Admin/Instructor):**

1. Crear: Completar formulario → Guardar → Verificar en listado
2. Leer: Ver listado → Ver detalle de curso
3. Actualizar: Editar curso → Guardar cambios → Verificar actualización
4. Eliminar: Seleccionar curso → Eliminar → Confirmar eliminación

**Inscripciones:**

1. Estudiante se inscribe a curso → Verificar aparece en "Mis Cursos"
2. Ver progreso del curso → Marcar sección completada → Verificar % de progreso
3. Admin ve inscripciones → Verificar datos correctos

**Reseñas:**

1. Estudiante deja reseña en curso → Verificar aparece en detalle
2. Instructor responde reseña → Verificar respuesta visible
3. Admin elimina reseña inapropiada → Verificar eliminación

---

## 📖 Backend de Cursos Online (Django REST API)

### Descripción de la API

API REST para un sistema completo de gestión de cursos online construido con Django REST Framework. El sistema permite la creación y administración de cursos educativos con una estructura jerárquica organizada, gestión de usuarios con diferentes roles, y seguimiento detallado del progreso de aprendizaje.

### Características Principales

**Gestión de Usuarios:**

- Sistema de autenticación basado en JWT (JSON Web Tokens)
- Tres tipos de perfiles: Estudiante, Instructor y Administrador
- Autenticación por email y username
- Registro y gestión de usuarios personalizados

**Sistema de Cursos:**

- Creación y administración de cursos por instructores
- Categorización por área (Programación, Diseño, Marketing, Negocios, Idiomas, Música, Fotografía, Otros)
- Niveles de dificultad (Principiante, Intermedio, Avanzado)
- Gestión de precios e imágenes
- Activación/desactivación de cursos

**Estructura de Contenido:**

- **Cursos**: Nivel superior de organización
- **Módulos**: Agrupación temática dentro de cada curso, con orden secuencial
- **Secciones**: Unidades individuales de contenido con texto, videos, archivos y duración

**Sistema de Inscripciones:**

- Inscripción de estudiantes a cursos
- Seguimiento de progreso por curso (porcentaje 0-100%)
- Marca automática de cursos completados
- Control de unicidad (un estudiante no puede inscribirse dos veces al mismo curso)

**Seguimiento de Progreso:**

- Registro detallado del progreso por sección
- Tiempo visualizado por sección (en segundos)
- Marca de secciones completadas con fecha
- Cálculo automático del progreso general del curso

**Sistema de Avisos:**

- Notificaciones personalizadas por usuario
- Tipos de avisos: General, Relacionado con curso, Sistema, Promoción
- Estado de lectura/no leído
- Gestión de fechas de envío

### Tecnologías Utilizadas

- **Framework**: Django 5.2.8
- **API**: Django REST Framework
- **Autenticación**: Simple JWT
- **Base de datos**: PostgreSQL (producción) / SQLite (desarrollo)
- **Base de datos NoSQL**: MongoDB (integración opcional)
- **Filtros**: django-filter
- **CORS**: django-cors-headers
- **Archivos estáticos**: WhiteNoise

## Funcionalidades del Backend

### 1. Gestión de Usuarios y Autenticación

**Registro y Login:**

- Registro de nuevos usuarios con validación de datos
- Login con email o username
- Autenticación basada en JWT (Access y Refresh tokens)
- Verificación y renovación de tokens

**Perfiles de Usuario:**

- **Estudiante**: Puede inscribirse a cursos, ver contenido, marcar progreso
- **Instructor**: Puede crear y administrar sus propios cursos
- **Administrador**: Acceso completo al sistema

**Gestión de Perfil:**

- Ver perfil propio (`GET /api/users/perfil/`)
- Actualizar información personal
- Ver estadísticas personales (cursos inscritos, progreso, tiempo estudiado)

### 2. Sistema de Cursos

**CRUD Completo de Cursos:**

- **Crear**: Instructores pueden crear cursos con título, descripción, categoría, nivel, precio e imagen
- **Leer**: Listado público de cursos activos con filtros y búsqueda
- **Actualizar**: El instructor propietario o administrador puede editar
- **Eliminar**: Desactivación lógica (soft delete) del curso

**Filtros y Búsqueda:**

- Filtrar por categoría, nivel e instructor
- Búsqueda por texto en título y descripción
- Ordenamiento por fecha, título o precio

**Inscripción a Cursos:**

- Estudiantes pueden inscribirse a cursos disponibles
- Control de inscripciones duplicadas
- Vista detallada del curso con módulos y secciones

**Estadísticas de Curso:**

- Total de estudiantes inscritos
- Progreso promedio de los estudiantes
- Información del instructor

### 3. Estructura de Contenido

**Módulos:**

- Creación de módulos dentro de cursos
- Ordenamiento secuencial personalizado
- Agrupación lógica de contenido
- Un módulo pertenece a un curso específico

**Secciones:**

- Contenido multimedia: texto, videos (URL), archivos descargables
- Duración en minutos de cada sección
- Ordenamiento dentro de cada módulo
- Gestión de recursos educativos

**Jerarquía:**

```
Curso
  └── Módulo 1
      ├── Sección 1.1
      ├── Sección 1.2
      └── Sección 1.3
  └── Módulo 2
      ├── Sección 2.1
      └── Sección 2.2
```

### 4. Seguimiento de Progreso

**Progreso por Curso:**

- Cálculo automático del porcentaje completado (0-100%)
- Marca automática cuando se alcanza 100%
- Registro de fecha de completación
- Historial de inscripciones del estudiante

**Progreso por Sección:**

- Seguimiento individual de cada sección vista
- Registro del tiempo visualizado en segundos
- Marca de sección completada con fecha
- Actualización del progreso general del curso

**Marcar Completado:**

- Endpoint para marcar secciones como completadas
- Actualización automática del progreso del curso
- Validación de permisos (solo el estudiante inscrito)

### 5. Sistema de Inscripciones

**Gestión de Inscripciones:**

- Inscripción automática con validación de perfil (solo estudiantes)
- Listado de cursos inscritos por usuario
- Filtrado de inscripciones por estado (completado/en progreso)
- Detalle de inscripción con progreso y fechas

**Control de Acceso:**

- Solo estudiantes pueden inscribirse
- Unicidad: un estudiante no puede inscribirse dos veces al mismo curso
- Verificación de permisos para ver contenido

**Estadísticas de Inscripción:**

- Total de cursos inscritos
- Cursos completados
- Progreso promedio en todos los cursos
- Tiempo total estudiado

### 6. Sistema de Avisos

**Tipos de Avisos:**

- **General**: Anuncios generales del sistema
- **Curso**: Avisos relacionados con cursos específicos
- **Sistema**: Notificaciones técnicas o de mantenimiento
- **Promoción**: Ofertas y promociones

**Gestión de Avisos:**

- Creación de avisos personalizados por usuario
- Programación de envío con fecha específica
- Marca de leído/no leído
- Comentarios adicionales

**Visualización:**

- Listado de avisos del usuario autenticado
- Filtrado por tipo y estado de lectura
- Ordenamiento por fecha (más recientes primero)

### 6.1. Sistema de Notificaciones (MongoDB)

**Arquitectura:**

- Base de datos MongoDB independiente para notificaciones
- Integración con MongoEngine para ODM
- Soporte para WebSockets con Django Channels
- Notificaciones automáticas mediante señales de Django

**Tipos de Notificaciones:**

- `nueva_inscripcion`: Notifica al instructor cuando un estudiante se inscribe
- `curso_completado`: Felicitación cuando un estudiante completa un curso (100%)
- `nueva_resena`: Cuando un estudiante deja una reseña en un curso
- `curso_actualizado`: Notificaciones sobre cambios en cursos
- `sistema`: Notificaciones administrativas del sistema
- `respuesta_comentario`: Respuestas a comentarios de reseñas
- `mensaje_directo`: Mensajes directos entre usuarios

**Notificaciones Automáticas:**

- ✅ **Inscripción a curso**: Se crean 2 notificaciones automáticamente
  - Notificación al instructor sobre nueva inscripción
  - Notificación de bienvenida al estudiante
- ✅ **Curso completado**: Se crean 2 notificaciones al alcanzar 100% de progreso
  - Felicitación al estudiante por completar el curso
  - Notificación al instructor sobre el logro del estudiante

**Características:**

- Estado de lectura (leída/no leída)
- Timestamps de creación y lectura
- Datos adicionales personalizados (datos_extra)
- Contador de notificaciones no leídas
- Filtrado por estado de lectura
- Entrega en tiempo real vía WebSockets

**Endpoints:**

- `GET /api/notificaciones/` - Listar todas las notificaciones del usuario
- `GET /api/notificaciones/no_leidas/` - Solo notificaciones no leídas
- `POST /api/notificaciones/{id}/marcar_leida/` - Marcar como leída
- `GET /api/notificaciones/contador/` - Contador de no leídas
- `POST /api/notificaciones/` - Crear notificación manual (admin)

### 6.2. Sistema de Reseñas (MongoDB)

**Arquitectura:**

- Almacenamiento en MongoDB para flexibilidad
- Una reseña por usuario por curso (índice único)
- Soporte para respuestas anidadas del instructor
- Sistema de utilidad (reseñas útiles)

**Modelo de Reseña:**

- Rating: 1.0 - 5.0 estrellas
- Título y comentario detallado
- Verificación de compra (inscripción válida)
- Imágenes adjuntas (opcional)
- Tags/etiquetas
- Timestamps de creación y modificación

**Características:**

- ✅ Crear/editar/eliminar reseña (solo propietario)
- ✅ Responder a reseñas (instructores)
- ✅ Marcar reseña como útil
- ✅ Contador de utilidad
- ✅ Mis reseñas (listado personal)
- ✅ Estadísticas por curso (promedio de ratings)
- ✅ Validación: una reseña por usuario por curso

**Endpoints:**

- `GET /api/resenas/` - Listar reseñas (filtro por curso_id)
- `POST /api/resenas/` - Crear reseña
- `GET /api/resenas/{id}/` - Detalle de reseña
- `PUT/PATCH /api/resenas/{id}/` - Actualizar reseña
- `DELETE /api/resenas/{id}/` - Eliminar reseña
- `POST /api/resenas/{id}/marcar_util/` - Marcar como útil
- `POST /api/resenas/{id}/responder/` - Responder (instructor)
- `GET /api/resenas/mis_resenas/` - Mis reseñas
- `GET /api/resenas/estadisticas_curso/` - Estadísticas por curso

### 6.3. Analytics y Eventos (MongoDB)

**Arquitectura:**

- Sistema de tracking de eventos de usuario
- Almacenamiento en MongoDB para big data
- Análisis de comportamiento y patrones
- Solo accesible para administradores

**Tipos de Eventos Rastreados:**

- `page_view`: Vista de página general
- `curso_view`: Vista de detalle de curso
- `seccion_view`: Vista de sección específica
- `video_start`: Inicio de reproducción de video
- `video_complete`: Video completado
- `curso_inscripcion`: Inscripción a curso
- `resena_create`: Creación de reseña
- `search`: Búsquedas realizadas
- `click`: Clics en elementos
- `download`: Descargas de archivos
- `login/logout`: Sesiones de usuario

**Datos Capturados:**

- Usuario ID y timestamp
- Tipo de evento
- Curso/Módulo/Sección relacionados
- Metadata flexible (JSON)
- Información de sesión (IP, User Agent)
- URL y referrer
- Duración en segundos

**Endpoints:**

- `POST /api/analytics/eventos/` - Registrar evento (autenticado)
- `GET /api/analytics/eventos/` - Listar eventos (solo admin)
- `GET /api/analytics/eventos/{id}/` - Detalle evento (solo admin)
- `GET /api/analytics/eventos/estadisticas_usuario/` - Stats por usuario (admin)
- `GET /api/analytics/eventos/eventos_recientes/` - Eventos recientes (admin)
- `GET /api/analytics/eventos/cursos_populares/` - Cursos más visitados (admin)

**Uso:**

- Análisis de comportamiento de usuarios
- Identificación de cursos populares
- Optimización de contenido
- Detección de patrones de abandono
- Métricas de engagement

### 7. Permisos y Seguridad

**Control de Acceso:**

- Autenticación requerida para operaciones sensibles
- Validación de permisos por rol de usuario
- Verificación de propiedad de recursos

**Reglas de Negocio:**

- Instructores solo pueden editar sus propios cursos
- Estudiantes solo pueden ver sus propias inscripciones
- Administradores tienen acceso completo
- Endpoints públicos para listado de cursos
- Una reseña por usuario por curso
- Solo instructores pueden responder reseñas
- Solo administradores pueden acceder a analytics

**Validaciones:**

- Control de unicidad en inscripciones
- Validación de datos en registro y login
- Verificación de tokens JWT en cada petición
- Límites en valores de progreso (0-100%)
- Rating de reseñas entre 1.0 y 5.0
- Verificación de compra para crear reseña

### 8. Filtros y Búsqueda Avanzada

**Disponible en:**

- Usuarios: por perfil, estado activo, búsqueda por nombre/email
- Cursos: por categoría, nivel, instructor, búsqueda en título/descripción
- Inscripciones: por estado de completado
- Avisos: por tipo, estado de lectura
- Notificaciones: por estado de lectura (leída/no leída)
- Reseñas: por curso_id, rating, usuario
- Analytics: por usuario_id, tipo_evento, rango de fechas

**Ordenamiento:**

- Por fecha de creación
- Por nombre o título
- Por precio (cursos)
- Por rating (reseñas)
- Ordenamiento ascendente o descendente

### 9. API RESTful Completa

**Estándares REST:**

- Verbos HTTP correctos (GET, POST, PUT, PATCH, DELETE)
- Códigos de estado HTTP apropiados
- Respuestas JSON estructuradas
- Paginación en listados

**Endpoints Personalizados:**

- `/api/users/perfil/` - Perfil del usuario actual
- `/api/users/estadisticas/` - Estadísticas del usuario
- `/api/cursos/{id}/inscribirse/` - Inscripción a curso
- `/api/secciones/{id}/marcar_completado/` - Marcar sección completada
- `/api/avisos/{id}/marcar_leido/` - Marcar aviso como leído
- `/api/notificaciones/no_leidas/` - Listar notificaciones no leídas
- `/api/notificaciones/{id}/marcar_leida/` - Marcar notificación como leída
- `/api/notificaciones/contador/` - Contador de notificaciones no leídas
- `/api/resenas/{id}/marcar_util/` - Marcar reseña como útil
- `/api/resenas/{id}/responder/` - Responder a reseña
- `/api/resenas/mis_resenas/` - Listar mis reseñas
- `/api/resenas/estadisticas_curso/` - Estadísticas de reseñas por curso
- `/api/analytics/eventos/estadisticas_usuario/` - Estadísticas por usuario
- `/api/analytics/eventos/cursos_populares/` - Cursos más visitados

**Documentación:**

- ViewSets de Django REST Framework
- Serializers personalizados por acción
- Permisos configurables por endpoint

## Instalación y Ejecución

### Prerrequisitos

- Python 3.11+
- PostgreSQL 13+
- MongoDB 6.0+
- Redis (para WebSockets)
- pip

### 1. Clonar repositorio

```bash
git https://github.com/KleverGM/Backend_cursos_online.git
cd backend_cursos_online
```

### 2. Crear entorno virtual

```bash
python -m venv .venv
.venv\Scripts\activate
```

### 3. Instalar dependencias

```bash
pip install -r requirements.txt
```

### 4. Configurar base de datos

**PostgreSQL:**

```bash
python manage.py migrate
python manage.py createsuperuser
```

**MongoDB:**

- Configurar conexión en `settings.py`
- Las colecciones se crean automáticamente: `notificaciones`, `resenas`, `eventos_usuario`

**Redis (opcional para WebSockets):**

- Instalar Redis y configurar en `settings.py`
- Requerido solo para notificaciones en tiempo real

### 5. Ejecutar servidor

```bash
python manage.py runserver
```

La API estará disponible en: `http://localhost:8000/`

## Autenticación

### Obtener token de acceso

**Registro:**

```bash
POST /api/users/register/
{
  "username": "estudiante1",
  "email": "estudiante@example.com",
  "password": "password123",
  "password_confirm": "password123",
  "first_name": "Juan",
  "last_name": "Pérez",
  "tipo_usuario": "estudiante"
}
```

**Login:**

```bash
POST /api/users/login/
{
  "email": "estudiante@example.com",
  "password": "password123"
}
```

**Respuesta:**

```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "username": "estudiante1",
    "email": "estudiante@example.com"
  }
}
```

### Usar token en requests

```bash
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...
```

## Endpoints de la API

### Autenticación

- `POST /api/users/register/` - Registro de usuario
- `POST /api/users/login/` - Login de usuario
- `POST /api/auth/token/` - Obtener token JWT
- `POST /api/auth/refresh/` - Renovar token

### Usuarios

- `GET /api/users/` - Listar usuarios
- `GET /api/users/{id}/` - Detalle de usuario
- `PUT /api/users/{id}/` - Actualizar usuario
- `GET /api/users/perfil/` - Perfil del usuario autenticado

### Cursos

- `GET /api/cursos/` - Listar cursos
- `POST /api/cursos/` - Crear curso
- `GET /api/cursos/{id}/` - Detalle de curso
- `PUT /api/cursos/{id}/` - Actualizar curso
- `POST /api/cursos/{id}/inscribirse/` - Inscribirse en curso

### Módulos

- `GET /api/modulos/` - Listar módulos
- `POST /api/modulos/` - Crear módulo
- `GET /api/modulos/{id}/` - Detalle de módulo
- `PUT /api/modulos/{id}/` - Actualizar módulo

### Secciones

- `GET /api/secciones/` - Listar secciones
- `POST /api/secciones/` - Crear sección
- `GET /api/secciones/{id}/` - Detalle de sección
- `POST /api/secciones/{id}/marcar_completado/` - Marcar completada

### Inscripciones

- `GET /api/inscripciones/` - Listar inscripciones del usuario
- `GET /api/inscripciones/{id}/` - Detalle de inscripción

### Avisos

- `GET /api/avisos/` - Listar avisos del usuario
- `POST /api/avisos/` - Crear aviso
- `PUT /api/avisos/{id}/` - Actualizar aviso

### Notificaciones

- `GET /api/notificaciones/` - Listar notificaciones del usuario
- `GET /api/notificaciones/no_leidas/` - Solo no leídas
- `POST /api/notificaciones/{id}/marcar_leida/` - Marcar como leída
- `GET /api/notificaciones/contador/` - Contador de no leídas
- `POST /api/notificaciones/` - Crear notificación (admin)

### Reseñas

- `GET /api/resenas/` - Listar reseñas (filtro por curso_id)
- `POST /api/resenas/` - Crear reseña
- `GET /api/resenas/{id}/` - Detalle de reseña
- `PUT/PATCH /api/resenas/{id}/` - Actualizar reseña
- `DELETE /api/resenas/{id}/` - Eliminar reseña
- `POST /api/resenas/{id}/marcar_util/` - Marcar como útil
- `POST /api/resenas/{id}/responder/` - Responder (instructor)
- `GET /api/resenas/mis_resenas/` - Mis reseñas
- `GET /api/resenas/estadisticas_curso/` - Estadísticas por curso

### Analytics

- `POST /api/analytics/eventos/` - Registrar evento
- `GET /api/analytics/eventos/` - Listar eventos (admin)
- `GET /api/analytics/eventos/{id}/` - Detalle evento (admin)
- `GET /api/analytics/eventos/estadisticas_usuario/` - Stats por usuario (admin)
- `GET /api/analytics/eventos/eventos_recientes/` - Eventos recientes (admin)
- `GET /api/analytics/eventos/cursos_populares/` - Cursos más visitados (admin)

## Ejemplos de Uso con Token

### 1. Crear un curso (como instructor)

```bash
curl -X POST http://localhost:8000/api/cursos/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Introducción a Python",
    "descripcion": "Aprende los fundamentos de Python",
    "categoria": "programacion",
    "nivel": "principiante",
    "precio": "99.99"
  }'
```

### 2. Listar cursos con filtros

```bash
# Todos los cursos
curl http://localhost:8000/api/cursos/

# Cursos de programación
curl "http://localhost:8000/api/cursos/?categoria=programacion"

# Buscar por título
curl "http://localhost:8000/api/cursos/?search=python"
```

### 3. Inscribirse en un curso

```bash
curl -X POST http://localhost:8000/api/cursos/1/inscribirse/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 4. Crear módulo

```bash
curl -X POST http://localhost:8000/api/modulos/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Fundamentos de Python",
    "descripcion": "Conceptos básicos",
    "orden": 1,
    "curso": 1
  }'
```

### 5. Crear sección

```bash
curl -X POST http://localhost:8000/api/secciones/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Variables y tipos de datos",
    "contenido": "En esta lección aprenderemos...",
    "orden": 1,
    "duracion_minutos": 15,
    "modulo": 1
  }'
```

### 6. Marcar sección completada

```bash
curl -X POST http://localhost:8000/api/secciones/1/marcar_completado/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 7. Ver mis inscripciones

```bash
curl http://localhost:8000/api/inscripciones/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 8. Listar notificaciones no leídas

```bash
curl http://localhost:8000/api/notificaciones/no_leidas/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 9. Crear reseña

```bash
curl -X POST http://localhost:8000/api/resenas/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "curso_id": 1,
    "rating": 4.5,
    "titulo": "Excelente curso",
    "comentario": "Aprendí mucho, muy recomendado"
  }'
```

### 10. Registrar evento de analytics

```bash
curl -X POST http://localhost:8000/api/analytics/eventos/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "tipo_evento": "curso_view",
    "curso_id": 1,
    "duracion_segundos": 120
  }'
```

## Tecnologías Utilizadas

### Backend

- **Django 5.2.8**: Framework web principal
- **Django REST Framework**: API REST
- **PostgreSQL**: Base de datos relacional principal
- **MongoDB + MongoEngine**: Base de datos NoSQL para notificaciones, reseñas y analytics
- **Redis + Django Channels**: WebSockets para notificaciones en tiempo real
- **Simple JWT**: Autenticación con tokens JWT

### Despliegue

- **Gunicorn**: Servidor WSGI
- **Nginx**: Reverse proxy
- **GitHub Actions**: CI/CD pipeline
- **Azure VM**: Hosting en la nube

## Integración y Despliegue Continuo (CI/CD)

El proyecto cuenta con un pipeline automatizado de CI/CD implementado con GitHub Actions que se ejecuta automáticamente en cada cambio al código.

### Triggers

El workflow se activa en las siguientes situaciones:

1. **Push**: Cuando se sube código a la rama `main` del repositorio
2. **Pull Request**: Cuando se realiza una solicitud de cambios a la rama `main` del repositorio

### Job: Test

Este job se ejecuta en cada push o pull request para validar que el código funciona correctamente:

**Configuración:**

- **Entorno**: Ubuntu Latest
- **Base de datos temporal**: PostgreSQL 16 con health checks
- **Python**: 3.12

**Pasos del Job:**

1. **Checkout del código**: Descarga el código del repositorio
2. **Configuración de Python**: Instala Python 3.12
3. **Instalación de dependencias**: Instala todas las dependencias desde `requirements.txt`
4. **Ejecución de tests**: Ejecuta la suite de tests de Django con las siguientes variables de entorno:
   - Base de datos PostgreSQL temporal
   - Secret key de prueba
   - Configuración de hosts permitidos

**Servicio PostgreSQL:**

```yaml
services:
  postgres:
    image: postgres:16
    env:
      POSTGRES_PASSWORD: postgres
    options: >-
      --health-cmd pg_isready
      --health-interval 10s
      --health-timeout 5s
      --health-retries 5
    ports:
      - 5432:5432
```

### Job: Deploy

Este job se ejecuta **solo si el job de test es exitoso** y **solo en la rama main**:

**Requisitos:**

- El job `test` debe completarse exitosamente
- El push/merge debe ser hacia la rama `main` o `master`

**Pasos del Deployment:**

1. **Setup SSH**: Configura las credenciales SSH para conectarse al servidor VPS
2. **Conexión al VPS**: Se conecta al servidor usando las credenciales almacenadas en GitHub Secrets
3. **Actualización de código**:
   - Hace pull del código más reciente desde `origin/main`
   - Reinicia el código a la última versión
4. **Activación del entorno virtual**: Activa el virtualenv de Python en el servidor
5. **Instalación de dependencias**: Actualiza las dependencias desde `requirements.txt`
6. **Migraciones**: Aplica las migraciones de base de datos pendientes
7. **Archivos estáticos**: Recolecta los archivos estáticos
8. **Reinicio del servicio**: Reinicia el servicio de la aplicación

**Secrets Requeridos:**

- `VPS_SSH_KEY`: Clave SSH privada para acceder al servidor
- `VPS_HOST`: Dirección IP o dominio del servidor
- `VPS_USERNAME`: Usuario SSH del servidor
- `DEPLOY_PATH`: Ruta de deployment en el servidor
- `PROJECT_PATH`: Ruta del proyecto en el servidor
- `VENV_PATH`: Ruta del entorno virtual en el servidor

### Beneficios del CI/CD

✅ **Automatización**: Despliegue automático sin intervención manual  
✅ **Calidad**: Tests automáticos antes de cada deployment  
✅ **Confiabilidad**: Validación de PostgreSQL antes de desplegar  
✅ **Rapidez**: Deployment inmediato al hacer merge a main  
✅ **Seguridad**: Credenciales protegidas con GitHub Secrets  
✅ **Trazabilidad**: Historial completo de deployments en GitHub Actions

### Archivo de Configuración

El workflow está definido en: `.github/workflows/deploy.yml`

---

## Subida de Videos MP4

La aplicación soporta dos tipos de videos para las secciones de cursos:

### Opción 1: URL de YouTube

- Videos alojados en YouTube
- Puede tener restricciones de reproducción (Error 152-4)
- No consume espacio del servidor

### Opción 2: Archivo MP4 (Recomendado)

- Videos alojados en el servidor propio
- Sin restricciones de reproducción
- Máximo 500 MB por archivo
- Formatos: MP4, MOV, AVI, MKV

**Configuración del Backend:**

```python
# settings.py
FILE_UPLOAD_MAX_MEMORY_SIZE = 524288000  # 500 MB
DATA_UPLOAD_MAX_MEMORY_SIZE = 524288000  # 500 MB
```

**Uso en la App:**

1. Crear/editar sección
2. Seleccionar "Subir MP4" (en lugar de URL)
3. Elegir archivo de video
4. El backend genera URL completa: `https://api.../media/videos/video.mp4`
5. La app reproduce sin restricciones usando VideoPlayerDialog

---

## Gestión de Avisos y Notificaciones

### Funcionalidades de Administrador:

**Crear Avisos:**

- Avisos individuales para usuarios específicos
- Avisos broadcast (envío masivo)
- Tipos: información, advertencia, éxito, error, anuncio
- Marcar como importante

**Gestionar Avisos:**

- Ver todos los avisos del sistema
- Filtros por estado (leídos/no leídos/importantes)
- Búsqueda por título y contenido
- Editar y eliminar avisos con confirmación

**Endpoints:**

```
POST /api/avisos/              - Crear aviso
GET /api/avisos/               - Listar todos
PUT /api/avisos/{id}/          - Actualizar
DELETE /api/avisos/{id}/       - Eliminar
POST /api/avisos/broadcast/    - Envío masivo
```

---

## Sistema de Analytics

El módulo de analytics registra eventos de usuario para análisis:

**Eventos Rastreados:**

- Vistas de cursos (`course_view`)
- Inscripciones (`enrollment_created`)
- Progreso de secciones (`section_completed`)
- Creación de reseñas (`review_created`)

**Endpoints de Analytics:**

```
POST /api/analytics/eventos/                        - Registrar evento
GET /api/analytics/eventos/estadisticas_globales/   - Stats globales (admin)
GET /api/analytics/eventos/cursos_populares/        - Cursos más visitados
GET /api/analytics/eventos/estadisticas_usuario/    - Stats por usuario
```

**Datos de Estadísticas Globales:**

- Total de usuarios, cursos, inscripciones
- Ingresos totales
- Usuarios activos
- Cursos activos
- Tasa de completación promedio
- Distribución de usuarios por rol

---

## Gestión de Inscripciones (Admin)

Los administradores tienen control total sobre las inscripciones de estudiantes:

**Ver Inscripciones:**

- Lista completa con curso, estudiante, progreso, fechas
- Filtros: por curso, por usuario, por estado (completado/en progreso)
- Los filtros se pueden combinar

**Inscripción Manual:**

- El admin puede inscribir estudiantes directamente
- Útil para promociones, resolver problemas o acceso directo
- Requiere ID de curso e ID de usuario

**Cancelar Inscripciones:**

- Eliminar inscripciones con confirmación
- ⚠️ El estudiante pierde acceso al curso y su progreso
- Útil para correcciones, reembolsos o casos especiales

**Endpoints de Inscripciones:**

```
GET /api/inscripciones/          - Listar todas (filtros: curso, usuario, completado)
POST /api/inscripciones/         - Crear inscripción manual
DELETE /api/inscripciones/{id}/  - Eliminar inscripción
```

---

## Configuración de WebSocket (Azure)

El backend usa **Gunicorn** para HTTP y **Daphne** para WebSocket:

```
Internet → Nginx (80/443)
    ├── HTTP /api/* → Gunicorn :8000 (REST API)
    └── WebSocket /ws/* → Daphne :8001 (WebSocket)
```

**Servicios systemd:**

1. **gunicorn.service** - Maneja API REST en puerto 8000
2. **daphne.service** - Maneja WebSocket en puerto 8001

**Channel Layer:**

- Actualmente: `InMemoryChannelLayer` (desarrollo)
- Para producción multi-worker: Migrar a Redis

**Nginx Config:**

```nginx
location /ws/ {
    proxy_pass http://127.0.0.1:8001;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}
```

---

## Sistema de Notificaciones en Tiempo Real

**Tipos de Notificaciones:**

- `mensaje_sistema` - Anuncios generales
- `curso_nuevo` - Nuevo curso disponible
- `inscripcion_confirmada` - Confirmación de inscripción
- `progreso_actualizado` - Progreso en curso
- `curso_completado` - Curso finalizado
- `certificado_disponible` - Certificado listo
- `mensaje_instructor` - Mensaje del instructor

**Funcionamiento:**

- WebSocket conecta a: `wss://api.../ws/notificaciones/`
- Autenticación con JWT token en query params
- Notificaciones push en tiempo real
- Estados: leída/no leída

**Signals Automáticos:**
El backend genera notificaciones automáticamente cuando:

- Se crea una inscripción
- Se actualiza el progreso
- Se completa un curso
- Hay nuevos avisos para el usuario

---

## Deployment en Azure

### Arquitectura de Producción

**URL:** https://cursos-online-api.desarrollo-software.xyz/

**Stack:**

- Azure VM Ubuntu
- Nginx (proxy reverso en puerto 80/443)
- Gunicorn (servidor WSGI en puerto 8000)
- Daphne (servidor ASGI en puerto 8001 para WebSocket)
- PostgreSQL (base de datos)

**Servicios systemd:**

```bash
# Ver estado de servicios
sudo systemctl status gunicorn
sudo systemctl status daphne

# Reiniciar servicios
sudo systemctl restart gunicorn
sudo systemctl restart daphne

# Ver logs
sudo journalctl -u gunicorn -n 50
sudo journalctl -u daphne -n 50
```

### Desplegar Cambios

```bash
# 1. Conectar por SSH
ssh azureuser@<ip-azure>

# 2. Ir al directorio del proyecto
cd /home/azureuser/backend_cursos_online

# 3. Activar entorno virtual
source /home/azureuser/venv/bin/activate

# 4. Actualizar código
git pull origin main

# 5. Instalar dependencias
pip install -r requirements.txt

# 6. Ejecutar migraciones
python manage.py migrate

# 7. Recopilar archivos estáticos
python manage.py collectstatic --noinput

# 8. Reiniciar servicios
sudo systemctl restart gunicorn
sudo systemctl restart daphne
```

### Variables de Entorno (.env)

```bash
DEBUG=False
ALLOWED_HOSTS=*
SECRET_KEY=TU_CLAVE_SECRETA
DB_NAME=cursos_online_db
DB_USER=admin_user
DB_PASSWORD=Admin123
DB_HOST=127.0.0.1
DB_PORT=5432
```

### Configuración de Archivos Media

El servidor almacena videos y archivos en `media/`:

```python
# settings.py
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

FILE_UPLOAD_MAX_MEMORY_SIZE = 524288000  # 500 MB
DATA_UPLOAD_MAX_MEMORY_SIZE = 524288000
```

**Nginx Config para Media:**

```nginx
location /media/ {
    alias /home/azureuser/backend_cursos_online/media/;
}
```

### Logs del Backend en Azure

**Opción 1: Log Stream (Azure Portal)**

1. Azure Portal → Tu VM → Configuración → Logs
2. Seleccionar "Log Stream"
3. Ver logs en tiempo real

**Opción 2: SSH + journalctl**

```bash
# Logs de Gunicorn
sudo journalctl -u gunicorn -f

# Logs de Daphne
sudo journalctl -u daphne -f

# Logs de Nginx
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

**Opción 3: Azure CLI**

```bash
az vm run-command invoke \
  --resource-group tu-grupo \
  --name tu-vm \
  --command-id RunShellScript \
  --scripts "sudo journalctl -u gunicorn -n 100"
```
