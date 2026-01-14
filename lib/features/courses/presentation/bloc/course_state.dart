import 'package:equatable/equatable.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/course_detail.dart';

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
