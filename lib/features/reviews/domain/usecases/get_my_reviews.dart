import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

/// Caso de uso para obtener todas las reseñas del instructor
class GetMyReviews {
  final ReviewRepository repository;

  GetMyReviews(this.repository);

  Future<Either<Failure, List<Review>>> call() async {
    return await repository.getMyReviews();
  }
}
