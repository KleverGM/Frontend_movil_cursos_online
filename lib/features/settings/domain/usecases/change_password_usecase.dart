import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/settings_repository.dart';

/// Caso de uso para cambiar contraseña
class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final SettingsRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> execute(ChangePasswordParams params) async {
    try {
      await repository.changePassword(
        userId: params.userId,
        currentPassword: params.currentPassword,
        newPassword: params.newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

/// Parámetros para cambiar contraseña
class ChangePasswordParams {
  final int userId;
  final String currentPassword;
  final String newPassword;

  ChangePasswordParams({
    required this.userId,
    required this.currentPassword,
    required this.newPassword,
  });
}
