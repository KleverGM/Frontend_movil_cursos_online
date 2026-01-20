import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/user_preferences_model.dart';

/// Datasource remoto para configuración
abstract class SettingsRemoteDataSource {
  Future<void> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  });

  Future<UserPreferencesModel> getPreferences();
  Future<void> savePreferences(UserPreferencesModel preferences);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiClient _apiClient;

  SettingsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<void> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _apiClient.post(
      '${ApiConstants.users}/$userId/cambiar_password/',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['error'] ?? 'Error al cambiar contraseña');
    }
  }

  @override
  Future<UserPreferencesModel> getPreferences() async {
    // Por ahora, las preferencias se guardan localmente
    // Si el backend implementa un endpoint, puedes usar:
    // final response = await _apiClient.get(ApiConstants.preferences);
    // return UserPreferencesModel.fromJson(response.data);
    
    // Retornar preferencias por defecto
    return const UserPreferencesModel(
      notificationsEnabled: true,
      emailNotifications: true,
      pushNotifications: true,
      theme: 'system',
      language: 'es',
    );
  }

  @override
  Future<void> savePreferences(UserPreferencesModel preferences) async {
    // Por ahora, las preferencias se guardan localmente
    // Si el backend implementa un endpoint, puedes usar:
    // await _apiClient.post(ApiConstants.preferences, data: preferences.toJson());
    
    // No hacer nada por ahora
    return;
  }
}
