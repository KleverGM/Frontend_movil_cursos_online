import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/enrollment.dart';
import '../repositories/enrollment_repository.dart';

/// Use case para obtener todas las inscripciones del instructor
class GetInstructorEnrollments implements UseCase<List<Enrollment>, NoParams> {
  final EnrollmentRepository repository;

  GetInstructorEnrollments(this.repository);

  Future<Either<Failure, List<Enrollment>>> call(NoParams params) async {
    return await repository.getInstructorEnrollments();
  }

  @override
  Future<Either<Failure, List<Enrollment>>> execute(NoParams params) async {
    return await call(params);
  }
}
