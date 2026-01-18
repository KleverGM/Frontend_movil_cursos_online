import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

/// Caso de uso para responder a una reseña
class ReplyToReview implements UseCase<Review, ReplyToReviewParams> {
  final ReviewRepository _repository;

  ReplyToReview(this._repository);

  @override
  Future<Either<Failure, Review>> execute(ReplyToReviewParams params) async {
    return await _repository.replyToReview(
      params.reviewId,
      params.respuesta,
    );
  }
}

/// Parámetros para responder a una reseña
class ReplyToReviewParams extends Equatable {
  final String reviewId;
  final String respuesta;

  const ReplyToReviewParams({
    required this.reviewId,
    required this.respuesta,
  });

  @override
  List<Object> get props => [reviewId, respuesta];
}
