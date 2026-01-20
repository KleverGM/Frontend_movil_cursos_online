import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/review.dart';
import '../entities/review_stats.dart';

/// Interfaz del repositorio de reseñas
abstract class ReviewRepository {
  /// Obtener reseñas de un curso
  Future<Either<Failure, List<Review>>> getCourseReviews(int cursoId);

  /// Obtener estadísticas de reseñas de un curso
  Future<Either<Failure, ReviewStats>> getCourseReviewStats(int cursoId);

  /// Crear una reseña
  Future<Either<Failure, Review>> createReview({
    required int cursoId,
    required int calificacion,
    required String comentario,
  });

  /// Actualizar una reseña
  Future<Either<Failure, Review>> updateReview({
    required String reviewId,
    required int calificacion,
    required String comentario,
  });

  /// Obtener mis reseñas
  Future<Either<Failure, List<Review>>> getMyReviews();

  /// Eliminar una reseña
  Future<Either<Failure, void>> deleteReview(String reviewId);

  /// Marcar reseña como útil
  Future<Either<Failure, void>> markReviewHelpful(String reviewId);

  /// Responder a una reseña (solo instructores)
  Future<Either<Failure, Review>> replyToReview(String reviewId, String respuesta);
  
  // ============ MÉTODOS DE ADMINISTRACIÓN ============
  
  /// Obtener todas las reseñas del sistema (solo admin)
  Future<Either<Failure, List<Review>>> getAllReviews();
}
