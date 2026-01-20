import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../datasources/enrollment_remote_datasource.dart';

class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final EnrollmentRemoteDataSource remoteDataSource;

  EnrollmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Enrollment>>> getInstructorEnrollments() async {
    try {
      final enrollmentModels = await remoteDataSource.getInstructorEnrollments();
      final enrollments = enrollmentModels.map((model) => model.toEntity()).toList();
      return Right(enrollments);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Enrollment>>> getEnrollmentsByCourse(int cursoId) async {
    try {
      final enrollmentModels = await remoteDataSource.getEnrollmentsByCourse(cursoId);
      final enrollments = enrollmentModels.map((model) => model.toEntity()).toList();
      return Right(enrollments);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: ${e.toString()}'));
    }
  }
}
