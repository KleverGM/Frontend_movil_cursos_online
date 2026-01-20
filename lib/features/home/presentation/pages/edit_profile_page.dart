import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../core/widgets/inputs/custom_text_fields.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Página para editar el perfil del usuario
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    
    // Inicializar controllers con datos actuales del usuario
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _usernameController = TextEditingController(text: authState.user.username);
      _firstNameController = TextEditingController(text: authState.user.firstName ?? '');
      _lastNameController = TextEditingController(text: authState.user.lastName ?? '');
    } else {
      _usernameController = TextEditingController();
      _firstNameController = TextEditingController();
      _lastNameController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            UpdateProfileRequested(
              username: _usernameController.text.trim(),
              firstName: _firstNameController.text.trim().isEmpty 
                  ? null 
                  : _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim().isEmpty 
                  ? null 
                  : _lastNameController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Limpiar snackbars anteriores
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ Perfil actualizado exitosamente'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AuthError) {
            // Limpiar snackbars anteriores
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Información de ayuda
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Actualiza tu información personal. El correo no se puede cambiar.',
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Correo (solo lectura)
                  if (state is Authenticated) ...[
                    CustomTextField(
                      controller: TextEditingController(text: state.user.email),
                      label: 'Correo Electrónico',
                      prefixIcon: const Icon(Icons.email),
                      enabled: false,
                      hint: 'El correo no se puede modificar',
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Username
                  CustomTextField(
                    controller: _usernameController,
                    label: 'Nombre de usuario',
                    prefixIcon: const Icon(Icons.person),
                    enabled: !isLoading,
                    validator: Validators.username,
                  ),
                  const SizedBox(height: 16),

                  // Nombre
                  CustomTextField(
                    controller: _firstNameController,
                    label: 'Nombre',
                    prefixIcon: const Icon(Icons.badge),
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Opcional
                      }
                      if (value.length < 2) {
                        return 'El nombre debe tener al menos 2 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Apellido
                  CustomTextField(
                    controller: _lastNameController,
                    label: 'Apellido',
                    prefixIcon: const Icon(Icons.badge_outlined),
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Opcional
                      }
                      if (value.length < 2) {
                        return 'El apellido debe tener al menos 2 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Botón guardar
                  PrimaryButton(
                    onPressed: isLoading ? null : _handleSubmit,
                    text: 'Guardar Cambios',
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 12),

                  // Botón cancelar
                  OutlinedButton(
                    onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
