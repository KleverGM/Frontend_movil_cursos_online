import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/review_stats.dart';
import '../repositories/review_repository.dart';

/// Caso de uso para obtener estadísticas de reseñas
class GetCourseReviewStats {
  final ReviewRepository repository;

  GetCourseReviewStats(this.repository);

  Future<Either<Failure, ReviewStats>> call(int cursoId) async {
    return await repository.getCourseReviewStats(cursoId);
  }
}
