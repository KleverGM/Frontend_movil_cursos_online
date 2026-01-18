import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/course_detail.dart';
import '../../domain/entities/section.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/section_content_view.dart';
import '../widgets/section_navigation_bar.dart';
import '../widgets/section_video_player.dart';

/// Página para visualizar el contenido de un curso
class CourseContentPage extends StatefulWidget {
  final CourseDetail courseDetail;

  const CourseContentPage({
    super.key,
    required this.courseDetail,
  });

  @override
  State<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> {
  int _currentSectionIndex = 0;
  bool _isCompleting = false;
  final Set<int> _completedSections = {};

  List<Section> get allSections {
    final sections = <Section>[];
    for (final module in widget.courseDetail.modulos) {
      sections.addAll(module.secciones);
    }
    return sections;
  }

  Section? get currentSection {
    if (allSections.isEmpty) return null;
    if (_currentSectionIndex >= allSections.length) return null;
    return allSections[_currentSectionIndex];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CourseBloc>(),
      child: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is SectionCompletedSuccess) {
            setState(() {
              _isCompleting = false;
              _completedSections.add(state.sectionId);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Sección completada!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is CourseError) {
            setState(() {
              _isCompleting = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.courseDetail.course.titulo),
            actions: [
              // Progreso del curso
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${_completedSections.length}/${allSections.length}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: allSections.isEmpty
              ? _buildEmptyState()
              : _buildContent(),
          bottomNavigationBar: allSections.isEmpty
              ? null
              : SectionNavigationBar(
                  sections: allSections,
                  currentIndex: _currentSectionIndex,
                  onSectionChanged: (index) {
                    setState(() {
                      _currentSectionIndex = index;
                    });
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No hay contenido disponible',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final section = currentSection;
    if (section == null) return _buildEmptyState();

    return Column(
      children: [
        // Video player si la sección tiene video
        if (section.tieneVideo)
          SectionVideoPlayer(videoUrl: section.videoUrl!),
        // Contenido de la sección
        Expanded(
          child: SectionContentView(
            section: section,
            isCompleting: _isCompleting,
            onMarkCompleted: () => _markSectionCompleted(section.id),
          ),
        ),
      ],
    );
  }

  void _markSectionCompleted(int sectionId) {
    // Evitar múltiples llamadas
    if (_completedSections.contains(sectionId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta sección ya está completada'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isCompleting = true;
    });

    context.read<CourseBloc>().add(
          MarkSectionCompletedEvent(sectionId),
        );
  }
}
