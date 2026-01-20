import 'package:equatable/equatable.dart';
import '../../domain/entities/user_preferences.dart';

/// Eventos del Bloc de configuración
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar preferencias
class LoadPreferencesEvent extends SettingsEvent {}

/// Evento para guardar preferencias
class SavePreferencesEvent extends SettingsEvent {
  final UserPreferences preferences;

  const SavePreferencesEvent(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

/// Evento para cambiar contraseña
class ChangePasswordEvent extends SettingsEvent {
  final int userId;
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.userId,
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [userId, currentPassword, newPassword];
}
