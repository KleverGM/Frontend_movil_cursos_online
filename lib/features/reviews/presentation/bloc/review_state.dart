import 'package:equatable/equatable.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/review_stats.dart';

/// Estados del BLoC de reseñas
abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

/// Cargando reseñas
class ReviewLoading extends ReviewState {
  const ReviewLoading();
}

/// Reseñas cargadas
class ReviewsLoaded extends ReviewState {
  final List<Review> reviews;
  final ReviewStats? stats;

  const ReviewsLoaded(this.reviews, {this.stats});

  @override
  List<Object?> get props => [reviews, stats];
}

/// Reseña creada exitosamente
class ReviewCreated extends ReviewState {
  final Review review;

  const ReviewCreated(this.review);

  @override
  List<Object> get props => [review];
}

/// Reseña marcada como útil
class ReviewMarkedHelpful extends ReviewState {
  final String reviewId;

  const ReviewMarkedHelpful(this.reviewId);

  @override
  List<Object> get props => [reviewId];
}

/// Respuesta a reseña enviada
class ReviewReplied extends ReviewState {
  final Review review;

  const ReviewReplied(this.review);

  @override
  List<Object> get props => [review];
}

/// Reseña eliminada
class ReviewDeleted extends ReviewState {
  final String reviewId;

  const ReviewDeleted(this.reviewId);

  @override
  List<Object> get props => [reviewId];
}

/// Error
class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object> get props => [message];
}
