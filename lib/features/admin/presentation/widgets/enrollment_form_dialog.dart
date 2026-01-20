import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_bloc.dart';
import '../../../courses/domain/entities/course.dart';
import '../../domain/entities/user_summary.dart';

class EnrollmentFormDialog extends StatefulWidget {
  const EnrollmentFormDialog({super.key});

  @override
  State<EnrollmentFormDialog> createState() => _EnrollmentFormDialogState();
}

class _EnrollmentFormDialogState extends State<EnrollmentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedCursoId;
  int? _selectedUsuarioId;
  
  List<Course> _courses = [];
  List<UserSummary> _students = [];
  bool _loadingData = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loadingData = true);
    
    // Cargar cursos y estudiantes
    context.read<AdminBloc>().add(const GetAllCoursesAdminEvent());
    context.read<AdminBloc>().add(const GetUsersEvent(perfil: 'estudiante'));
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() => _loadingData = false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCursoId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecciona un curso'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      if (_selectedUsuarioId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecciona un estudiante'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      context.read<AdminBloc>().add(
        CreateEnrollmentAsAdminEvent(
          cursoId: _selectedCursoId!,
          usuarioId: _selectedUsuarioId!,
        ),
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inscripción creada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Inscribir Estudiante'),
      content: BlocListener<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminLoaded) {
            setState(() {
              if (state.courses.isNotEmpty) {
                _courses = state.courses;
              }
              if (state.users.isNotEmpty) {
                _students = state.users;
              }
            });
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Inscribe manualmente a un estudiante en un curso.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                
                // Dropdown de Cursos
                _buildCursoDropdown(),
                const SizedBox(height: 16),
                
                // Dropdown de Estudiantes
                _buildEstudianteDropdown(),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity( 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity( 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Esta acción inscribirá inmediatamente al estudiante en el curso.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _loadingData ? null : _submit,
          child: const Text('Inscribir'),
        ),
      ],
    );
  }

  Widget _buildCursoDropdown() {
    if (_loadingData || _courses.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Curso *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.school),
            ),
          ),
          const SizedBox(height: 8),
          if (_loadingData)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              children: [
                const Text(
                  'No hay cursos disponibles',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Recargar', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
        ],
      );
    }

    return DropdownButtonFormField<int>(
      value: _selectedCursoId,
      decoration: const InputDecoration(
        labelText: 'Curso *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.school),
        helperText: 'Selecciona el curso',
      ),
      items: _courses.map((curso) {
        return DropdownMenuItem<int>(
          value: curso.id,
          child: Text(
            curso.titulo,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedCursoId = value),
      validator: (value) {
        if (value == null) {
          return 'Selecciona un curso';
        }
        return null;
      },
    );
  }

  Widget _buildEstudianteDropdown() {
    if (_loadingData || _students.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Estudiante *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 8),
          if (_loadingData)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              children: [
                const Text(
                  'No hay estudiantes disponibles',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Recargar', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
        ],
      );
    }

    return DropdownButtonFormField<int>(
      value: _selectedUsuarioId,
      decoration: const InputDecoration(
        labelText: 'Estudiante *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
        helperText: 'Selecciona el estudiante a inscribir',
      ),
      items: _students.map((student) {
        return DropdownMenuItem<int>(
          value: student.id,
          child: Text(
            '${student.firstName} ${student.lastName} (${student.username})',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedUsuarioId = value),
      validator: (value) {
        if (value == null) {
          return 'Selecciona un estudiante';
        }
        return null;
      },
    );
  }
}
