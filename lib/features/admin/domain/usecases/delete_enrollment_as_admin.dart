import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

/// Caso de uso para eliminar una inscripción (admin)
class DeleteEnrollmentAsAdmin implements UseCase<void, int> {
  final AdminRepository repository;

  DeleteEnrollmentAsAdmin(this.repository);

  @override
  Future<Either<Failure, void>> execute(int enrollmentId) async {
    return await repository.deleteEnrollment(enrollmentId);
  }

  Future<Either<Failure, void>> call(int enrollmentId) async {
    return await execute(enrollmentId);
  }
}
