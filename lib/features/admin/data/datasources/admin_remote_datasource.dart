import '../../../courses/data/models/course_model.dart';
import '../models/course_stats_admin_model.dart';
import '../models/enrollment_admin_model.dart';
import '../models/platform_stats_model.dart';
import '../models/popular_course_model.dart';
import '../models/user_summary_model.dart';

abstract class AdminRemoteDataSource {
  // Platform Stats
  Future<PlatformStatsModel> getPlatformStats({int dias = 7});
  Future<List<PopularCourseModel>> getPopularCourses({int dias = 30});
  Future<Map<String, int>> getUserCountByRole();
  Future<int> getActiveCourseCount();
  Future<int> getTotalEnrollmentCount();
  
  // Users Management
  Future<List<UserSummaryModel>> getUsers({
    String? perfil,
    bool? isActive,
    String? search,
  });
  
  Future<UserSummaryModel> createUser({
    required String username,
    required String email,
    required String password,
    required String perfil,
    String? firstName,
    String? lastName,
  });
  
  Future<UserSummaryModel> updateUser({
    required int userId,
    String? username,
    String? email,
    String? perfil,
    String? firstName,
    String? lastName,
    bool? isActive,
  });
  
  Future<void> deleteUser(int userId);
  
  Future<void> changeUserPassword({
    required int userId,
    required String newPassword,
  });
  
  // Courses Management
  Future<List<CourseModel>> getAllCourses({
    String? categoria,
    String? nivel,
    String? search,
    bool? activo,
    int? instructorId,
  });
  
  Future<CourseModel> createCourseAsAdmin({
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    required int instructorId,
    String? imagenPath,
  });
  
  Future<CourseModel> updateCourseAsAdmin({
    required int courseId,
    String? titulo,
    String? descripcion,
    String? categoria,
    String? nivel,
    double? precio,
    int? instructorId,
    String? imagenPath,
  });
  
  Future<void> deleteCourseAsAdmin(int courseId);
  
  Future<CourseModel> activateCourse(int courseId);
  
  Future<CourseModel> deactivateCourse(int courseId);
  
  Future<CourseStatsAdminModel> getCourseStatistics(int courseId);
  
  // Enrollments Management
  Future<List<EnrollmentAdminModel>> getAllEnrollments({
    int? cursoId,
    int? usuarioId,
    bool? completado,
  });
  
  Future<EnrollmentAdminModel> createEnrollment({
    required int cursoId,
    required int usuarioId,
  });
  
  Future<EnrollmentAdminModel> updateEnrollment({
    required int enrollmentId,
    double? progreso,
    bool? completado,
    int? cursoId,
    int? usuarioId,
  });
  
  Future<void> deleteEnrollment(int enrollmentId);
}
