import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../datasources/settings_remote_datasource.dart';
import '../models/user_preferences_model.dart';

/// Implementación del repositorio de configuración
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        userId: userId,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception('Error al cambiar contraseña: $e');
    }
  }

  @override
  Future<UserPreferences> getPreferences() async {
    try {
      // Intentar obtener del almacenamiento local
      return await localDataSource.getPreferences();
    } catch (e) {
      // Si falla, retornar preferencias por defecto
      return const UserPreferences();
    }
  }

  @override
  Future<void> savePreferences(UserPreferences preferences) async {
    try {
      final model = UserPreferencesModel.fromEntity(preferences);
      
      // Guardar localmente
      await localDataSource.savePreferences(model);
      
      // Opcionalmente guardar en el backend
      // await remoteDataSource.savePreferences(model);
    } catch (e) {
      throw Exception('Error al guardar preferencias: $e');
    }
  }
}
