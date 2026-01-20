import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/course_detail.dart';
import '../../domain/entities/course_filters.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/entities/enrollment_detail.dart';
import '../../domain/entities/course_stats.dart';
import '../../domain/entities/global_stats.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_datasource.dart';

/// Implementación del repositorio de cursos
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  CourseRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<Course>>> getCourses({CourseFilters? filters}) async {
    if (await _networkInfo.isConnected) {
      try {
        final courses = await _remoteDataSource.getCourses(filters: filters);
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

  @override
  Future<Either<Failure, void>> markSectionCompleted(int sectionId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.markSectionCompleted(sectionId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }
  
  @override
  Future<Either<Failure, Course>> createCourse({
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    String? imagenPath,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final course = await _remoteDataSource.createCourse(
          titulo: titulo,
          descripcion: descripcion,
          categoria: categoria,
          nivel: nivel,
          precio: precio,
          imagenPath: imagenPath,
        );
        return Right(course);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }
  
  @override
  Future<Either<Failure, Course>> updateCourse({
    required int courseId,
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    String? imagenPath,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final course = await _remoteDataSource.updateCourse(
          courseId: courseId,
          titulo: titulo,
          descripcion: descripcion,
          categoria: categoria,
          nivel: nivel,
          precio: precio,
          imagenPath: imagenPath,
        );
        return Right(course);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteCourse(int courseId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteCourse(courseId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<EnrollmentDetail>>> getInstructorEnrollments({int? courseId}) async {
    if (await _networkInfo.isConnected) {
      try {
        final enrollments = await _remoteDataSource.getInstructorEnrollments(courseId: courseId);
        return Right(enrollments);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, CourseStats>> getCourseStats(int courseId) async {
    if (await _networkInfo.isConnected) {
      try {
        final stats = await _remoteDataSource.getCourseStats(courseId);
        return Right(stats);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Course>> activateCourse(int courseId) async {
    if (await _networkInfo.isConnected) {
      try {
        final course = await _remoteDataSource.activateCourse(courseId);
        return Right(course);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Course>> deactivateCourse(int courseId) async {
    if (await _networkInfo.isConnected) {
      try {
        final course = await _remoteDataSource.deactivateCourse(courseId);
        return Right(course);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, GlobalStats>> getGlobalStats() async {
    if (await _networkInfo.isConnected) {
      try {
        final stats = await _remoteDataSource.getGlobalStats();
        return Right(stats);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }
}
