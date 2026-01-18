import 'package:equatable/equatable.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/course_detail.dart';
import '../../domain/entities/enrollment_detail.dart';

/// Estados del BLoC de cursos
abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class CourseInitial extends CourseState {
  const CourseInitial();
}

/// Cargando cursos
class CourseLoading extends CourseState {
  const CourseLoading();
}

/// Cursos cargados exitosamente
class CoursesLoaded extends CourseState {
  final List<Course> courses;
  final String? activeFilter;

  const CoursesLoaded(this.courses, {this.activeFilter});

  @override
  List<Object?> get props => [courses, activeFilter];
}

/// Detalle de curso cargado
class CourseDetailLoaded extends CourseState {
  final CourseDetail courseDetail;

  const CourseDetailLoaded(this.courseDetail);

  @override
  List<Object> get props => [courseDetail];
}

/// Inscripción exitosa
class EnrollmentSuccess extends CourseState {
  final String message;
  final int courseId;

  const EnrollmentSuccess(this.message, this.courseId);

  @override
  List<Object> get props => [message, courseId];
}

/// Cursos inscritos cargados
class EnrolledCoursesLoaded extends CourseState {
  final List<Course> courses;

  const EnrolledCoursesLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

/// Mis cursos (instructor) cargados
class MyCoursesLoaded extends CourseState {
  final List<Course> courses;

  const MyCoursesLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

/// Error
class CourseError extends CourseState {
  final String message;

  const CourseError(this.message);

  @override
  List<Object> get props => [message];
}

/// Sección marcada como completada
class SectionCompletedSuccess extends CourseState {
  final int sectionId;

  const SectionCompletedSuccess(this.sectionId);

  @override
  List<Object> get props => [sectionId];
}

/// Curso creado exitosamente
class CourseCreatedSuccess extends CourseState {
  final Course course;

  const CourseCreatedSuccess(this.course);

  @override
  List<Object> get props => [course];
}

/// Curso actualizado exitosamente
class CourseUpdatedSuccess extends CourseState {
  final Course course;

  const CourseUpdatedSuccess(this.course);

  @override
  List<Object> get props => [course];
}

/// Curso eliminado exitosamente
class CourseDeletedSuccess extends CourseState {
  final int courseId;

  const CourseDeletedSuccess(this.courseId);

  @override
  List<Object> get props => [courseId];
}

/// Inscripciones del instructor cargadas
class InstructorEnrollmentsLoaded extends CourseState {
  final List<EnrollmentDetail> enrollments;

  const InstructorEnrollmentsLoaded(this.enrollments);

  @override
  List<Object> get props => [enrollments];
}
