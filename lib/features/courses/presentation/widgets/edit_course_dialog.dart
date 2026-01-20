import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/course.dart';
import '../../../admin/presentation/bloc/admin_bloc.dart';

class EditCourseDialog extends StatefulWidget {
  final Course course;

  const EditCourseDialog({
    super.key,
    required this.course,
  });

  @override
  State<EditCourseDialog> createState() => _EditCourseDialogState();
}

class _EditCourseDialogState extends State<EditCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  String _selectedCategoria = 'programacion';
  String _selectedNivel = 'principiante';

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.course.titulo);
    _descripcionController = TextEditingController(text: widget.course.descripcion);
    _precioController = TextEditingController(text: widget.course.precio.toString());
    _selectedCategoria = widget.course.categoria;
    _selectedNivel = widget.course.nivel;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AdminBloc>().add(UpdateCourseAsAdminEvent(
            courseId: widget.course.id,
            titulo: _tituloController.text.trim(),
            descripcion: _descripcionController.text.trim(),
            categoria: _selectedCategoria,
            nivel: _selectedNivel,
            precio: double.parse(_precioController.text.trim()),
          ));
      Navigator.pop(context, true); // Retornar true para indicar que se guardó
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
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
                  const Expanded(
                    child: Text(
                      'Editar Curso',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                      // Título
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título *',
                          prefixIcon: Icon(Icons.title),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El título es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Descripción
                      TextFormField(
                        controller: _descripcionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción *',
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La descripción es requerida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Categoría
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategoria,
                        decoration: const InputDecoration(
                          labelText: 'Categoría *',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'programacion',
                            child: Text('Programación'),
                          ),
                          DropdownMenuItem(
                            value: 'diseño',
                            child: Text('Diseño'),
                          ),
                          DropdownMenuItem(
                            value: 'marketing',
                            child: Text('Marketing'),
                          ),
                          DropdownMenuItem(
                            value: 'negocios',
                            child: Text('Negocios'),
                          ),
                          DropdownMenuItem(
                            value: 'desarrollo_personal',
                            child: Text('Desarrollo Personal'),
                          ),
                          DropdownMenuItem(
                            value: 'fotografia',
                            child: Text('Fotografía'),
                          ),
                          DropdownMenuItem(
                            value: 'musica',
                            child: Text('Música'),
                          ),
                          DropdownMenuItem(
                            value: 'idiomas',
                            child: Text('Idiomas'),
                          ),
                          DropdownMenuItem(
                            value: 'otros',
                            child: Text('Otros'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoria = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Nivel
                      DropdownButtonFormField<String>(
                        initialValue: _selectedNivel,
                        decoration: const InputDecoration(
                          labelText: 'Nivel *',
                          prefixIcon: Icon(Icons.signal_cellular_alt),
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'principiante',
                            child: Text('Principiante'),
                          ),
                          DropdownMenuItem(
                            value: 'intermedio',
                            child: Text('Intermedio'),
                          ),
                          DropdownMenuItem(
                            value: 'avanzado',
                            child: Text('Avanzado'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedNivel = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Precio
                      TextFormField(
                        controller: _precioController,
                        decoration: const InputDecoration(
                          labelText: 'Precio *',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                          helperText: 'Ingrese 0 para curso gratuito',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El precio es requerido';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Ingrese un precio válido';
                          }
                          if (double.parse(value) < 0) {
                            return 'El precio no puede ser negativo';
                          }
                          return null;
                        },
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
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('Guardar'),
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
