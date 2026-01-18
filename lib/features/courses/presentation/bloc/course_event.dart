import 'package:equatable/equatable.dart';
import '../../domain/entities/course_filters.dart';

/// Eventos del BLoC de cursos
abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

/// Obtener lista de cursos con filtros
class GetCoursesEvent extends CourseEvent {
  final CourseFilters? filters;

  const GetCoursesEvent({this.filters});

  @override
  List<Object?> get props => [filters];
}

/// Obtener detalle de un curso
class GetCourseDetailEvent extends CourseEvent {
  final int courseId;

  const GetCourseDetailEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

/// Inscribirse a un curso
class EnrollInCourseEvent extends CourseEvent {
  final int courseId;

  const EnrollInCourseEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

/// Obtener cursos inscritos
class GetEnrolledCoursesEvent extends CourseEvent {
  const GetEnrolledCoursesEvent();
}

/// Obtener mis cursos (instructor)
class GetMyCoursesEvent extends CourseEvent {
  const GetMyCoursesEvent();
}

/// Refrescar cursos
class RefreshCoursesEvent extends CourseEvent {
  const RefreshCoursesEvent();
}

/// Marcar sección como completada
class MarkSectionCompletedEvent extends CourseEvent {
  final int sectionId;

  const MarkSectionCompletedEvent(this.sectionId);

  @override
  List<Object> get props => [sectionId];
}

/// Crear un nuevo curso
class CreateCourseEvent extends CourseEvent {
  final String titulo;
  final String descripcion;
  final String categoria;
  final String nivel;
  final double precio;
  final String? imagenPath;

  const CreateCourseEvent({
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.nivel,
    required this.precio,
    this.imagenPath,
  });

  @override
  List<Object?> get props => [
        titulo,
        descripcion,
        categoria,
        nivel,
        precio,
        imagenPath,
      ];
}

/// Actualizar un curso existente
class UpdateCourseEvent extends CourseEvent {
  final int courseId;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String nivel;
  final double precio;
  final String? imagenPath;

  const UpdateCourseEvent({
    required this.courseId,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.nivel,
    required this.precio,
    this.imagenPath,
  });

  @override
  List<Object?> get props => [
        courseId,
        titulo,
        descripcion,
        categoria,
        nivel,
        precio,
        imagenPath,
      ];
}

/// Eliminar un curso
class DeleteCourseEvent extends CourseEvent {
  final int courseId;

  const DeleteCourseEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

/// Activar un curso
class ActivateCourseEvent extends CourseEvent {
  final int courseId;

  const ActivateCourseEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

/// Desactivar un curso
class DeactivateCourseEvent extends CourseEvent {
  final int courseId;

  const DeactivateCourseEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

/// Obtener inscripciones del instructor
class GetInstructorEnrollmentsEvent extends CourseEvent {
  final int? courseId;

  const GetInstructorEnrollmentsEvent({this.courseId});

  @override
  List<Object?> get props => [courseId];
}
