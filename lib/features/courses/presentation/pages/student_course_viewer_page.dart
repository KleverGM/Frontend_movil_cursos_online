import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/module_bloc.dart';
import '../bloc/module_event.dart';
import '../bloc/module_state.dart';
import '../bloc/section_bloc.dart';
import '../bloc/section_event.dart';
import '../bloc/section_state.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart' hide MarkSectionCompletedEvent;
import '../bloc/course_state.dart' hide SectionCompletedSuccess;
import '../widgets/student_section_item.dart';

/// Página para que los estudiantes visualicen el contenido del curso
class StudentCourseViewerPage extends StatefulWidget {
  final int courseId;

  const StudentCourseViewerPage({
    super.key,
    required this.courseId,
  });

  @override
  State<StudentCourseViewerPage> createState() =>
      _StudentCourseViewerPageState();
}

class _StudentCourseViewerPageState extends State<StudentCourseViewerPage> {
  final Map<int, bool> _expandedModules = {};
  final Map<int, List<dynamic>> _moduleSections = {};
  bool _isLoadingSections = false;

  @override
  void initState() {
    super.initState();
    _loadCourseDetail();
  }

  void _loadCourseDetail() {
    context.read<CourseBloc>().add(GetCourseDetailEvent(widget.courseId));
  }

  void _loadModuleSections(int moduleId) {
    if (_moduleSections.containsKey(moduleId)) return;

    setState(() {
      _isLoadingSections = true;
    });

    context.read<SectionBloc>().add(GetSectionsByModuleEvent(moduleId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<SectionBloc, SectionState>(
            listener: (context, state) {
              if (state is SectionListLoaded) {
                setState(() {
                  _moduleSections[state.moduleId] = state.sections;
                  _isLoadingSections = false;
                });
              } else if (state is SectionError) {
                setState(() {
                  _isLoadingSections = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is SectionCompletedSuccess) {
                // Mostrar mensaje de éxito
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sección completada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Recargar detalle del curso para actualizar progreso
                _loadCourseDetail();
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
              
              // Expandir primer módulo por defecto
              if (_expandedModules.isEmpty && detail.modulos.isNotEmpty) {
                _expandedModules[detail.modulos[0].id] = true;
                _loadModuleSections(detail.modulos[0].id);
              }

              return CustomScrollView(
                slivers: [
                  _buildAppBar(detail),
                  SliverToBoxAdapter(
                    child: _buildCourseInfo(detail),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final module = detail.modulos[index];
                        final isExpanded = _expandedModules[module.id] ?? false;
                        final sections = _moduleSections[module.id];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
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
                                trailing: Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
                              ),
                              if (isExpanded) ...[
                                const Divider(height: 1),
                                if (sections == null)
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else if (sections.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      'No hay secciones en este módulo',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: sections.length,
                                    separatorBuilder: (context, index) =>
                                        const Divider(height: 1, indent: 16),
                                    itemBuilder: (context, sectionIndex) {
                                      return StudentSectionItem(
                                        section: sections[sectionIndex],
                                        onCompleted: () {
                                          context.read<SectionBloc>().add(
                                                MarkSectionCompletedEvent(
                                                  sections[sectionIndex].id,
                                                ),
                                              );
                                        },
                                      );
                                    },
                                  ),
                              ],
                            ],
                          ),
                        );
                      },
                      childCount: detail.modulos.length,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),
                ],
              );
            }

            return const Center(
              child: Text('Carga el curso para visualizar'),
            );
          },
        ),
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
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (detail.course.imagen != null &&
                detail.course.imagen!.isNotEmpty)
              Image.network(
                detail.course.imagen!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
            else
              _buildPlaceholderImage(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.school,
          size: 80,
          color: Colors.white54,
        ),
      ),
    );
  }

  Widget _buildCourseInfo(dynamic detail) {
    final progreso = detail.progreso ?? 0.0;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu Progreso',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${progreso.toInt()}%',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              CircularProgressIndicator(
                value: progreso / 100,
                strokeWidth: 8,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progreso / 100,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatChip(
                Icons.video_library,
                '${detail.modulos.length} Módulos',
                Colors.purple,
              ),
              const SizedBox(width: 8),
              _buildStatChip(
                Icons.list_alt,
                'Secciones',
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
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
              fontSize: 12,
              color: Color.lerp(color, Colors.black, 0.3),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar el curso',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCourseDetail,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  int? _getModuleIdForSection(int sectionId) {
    for (var entry in _moduleSections.entries) {
      if (entry.value.any((section) => section.id == sectionId)) {
        return entry.key;
      }
    }
    return null;
  }
}
