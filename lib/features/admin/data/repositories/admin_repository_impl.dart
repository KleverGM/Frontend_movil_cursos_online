import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../courses/domain/entities/course.dart';
import '../../domain/entities/course_stats_admin.dart';
import '../../domain/entities/enrollment_admin.dart';
import '../../domain/entities/platform_stats.dart';
import '../../domain/entities/popular_course.dart';
import '../../domain/entities/user_summary.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PlatformStats>> getPlatformStats({int dias = 7}) async {
    try {
      final platformStats = await remoteDataSource.getPlatformStats(dias: dias);
      return Right(platformStats);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PopularCourse>>> getPopularCourses({int dias = 30}) async {
    try {
      final courses = await remoteDataSource.getPopularCourses(dias: dias);
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserSummary>>> getUsers({
    String? perfil,
    bool? isActive,
    String? search,
  }) async {
    try {
      final users = await remoteDataSource.getUsers(
        perfil: perfil,
        isActive: isActive,
        search: search,
      );
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSummary>> createUser({
    required String username,
    required String email,
    required String password,
    required String perfil,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final user = await remoteDataSource.createUser(
        username: username,
        email: email,
        password: password,
        perfil: perfil,
        firstName: firstName,
        lastName: lastName,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSummary>> updateUser({
    required int userId,
    String? username,
    String? email,
    String? perfil,
    String? firstName,
    String? lastName,
    bool? isActive,
  }) async {
    try {
      final user = await remoteDataSource.updateUser(
        userId: userId,
        username: username,
        email: email,
        perfil: perfil,
        firstName: firstName,
        lastName: lastName,
        isActive: isActive,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(int userId) async {
    try {
      await remoteDataSource.deleteUser(userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changeUserPassword({
    required int userId,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changeUserPassword(
        userId: userId,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== COURSES MANAGEMENT ====================

  @override
  Future<Either<Failure, List<Course>>> getAllCourses({
    String? categoria,
    String? nivel,
    String? search,
    bool? activo,
    int? instructorId,
  }) async {
    try {
      final courses = await remoteDataSource.getAllCourses(
        categoria: categoria,
        nivel: nivel,
        search: search,
        activo: activo,
        instructorId: instructorId,
      );
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Course>> createCourseAsAdmin({
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    required int instructorId,
    String? imagenPath,
  }) async {
    try {
      final course = await remoteDataSource.createCourseAsAdmin(
        titulo: titulo,
        descripcion: descripcion,
        categoria: categoria,
        nivel: nivel,
        precio: precio,
        instructorId: instructorId,
        imagenPath: imagenPath,
      );
      return Right(course);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Course>> updateCourseAsAdmin({
    required int courseId,
    String? titulo,
    String? descripcion,
    String? categoria,
    String? nivel,
    double? precio,
    int? instructorId,
    String? imagenPath,
  }) async {
    try {
      final course = await remoteDataSource.updateCourseAsAdmin(
        courseId: courseId,
        titulo: titulo,
        descripcion: descripcion,
        categoria: categoria,
        nivel: nivel,
        precio: precio,
        instructorId: instructorId,
        imagenPath: imagenPath,
      );
      return Right(course);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCourseAsAdmin(int courseId) async {
    try {
      await remoteDataSource.deleteCourseAsAdmin(courseId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Course>> activateCourse(int courseId) async {
    try {
      final course = await remoteDataSource.activateCourse(courseId);
      return Right(course);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Course>> deactivateCourse(int courseId) async {
    try {
      final course = await remoteDataSource.deactivateCourse(courseId);
      return Right(course);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CourseStatsAdmin>> getCourseStatistics(int courseId) async {
    try {
      final stats = await remoteDataSource.getCourseStatistics(courseId);
      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EnrollmentAdmin>>> getAllEnrollments({
    int? cursoId,
    int? usuarioId,
    bool? completado,
  }) async {
    try {
      final enrollments = await remoteDataSource.getAllEnrollments(
        cursoId: cursoId,
        usuarioId: usuarioId,
        completado: completado,
      );
      return Right(enrollments);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EnrollmentAdmin>> createEnrollment({
    required int cursoId,
    required int usuarioId,
  }) async {
    try {
      final enrollment = await remoteDataSource.createEnrollment(
        cursoId: cursoId,
        usuarioId: usuarioId,
      );
      return Right(enrollment);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EnrollmentAdmin>> updateEnrollment({
    required int enrollmentId,
    double? progreso,
    bool? completado,
    int? cursoId,
    int? usuarioId,
  }) async {
    try {
      final enrollment = await remoteDataSource.updateEnrollment(
        enrollmentId: enrollmentId,
        progreso: progreso,
        completado: completado,
        cursoId: cursoId,
        usuarioId: usuarioId,
      );
      return Right(enrollment);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEnrollment(int enrollmentId) async {
    try {
      await remoteDataSource.deleteEnrollment(enrollmentId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException {
      return Left(AuthFailure(message: 'No autorizado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
