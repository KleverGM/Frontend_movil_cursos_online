import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Diálogo para crear o editar una sección
class SectionFormDialog extends StatefulWidget {
  final String? initialTitulo;
  final String? initialContenido;
  final String? initialVideoUrl;
  final int? initialDuracionMinutos;
  final bool? initialEsPreview;
  final int orden;
  final bool isEditing;

  const SectionFormDialog({
    super.key,
    this.initialTitulo,
    this.initialContenido,
    this.initialVideoUrl,
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
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    _videoUrlController.dispose();
    _duracionController.dispose();
    super.dispose();
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
              });
            }
          },
          child: Text(widget.isEditing ? 'Guardar' : 'Crear'),
        ),
      ],
    );
  }
}
