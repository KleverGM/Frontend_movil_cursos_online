import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notice.dart';
import '../bloc/notice_bloc.dart';
import '../bloc/notice_event.dart';
import '../bloc/notice_state.dart';
import '../widgets/notice_stat_card.dart';

/// Página para editar un aviso existente
class AdminNoticeEditPage extends StatefulWidget {
  final Notice notice;

  const AdminNoticeEditPage({
    super.key,
    required this.notice,
  });

  @override
  State<AdminNoticeEditPage> createState() => _AdminNoticeEditPageState();
}

class _AdminNoticeEditPageState extends State<AdminNoticeEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _mensajeController;
  late NoticeType _selectedType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.notice.titulo);
    _mensajeController = TextEditingController(text: widget.notice.mensaje);
    _selectedType = widget.notice.tipo;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _mensajeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Solo actualizar si algo cambió
      final bool hasChanges = 
        _tituloController.text.trim() != widget.notice.titulo ||
        _mensajeController.text.trim() != widget.notice.mensaje ||
        _selectedType != widget.notice.tipo;

      if (!hasChanges) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay cambios para guardar'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      context.read<NoticeBloc>().add(
        UpdateNoticeEvent(
          noticeId: widget.notice.id,
          titulo: _tituloController.text.trim() != widget.notice.titulo
              ? _tituloController.text.trim()
              : null,
          mensaje: _mensajeController.text.trim() != widget.notice.mensaje
              ? _mensajeController.text.trim()
              : null,
          tipo: _selectedType != widget.notice.tipo ? _selectedType : null,
        ),
      );
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Aviso'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este aviso? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<NoticeBloc>().add(DeleteNoticeEvent(widget.notice.id));
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context, true); // Volver a la lista
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Aviso'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
            tooltip: 'Eliminar aviso',
          ),
        ],
      ),
      body: BlocListener<NoticeBloc, NoticeState>(
        listener: (context, state) {
          if (state is NoticeLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);

            if (state is NoticeUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Aviso actualizado exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
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
                Card(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Información del Aviso',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        InfoRow(
                          label: 'ID',
                          value: '#${widget.notice.id}',
                        ),
                        InfoRow(
                          label: 'Usuario',
                          value: 'ID: ${widget.notice.usuarioId}',
                        ),
                        InfoRow(
                          label: 'Fecha de creación',
                          value: _formatDate(widget.notice.fechaCreacion),
                        ),
                        InfoRow(
                          label: 'Estado',
                          value: widget.notice.leido ? 'Leído' : 'No leído',
                          valueColor: widget.notice.leido ? Colors.green : Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

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
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(
                                'Guardar Cambios',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
