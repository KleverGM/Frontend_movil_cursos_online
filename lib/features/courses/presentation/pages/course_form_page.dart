import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/course_input.dart';
import '../bloc/course_bloc.dart';

/// Página para crear o editar cursos (para instructores)
class CourseFormPage extends StatefulWidget {
  final Course? course; // null si es crear, Course si es editar

  const CourseFormPage({super.key, this.course});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late CourseInput _courseInput;
  File? _selectedImageFile;
  bool _isSubmitting = false;

  // Controladores de texto
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;

  // Opciones de categorías y niveles (deben coincidir con el backend)
  final List<Map<String, String>> _categorias = [
    {'value': 'programacion', 'label': 'Programación'},
    {'value': 'diseño', 'label': 'Diseño'},
    {'value': 'marketing', 'label': 'Marketing'},
    {'value': 'negocios', 'label': 'Negocios'},
    {'value': 'idiomas', 'label': 'Idiomas'},
    {'value': 'musica', 'label': 'Música'},
    {'value': 'fotografia', 'label': 'Fotografía'},
    {'value': 'otros', 'label': 'Otros'},
  ];

  final List<Map<String, String>> _niveles = [
    {'value': 'principiante', 'label': 'Principiante'},
    {'value': 'intermedio', 'label': 'Intermedio'},
    {'value': 'avanzado', 'label': 'Avanzado'},
  ];

  @override
  void initState() {
    super.initState();
    // Inicializar con curso existente o vacío
    _courseInput = widget.course != null
        ? CourseInput.fromCourse(widget.course!)
        : const CourseInput.empty();

    _tituloController = TextEditingController(text: _courseInput.titulo);
    _descripcionController = TextEditingController(text: _courseInput.descripcion);
    _precioController = TextEditingController(
      text: _courseInput.isNew ? '' : _courseInput.precio.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final courseBloc = context.read<CourseBloc>();

      if (_courseInput.isNew) {
        // Crear nuevo curso
        courseBloc.add(
          CreateCourseEvent(
            titulo: _tituloController.text.trim(),
            descripcion: _descripcionController.text.trim(),
            categoria: _courseInput.categoria,
            nivel: _courseInput.nivel,
            precio: double.parse(_precioController.text),
            imagenPath: _selectedImageFile?.path,
          ),
        );
      } else {
        // Actualizar curso existente
        courseBloc.add(
          UpdateCourseEvent(
            courseId: _courseInput.id!,
            titulo: _tituloController.text.trim(),
            descripcion: _descripcionController.text.trim(),
            categoria: _courseInput.categoria,
            nivel: _courseInput.nivel,
            precio: double.parse(_precioController.text),
            imagenPath: _selectedImageFile?.path,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = !_courseInput.isNew;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Curso' : 'Crear Nuevo Curso'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseCreatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Curso creado exitosamente')),
            );
            Navigator.of(context).pop(true); // Retornar true para indicar éxito
          } else if (state is CourseUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Curso actualizado exitosamente')),
            );
            Navigator.of(context).pop(true);
          } else if (state is CourseDeletedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Curso eliminado exitosamente')),
            );
            Navigator.of(context).pop(true);
          } else if (state is CourseError) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagen
                _buildImageSection(),
                const SizedBox(height: 24),

                // Título
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título del Curso *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.book),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El título es requerido';
                    }
                    if (value.length < 5) {
                      return 'El título debe tener al menos 5 caracteres';
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
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La descripción es requerida';
                    }
                    if (value.length < 20) {
                      return 'La descripción debe tener al menos 20 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Categoría
                DropdownButtonFormField<String>(
                  value: _courseInput.categoria,
                  decoration: const InputDecoration(
                    labelText: 'Categoría *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _categorias.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat['value'],
                      child: Text(cat['label']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _courseInput = _courseInput.copyWith(categoria: value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La categoría es requerida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Nivel
                DropdownButtonFormField<String>(
                  value: _courseInput.nivel,
                  decoration: const InputDecoration(
                    labelText: 'Nivel *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.signal_cellular_alt),
                  ),
                  items: _niveles.map((nivel) {
                    return DropdownMenuItem<String>(
                      value: nivel['value'],
                      child: Text(nivel['label']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _courseInput = _courseInput.copyWith(nivel: value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nivel es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Precio
                TextFormField(
                  controller: _precioController,
                  decoration: const InputDecoration(
                    labelText: 'Precio (USD) *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El precio es requerido';
                    }
                    final precio = double.tryParse(value);
                    if (precio == null) {
                      return 'Ingrese un precio válido';
                    }
                    if (precio < 0) {
                      return 'El precio debe ser mayor o igual a 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Botón de submit
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          isEditing ? 'Guardar Cambios' : 'Crear Curso',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imagen del Curso',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: _buildImageWidget(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Toca para seleccionar una imagen',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildImageWidget() {
    if (_selectedImageFile != null) {
      // Mostrar imagen seleccionada
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          _selectedImageFile!,
          fit: BoxFit.cover,
        ),
      );
    } else if (_courseInput.imagenUrl != null) {
      // Mostrar imagen existente (al editar)
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          _courseInput.imagenUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        ),
      );
    } else {
      // Placeholder
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Sin imagen',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este curso? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<CourseBloc>().add(
                    DeleteCourseEvent(_courseInput.id!),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
