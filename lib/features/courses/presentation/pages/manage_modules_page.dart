import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/module.dart';
import '../bloc/module_bloc.dart';
import '../bloc/module_event.dart';
import '../bloc/module_state.dart';
import '../widgets/instructor_module_card.dart';
import '../widgets/empty_modules_widget.dart';
import '../widgets/module_form_dialog.dart';

/// Página para gestionar los módulos de un curso
class ManageModulesPage extends StatelessWidget {
  final Course course;

  const ManageModulesPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ModuleBloc>()..add(GetModulesByCourseEvent(course.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Módulos - ${course.titulo}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => _showHelp(context),
              tooltip: 'Ayuda',
            ),
          ],
        ),
        body: BlocConsumer<ModuleBloc, ModuleState>(
          listener: (context, state) {
            if (state is ModuleError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is ModuleCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Módulo creado exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<ModuleBloc>().add(GetModulesByCourseEvent(course.id));
            } else if (state is ModuleUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Módulo actualizado exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<ModuleBloc>().add(GetModulesByCourseEvent(course.id));
            } else if (state is ModuleDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Módulo eliminado exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<ModuleBloc>().add(GetModulesByCourseEvent(course.id));
            }
          },
          builder: (context, state) {
            if (state is ModuleLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ModulesLoaded) {
              if (state.modules.isEmpty) {
                return EmptyModulesWidget(
                  onCreateModule: () => _showCreateModuleDialog(context, 1),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ModuleBloc>().add(GetModulesByCourseEvent(course.id));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.modules.length,
                  itemBuilder: (context, index) {
                    final module = state.modules[index];
                    return InstructorModuleCard(
                      module: module,
                      onTap: () {
                        // TODO: Navegar a gestión de secciones
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gestión de secciones próximamente...'),
                          ),
                        );
                      },
                      onEdit: () => _showEditModuleDialog(context, module),
                      onDelete: () => _showDeleteConfirmation(context, module),
                    );
                  },
                ),
              );
            }

            return EmptyModulesWidget(
              onCreateModule: () => _showCreateModuleDialog(context, 1),
            );
          },
        ),
        floatingActionButton: BlocBuilder<ModuleBloc, ModuleState>(
          builder: (context, state) {
            final nextOrder = state is ModulesLoaded ? state.modules.length + 1 : 1;
            return FloatingActionButton.extended(
              onPressed: () => _showCreateModuleDialog(context, nextOrder),
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Módulo'),
            );
          },
        ),
      ),
    );
  }

  void _showCreateModuleDialog(BuildContext context, int orden) async {
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (dialogContext) => ModuleFormDialog(orden: orden),
    );

    if (result != null && context.mounted) {
      context.read<ModuleBloc>().add(
            CreateModuleEvent(
              cursoId: course.id,
              titulo: result['titulo']!,
              descripcion: result['descripcion'],
              orden: orden,
            ),
          );
    }
  }

  void _showEditModuleDialog(BuildContext context, Module module) async {
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (dialogContext) => ModuleFormDialog(
        initialTitulo: module.titulo,
        initialDescripcion: module.descripcion,
        orden: module.orden,
        isEditing: true,
      ),
    );

    if (result != null && context.mounted) {
      context.read<ModuleBloc>().add(
            UpdateModuleEvent(
              moduleId: module.id,
              titulo: result['titulo']!,
              descripcion: result['descripcion'],
              orden: module.orden,
            ),
          );
    }
  }

  void _showDeleteConfirmation(BuildContext context, Module module) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Módulo'),
        content: Text(
          '¿Estás seguro de eliminar "${module.titulo}"?\n\nEsta acción no se puede deshacer y eliminará todas las secciones asociadas.',
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
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }


  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda - Gestión de Módulos'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem(
                '📚 Módulos',
                'Los módulos son las unidades principales que organizan tu curso.',
              ),
              _buildHelpItem(
                '📄 Secciones',
                'Cada módulo contiene secciones con el contenido específico.',
              ),
              _buildHelpItem(
                '🎥 Videos',
                'Puedes subir videos o enlazar desde YouTube/Vimeo.',
              ),
              _buildHelpItem(
                '📎 Archivos',
                'Adjunta PDFs, presentaciones o recursos descargables.',
              ),
              _buildHelpItem(
                '↕️ Orden',
                'Arrastra para reordenar módulos y secciones.',
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

