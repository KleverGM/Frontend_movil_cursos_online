import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../bloc/section_bloc.dart';
import '../bloc/section_event.dart';

class AddSectionDialog extends StatefulWidget {
  final int moduleId;
  final int nextOrder;
  final String moduleName;

  const AddSectionDialog({
    super.key,
    required this.moduleId,
    required this.nextOrder,
    required this.moduleName,
  });

  @override
  State<AddSectionDialog> createState() => _AddSectionDialogState();
}

class _AddSectionDialogState extends State<AddSectionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _duracionController = TextEditingController(text: '0');
  bool _esPreview = false;
  PlatformFile? _selectedVideoFile;
  bool _useUrl = true; // true = URL, false = archivo

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    _videoUrlController.dispose();
    _duracionController.dispose();
    super.dispose();
  }

  Future<void> _pickVideoFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mov', 'avi', 'mkv'],
        withData: false,
        withReadStream: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedVideoFile = result.files.first;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar archivo: $e')),
        );
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Validar que haya contenido de video si se eligió esa opción
      if (_useUrl && _videoUrlController.text.trim().isEmpty) {
        // No hay problema, el video es opcional
      } else if (!_useUrl && _selectedVideoFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona un archivo de video')),
        );
        return;
      }

      context.read<SectionBloc>().add(CreateSectionEvent(
            moduloId: widget.moduleId,
            titulo: _tituloController.text.trim(),
            contenido: _contenidoController.text.trim(),
            videoUrl: _useUrl && _videoUrlController.text.trim().isNotEmpty
                ? _videoUrlController.text.trim()
                : null,
            videoFile: !_useUrl ? _selectedVideoFile : null,
            orden: widget.nextOrder,
            duracionMinutos: int.tryParse(_duracionController.text) ?? 0,
            esPreview: _esPreview,
          ));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Agregar Sección',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Módulo: ${widget.moduleName}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Orden (solo informativo)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity( 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.numbers, color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Esta será la sección #${widget.nextOrder}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Título
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título de la Sección *',
                          prefixIcon: Icon(Icons.title),
                          border: OutlineInputBorder(),
                          helperText: 'Ejemplo: Introducción al tema',
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El título es requerido';
                          }
                          if (value.trim().length < 3) {
                            return 'Mínimo 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Contenido/Descripción
                      TextFormField(
                        controller: _contenidoController,
                        decoration: const InputDecoration(
                          labelText: 'Contenido/Descripción *',
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          helperText: 'Describe el contenido de esta sección',
                        ),
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El contenido es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Selector: URL o Archivo
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  topRight: Radius.circular(7),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.video_library, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Video de la Sección (opcional)',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Opciones de tipo
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ChoiceChip(
                                          label: const Text('URL (YouTube)'),
                                          avatar: const Icon(Icons.link, size: 16),
                                          selected: _useUrl,
                                          onSelected: (selected) {
                                            setState(() {
                                              _useUrl = true;
                                              _selectedVideoFile = null;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ChoiceChip(
                                          label: const Text('Subir MP4'),
                                          avatar: const Icon(Icons.upload_file, size: 16),
                                          selected: !_useUrl,
                                          onSelected: (selected) {
                                            setState(() {
                                              _useUrl = false;
                                              _videoUrlController.clear();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // Campo según selección
                                  if (_useUrl)
                                    TextFormField(
                                      controller: _videoUrlController,
                                      decoration: const InputDecoration(
                                        labelText: 'URL del Video',
                                        hintText: 'https://youtube.com/watch?v=...',
                                        prefixIcon: Icon(Icons.link),
                                        border: OutlineInputBorder(),
                                        helperText: 'Puede tener restricciones de reproducción',
                                        helperMaxLines: 2,
                                      ),
                                      keyboardType: TextInputType.url,
                                      validator: (value) {
                                        if (_useUrl && value != null && value.trim().isNotEmpty) {
                                          final uri = Uri.tryParse(value.trim());
                                          if (uri == null || !uri.hasScheme) {
                                            return 'URL inválida';
                                          }
                                        }
                                        return null;
                                      },
                                    )
                                  else
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: _pickVideoFile,
                                          icon: const Icon(Icons.upload_file),
                                          label: const Text('Seleccionar Archivo MP4'),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                          ),
                                        ),
                                        if (_selectedVideoFile != null) ...[
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.green.withOpacity(0.3)),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        _selectedVideoFile!.name,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Text(
                                                        '${(_selectedVideoFile!.size / (1024 * 1024)).toStringAsFixed(1)} MB',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.close, size: 18),
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedVideoFile = null;
                                                    });
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ] else ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            '💡 Sin restricciones de reproducción',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Duración
                      TextFormField(
                        controller: _duracionController,
                        decoration: const InputDecoration(
                          labelText: 'Duración (minutos)',
                          prefixIcon: Icon(Icons.timer),
                          border: OutlineInputBorder(),
                          helperText: 'Tiempo estimado para completar',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La duración es requerida';
                          }
                          final duration = int.tryParse(value.trim());
                          if (duration == null || duration < 0) {
                            return 'Ingrese un número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Es Preview
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.preview, size: 20, color: Colors.orange),
                                      SizedBox(width: 8),
                                      Text(
                                        'Vista Previa Gratuita',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Permite que usuarios no inscritos vean esta sección',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _esPreview,
                              onChanged: (value) {
                                setState(() {
                                  _esPreview = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Info
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Podrás editar o eliminar esta sección después de crearla',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
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
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Crear Sección'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
