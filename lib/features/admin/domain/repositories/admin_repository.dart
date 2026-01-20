import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../courses/domain/entities/course.dart';
import '../entities/enrollment_admin.dart';
import '../entities/platform_stats.dart';
import '../entities/popular_course.dart';
import '../entities/user_summary.dart';
import '../entities/course_stats_admin.dart';

abstract class AdminRepository {
  // Platform Stats
  Future<Either<Failure, PlatformStats>> getPlatformStats({int dias = 7});
  Future<Either<Failure, List<PopularCourse>>> getPopularCourses({int dias = 30});
  
  // Users Management
  Future<Either<Failure, List<UserSummary>>> getUsers({
    String? perfil,
    bool? isActive,
    String? search,
  });
  
  Future<Either<Failure, UserSummary>> createUser({
    required String username,
    required String email,
    required String password,
    required String perfil,
    String? firstName,
    String? lastName,
  });
  
  Future<Either<Failure, UserSummary>> updateUser({
    required int userId,
    String? username,
    String? email,
    String? perfil,
    String? firstName,
    String? lastName,
    bool? isActive,
  });
  
  Future<Either<Failure, void>> deleteUser(int userId);
  
  Future<Either<Failure, void>> changeUserPassword({
    required int userId,
    required String newPassword,
  });
  
  // Courses Management
  Future<Either<Failure, List<Course>>> getAllCourses({
    String? categoria,
    String? nivel,
    String? search,
    bool? activo,
    int? instructorId,
  });
  
  Future<Either<Failure, Course>> createCourseAsAdmin({
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    required int instructorId,
    String? imagenPath,
  });
  
  Future<Either<Failure, Course>> updateCourseAsAdmin({
    required int courseId,
    String? titulo,
    String? descripcion,
    String? categoria,
    String? nivel,
    double? precio,
    int? instructorId,
    String? imagenPath,
  });
  
  Future<Either<Failure, void>> deleteCourseAsAdmin(int courseId);
  
  Future<Either<Failure, Course>> activateCourse(int courseId);
  
  Future<Either<Failure, Course>> deactivateCourse(int courseId);
  
  Future<Either<Failure, CourseStatsAdmin>> getCourseStatistics(int courseId);
  
  // Enrollments Management
  Future<Either<Failure, List<EnrollmentAdmin>>> getAllEnrollments({
    int? cursoId,
    int? usuarioId,
    bool? completado,
  });
  
  Future<Either<Failure, EnrollmentAdmin>> createEnrollment({
    required int cursoId,
    required int usuarioId,
  });
  
  Future<Either<Failure, EnrollmentAdmin>> updateEnrollment({
    required int enrollmentId,
    double? progreso,
    bool? completado,
    int? cursoId,
    int? usuarioId,
  });
  
  Future<Either<Failure, void>> deleteEnrollment(int enrollmentId);
}
