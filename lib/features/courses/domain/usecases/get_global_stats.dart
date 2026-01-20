import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/global_stats.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para obtener estadísticas globales de la plataforma
class GetGlobalStatsUseCase {
  final CourseRepository _repository;

  GetGlobalStatsUseCase(this._repository);

  Future<Either<Failure, GlobalStats>> call() async {
    return await _repository.getGlobalStats();
  }
}
