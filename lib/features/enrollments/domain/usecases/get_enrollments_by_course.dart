import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/enrollment.dart';
import '../repositories/enrollment_repository.dart';

/// Parámetros para obtener inscripciones por curso
class GetEnrollmentsByCourseParams extends Equatable {
  final int cursoId;

  const GetEnrollmentsByCourseParams({required this.cursoId});

  @override
  List<Object?> get props => [cursoId];
}

/// Use case para obtener inscripciones de un curso específico
class GetEnrollmentsByCourse implements UseCase<List<Enrollment>, GetEnrollmentsByCourseParams> {
  final EnrollmentRepository repository;

  GetEnrollmentsByCourse(this.repository);

  Future<Either<Failure, List<Enrollment>>> call(GetEnrollmentsByCourseParams params) async {
    return await repository.getEnrollmentsByCourse(params.cursoId);
  }

  @override
  Future<Either<Failure, List<Enrollment>>> execute(GetEnrollmentsByCourseParams params) async {
    return await call(params);
  }
}
