import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/course_stats_admin.dart';
import '../repositories/admin_repository.dart';

/// Caso de uso para obtener estadísticas de un curso
class GetCourseStatistics implements UseCase<CourseStatsAdmin, int> {
  final AdminRepository repository;

  GetCourseStatistics(this.repository);

  @override
  Future<Either<Failure, CourseStatsAdmin>> execute(int courseId) async {
    return await repository.getCourseStatistics(courseId);
  }

  Future<Either<Failure, CourseStatsAdmin>> call(int courseId) async {
    return execute(courseId);
  }
}
