import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';

/// Implementación del repositorio de reseñas
class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ReviewRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<Review>>> getCourseReviews(int cursoId) async {
    if (await _networkInfo.isConnected) {
      try {
        final reviews = await _remoteDataSource.getCourseReviews(cursoId);
        return Right(reviews);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, ReviewStats>> getCourseReviewStats(int cursoId) async {
    if (await _networkInfo.isConnected) {
      try {
        final stats = await _remoteDataSource.getCourseReviewStats(cursoId);
        return Right(stats);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Review>> createReview({
    required int cursoId,
    required int calificacion,
    required String comentario,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final review = await _remoteDataSource.createReview(
          cursoId: cursoId,
          calificacion: calificacion,
          comentario: comentario,
        );
        return Right(review);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Review>> updateReview({
    required String reviewId,
    required int calificacion,
    required String comentario,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final review = await _remoteDataSource.updateReview(
          reviewId: reviewId,
          calificacion: calificacion,
          comentario: comentario,
        );
        return Right(review);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteReview(reviewId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> markReviewHelpful(String reviewId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.markReviewHelpful(reviewId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Review>> replyToReview(String reviewId, String respuesta) async {
    if (await _networkInfo.isConnected) {
      try {
        final review = await _remoteDataSource.replyToReview(reviewId, respuesta);
        return Right(review);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getMyReviews() async {
    if (await _networkInfo.isConnected) {
      try {
        final reviews = await _remoteDataSource.getMyReviews();
        return Right(reviews);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }
}
