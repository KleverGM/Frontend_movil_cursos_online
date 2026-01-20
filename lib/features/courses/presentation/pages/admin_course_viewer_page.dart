import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../admin/presentation/bloc/admin_bloc.dart';
import '../../domain/entities/module.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart' as course_events;
import '../bloc/course_state.dart';
import '../bloc/module_bloc.dart';
import '../bloc/module_event.dart';
import '../bloc/module_state.dart';
import '../bloc/section_bloc.dart';
import '../bloc/section_event.dart';
import '../bloc/section_state.dart';
import '../widgets/add_module_dialog.dart';
import '../widgets/add_section_dialog.dart';
import '../widgets/edit_course_dialog.dart';
import '../widgets/edit_module_dialog.dart';
import '../widgets/edit_section_dialog.dart';
import 'course_stats_page.dart';
import 'student_course_viewer_page.dart';

/// Página para que los administradores gestionen el contenido del curso
class AdminCourseViewerPage extends StatefulWidget {
  final int courseId;

  const AdminCourseViewerPage({
    super.key,
    required this.courseId,
  });

  @override
  State<AdminCourseViewerPage> createState() => _AdminCourseViewerPageState();
}

class _AdminCourseViewerPageState extends State<AdminCourseViewerPage> {
  final Map<int, bool> _expandedModules = {};
  final Map<int, List<dynamic>> _moduleSections = {};

  @override
  void initState() {
    super.initState();
    _loadCourseDetail();
  }

  void _loadCourseDetail() {
    context.read<CourseBloc>().add(course_events.GetCourseDetailEvent(widget.courseId));
  }

  void _loadModuleSections(int moduleId) {
    if (_moduleSections.containsKey(moduleId)) return;
    context.read<SectionBloc>().add(GetSectionsByModuleEvent(moduleId));
  }

