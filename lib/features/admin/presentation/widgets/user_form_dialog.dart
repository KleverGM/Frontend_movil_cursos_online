import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_bloc.dart';

class UserFormDialog extends StatefulWidget {
  final int? userId;
  final Map<String, dynamic>? initialData;

  const UserFormDialog({
    super.key,
    this.userId,
    this.initialData,
  });

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  String _selectedPerfil = 'estudiante';
  bool _isActive = true;

  bool get isEditing => widget.userId != null;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.initialData?['username'] ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialData?['email'] ?? '',
    );
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController(
      text: widget.initialData?['first_name'] ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.initialData?['last_name'] ?? '',
    );
    _selectedPerfil = widget.initialData?['perfil'] ?? 'estudiante';
    _isActive = widget.initialData?['is_active'] ?? true;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (isEditing) {
        context.read<AdminBloc>().add(UpdateUserEvent(
              userId: widget.userId!,
              username: _usernameController.text.trim().isNotEmpty
                  ? _usernameController.text.trim()
                  : null,
              email: _emailController.text.trim().isNotEmpty
                  ? _emailController.text.trim()
                  : null,
              perfil: _selectedPerfil,
              firstName: _firstNameController.text.trim().isNotEmpty
                  ? _firstNameController.text.trim()
                  : null,
              lastName: _lastNameController.text.trim().isNotEmpty
                  ? _lastNameController.text.trim()
                  : null,
              isActive: _isActive,
            ));
      } else {
        if (_passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('La contraseña es requerida para crear un usuario'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        context.read<AdminBloc>().add(CreateUserEvent(
              username: _usernameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              perfil: _selectedPerfil,
              firstName: _firstNameController.text.trim().isNotEmpty
                  ? _firstNameController.text.trim()
                  : null,
              lastName: _lastNameController.text.trim().isNotEmpty
                  ? _lastNameController.text.trim()
                  : null,
            ));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Editar Usuario' : 'Crear Nuevo Usuario'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username *',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (!isEditing && (value == null || value.isEmpty)) {
                    return 'El username es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!isEditing && (value == null || value.isEmpty)) {
                    return 'El email es requerido';
                  }
                  if (value != null &&
                      value.isNotEmpty &&
                      !value.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password (solo al crear)
              if (!isEditing)
                Column(
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña *',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                        helperText: 'Mínimo 8 caracteres',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La contraseña es requerida';
                        }
                        if (value.length < 8) {
                          return 'La contraseña debe tener al menos 8 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              // First Name
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Last Name
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Perfil
              DropdownButtonFormField<String>(
                initialValue: _selectedPerfil,
                decoration: const InputDecoration(
                  labelText: 'Perfil *',
                  prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'estudiante',
                    child: Text('Estudiante'),
                  ),
                  DropdownMenuItem(
                    value: 'instructor',
                    child: Text('Instructor'),
                  ),
                  DropdownMenuItem(
                    value: 'administrador',
                    child: Text('Administrador'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedPerfil = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Estado (solo al editar)
              if (isEditing)
                SwitchListTile(
                  title: const Text('Usuario Activo'),
                  subtitle: Text(_isActive ? 'El usuario puede acceder' : 'Acceso bloqueado'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() => _isActive = value);
                  },
                  activeThumbColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(isEditing ? 'Actualizar' : 'Crear'),
        ),
      ],
    );
  }
}
