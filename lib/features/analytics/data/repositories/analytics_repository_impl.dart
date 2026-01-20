import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/analytics_entities.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_remote_datasource.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AnalyticsRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<CourseAnalytics>>> getPopularCourses(int days) async {
    if (await _networkInfo.isConnected) {
      try {
        final courses = await _remoteDataSource.getPopularCourses(days);
        return Right(courses);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, GlobalTrends>> getGlobalTrends(int days) async {
    if (await _networkInfo.isConnected) {
      try {
        final trends = await _remoteDataSource.getGlobalTrends(days);
        return Right(trends);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<InstructorAnalytics>>> getInstructorRankings() async {
    if (await _networkInfo.isConnected) {
      try {
        final instructors = await _remoteDataSource.getInstructorRankings();
        return Right(instructors);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<UserGrowth>>> getUserGrowth(int days) async {
    if (await _networkInfo.isConnected) {
      try {
        final growth = await _remoteDataSource.getUserGrowth(days);
        return Right(growth);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, CourseStats>> getCourseStats(int cursoId, int days) async {
    if (await _networkInfo.isConnected) {
      try {
        final stats = await _remoteDataSource.getCourseStats(cursoId, days);
        return Right(stats);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }
}
