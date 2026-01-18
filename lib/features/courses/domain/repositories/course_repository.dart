import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/course.dart';
import '../entities/course_detail.dart';
import '../entities/course_filters.dart';
import '../entities/enrollment.dart';

/// Interfaz del repositorio de cursos
abstract class CourseRepository {
  /// Obtener lista de cursos con filtros opcionales
  Future<Either<Failure, List<Course>>> getCourses({CourseFilters? filters});

  /// Obtener detalle de un curso específico
  Future<Either<Failure, CourseDetail>> getCourseDetail(int courseId);

  /// Inscribirse a un curso
  Future<Either<Failure, Enrollment>> enrollInCourse(int courseId);

  /// Obtener cursos inscritos del usuario
  Future<Either<Failure, List<Course>>> getEnrolledCourses();

  /// Obtener cursos creados por el instructor (si es instructor)
  Future<Either<Failure, List<Course>>> getMyCourses();

  /// Marcar una sección como completada
  Future<Either<Failure, void>> markSectionCompleted(int sectionId);
}
