import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

/// Caso de uso para obtener reseñas de un curso
class GetCourseReviews {
  final ReviewRepository repository;

  GetCourseReviews(this.repository);

  Future<Either<Failure, List<Review>>> call(int cursoId) async {
    return await repository.getCourseReviews(cursoId);
  }
}
