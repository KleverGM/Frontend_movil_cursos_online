import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/enrollment_admin.dart';
import '../repositories/admin_repository.dart';

/// Caso de uso para obtener todas las inscripciones (admin)
class GetAllEnrollmentsAdmin implements UseCase<List<EnrollmentAdmin>, GetAllEnrollmentsParams> {
  final AdminRepository repository;

  GetAllEnrollmentsAdmin(this.repository);

  @override
  Future<Either<Failure, List<EnrollmentAdmin>>> execute(GetAllEnrollmentsParams params) async {
    return await repository.getAllEnrollments(
      cursoId: params.cursoId,
      usuarioId: params.usuarioId,
      completado: params.completado,
    );
  }

  Future<Either<Failure, List<EnrollmentAdmin>>> call(GetAllEnrollmentsParams params) async {
    return await execute(params);
  }
}

class GetAllEnrollmentsParams extends Equatable {
  final int? cursoId;
  final int? usuarioId;
  final bool? completado;

  const GetAllEnrollmentsParams({
    this.cursoId,
    this.usuarioId,
    this.completado,
  });

  @override
  List<Object?> get props => [cursoId, usuarioId, completado];
}
