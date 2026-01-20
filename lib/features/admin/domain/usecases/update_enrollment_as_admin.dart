import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/enrollment_admin.dart';
import '../repositories/admin_repository.dart';

class UpdateEnrollmentAsAdmin implements UseCase<EnrollmentAdmin, UpdateEnrollmentParams> {
  final AdminRepository repository;

  UpdateEnrollmentAsAdmin(this.repository);

  @override
  Future<Either<Failure, EnrollmentAdmin>> execute(UpdateEnrollmentParams params) async {
    return await repository.updateEnrollment(
      enrollmentId: params.enrollmentId,
      progreso: params.progreso,
      completado: params.completado,
      cursoId: params.cursoId,
      usuarioId: params.usuarioId,
    );
  }

  Future<Either<Failure, EnrollmentAdmin>> call(UpdateEnrollmentParams params) async {
    return await execute(params);
  }
}

class UpdateEnrollmentParams extends Equatable {
  final int enrollmentId;
  final double? progreso;
  final bool? completado;
  final int? cursoId;
  final int? usuarioId;

  const UpdateEnrollmentParams({
    required this.enrollmentId,
    this.progreso,
    this.completado,
    this.cursoId,
    this.usuarioId,
  });

  @override
  List<Object?> get props => [enrollmentId, progreso, completado, cursoId, usuarioId];
}
