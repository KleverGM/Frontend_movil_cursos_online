import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/module.dart';
import '../../domain/entities/section.dart';
import '../bloc/module_bloc.dart';
import '../bloc/module_event.dart';
import '../bloc/module_state.dart';
import '../bloc/section_bloc.dart';
import '../bloc/section_event.dart';
import '../bloc/section_state.dart';
import '../widgets/preview_section_item.dart';

/// Página de vista previa del curso para instructores
class CoursePreviewPage extends StatelessWidget {
  final int courseId;
  final String courseTitle;

  const CoursePreviewPage({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ModuleBloc>()
            ..add(GetModulesByCourseEvent(courseId)),
        ),
        BlocProvider(
          create: (context) => getIt<SectionBloc>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vista Previa del Curso'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                _showPreviewInfo(context);
              },
              tooltip: 'Información',
            ),
          ],
        ),
        body: _CoursePreviewContent(
          courseId: courseId,
          courseTitle: courseTitle,
        ),
      ),
    );
  }

  void _showPreviewInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('Vista Previa'),
          ],
        ),
        content: const Text(
          'Esta es una vista previa de cómo los estudiantes verán tu curso. '
          'Puedes navegar por los módulos y secciones para verificar el contenido.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}

class _CoursePreviewContent extends StatelessWidget {
  final int courseId;
  final String courseTitle;

  const _CoursePreviewContent({
    required this.courseId,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModuleBloc, ModuleState>(
      builder: (context, state) {
        if (state is ModuleLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ModuleError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Volver'),
                ),
              ],
            ),
          );
        }

        if (state is ModulesLoaded) {
          if (state.modules.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.video_library_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay módulos en este curso',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega módulos y secciones para comenzar',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del curso
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courseTitle,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.school, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${state.modules.length} módulo${state.modules.length != 1 ? 's' : ''}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.video_library, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${_totalSections(state.modules)} lección${_totalSections(state.modules) != 1 ? 'es' : ''}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Lista de módulos
                Text(
                  'Contenido del Curso',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                ...state.modules.asMap().entries.map((entry) {
                  final index = entry.key;
                  final module = entry.value;
                  return _ModulePreviewCard(
                    module: module,
                    index: index + 1,
                  );
                }),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  int _totalSections(List<Module> modules) {
    return modules.fold(0, (sum, module) => sum + (module.totalSecciones ?? 0));
  }
}

class _ModulePreviewCard extends StatefulWidget {
  final Module module;
  final int index;

  const _ModulePreviewCard({
    required this.module,
    required this.index,
  });

  @override
  State<_ModulePreviewCard> createState() => _ModulePreviewCardState();
}

class _ModulePreviewCardState extends State<_ModulePreviewCard> {
  bool _isExpanded = false;
  List<Section>? _sections;
  bool _isLoadingSections = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Cargar secciones automáticamente si el módulo es el primero
    if (widget.index == 1) {
      _loadSections();
      _isExpanded = true;
    }
  }

  Future<void> _loadSections() async {
    if (_sections != null) return; // Ya cargadas

    setState(() {
      _isLoadingSections = true;
      _error = null;
    });

    context.read<SectionBloc>().add(
          GetSectionsByModuleEvent(widget.module.id),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SectionBloc, SectionState>(
      listener: (context, state) {
        if (state is SectionsLoaded) {
          setState(() {
            _sections = state.sections;
            _isLoadingSections = false;
          });
        } else if (state is SectionError) {
          setState(() {
            _error = state.message;
            _isLoadingSections = false;
          });
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                '${widget.index}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              widget.module.titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${widget.module.totalSecciones ?? 0} lección${widget.module.totalSecciones != 1 ? 'es' : ''}',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            initiallyExpanded: _isExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _isExpanded = expanded;
              });
              if (expanded && _sections == null && !_isLoadingSections) {
                _loadSections();
              }
            },
            children: [
              if (_isLoadingSections)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (_sections != null)
                ..._sections!.asMap().entries.map((entry) {
                  final sectionIndex = entry.key;
                  final section = entry.value;
                  return PreviewSectionItem(
                    section: section,
                    index: sectionIndex + 1,
                  );
                }).toList()
              else
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No hay secciones en este módulo',
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
