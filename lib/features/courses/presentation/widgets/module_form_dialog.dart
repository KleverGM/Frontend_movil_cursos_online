import 'package:flutter/material.dart';

/// Diálogo para crear o editar un módulo
class ModuleFormDialog extends StatefulWidget {
  final String? initialTitulo;
  final String? initialDescripcion;
  final int orden;
  final bool isEditing;

  const ModuleFormDialog({
    super.key,
    this.initialTitulo,
    this.initialDescripcion,
    required this.orden,
    this.isEditing = false,
  });

  @override
  State<ModuleFormDialog> createState() => _ModuleFormDialogState();
}

class _ModuleFormDialogState extends State<ModuleFormDialog> {
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.initialTitulo);
    _descripcionController = TextEditingController(text: widget.initialDescripcion);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Editar Módulo' : 'Nuevo Módulo'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Módulo ${widget.orden}',
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
                  labelText: 'Título del módulo *',
                  hintText: 'Ej: Introducción al Curso',
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
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  hintText: 'Breve descripción del módulo',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                'descripcion': _descripcionController.text.trim().isEmpty
                    ? null
                    : _descripcionController.text.trim(),
              });
            }
          },
          child: Text(widget.isEditing ? 'Guardar' : 'Crear'),
        ),
      ],
    );
  }
}
