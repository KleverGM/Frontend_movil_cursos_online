import 'package:equatable/equatable.dart';

/// Eventos del BLoC de reseñas
abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

/// Obtener reseñas de un curso
class GetCourseReviewsEvent extends ReviewEvent {
  final int cursoId;

  const GetCourseReviewsEvent(this.cursoId);

  @override
  List<Object> get props => [cursoId];
}

/// Obtener estadísticas de reseñas
class GetCourseReviewStatsEvent extends ReviewEvent {
  final int cursoId;

  const GetCourseReviewStatsEvent(this.cursoId);

  @override
  List<Object> get props => [cursoId];
}

/// Crear una reseña
class CreateReviewEvent extends ReviewEvent {
  final int cursoId;
  final int calificacion;
  final String comentario;

  const CreateReviewEvent({
    required this.cursoId,
    required this.calificacion,
    required this.comentario,
  });

  @override
  List<Object> get props => [cursoId, calificacion, comentario];
}

/// Marcar reseña como útil
class MarkReviewHelpfulEvent extends ReviewEvent {
  final String reviewId;

  const MarkReviewHelpfulEvent(this.reviewId);

  @override
  List<Object> get props => [reviewId];
}

/// Responder a una reseña
class ReplyToReviewEvent extends ReviewEvent {
  final String reviewId;
  final String respuesta;

  const ReplyToReviewEvent({
    required this.reviewId,
    required this.respuesta,
  });

  @override
  List<Object> get props => [reviewId, respuesta];
}

/// Eliminar reseña
class DeleteReviewEvent extends ReviewEvent {
  final String reviewId;

  const DeleteReviewEvent(this.reviewId);

  @override
  List<Object> get props => [reviewId];
}
