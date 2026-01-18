import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/review_repository.dart';

/// Caso de uso para marcar una reseña como útil
class MarkReviewHelpful {
  final ReviewRepository repository;

  MarkReviewHelpful(this.repository);

  Future<Either<Failure, void>> call(String reviewId) async {
    return await repository.markReviewHelpful(reviewId);
  }
}
