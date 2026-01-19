import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/module.dart';
import '../../domain/entities/section.dart';
import '../bloc/section_bloc.dart';
import '../bloc/section_event.dart';
import '../bloc/section_state.dart';
import '../widgets/instructor_section_card.dart';
import '../widgets/empty_sections_widget.dart';
import '../widgets/section_form_dialog.dart';

/// Página para gestionar las secciones de un módulo
class ManageSectionsPage extends StatelessWidget {
  final Module module;

  const ManageSectionsPage({
    super.key,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SectionBloc>()..add(GetSectionsByModuleEvent(module.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Módulo ${module.orden}: ${module.titulo}'),
              Text(
                'Secciones',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => _showHelp(context),
              tooltip: 'Ayuda',
            ),
          ],
        ),
        body: BlocConsumer<SectionBloc, SectionState>(
          listener: (context, state) {
            if (state is SectionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is SectionCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sección creada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<SectionBloc>().add(GetSectionsByModuleEvent(module.id));
            } else if (state is SectionUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sección actualizada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<SectionBloc>().add(GetSectionsByModuleEvent(module.id));
            } else if (state is SectionDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sección eliminada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<SectionBloc>().add(GetSectionsByModuleEvent(module.id));
            }
          },
          builder: (context, state) {
            if (state is SectionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SectionsLoaded) {
              if (state.sections.isEmpty) {
                return EmptySectionsWidget(
                  onCreateSection: () => _showCreateSectionDialog(context, 1),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<SectionBloc>().add(GetSectionsByModuleEvent(module.id));
                },
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.sections.length,
                  onReorder: (oldIndex, newIndex) {
                    _onReorderSections(context, state.sections, oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final section = state.sections[index];
                    return InstructorSectionCard(
                      key: ValueKey(section.id),
                      section: section,
                      onTap: () => _showEditSectionDialog(context, section),
                      onEdit: () => _showEditSectionDialog(context, section),
                      onDelete: () => _showDeleteConfirmation(context, section),
                    );
                  },
                ),
              );
            }

            return EmptySectionsWidget(
              onCreateSection: () => _showCreateSectionDialog(context, 1),
            );
          },
        ),
        floatingActionButton: BlocBuilder<SectionBloc, SectionState>(
          builder: (context, state) {
            final nextOrder = state is SectionsLoaded ? state.sections.length + 1 : 1;
            return FloatingActionButton.extended(
              onPressed: () => _showCreateSectionDialog(context, nextOrder),
              icon: const Icon(Icons.add),
              label: const Text('Nueva Sección'),
            );
          },
        ),
      ),
    );
  }

  void _showCreateSectionDialog(BuildContext context, int orden) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => SectionFormDialog(orden: orden),
    );

    if (result != null && context.mounted) {
      context.read<SectionBloc>().add(
            CreateSectionEvent(
              moduloId: module.id,
              titulo: result['titulo'],
              contenido: result['contenido'],
              videoUrl: result['videoUrl'],
              archivoPath: result['archivo']?.path, // Obtener path del File
              orden: orden,
              duracionMinutos: result['duracionMinutos'],
              esPreview: result['esPreview'],
            ),
          );
    }
  }

  void _showEditSectionDialog(BuildContext context, Section section) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => SectionFormDialog(
        initialTitulo: section.titulo,
        initialContenido: section.contenido,
        initialVideoUrl: section.videoUrl,
        initialArchivo: section.archivo,
        initialDuracionMinutos: section.duracionMinutos,
        initialEsPreview: section.esPreview,
        orden: section.orden,
        isEditing: true,
      ),
    );

    if (result != null && context.mounted) {
      context.read<SectionBloc>().add(
            UpdateSectionEvent(
              sectionId: section.id,
              titulo: result['titulo'],
              contenido: result['contenido'],
              videoUrl: result['videoUrl'],
              archivoPath: result['archivo']?.path, // Obtener path del File
              orden: section.orden,
              duracionMinutos: result['duracionMinutos'],
              esPreview: result['esPreview'],
            ),
          );
    }
  }

  void _showDeleteConfirmation(BuildContext context, Section section) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Sección'),
        content: Text(
          '¿Estás seguro de eliminar "${section.titulo}"?\n\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SectionBloc>().add(DeleteSectionEvent(section.id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _onReorderSections(
    BuildContext context,
    List<Section> sections,
    int oldIndex,
    int newIndex,
  ) {
    // Ajustar newIndex si movemos hacia abajo
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // Reordenar la lista localmente
    final updatedSections = List<Section>.from(sections);
    final movedSection = updatedSections.removeAt(oldIndex);
    updatedSections.insert(newIndex, movedSection);

    // Actualizar el orden de cada sección afectada
    for (int i = 0; i < updatedSections.length; i++) {
      if (updatedSections[i].orden != i + 1) {
        context.read<SectionBloc>().add(
              UpdateSectionEvent(
                sectionId: updatedSections[i].id,
                titulo: updatedSections[i].titulo,
                contenido: updatedSections[i].contenido,
                videoUrl: updatedSections[i].videoUrl,
                orden: i + 1,
                duracionMinutos: updatedSections[i].duracionMinutos,
                esPreview: updatedSections[i].esPreview,
              ),
            );
      }
    }

    // Recargar después de un pequeño delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.read<SectionBloc>().add(GetSectionsByModuleEvent(module.id));
      }
    });
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda - Gestión de Secciones'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem(
                '📄 Secciones',
                'Cada sección es una lección individual dentro del módulo.',
              ),
              _buildHelpItem(
                '🎥 Videos',
                'Agrega URLs de videos de YouTube, Vimeo u otras plataformas.',
              ),
              _buildHelpItem(
                '⏱️ Duración',
                'Indica la duración estimada en minutos para cada sección.',
              ),
              _buildHelpItem(
                '👁️ Preview',
                'Marca secciones como preview para que usuarios no inscritos puedan verlas.',
              ),
              _buildHelpItem(
                '↕️ Orden',
                'Mantén presionado y arrastra una sección para reordenarla.',
              ),
              _buildHelpItem(
                '📎 Archivos',
                'Próximamente: adjunta PDFs, presentaciones y más.',
              ),
            ],
          ),
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

  Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
