import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notice.dart';
import '../bloc/notice_bloc.dart';
import '../bloc/notice_event.dart';
import '../bloc/notice_state.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';

/// Página para crear un nuevo aviso (individual o broadcast)
class AdminNoticeCreatePage extends StatefulWidget {
  final bool isBroadcast;

  const AdminNoticeCreatePage({
    super.key,
    this.isBroadcast = false,
  });

  @override
  State<AdminNoticeCreatePage> createState() => _AdminNoticeCreatePageState();
}

class _AdminNoticeCreatePageState extends State<AdminNoticeCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _mensajeController = TextEditingController();
  NoticeType _selectedType = NoticeType.info;
  bool _isImportante = false;
  bool _isLoading = false;

  // Para avisos individuales
  int? _selectedUserId;
  List<Map<String, dynamic>> _users = [];
  bool _loadingUsers = true; // Empieza como true para mostrar el indicador de carga

  // Para avisos broadcast
  List<int> _selectedUserIds = [];
  bool _sendToAll = true;

  @override
  void initState() {
    super.initState();
    if (!widget.isBroadcast) {
      _loadUsers();
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _mensajeController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    print('🔄 Iniciando carga de usuarios...');
    setState(() => _loadingUsers = true);
    
    try {
      final apiClient = getIt<ApiClient>();
      print('🌐 Llamando a /api/users/');
      final response = await apiClient.get('/api/users/');
      print('📥 Respuesta recibida: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data as List<dynamic>
            : (response.data as Map<String, dynamic>)['results'] as List<dynamic>;
        
        print('✅ Usuarios cargados: ${data.length}');
        
        setState(() {
          _users = data.map((user) {
            return {
              'id': user['id'] as int,
              'username': user['username'] as String,
              'email': user['email'] as String,
              'first_name': user['first_name'] as String? ?? '',
              'last_name': user['last_name'] as String? ?? '',
              'perfil': user['perfil'] as String? ?? 'estudiante',
            };
          }).toList();
          _loadingUsers = false;
        });
        print('✅ Estado actualizado con ${_users.length} usuarios');
      } else {
        print('❌ Error en respuesta: ${response.statusCode}');
        setState(() => _loadingUsers = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Excepción capturada: $e');
      setState(() => _loadingUsers = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar usuarios: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.isBroadcast) {
        _createBroadcastNotice();
      } else {
        _createIndividualNotice();
      }
    }
  }

  void _createBroadcastNotice() {
    context.read<NoticeBloc>().add(
      CreateBroadcastNoticeEvent(
        titulo: _tituloController.text.trim(),
        mensaje: _mensajeController.text.trim(),
        tipo: _selectedType,
        usuarioIds: _sendToAll ? null : _selectedUserIds,
      ),
    );
  }

  void _createIndividualNotice() {
    if (_selectedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar un usuario'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<NoticeBloc>().add(
      CreateNoticeEvent(
        usuarioId: _selectedUserId!,
        titulo: _tituloController.text.trim(),
        mensaje: _mensajeController.text.trim(),
        tipo: _selectedType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isBroadcast ? 'Crear Aviso Broadcast' : 'Crear Aviso'),
      ),
      body: BlocListener<NoticeBloc, NoticeState>(
        listener: (context, state) {
          if (state is NoticeLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);

            if (state is BroadcastNoticesCreated) {
              Navigator.pop(context, true);
            } else if (state is NoticeCreated) {
              Navigator.pop(context, true);
            } else if (state is NoticeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isBroadcast) ...[
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Este aviso se enviará a múltiples usuarios',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Enviar a todos los usuarios'),
                    subtitle: const Text('Si está desactivado, puedes seleccionar usuarios específicos'),
                    value: _sendToAll,
                    onChanged: (value) {
                      setState(() => _sendToAll = value);
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                if (!widget.isBroadcast) ...[
                  const Text(
                    'Usuario Destinatario',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _loadingUsers
                      ? const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 12),
                                Text('Cargando usuarios...'),
                              ],
                            ),
                          ),
                        )
                      : DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.person),
                            hintText: _users.isEmpty 
                                ? 'No hay usuarios disponibles'
                                : 'Selecciona un usuario',
                          ),
                          initialValue: _selectedUserId,
                          items: _users.map((user) {
                            final firstName = user['first_name'] as String? ?? '';
                            final lastName = user['last_name'] as String? ?? '';
                            final username = user['username'] as String;
                            final perfil = user['perfil'] as String? ?? 'estudiante';
                            
                            // Construir nombre completo o usar username
                            final displayName = firstName.isNotEmpty || lastName.isNotEmpty
                                ? '$firstName $lastName'.trim()
                                : username;
                            
                            // Emoji según perfil
                            final perfilIcon = perfil == 'administrador' 
                                ? '👑' 
                                : perfil == 'instructor' 
                                    ? '👨‍🏫' 
                                    : '👤';
                            
                            return DropdownMenuItem<int>(
                              value: user['id'] as int,
                              child: Text('$perfilIcon $displayName (@$username)'),
                            );
                          }).toList(),
                          onChanged: _users.isEmpty ? null : (value) {
                            setState(() => _selectedUserId = value);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Debes seleccionar un usuario';
                            }
                            return null;
                          },
                        ),
                  if (_users.isEmpty && !_loadingUsers) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Colors.orange[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'No se pudieron cargar los usuarios. Intenta recargar.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[700],
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _loadUsers,
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Recargar'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                ],

                const Text(
                  'Título',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.title),
                    hintText: 'Título del aviso',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El título es requerido';
                    }
                    if (value.trim().length < 3) {
                      return 'El título debe tener al menos 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                const Text(
                  'Mensaje',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _mensajeController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Icon(Icons.message),
                    ),
                    hintText: 'Contenido del aviso',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El mensaje es requerido';
                    }
                    if (value.trim().length < 10) {
                      return 'El mensaje debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                const Text(
                  'Tipo de Aviso',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: NoticeType.values.map((type) {
                    final isSelected = _selectedType == type;
                    return ChoiceChip(
                      label: Text(type.displayName),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedType = type);
                        }
                      },
                      selectedColor: _getTypeColor(type).withOpacity( 0.3),
                      avatar: isSelected ? null : Icon(_getTypeIcon(type), size: 18),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                SwitchListTile(
                  title: const Text('Marcar como importante'),
                  subtitle: const Text('Los avisos importantes se destacan en la lista'),
                  value: _isImportante,
                  onChanged: (value) {
                    setState(() => _isImportante = value);
                  },
                  secondary: const Icon(Icons.priority_high),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Crear Aviso',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(NoticeType type) {
    switch (type) {
      case NoticeType.info:
        return Colors.blue;
      case NoticeType.warning:
        return Colors.orange;
      case NoticeType.success:
        return Colors.green;
      case NoticeType.error:
        return Colors.red;
      case NoticeType.announcement:
        return Colors.purple;
    }
  }

  IconData _getTypeIcon(NoticeType type) {
    switch (type) {
      case NoticeType.info:
        return Icons.info_outline;
      case NoticeType.warning:
        return Icons.warning_amber;
      case NoticeType.success:
        return Icons.check_circle_outline;
      case NoticeType.error:
        return Icons.error_outline;
      case NoticeType.announcement:
        return Icons.campaign;
    }
  }
}
