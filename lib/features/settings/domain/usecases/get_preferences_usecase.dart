import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_preferences.dart';
import '../repositories/settings_repository.dart';

/// Caso de uso para obtener preferencias
class GetPreferencesUseCase implements UseCase<UserPreferences, NoParams> {
  final SettingsRepository repository;

  GetPreferencesUseCase(this.repository);

  @override
  Future<Either<Failure, UserPreferences>> execute(NoParams params) async {
    try {
      final preferences = await repository.getPreferences();
      return Right(preferences);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
