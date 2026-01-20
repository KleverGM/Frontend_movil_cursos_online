import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/course.dart';
import '../entities/course_detail.dart';
import '../entities/course_filters.dart';
import '../entities/enrollment.dart';
import '../entities/enrollment_detail.dart';
import '../entities/course_stats.dart';
import '../entities/global_stats.dart';

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
  
  /// Crear un nuevo curso
  Future<Either<Failure, Course>> createCourse({
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    String? imagenPath,
  });
  
  /// Actualizar un curso existente
  Future<Either<Failure, Course>> updateCourse({
    required int courseId,
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    String? imagenPath,
  });
  
  /// Eliminar un curso (desactivación lógica)
  Future<Either<Failure, void>> deleteCourse(int courseId);

  /// Activar un curso (hacerlo visible en el catálogo público)
  Future<Either<Failure, Course>> activateCourse(int courseId);
  
  /// Desactivar un curso (ocultarlo del catálogo público)
  Future<Either<Failure, Course>> deactivateCourse(int courseId);

  /// Obtener inscripciones de los cursos del instructor
  Future<Either<Failure, List<EnrollmentDetail>>> getInstructorEnrollments({int? courseId});
  
  /// Obtener estadísticas detalladas de un curso
  Future<Either<Failure, CourseStats>> getCourseStats(int courseId);
  
  /// Obtener estadísticas globales de la plataforma (solo administradores)
  Future<Either<Failure, GlobalStats>> getGlobalStats();
}
