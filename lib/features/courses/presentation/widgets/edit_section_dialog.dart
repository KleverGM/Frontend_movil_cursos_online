import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/entities/section.dart';
import '../bloc/section_bloc.dart';
import '../bloc/section_event.dart';

class EditSectionDialog extends StatefulWidget {
  final Section section;
  final String moduleName;
  final int moduleId;

  const EditSectionDialog({
    super.key,
    required this.section,
    required this.moduleName,
    required this.moduleId,
  });

  @override
  State<EditSectionDialog> createState() => _EditSectionDialogState();
}

class _EditSectionDialogState extends State<EditSectionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _contenidoController;
  late final TextEditingController _videoUrlController;
  late final TextEditingController _duracionController;
  late final TextEditingController _ordenController;
  late bool _esPreview;
  PlatformFile? _selectedVideoFile;
  late bool _useUrl; // true = URL, false = archivo

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.section.titulo);
    _contenidoController = TextEditingController(text: widget.section.contenido);
    _videoUrlController = TextEditingController(text: widget.section.videoUrl ?? '');
    _duracionController = TextEditingController(text: widget.section.duracionMinutos.toString());
    _ordenController = TextEditingController(text: widget.section.orden.toString());
    _esPreview = widget.section.esPreview;
    _useUrl = widget.section.videoUrl != null && widget.section.videoUrl!.isNotEmpty;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    _videoUrlController.dispose();
    _duracionController.dispose();
    _ordenController.dispose();
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
      context.read<SectionBloc>().add(UpdateSectionEvent(
            sectionId: widget.section.id,
            moduleId: widget.moduleId,
            titulo: _tituloController.text.trim(),
            contenido: _contenidoController.text.trim(),
            videoUrl: _useUrl && _videoUrlController.text.trim().isNotEmpty
                ? _videoUrlController.text.trim()
                : null,
            videoFile: !_useUrl ? _selectedVideoFile : null,
            orden: int.parse(_ordenController.text.trim()),
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
                  const Icon(Icons.edit, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Editar Sección',
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
                      // ID de la sección (solo informativo)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity( 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Sección ID: ${widget.section.id}',
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
                          helperText: 'Ejemplo: Introducción a HTML',
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

                      // Contenido
                      TextFormField(
                        controller: _contenidoController,
                        decoration: const InputDecoration(
                          labelText: 'Contenido/Descripción *',
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          helperText: 'Describe el contenido de esta sección',
                        ),
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El contenido es requerido';
                          }
                          if (value.trim().length < 10) {
                            return 'Mínimo 10 caracteres';
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
                                        helperText: 'Puede tener restricciones',
                                      ),
                                      keyboardType: TextInputType.url,
                                      validator: (value) {
                                        if (_useUrl && value != null && value.trim().isNotEmpty) {
                                          final url = value.trim();
                                          if (!url.startsWith('http://') && !url.startsWith('https://')) {
                                            return 'Debe comenzar con http:// o https://';
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
                                            '💡 Reemplazará el video actual',
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

                      // Duración y Orden en fila
                      Row(
                        children: [
                          // Duración
                          Expanded(
                            child: TextFormField(
                              controller: _duracionController,
                              decoration: const InputDecoration(
                                labelText: 'Duración (min)',
                                prefixIcon: Icon(Icons.timer),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null && value.trim().isNotEmpty) {
                                  final duracion = int.tryParse(value.trim());
                                  if (duracion == null || duracion < 0) {
                                    return 'Número inválido';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Orden
                          Expanded(
                            child: TextFormField(
                              controller: _ordenController,
                              decoration: const InputDecoration(
                                labelText: 'Orden *',
                                prefixIcon: Icon(Icons.numbers),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Requerido';
                                }
                                final orden = int.tryParse(value.trim());
                                if (orden == null || orden < 1) {
                                  return 'Debe ser > 0';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Vista previa
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SwitchListTile(
                          value: _esPreview,
                          onChanged: (value) {
                            setState(() {
                              _esPreview = value;
                            });
                          },
                          title: const Text('Vista Previa Gratuita'),
                          subtitle: const Text(
                            'Los usuarios no inscritos pueden ver esta sección',
                            style: TextStyle(fontSize: 12),
                          ),
                          secondary: Icon(
                            _esPreview ? Icons.visibility : Icons.visibility_off,
                            color: _esPreview ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.save, size: 20),
                            label: const Text('Guardar Cambios'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
