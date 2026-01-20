import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/get_preferences_usecase.dart';
import '../../domain/usecases/save_preferences_usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

/// Bloc para manejar la configuración
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetPreferencesUseCase getPreferencesUseCase;
  final SavePreferencesUseCase savePreferencesUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  SettingsBloc({
    required this.getPreferencesUseCase,
    required this.savePreferencesUseCase,
    required this.changePasswordUseCase,
  }) : super(SettingsInitial()) {
    on<LoadPreferencesEvent>(_onLoadPreferences);
    on<SavePreferencesEvent>(_onSavePreferences);
    on<ChangePasswordEvent>(_onChangePassword);
  }

  Future<void> _onLoadPreferences(
    LoadPreferencesEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    final result = await getPreferencesUseCase.execute(NoParams());
    result.fold(
      (failure) => emit(SettingsError('Error al cargar preferencias: ${failure.toString()}')),
      (preferences) => emit(PreferencesLoaded(preferences)),
    );
  }

  Future<void> _onSavePreferences(
    SavePreferencesEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await savePreferencesUseCase.execute(event.preferences);
    result.fold(
      (failure) => emit(SettingsError('Error al guardar preferencias: ${failure.toString()}')),
      (_) {
        emit(PreferencesSaved(event.preferences));
        emit(PreferencesLoaded(event.preferences));
      },
    );
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final result = await changePasswordUseCase.execute(
        ChangePasswordParams(
          userId: event.userId,
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
        ),
      );
      
      result.fold(
        (failure) {
          emit(SettingsError(failure.toString()));
        },
        (_) async {
          emit(const SettingsPasswordChanged('Contraseña actualizada exitosamente'));
          
          // Volver a cargar preferencias
          final prefsResult = await getPreferencesUseCase.execute(NoParams());
          prefsResult.fold(
            (failure) => emit(SettingsError(failure.toString())),
            (prefs) => emit(PreferencesLoaded(prefs)),
          );
        },
      );
    } catch (e) {
      final prefsResult = await getPreferencesUseCase.execute(NoParams());
      prefsResult.fold(
        (failure) => emit(SettingsError(e.toString().replaceAll('Exception: ', ''))),
        (prefs) {
          emit(PreferencesLoaded(prefs));
          emit(SettingsError(e.toString().replaceAll('Exception: ', '')));
        },
      );
    }
  }
}
