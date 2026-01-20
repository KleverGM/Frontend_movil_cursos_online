import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_preferences.dart';
import '../repositories/settings_repository.dart';

/// Caso de uso para guardar preferencias
class SavePreferencesUseCase implements UseCase<void, UserPreferences> {
  final SettingsRepository repository;

  SavePreferencesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> execute(UserPreferences params) async {
    try {
      await repository.savePreferences(params);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
