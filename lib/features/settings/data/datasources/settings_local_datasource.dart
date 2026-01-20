import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences_model.dart';
import 'dart:convert';

/// Datasource local para preferencias del usuario
abstract class SettingsLocalDataSource {
  Future<UserPreferencesModel> getPreferences();
  Future<void> savePreferences(UserPreferencesModel preferences);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _prefs;
  static const String _preferencesKey = 'user_preferences';

  SettingsLocalDataSourceImpl(this._prefs);

  @override
  Future<UserPreferencesModel> getPreferences() async {
    final jsonString = _prefs.getString(_preferencesKey);
    
    if (jsonString == null) {
      // Retornar preferencias por defecto
      return const UserPreferencesModel(
        notificationsEnabled: true,
        emailNotifications: true,
        pushNotifications: true,
        theme: 'system',
        language: 'es',
      );
    }

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return UserPreferencesModel.fromJson(json);
  }

  @override
  Future<void> savePreferences(UserPreferencesModel preferences) async {
    final jsonString = jsonEncode(preferences.toJson());
    await _prefs.setString(_preferencesKey, jsonString);
  }
}
