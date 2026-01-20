import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme_config.dart';
import '../../../courses/domain/entities/course.dart';
import '../bloc/admin_bloc.dart';
import '../widgets/course_card_admin.dart';
import '../widgets/course_filters_admin.dart';
import 'course_form_page.dart';

/// Página de gestión de cursos para administradores
class CoursesManagementPage extends StatefulWidget {
  const CoursesManagementPage({super.key});

  @override
  State<CoursesManagementPage> createState() => _CoursesManagementPageState();
}

class _CoursesManagementPageState extends State<CoursesManagementPage> {
  String? _selectedCategoria;
  String? _selectedNivel;
  bool? _selectedActivo;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    context.read<AdminBloc>().add(GetAllCoursesAdminEvent(
      categoria: _selectedCategoria,
      nivel: _selectedNivel,
      activo: _selectedActivo,
      search: _searchQuery,
    ));
  }

  void _applyFilters({
    String? categoria,
    String? nivel,
    bool? activo,
    String? search,
  }) {
    setState(() {
      _selectedCategoria = categoria;
      _selectedNivel = nivel;
      _selectedActivo = activo;
      _searchQuery = search;
    });

    context.read<AdminBloc>().add(GetAllCoursesAdminEvent(
          categoria: categoria,
          nivel: nivel,
          activo: activo,
          search: search,
        ));
  }

  void _clearFilters() {
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar con gradiente
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Gestión de Cursos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ThemeConfig.primaryColor,
                      ThemeConfig.primaryColor.withOpacity( 0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Filtros
          SliverToBoxAdapter(
            child: CourseFiltersAdmin(
              selectedCategoria: _selectedCategoria,
              selectedNivel: _selectedNivel,
              selectedActivo: _selectedActivo,
              onFiltersChanged: _applyFilters,
              onClearFilters: _clearFilters,
            ),
          ),

          // Contador de cursos
          BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) {
              if (state is AdminLoaded && state.courses.isNotEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.school, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          '${state.courses.length} curso${state.courses.length != 1 ? 's' : ''} encontrado${state.courses.length != 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Todos los cursos del sistema',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),

          // Lista de cursos
          BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) {
              if (state is AdminLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is AdminError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<AdminBloc>().add(const GetAllCoursesAdminEvent());
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is AdminLoaded) {
                final courses = state.courses;

                if (courses.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay cursos disponibles',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Crea tu primer curso',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final course = courses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CourseCardAdmin(
                            course: course,
                            onEdit: () => _navigateToEdit(course),
                            onDelete: () => _confirmDelete(course),
                            onToggleStatus: () => _toggleCourseStatus(course),
                            onViewStats: () => _viewStatistics(course),
                          ),
                        );
                      },
                      childCount: courses.length,
                    ),
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreate,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Curso'),
        backgroundColor: ThemeConfig.primaryColor,
      ),
    );
  }

  void _navigateToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<AdminBloc>(),
          child: const CourseFormPage(),
        ),
      ),
    );
  }

  void _navigateToEdit(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<AdminBloc>(),
          child: CourseFormPage(course: course),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(Course course) async {
    final hasStudents = course.totalEstudiantes > 0;
    final hasModules = course.totalModulos > 0;
    final hasSections = course.totalSecciones > 0;
    final hasContent = hasStudents || hasModules || hasSections;
    
    // Si tiene contenido, mostrar advertencia y solo permitir desactivar
    if (hasContent) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.block, color: Colors.red.shade700),
              const SizedBox(width: 8),
              const Text('No se puede eliminar'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No puedes eliminar "${course.titulo}" porque contiene:',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                if (hasModules || hasSections) ...[
                  _buildWarningItem(
                    icon: Icons.folder_outlined,
                    text: '${course.totalModulos} módulo(s) y ${course.totalSecciones} sección(es)',
                  ),
                  const SizedBox(height: 8),
                ],
                if (hasStudents) ...[
                  _buildWarningItem(
                    icon: Icons.people_outline,
                    text: '${course.totalEstudiantes} estudiante(s) inscrito(s)',
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Para eliminar este curso, primero debes eliminar todo su contenido (módulos, secciones e inscripciones).',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Recomendación: Desactiva el curso en lugar de eliminarlo.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // Desactivar el curso
                context.read<AdminBloc>().add(DeactivateCourseEvent(course.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Desactivando curso...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.visibility_off),
              label: const Text('Desactivar curso'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      );
      return;
    }
    
    // Si no tiene contenido, confirmar eliminación normal
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar curso'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Estás seguro de eliminar "${course.titulo}"?'),
            const SizedBox(height: 12),
            Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<AdminBloc>().add(DeleteCourseAsAdminEvent(course.id));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Eliminando curso...')),
      );

      // Recargar la lista después de eliminar
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _loadCourses();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Curso eliminado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
    } else if (confirmed == 'deactivate' && mounted) {
      context.read<AdminBloc>().add(DeactivateCourseEvent(course.id));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Curso desactivado correctamente')),
      );

      // Recargar la lista después de desactivar
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _loadCourses();
        }
      });
    }
  }

  void _toggleCourseStatus(Course course) {
    if (course.activo) {
      context.read<AdminBloc>().add(DeactivateCourseEvent(course.id));
    } else {
      context.read<AdminBloc>().add(ActivateCourseEvent(course.id));
    }

    final message = course.activo
        ? 'Curso desactivado correctamente'
        : 'Curso activado correctamente';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    // Recargar la lista después de un pequeño delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _loadCourses();
      }
    });
  }

  void _viewStatistics(Course course) {
    // TODO: Implementar vista de estadísticas
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Estadísticas en desarrollo')),
    );
  }

  Widget _buildWarningItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.orange.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
