import '../../domain/entities/user_preferences.dart';

/// Modelo de preferencias de usuario
class UserPreferencesModel extends UserPreferences {
  const UserPreferencesModel({
    required super.notificationsEnabled,
    required super.emailNotifications,
    required super.pushNotifications,
    required super.theme,
    required super.language,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      emailNotifications: json['email_notifications'] as bool? ?? true,
      pushNotifications: json['push_notifications'] as bool? ?? true,
      theme: json['theme'] as String? ?? 'system',
      language: json['language'] as String? ?? 'es',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications_enabled': notificationsEnabled,
      'email_notifications': emailNotifications,
      'push_notifications': pushNotifications,
      'theme': theme,
      'language': language,
    };
  }

  factory UserPreferencesModel.fromEntity(UserPreferences preferences) {
    return UserPreferencesModel(
      notificationsEnabled: preferences.notificationsEnabled,
      emailNotifications: preferences.emailNotifications,
      pushNotifications: preferences.pushNotifications,
      theme: preferences.theme,
      language: preferences.language,
    );
  }
}
