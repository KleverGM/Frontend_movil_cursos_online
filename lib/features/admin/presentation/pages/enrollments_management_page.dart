import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_bloc.dart';
import '../widgets/enrollment_card_admin.dart';
import '../widgets/enrollment_edit_dialog.dart';
import '../widgets/enrollment_filters_admin.dart';
import '../widgets/enrollment_form_dialog.dart';

class EnrollmentsManagementPage extends StatefulWidget {
  const EnrollmentsManagementPage({super.key});

  @override
  State<EnrollmentsManagementPage> createState() => _EnrollmentsManagementPageState();
}

class _EnrollmentsManagementPageState extends State<EnrollmentsManagementPage> {
  int? _selectedCursoId;
  int? _selectedUsuarioId;
  bool? _selectedCompletado;

  @override
  void initState() {
    super.initState();
    _loadEnrollments();
  }

  void _loadEnrollments() {
    context.read<AdminBloc>().add(GetAllEnrollmentsAdminEvent(
      cursoId: _selectedCursoId,
      usuarioId: _selectedUsuarioId,
      completado: _selectedCompletado,
    ));
  }

  void _applyFilters({int? cursoId, int? usuarioId, bool? completado}) {
    setState(() {
      _selectedCursoId = cursoId;
      _selectedUsuarioId = usuarioId;
      _selectedCompletado = completado;
    });
    _loadEnrollments();
  }

  void _clearFilters() {
    setState(() {
      _selectedCursoId = null;
      _selectedUsuarioId = null;
      _selectedCompletado = null;
    });
    _loadEnrollments();
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<AdminBloc>(),
        child: const EnrollmentFormDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Inscripciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (bottomSheetContext) => BlocProvider.value(
                  value: context.read<AdminBloc>(),
                  child: EnrollmentFiltersAdmin(
                    selectedCursoId: _selectedCursoId,
                    selectedUsuarioId: _selectedUsuarioId,
                    selectedCompletado: _selectedCompletado,
                    onApplyFilters: _applyFilters,
                    onClearFilters: _clearFilters,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEnrollments,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        icon: const Icon(Icons.person_add),
        label: const Text('Inscribir Estudiante'),
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            // Recargar después de un error de creación/eliminación
            _loadEnrollments();
          }
        },
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminLoaded) {
            final enrollments = state.enrollments;

            if (enrollments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay inscripciones',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _hasActiveFilters()
                          ? 'No se encontraron inscripciones con los filtros aplicados'
                          : 'Aún no hay estudiantes inscritos en cursos',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _loadEnrollments(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: enrollments.length,
                itemBuilder: (context, index) {
                  final enrollment = enrollments[index];
                  return EnrollmentCardAdmin(
                    enrollment: enrollment,
                    onEdit: () {
                      _showEditDialog(enrollment);
                    },
                    onDelete: () {
                      _showDeleteConfirmation(enrollment.id);
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedCursoId != null ||
        _selectedUsuarioId != null ||
        _selectedCompletado != null;
  }

  void _showEditDialog(enrollment) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<AdminBloc>(),
        child: EnrollmentEditDialog(enrollment: enrollment),
      ),
    );
  }

  void _showDeleteConfirmation(int enrollmentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancelar Inscripción'),
        content: const Text(
          '¿Estás seguro de que deseas cancelar esta inscripción?\n\n'
          'El estudiante perderá acceso al curso y todo su progreso.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AdminBloc>().add(
                DeleteEnrollmentAsAdminEvent(enrollmentId),
              );
              Navigator.pop(dialogContext);
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
