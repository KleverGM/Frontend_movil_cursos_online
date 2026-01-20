import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

/// Caso de uso para obtener todas las reseñas del sistema (admin)
class GetAllReviewsUseCase implements UseCase<List<Review>, NoParams> {
  final ReviewRepository repository;

  GetAllReviewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Review>>> execute(NoParams params) async {
    return await repository.getAllReviews();
  }
}
