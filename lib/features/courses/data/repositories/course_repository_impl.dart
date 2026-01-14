import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/course_detail.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_datasource.dart';

/// Implementación del repositorio de cursos
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  CourseRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<Course>>> getCourses({
    String? categoria,
    String? nivel,
    String? search,
    String? ordering,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final courses = await _remoteDataSource.getCourses(
          categoria: categoria,
          nivel: nivel,
          search: search,
          ordering: ordering,
        );
        return Right(courses);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, CourseDetail>> getCourseDetail(int courseId) async {
    if (await _networkInfo.isConnected) {
      try {
        final courseDetail = await _remoteDataSource.getCourseDetail(courseId);
        return Right(courseDetail);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Enrollment>> enrollInCourse(int courseId) async {
    if (await _networkInfo.isConnected) {
      try {
        final enrollment = await _remoteDataSource.enrollInCourse(courseId);
        return Right(enrollment);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<Course>>> getEnrolledCourses() async {
    if (await _networkInfo.isConnected) {
      try {
        final courses = await _remoteDataSource.getEnrolledCourses();
        return Right(courses);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<Course>>> getMyCourses() async {
    if (await _networkInfo.isConnected) {
      try {
        final courses = await _remoteDataSource.getMyCourses();
        return Right(courses);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }
}
