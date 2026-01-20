import 'package:equatable/equatable.dart';
import '../../domain/entities/user_preferences.dart';

/// Estados del Bloc de configuración
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class SettingsInitial extends SettingsState {}

/// Estado de carga
class SettingsLoading extends SettingsState {}

/// Estado de preferencias cargadas
class PreferencesLoaded extends SettingsState {
  final UserPreferences preferences;

  const PreferencesLoaded(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

/// Estado de éxito al cambiar contraseña
class SettingsPasswordChanged extends SettingsState {
  final String message;

  const SettingsPasswordChanged(this.message);

  @override
  List<Object?> get props => [message];
}

/// Estado de éxito al guardar preferencias
class PreferencesSaved extends SettingsState {
  final UserPreferences preferences;

  const PreferencesSaved(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

/// Estado de error
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
