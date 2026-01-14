import 'package:equatable/equatable.dart';

/// Eventos del BLoC de cursos
abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

/// Obtener lista de cursos
class GetCoursesEvent extends CourseEvent {
  final String? categoria;
  final String? nivel;
  final String? search;
  final String? ordering;

  const GetCoursesEvent({
    this.categoria,
    this.nivel,
    this.search,
    this.ordering,
  });

  @override
  List<Object?> get props => [categoria, nivel, search, ordering];
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
