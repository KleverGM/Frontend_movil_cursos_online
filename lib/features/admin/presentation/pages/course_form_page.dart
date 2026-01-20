import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/theme_config.dart';
import '../../../courses/domain/entities/course.dart';
import '../bloc/admin_bloc.dart';
import '../../domain/entities/user_summary.dart';

/// Formulario para crear o editar curso como admin
class CourseFormPage extends StatefulWidget {
  final Course? course; // null = crear, no null = editar

  const CourseFormPage({super.key, this.course});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();

  String? _categoria;
  String? _nivel;
  int? _selectedInstructorId;
  String? _imagenPath;
  File? _imageFile;

  List<UserSummary> _instructors = [];
  bool _loadingInstructors = false;

  @override
  void initState() {
    super.initState();
    _loadInstructors();

    if (widget.course != null) {
      // Modo edición
      final course = widget.course!;
      _tituloController.text = course.titulo;
      _descripcionController.text = course.descripcion;
      _precioController.text = course.precio.toStringAsFixed(0);
      
      // Normalizar categoría para compatibilidad con valores antiguos
      _categoria = _normalizeCategoria(course.categoria);
      _nivel = course.nivel;
      _selectedInstructorId = course.instructor?.id;
    }
  }
  
  /// Normaliza valores de categoría antiguos a los nuevos valores del backend
  String _normalizeCategoria(String categoria) {
    final map = {
      'diseno': 'diseño',
      'desarrollo_personal': 'otros',
    };
    return map[categoria] ?? categoria;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _loadInstructors() async {
    setState(() => _loadingInstructors = true);
    
    // Cargar lista de instructores
    context.read<AdminBloc>().add(const GetUsersEvent(perfil: 'instructor'));
    
    // Esperar a que cargue el estado
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() => _loadingInstructors = false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imagenPath = pickedFile.path;
      });
    }
  }

  void _saveCourse() {
    if (!_formKey.currentState!.validate()) return;

    if (_categoria == null) {
      _showError('Selecciona una categoría');
      return;
    }

    if (_nivel == null) {
      _showError('Selecciona un nivel');
      return;
    }

    if (_selectedInstructorId == null) {
      _showError('Selecciona un instructor');
      return;
    }

    final titulo = _tituloController.text.trim();
    final descripcion = _descripcionController.text.trim();
    final precio = double.tryParse(_precioController.text) ?? 0.0;

    if (widget.course == null) {
      // Crear curso
      context.read<AdminBloc>().add(CreateCourseAsAdminEvent(
            titulo: titulo,
            descripcion: descripcion,
            categoria: _categoria!,
            nivel: _nivel!,
            precio: precio,
            instructorId: _selectedInstructorId!,
            imagenPath: _imagenPath,
          ));
    } else {
      // Actualizar curso
      context.read<AdminBloc>().add(UpdateCourseAsAdminEvent(
            courseId: widget.course!.id,
            titulo: titulo,
            descripcion: descripcion,
            categoria: _categoria,
            nivel: _nivel,
            precio: precio,
            instructorId: _selectedInstructorId,
            imagenPath: _imagenPath,
          ));
    }

    Navigator.pop(context);
    
    final message = widget.course == null
        ? 'Curso creado correctamente'
        : 'Curso actualizado correctamente';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course == null ? 'Crear Curso' : 'Editar Curso'),
        backgroundColor: ThemeConfig.primaryColor,
      ),
      body: BlocListener<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminLoaded && state.users.isNotEmpty) {
            setState(() {
              _instructors = state.users;
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El título es obligatorio';
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
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Categoría
                DropdownButtonFormField<String>(
                  initialValue: _categoria,
                  decoration: const InputDecoration(
                    labelText: 'Categoría *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'programacion', child: Text('Programación')),
                    DropdownMenuItem(value: 'diseño', child: Text('Diseño')),
                    DropdownMenuItem(value: 'marketing', child: Text('Marketing')),
                    DropdownMenuItem(value: 'negocios', child: Text('Negocios')),
                    DropdownMenuItem(value: 'idiomas', child: Text('Idiomas')),
                    DropdownMenuItem(value: 'musica', child: Text('Música')),
                    DropdownMenuItem(value: 'fotografia', child: Text('Fotografía')),
                    DropdownMenuItem(value: 'otros', child: Text('Otros')),
                  ],
                  onChanged: (value) => setState(() => _categoria = value),
                ),
                const SizedBox(height: 16),

                // Nivel
                DropdownButtonFormField<String>(
                  initialValue: _nivel,
                  decoration: const InputDecoration(
                    labelText: 'Nivel *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.bar_chart),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'principiante', child: Text('Principiante')),
                    DropdownMenuItem(value: 'intermedio', child: Text('Intermedio')),
                    DropdownMenuItem(value: 'avanzado', child: Text('Avanzado')),
                  ],
                  onChanged: (value) => setState(() => _nivel = value),
                ),
                const SizedBox(height: 16),

                // Precio
                TextFormField(
                  controller: _precioController,
                  decoration: const InputDecoration(
                    labelText: 'Precio *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El precio es obligatorio';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingresa un precio válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Instructor
                _buildInstructorDropdown(),
                const SizedBox(height: 32),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveCourse,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeConfig.primaryColor,
                        ),
                        child: Text(widget.course == null ? 'Crear' : 'Guardar'),
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

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imagen del Curso',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  )
                : widget.course?.imagen != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(widget.course!.imagen!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Toca para seleccionar imagen'),
                        ],
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructorDropdown() {
    if (_loadingInstructors) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_instructors.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'No hay instructores disponibles',
            style: TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _loadInstructors,
            icon: const Icon(Icons.refresh),
            label: const Text('Recargar'),
          ),
        ],
      );
    }

    // Validar que el instructor seleccionado exista en la lista
    final validInstructorId = _selectedInstructorId != null &&
            _instructors.any((i) => i.id == _selectedInstructorId)
        ? _selectedInstructorId
        : null;

    return DropdownButtonFormField<int>(
      initialValue: validInstructorId,
      decoration: const InputDecoration(
        labelText: 'Instructor *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      items: _instructors.map((instructor) {
        return DropdownMenuItem<int>(
          value: instructor.id,
          child: Text('${instructor.firstName} ${instructor.lastName} (${instructor.username})'),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedInstructorId = value),
    );
  }
}