  void _toggleCourseStatus(dynamic course, bool newStatus) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(newStatus ? 'Publicar Curso' : 'Despublicar Curso'),
        content: Text(
          newStatus
              ? '¿Está seguro de publicar el curso? Los estudiantes podrán inscribirse y acceder al contenido.'
              : '¿Está seguro de despublicar el curso? Los estudiantes no podrán inscribirse ni ver nuevo contenido.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Activar o desactivar el curso
              if (newStatus) {
                context.read<AdminBloc>().add(ActivateCourseEvent(course.id));
              } else {
                context.read<AdminBloc>().add(DeactivateCourseEvent(course.id));
              }
              
              // Pequeño delay y recargar
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) {
                  _loadCourseDetail();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        newStatus 
                            ? 'Curso publicado exitosamente'
                            : 'Curso despublicado exitosamente',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus ? Colors.green : Colors.orange,
            ),
            child: Text(newStatus ? 'Publicar' : 'Despublicar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ModuleBloc, ModuleState>(
            listener: (context, state) {
              if (state is ModuleCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Módulo creado exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadCourseDetail();
              } else if (state is ModuleUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Módulo actualizado exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadCourseDetail();
              } else if (state is ModuleDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Módulo eliminado exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadCourseDetail();
              } else if (state is ModuleError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<SectionBloc, SectionState>(
            listener: (context, state) {
              if (state is SectionListLoaded) {
                setState(() {
                  _moduleSections[state.moduleId] = state.sections;
                });
              } else if (state is SectionCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sección creada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.read<SectionBloc>().add(GetSectionsByModuleEvent(state.section.moduloId));
              } else if (state is SectionUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sección actualizada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.read<SectionBloc>().add(GetSectionsByModuleEvent(state.section.moduloId));
              } else if (state is SectionDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sección eliminada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is SectionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CourseError) {
              return _buildError(state.message);
            }

            if (state is CourseDetailLoaded) {
              final detail = state.courseDetail;

              return CustomScrollView(
                slivers: [
                  _buildAppBar(detail),
                  SliverToBoxAdapter(
                    child: _buildAdminActions(detail),
                  ),
                  SliverToBoxAdapter(
                    child: _buildCourseInfo(detail),
                  ),
                  SliverToBoxAdapter(
                    child: _buildModulesHeader(),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final module = detail.modulos[index];
                        final isExpanded = _expandedModules[module.id] ?? false;
                        final sections = _moduleSections[module.id];

                        return _buildModuleCard(module, isExpanded, sections, index);
                      },
                      childCount: detail.modulos.length,
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: Text('Seleccione un curso para ver su contenido'),
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is! CourseDetailLoaded) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton.extended(
            onPressed: () async {
              final detail = state.courseDetail;
              
              // Calcular el siguiente orden disponible
              // Encuentra el orden máximo y suma 1
              int nextOrder = 1;
              if (detail.modulos.isNotEmpty) {
                final maxOrder = detail.modulos
                    .map((m) => m.orden)
                    .reduce((a, b) => a > b ? a : b);
                nextOrder = maxOrder + 1;
              }

              final result = await showDialog(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: context.read<ModuleBloc>(),
                  child: AddModuleDialog(
                    courseId: widget.courseId,
                    nextOrder: nextOrder,
                  ),
                ),
              );

              if (result == true && mounted) {
                // Pequeño delay para que el backend procese
                await Future.delayed(const Duration(milliseconds: 500));
                
                if (mounted) {
                  _loadCourseDetail();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Módulo creado exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Agregar Módulo'),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(dynamic detail) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          detail.course.titulo,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3.0,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            detail.course.imagen != null
                ? Image.network(
                    detail.course.imagen!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.blue,
                        child: const Icon(
                          Icons.school,
                          size: 80,
                          color: Colors.white,
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.blue,
                    child: const Icon(
                      Icons.school,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity( 0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActions(dynamic detail) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Botón Vista Previa
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentCourseViewerPage(
                      courseId: widget.courseId,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.preview),
              label: const Text('Vista Previa como Estudiante'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Estado del curso (activo/inactivo)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SwitchListTile(
              value: detail.course.activo,
              onChanged: (value) {
                _toggleCourseStatus(detail.course, value);
              },
              title: Text(
                detail.course.activo ? 'Curso Publicado' : 'Curso No Publicado',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                detail.course.activo 
                    ? 'Los estudiantes pueden inscribirse y ver el contenido'
                    : 'El curso no es visible para los estudiantes',
                style: const TextStyle(fontSize: 12),
              ),
              secondary: Icon(
                detail.course.activo ? Icons.visibility : Icons.visibility_off,
                color: detail.course.activo ? Colors.green : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<AdminBloc>(),
                        child: EditCourseDialog(
                          course: detail.course,
                        ),
                      ),
                    );
                    
                    if (result == true && mounted) {
                      // Pequeño delay para asegurar que el backend procesó la actualización
                      await Future.delayed(const Duration(milliseconds: 500));
                      
                      // Recargar el curso después de editar
                      if (mounted) {
                        _loadCourseDetail();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Curso actualizado exitosamente'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Editar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseStatsPage(
                          course: detail.course,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.analytics, size: 18),
                  label: const Text('Estadísticas'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo(dynamic detail) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildInfoChip(
                Icons.category,
                detail.course.categoria ?? 'Sin categoría',
                Colors.purple,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                Icons.signal_cellular_alt,
                detail.course.nivel ?? 'Sin nivel',
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Descripción',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            detail.course.descripcion ?? 'Sin descripción',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  Icons.library_books,
                  '${detail.modulos.length}',
                  'Módulos',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  Icons.people,
                  '${detail.course.totalEstudiantes}',
                  'Estudiantes',
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  Icons.attach_money,
                  '\$${detail.course.precio}',
                  'Precio',
                  Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModulesHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.library_books, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            'Contenido del Curso',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(dynamic module, bool isExpanded, List<dynamic>? sections, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _expandedModules[module.id] = !isExpanded;
                if (!isExpanded) {
                  _loadModuleSections(module.id);
                }
              });
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              module.titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              module.descripcion ?? 'Sin descripción',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditModuleDialog(module),
                  tooltip: 'Editar módulo',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _confirmDeleteModule(module),
                  tooltip: 'Eliminar módulo',
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            if (sections == null)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (sections.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'No hay secciones en este módulo',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => _showAddSectionDialog(module),
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar primera sección'),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sections.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, indent: 16),
                    itemBuilder: (context, sectionIndex) {
                      final section = sections[sectionIndex];
                      return _buildSectionItem(section, module.titulo);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline, color: Colors.blue),
                    title: const Text(
                      'Agregar nueva sección',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () => _showAddSectionDialog(module, sections.length),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionItem(dynamic section, String moduleName) {
    IconData sectionIcon;
    Color iconColor;
    String tipoContenido;

    // Determinar tipo de contenido basado en las propiedades disponibles
    if (section.tieneVideo) {
      sectionIcon = Icons.play_circle_outline;
      iconColor = Colors.red;
      tipoContenido = 'Video';
    } else if (section.tieneArchivo) {
      sectionIcon = Icons.attach_file;
      iconColor = Colors.blue;
      tipoContenido = 'Archivo';
    } else {
      sectionIcon = Icons.article_outlined;
      iconColor = Colors.grey;
      tipoContenido = 'Lectura';
    }

    return ListTile(
      leading: Icon(sectionIcon, color: iconColor),
      title: Text(section.titulo),
      subtitle: Text(
        '$tipoContenido • ${section.duracionMinutos} min',
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            _showEditSectionDialog(section, moduleName);
          } else if (value == 'delete') {
            _confirmDeleteSection(section);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 20),
                SizedBox(width: 8),
                Text('Editar'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 20, color: Colors.red),
                SizedBox(width: 8),
                Text('Eliminar', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSection(dynamic section) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Está seguro de eliminar la sección "${section.titulo}"?'),
            const SizedBox(height: 8),
            const Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Guardar el moduleId antes de eliminar
              final moduleId = section.moduloId;
              context.read<SectionBloc>().add(DeleteSectionEvent(section.id, section.moduloId));
              // Recargar después de un pequeño delay
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  context.read<SectionBloc>().add(GetSectionsByModuleEvent(moduleId));
                }
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity( 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showAddSectionDialog(Module module, [int? existingSectionsCount]) {
    final nextOrder = (existingSectionsCount ?? 0) + 1;
    
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<SectionBloc>(),
        child: AddSectionDialog(
          moduleId: module.id,
          moduleName: module.titulo,
          nextOrder: nextOrder,
        ),
      ),
    );
  }

  void _showEditModuleDialog(Module module) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ModuleBloc>(),
        child: EditModuleDialog(module: module),
      ),
    );
  }

  void _confirmDeleteModule(Module module) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Está seguro de eliminar el módulo "${module.titulo}"?'),
            const SizedBox(height: 8),
            const Text(
              'Todas las secciones dentro de este módulo también se eliminarán.',
              style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ModuleBloc>().add(DeleteModuleEvent(module.id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar Módulo'),
          ),
        ],
      ),
    );
  }

  void _showEditSectionDialog(dynamic section, String moduleName) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<SectionBloc>(),
        child: EditSectionDialog(
          section: section,
          moduleName: moduleName,
          moduleId: section.moduloId,
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar el curso',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadCourseDetail,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
