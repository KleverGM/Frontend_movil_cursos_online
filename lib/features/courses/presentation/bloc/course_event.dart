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
