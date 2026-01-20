import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../settings/domain/entities/user_preferences.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_event.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../widgets/settings/settings_section.dart';
import '../widgets/settings/settings_tile.dart';

/// Página de configuración de la aplicación
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>()..add(LoadPreferencesEvent()),
      child: const _SettingsPageContent(),
    );
  }
}

class _SettingsPageContent extends StatefulWidget {
  const _SettingsPageContent();

  @override
  State<_SettingsPageContent> createState() => _SettingsPageContentState();
}

class _SettingsPageContentState extends State<_SettingsPageContent> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                // Redirigir a welcome después de cerrar sesión
                context.go(AppRoutes.welcome);
              }
            },
          ),
          BlocListener<SettingsBloc, SettingsState>(
            listener: (context, state) {
              if (state is SettingsPasswordChanged) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is PreferencesSaved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preferencias actualizadas'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is SettingsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            if (settingsState is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            UserPreferences preferences = const UserPreferences();
            if (settingsState is PreferencesLoaded) {
              preferences = settingsState.preferences;
            }

            return ListView(
              children: [
                // Sección de Notificaciones
                SettingsSection(
                  title: 'Notificaciones',
                  children: [
                    SettingsTile.switchTile(
                      icon: Icons.notifications,
                      title: 'Notificaciones',
                      subtitle: 'Activar o desactivar notificaciones',
                      value: preferences.notificationsEnabled,
                      onChanged: (value) {
                        final newPrefs = preferences.copyWith(notificationsEnabled: value);
                        context.read<SettingsBloc>().add(SavePreferencesEvent(newPrefs));
                      },
                    ),
                    SettingsTile.switchTile(
                      icon: Icons.email,
                      title: 'Notificaciones por correo',
                      subtitle: 'Recibir actualizaciones por email',
                      value: preferences.emailNotifications,
                      enabled: preferences.notificationsEnabled,
                      onChanged: (value) {
                        final newPrefs = preferences.copyWith(emailNotifications: value);
                        context.read<SettingsBloc>().add(SavePreferencesEvent(newPrefs));
                      },
                    ),
                    SettingsTile.switchTile(
                      icon: Icons.phone_android,
                      title: 'Notificaciones push',
                      subtitle: 'Recibir alertas en el dispositivo',
                      value: preferences.pushNotifications,
                      enabled: preferences.notificationsEnabled,
                      onChanged: (value) {
                        final newPrefs = preferences.copyWith(pushNotifications: value);
                        context.read<SettingsBloc>().add(SavePreferencesEvent(newPrefs));
                      },
                    ),
                  ],
                ),

                // Sección de Apariencia
                SettingsSection(
                  title: 'Apariencia',
                  children: [
                    SettingsTile.navigation(
                      icon: Icons.brightness_6,
                      title: 'Tema',
                      subtitle: _getThemeLabel(preferences.theme),
                      onTap: () => _showThemeDialog(context, preferences),
                    ),
                    SettingsTile.navigation(
                      icon: Icons.language,
                      title: 'Idioma',
                      subtitle: _getLanguageLabel(preferences.language),
                      onTap: () => _showLanguageDialog(context, preferences),
                    ),
                  ],
                ),

                // Sección de Cuenta
                SettingsSection(
                  title: 'Cuenta',
                  children: [
                    SettingsTile.navigation(
                      icon: Icons.lock,
                      title: 'Cambiar contraseña',
                      subtitle: 'Actualizar tu contraseña',
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                    SettingsTile.navigation(
                      icon: Icons.privacy_tip,
                      title: 'Privacidad',
                      subtitle: 'Configurar privacidad de datos',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función en desarrollo')),
                        );
                      },
                    ),
                  ],
                ),

                // Sección de Información
                SettingsSection(
                  title: 'Información',
                  children: [
                    SettingsTile.navigation(
                      icon: Icons.info,
                      title: 'Acerca de',
                      subtitle: 'Versión 1.0.0',
                      onTap: () => _showAboutDialog(context),
                    ),
                    SettingsTile.navigation(
                      icon: Icons.description,
                      title: 'Términos y condiciones',
                      subtitle: 'Ver términos de uso',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función en desarrollo')),
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      icon: Icons.policy,
                      title: 'Política de privacidad',
                      subtitle: 'Ver política de privacidad',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función en desarrollo')),
                        );
                      },
                    ),
                  ],
                ),

                // Sección de Sesión
                SettingsSection(
                  title: 'Sesión',
                  children: [
                    SettingsTile.navigation(
                      icon: Icons.logout,
                      title: 'Cerrar sesión',
                      subtitle: 'Salir de tu cuenta',
                      textColor: Colors.red,
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getThemeLabel(String theme) {
    switch (theme) {
      case 'light':
        return 'Claro';
      case 'dark':
        return 'Oscuro';
      case 'system':
        return 'Sistema';
      default:
        return 'Sistema';
    }
  }

  String _getLanguageLabel(String language) {
    switch (language) {
      case 'es':
        return 'Español';
      case 'en':
        return 'English';
      default:
        return 'Español';
    }
  }

  void _showThemeDialog(BuildContext context, UserPreferences preferences) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Seleccionar tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Claro'),
              value: 'light',
              groupValue: preferences.theme,
              onChanged: (value) {
                Navigator.pop(dialogContext);
                final newPrefs = preferences.copyWith(theme: value);
                context.read<SettingsBloc>().add(SavePreferencesEvent(newPrefs));
              },
            ),
            RadioListTile<String>(
              title: const Text('Oscuro'),
              value: 'dark',
              groupValue: preferences.theme,
              onChanged: (value) {
                Navigator.pop(dialogContext);
                final newPrefs = preferences.copyWith(theme: value);
                context.read<SettingsBloc>().add(SavePreferencesEvent(newPrefs));
              },
            ),
            RadioListTile<String>(
              title: const Text('Sistema'),
              value: 'system',
              groupValue: preferences.theme,
              onChanged: (value) {
                Navigator.pop(dialogContext);
                final newPrefs = preferences.copyWith(theme: value);
                context.read<SettingsBloc>().add(SavePreferencesEvent(newPrefs));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, UserPreferences preferences) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Español'),
              value: 'es',
              groupValue: preferences.language,
              onChanged: (value) {
                Navigator.pop(dialogContext);
                final newPrefs = preferences.copyWith(language: value);
                context.read<SettingsBloc>().add(SavePreferencesEvent(newPrefs));
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: preferences.language,
              onChanged: (value) {
                Navigator.pop(dialogContext);
                final newPrefs = preferences.copyWith(language: value);
                context.read<SettingsBloc>().add(SavePreferencesEvent(newPrefs));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        bool obscureCurrent = true;
        bool obscureNew = true;
        bool obscureConfirm = true;

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Cambiar contraseña'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    obscureText: obscureCurrent,
                    decoration: InputDecoration(
                      labelText: 'Contraseña actual',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(obscureCurrent ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => obscureCurrent = !obscureCurrent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    obscureText: obscureNew,
                    decoration: InputDecoration(
                      labelText: 'Nueva contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(obscureNew ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => obscureNew = !obscureNew),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirm,
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(obscureConfirm ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  return ElevatedButton(
                    onPressed: () {
                      if (newPasswordController.text != confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Las contraseñas no coinciden')),
                        );
                        return;
                      }

                      if (newPasswordController.text.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('La contraseña debe tener al menos 8 caracteres')),
                        );
                        return;
                      }

                      // Obtener el ID del usuario actual
                      if (authState is Authenticated) {
                        context.read<SettingsBloc>().add(
                              ChangePasswordEvent(
                                userId: authState.user.id,
                                currentPassword: currentPasswordController.text,
                                newPassword: newPasswordController.text,
                              ),
                            );
                        Navigator.pop(dialogContext);
                      }
                    },
                    child: const Text('Actualizar'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Acerca de'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plataforma de Cursos Online',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Versión: 1.0.0'),
            SizedBox(height: 4),
            Text('Build: 1'),
            SizedBox(height: 16),
            Text(
              'Una plataforma completa para aprender y enseñar online.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
