import '../entities/user_preferences.dart';

/// Repositorio de configuración
abstract class SettingsRepository {
  /// Cambiar contraseña del usuario
  Future<void> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  });

  /// Obtener preferencias del usuario
  Future<UserPreferences> getPreferences();

  /// Guardar preferencias del usuario
  Future<void> savePreferences(UserPreferences preferences);
}
