import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/enrollment_admin.dart';
import '../repositories/admin_repository.dart';

/// Caso de uso para crear una inscripción manualmente (admin)
class CreateEnrollmentAsAdmin implements UseCase<EnrollmentAdmin, CreateEnrollmentParams> {
  final AdminRepository repository;

  CreateEnrollmentAsAdmin(this.repository);

  @override
  Future<Either<Failure, EnrollmentAdmin>> execute(CreateEnrollmentParams params) async {
    return await repository.createEnrollment(
      cursoId: params.cursoId,
      usuarioId: params.usuarioId,
    );
  }

  Future<Either<Failure, EnrollmentAdmin>> call(CreateEnrollmentParams params) async {
    return await execute(params);
  }
}

class CreateEnrollmentParams extends Equatable {
  final int cursoId;
  final int usuarioId;

  const CreateEnrollmentParams({
    required this.cursoId,
    required this.usuarioId,
  });

  @override
  List<Object> get props => [cursoId, usuarioId];
}
