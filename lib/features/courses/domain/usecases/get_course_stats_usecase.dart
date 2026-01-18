import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/course_stats.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para obtener estadísticas de un curso
class GetCourseStatsUseCase {
  final CourseRepository _repository;

  GetCourseStatsUseCase(this._repository);

  Future<Either<Failure, CourseStats>> call(int courseId) async {
    return await _repository.getCourseStats(courseId);
  }
}
