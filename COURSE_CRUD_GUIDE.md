# Funcionalidad de Gestión de Cursos para Instructores

## Descripción

Se ha implementado la funcionalidad completa de CRUD (Crear, Leer, Actualizar, Eliminar) de cursos para instructores en el frontend Flutter, conectado con el backend Django REST Framework.

## Archivos Creados/Modificados

### Nuevos Archivos

1. **Domain Layer (Entidades y Casos de Uso)**
   - `lib/features/courses/domain/entities/course_input.dart` - Modelo de entrada para formularios
   - `lib/features/courses/domain/usecases/create_course_usecase.dart` - Caso de uso para crear cursos
   - `lib/features/courses/domain/usecases/update_course_usecase.dart` - Caso de uso para actualizar cursos
   - `lib/features/courses/domain/usecases/delete_course_usecase.dart` - Caso de uso para eliminar cursos

2. **Presentation Layer (UI)**
   - `lib/features/courses/presentation/pages/course_form_page.dart` - Formulario para crear/editar cursos
   - `lib/features/courses/presentation/pages/manage_courses_page.dart` - Página para gestionar cursos del instructor

### Archivos Modificados

1. **Domain Layer**
   - `lib/features/courses/domain/repositories/course_repository.dart` - Agregados métodos: `createCourse`, `updateCourse`, `deleteCourse`

2. **Data Layer**
   - `lib/features/courses/data/datasources/course_remote_datasource.dart` - Implementación de llamadas API para CRUD
   - `lib/features/courses/data/repositories/course_repository_impl.dart` - Implementación del repositorio

3. **Presentation Layer (BLoC)**
   - `lib/features/courses/presentation/bloc/course_event.dart` - Agregados eventos: `CreateCourseEvent`, `UpdateCourseEvent`, `DeleteCourseEvent`
   - `lib/features/courses/presentation/bloc/course_state.dart` - Agregados estados: `CourseCreatedSuccess`, `CourseUpdatedSuccess`, `CourseDeletedSuccess`
   - `lib/features/courses/presentation/bloc/course_bloc.dart` - Implementación de manejadores de eventos CRUD

4. **Dependency Injection**
   - `lib/core/di/injection.dart` - Registro de nuevas dependencias (casos de uso)

## Características Implementadas

### 1. Crear Curso

- Formulario completo con validación
- Campos: título, descripción, categoría, nivel, precio, imagen
- Subida de imágenes desde galería
- Validaciones en tiempo real

### 2. Editar Curso

- Carga de datos existentes del curso
- Modificación de todos los campos
- Actualización de imagen opcional
- Mantiene imagen anterior si no se selecciona nueva

### 3. Eliminar Curso

- Confirmación antes de eliminar
- Eliminación lógica (desactivación en el backend)
- Actualización automática de la lista

### 4. Listar Mis Cursos

- Vista de todos los cursos del instructor
- Tarjetas con información resumida
- Estadísticas: estudiantes, módulos, secciones
- Botones rápidos de edición y eliminación

## Uso

### Para Instructores

