import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/analytics_entities.dart';

/// Repositorio de Analytics
abstract class AnalyticsRepository {
  /// Obtener cursos más populares
  Future<Either<Failure, List<CourseAnalytics>>> getPopularCourses(int days);
  
  /// Obtener tendencias globales
  Future<Either<Failure, GlobalTrends>> getGlobalTrends(int days);
  
  /// Obtener ranking de instructores
  Future<Either<Failure, List<InstructorAnalytics>>> getInstructorRankings();
  
  /// Obtener evolución de usuarios
  Future<Either<Failure, List<UserGrowth>>> getUserGrowth(int days);
  
  /// Obtener estadísticas de un curso específico
  Future<Either<Failure, CourseStats>> getCourseStats(int cursoId, int days);
}
