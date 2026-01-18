import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

/// Caso de uso para crear una reseña
class CreateReview {
  final ReviewRepository repository;

  CreateReview(this.repository);

  Future<Either<Failure, Review>> call(CreateReviewParams params) async {
    return await repository.createReview(
      cursoId: params.cursoId,
      calificacion: params.calificacion,
      comentario: params.comentario,
    );
  }
}

class CreateReviewParams extends Equatable {
  final int cursoId;
  final int calificacion;
  final String comentario;

  const CreateReviewParams({
    required this.cursoId,
    required this.calificacion,
    required this.comentario,
  });

  @override
  List<Object> get props => [cursoId, calificacion, comentario];
}
