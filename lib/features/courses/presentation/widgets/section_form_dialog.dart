import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

/// Diálogo para crear o editar una sección
class SectionFormDialog extends StatefulWidget {
  final String? initialTitulo;
  final String? initialContenido;
  final String? initialVideoUrl;
  final String? initialArchivo;
  final int? initialDuracionMinutos;
  final bool? initialEsPreview;
  final int orden;
  final bool isEditing;

  const SectionFormDialog({
    super.key,
    this.initialTitulo,
    this.initialContenido,
    this.initialVideoUrl,
    this.initialArchivo,
    this.initialDuracionMinutos,
    this.initialEsPreview,
    required this.orden,
    this.isEditing = false,
  });

  @override
  State<SectionFormDialog> createState() => _SectionFormDialogState();
}

class _SectionFormDialogState extends State<SectionFormDialog> {
  late TextEditingController _tituloController;
  late TextEditingController _contenidoController;
  late TextEditingController _videoUrlController;
  late TextEditingController _duracionController;
  final _formKey = GlobalKey<FormState>();
  bool _esPreview = false;
  File? _selectedFile;
  String? _existingFileName;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.initialTitulo);
    _contenidoController = TextEditingController(text: widget.initialContenido);
    _videoUrlController = TextEditingController(text: widget.initialVideoUrl);
    _duracionController = TextEditingController(
      text: widget.initialDuracionMinutos?.toString() ?? '0',
    );
    _esPreview = widget.initialEsPreview ?? false;
    
    // Extraer nombre del archivo existente si hay
    if (widget.initialArchivo != null && widget.initialArchivo!.isNotEmpty) {
      _existingFileName = widget.initialArchivo!.split('/').last;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    _videoUrlController.dispose();
    _duracionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'txt', 'zip', 'rar'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Editar Sección' : 'Nueva Sección'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sección ${widget.orden}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título de la sección *',
                  hintText: 'Ej: Introducción al tema',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _contenidoController,
                decoration: const InputDecoration(
                  labelText: 'Contenido *',
                  hintText: 'Descripción del contenido de la sección',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El contenido es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _videoUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL del video (opcional)',
                  hintText: 'https://youtube.com/watch?v=...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.video_library),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              // Sección de archivo
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.attach_file, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Archivo adjunto (opcional)',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_selectedFile != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.insert_drive_file, color: Colors.green.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedFile!.path.split('/').last,
                                style: TextStyle(color: Colors.green.shade700),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () {
                                setState(() {
                                  _selectedFile = null;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ] else if (_existingFileName != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.insert_drive_file, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _existingFileName!,
                                style: TextStyle(color: Colors.blue.shade700),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Text(
                        'No hay archivo seleccionado',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Seleccionar archivo'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _duracionController,
                decoration: const InputDecoration(
                  labelText: 'Duración (minutos) *',
                  hintText: '0',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La duración es requerida';
                  }
                  final duration = int.tryParse(value);
                  if (duration == null || duration < 0) {
                    return 'Ingrese una duración válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Vista previa gratuita'),
                subtitle: const Text('Los usuarios no inscritos pueden ver esta sección'),
                value: _esPreview,
                onChanged: (value) {
                  setState(() {
                    _esPreview = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'titulo': _tituloController.text.trim(),
                'contenido': _contenidoController.text.trim(),
                'videoUrl': _videoUrlController.text.trim().isEmpty
                    ? null
                    : _videoUrlController.text.trim(),
                'duracionMinutos': int.parse(_duracionController.text.trim()),
                'esPreview': _esPreview,
                'archivo': _selectedFile, // Enviar el File seleccionado
              });
            }
          },
          child: Text(widget.isEditing ? 'Guardar' : 'Crear'),
        ),
      ],
    );
  }
}