#### Acceder a la Gestión de Cursos

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (context) => getIt<CourseBloc>(),
      child: const ManageCoursesPage(),
    ),
  ),
);
```

#### Crear un Nuevo Curso

1. Desde `ManageCoursesPage`, tocar el botón flotante "Crear Curso"
2. Completar el formulario:
   - **Título**: Mínimo 5 caracteres (requerido)
   - **Descripción**: Mínimo 20 caracteres (requerido)
   - **Categoría**: Seleccionar de lista desplegable (requerido)
   - **Nivel**: Principiante, Intermedio o Avanzado (requerido)
   - **Precio**: Valor en USD, mayor o igual a 0 (requerido)
   - **Imagen**: Opcional, seleccionar desde galería
3. Tocar "Crear Curso"

#### Editar un Curso Existente

1. Desde `ManageCoursesPage`, tocar una tarjeta de curso o el botón "Editar"
2. Modificar los campos deseados
3. Opcionalmente, cambiar la imagen
4. Tocar "Guardar Cambios"

#### Eliminar un Curso

1. Desde `ManageCoursesPage`, tocar el ícono de papelera
2. Confirmar la eliminación en el diálogo
3. El curso será desactivado (soft delete)

## Estructura de Datos

### CourseInput

```dart
class CourseInput {
  final int? id;              // null para nuevo, int para edición
  final String titulo;
  final String descripcion;
  final String categoria;
  final String nivel;
  final double precio;
  final String? imagenPath;   // Path local de imagen nueva
  final String? imagenUrl;    // URL de imagen existente
}
```

### Categorías Disponibles

- programacion → Programación
- diseño → Diseño
- marketing → Marketing
- negocios → Negocios
- idiomas → Idiomas
- musica → Música
- fotografia → Fotografía
- otros → Otros

### Niveles Disponibles

- principiante → Principiante
- intermedio → Intermedio
- avanzado → Avanzado

## Endpoints del Backend Utilizados

- `POST /api/cursos/` - Crear curso
- `PUT /api/cursos/{id}/` - Actualizar curso
- `DELETE /api/cursos/{id}/` - Eliminar curso (soft delete)
- `GET /api/cursos/mis_cursos/` - Obtener cursos del instructor

## Validaciones

### Frontend

- **Título**:
  - No vacío
  - Mínimo 5 caracteres
- **Descripción**:
  - No vacía
  - Mínimo 20 caracteres
- **Categoría**: Debe seleccionar una opción válida

- **Nivel**: Debe seleccionar una opción válida

- **Precio**:
  - Número válido
  - Mayor o igual a 0

### Backend

- El instructor debe estar autenticado
- Solo el propietario o administrador puede editar/eliminar
- Validación de campos requeridos
- Validación de tipos de datos

## Permisos

### Crear Curso

- Usuario autenticado
- Perfil: Instructor o Administrador

### Editar Curso

- Usuario autenticado
- Propietario del curso o Administrador

### Eliminar Curso

- Usuario autenticado
- Propietario del curso o Administrador

## Manejo de Imágenes

Las imágenes se suben usando `multipart/form-data` cuando se incluye una imagen nueva:

- **Formato**: JPEG, PNG
- **Tamaño máximo sugerido**: 1920x1080
- **Calidad**: 85%
- **Ubicación en servidor**: `/media/cursos/`

## Estados del BLoC

### Durante Operaciones

- `CourseLoading` - Mientras se procesa la petición

### Éxito

- `CourseCreatedSuccess(course)` - Curso creado exitosamente
- `CourseUpdatedSuccess(course)` - Curso actualizado exitosamente
- `CourseDeletedSuccess(courseId)` - Curso eliminado exitosamente

### Error

- `CourseError(message)` - Error en cualquier operación

## Ejemplos de Uso Programático

### Crear Curso desde BLoC

```dart
context.read<CourseBloc>().add(
  CreateCourseEvent(
    titulo: 'Flutter Avanzado',
    descripcion: 'Aprende Flutter desde cero hasta nivel avanzado...',
    categoria: 'programacion',
    nivel: 'avanzado',
    precio: 99.99,
    imagenPath: '/path/to/image.jpg',
  ),
);
```

### Actualizar Curso

```dart
context.read<CourseBloc>().add(
  UpdateCourseEvent(
    courseId: 1,
    titulo: 'Flutter Avanzado - Actualizado',
    descripcion: 'Nueva descripción...',
    categoria: 'programacion',
    nivel: 'avanzado',
    precio: 89.99,
    // imagenPath: null, // Mantener imagen anterior
  ),
);
```

### Eliminar Curso

```dart
context.read<CourseBloc>().add(
  DeleteCourseEvent(1),
);
```

## Dependencias Requeridas

Asegúrate de tener estas dependencias en `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  dio: ^5.3.3
  image_picker: ^1.0.4
  equatable: ^2.0.5
  dartz: ^0.10.1
  get_it: ^7.6.4
```

## Notas Importantes

1. **Permisos de Cámara/Galería**: Asegúrate de configurar los permisos en:
   - Android: `android/app/src/main/AndroidManifest.xml`
   - iOS: `ios/Runner/Info.plist`

2. **Autenticación**: El usuario debe estar autenticado con un token JWT válido

3. **Rol de Instructor**: El usuario debe tener el perfil de "instructor" o "administrador"

4. **Imágenes Grandes**: Las imágenes grandes pueden demorar en subirse dependiendo de la conexión

5. **Soft Delete**: Los cursos eliminados no se borran de la base de datos, solo se desactivan (`activo = False`)

## Troubleshooting

### Error: "Solo instructores pueden crear cursos"

- **Causa**: Usuario no tiene perfil de instructor
- **Solución**: Verificar que el usuario autenticado tenga `perfil = 'instructor'` o `'administrador'`

### Error al subir imagen

- **Causa**: Permisos de galería no otorgados
- **Solución**: Otorgar permisos de almacenamiento/galería en configuración del dispositivo

### Error: "No tienes permisos para editar este curso"

- **Causa**: Usuario no es propietario del curso
- **Solución**: Solo el instructor que creó el curso o un administrador pueden editarlo

## Próximas Mejoras Sugeridas

1. Vista previa de imagen antes de subir
2. Compresión automática de imágenes
3. Crop de imágenes
4. Múltiples imágenes por curso
5. Modo offline con sincronización
6. Validación de URL de videos
7. Duplicar curso existente
8. Estadísticas detalladas del curso
