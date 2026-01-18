import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/enrollment_detail.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/enrollment_card.dart';
import '../widgets/student_stats_card.dart';

/// Página para ver las inscripciones de los cursos del instructor
class CourseEnrollmentsPage extends StatefulWidget {
  final int? courseId;
  final String? courseTitle;

  const CourseEnrollmentsPage({
    super.key,
    this.courseId,
    this.courseTitle,
  });

  @override
  State<CourseEnrollmentsPage> createState() => _CourseEnrollmentsPageState();
}

class _CourseEnrollmentsPageState extends State<CourseEnrollmentsPage> {
  String _filterStatus = 'todos';
  List<EnrollmentDetail> _allEnrollments = [];
  List<EnrollmentDetail> _filteredEnrollments = [];

  @override
  void initState() {
    super.initState();
    _loadEnrollments();
  }

  void _loadEnrollments() {
    context.read<CourseBloc>().add(
          GetInstructorEnrollmentsEvent(courseId: widget.courseId),
        );
  }

  void _filterEnrollments(List<EnrollmentDetail> enrollments) {
    setState(() {
      _allEnrollments = enrollments;
      
      switch (_filterStatus) {
        case 'completados':
          _filteredEnrollments = enrollments.where((e) => e.completado).toList();
          break;
        case 'en_progreso':
          _filteredEnrollments = enrollments.where((e) => e.enProgreso).toList();
          break;
        case 'no_iniciado':
          _filteredEnrollments = enrollments.where((e) => e.noIniciado).toList();
          break;
        default:
          _filteredEnrollments = enrollments;
      }
      
      // Ordenar por progreso descendente
      _filteredEnrollments.sort((a, b) => b.progreso.compareTo(a.progreso));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.courseTitle != null
              ? 'Estudiantes - ${widget.courseTitle}'
              : 'Mis Estudiantes',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEnrollments,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: BlocConsumer<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is InstructorEnrollmentsLoaded) {
            _filterEnrollments(state.enrollments);
            
            if (_allEnrollments.isEmpty) {
              return _buildEmptyState();
            }

            return _buildEnrollmentsList();
          }

          if (state is CourseError) {
            return _buildErrorState(state.message);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEnrollmentsList() {
    return RefreshIndicator(
      onRefresh: () async {
        _loadEnrollments();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: CustomScrollView(
        slivers: [
          // Estadísticas
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StudentStatsCard(enrollments: _allEnrollments),
            ),
          ),

          // Filtros
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildFilterChips(),
            ),
          ),

          // Contador
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                '${_filteredEnrollments.length} ${_filteredEnrollments.length == 1 ? "estudiante" : "estudiantes"}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),

          // Lista de inscripciones
          if (_filteredEnrollments.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.filter_list_off,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay estudiantes con este filtro',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final enrollment = _filteredEnrollments[index];
                    return EnrollmentCard(
                      enrollment: enrollment,
                      onTap: () => _showEnrollmentDetail(enrollment),
                    );
                  },
                  childCount: _filteredEnrollments.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            label: 'Todos',
            value: 'todos',
            icon: Icons.people,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Completados',
            value: 'completados',
            icon: Icons.check_circle,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'En Progreso',
            value: 'en_progreso',
            icon: Icons.play_circle,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'No Iniciado',
            value: 'no_iniciado',
            icon: Icons.circle_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
          _filterEnrollments(_allEnrollments);
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              'No hay estudiantes inscritos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.courseId != null
                  ? 'Aún no hay estudiantes inscritos en este curso'
                  : 'Aún no hay estudiantes inscritos en tus cursos',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
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
            Text(
              'Error al cargar estudiantes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
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
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadEnrollments,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEnrollmentDetail(EnrollmentDetail enrollment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Avatar y nombre
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        enrollment.usuarioNombre[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            enrollment.usuarioNombre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            enrollment.usuarioEmail,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                const Divider(),
                const SizedBox(height: 16),
                
                // Información del curso
                _buildDetailRow(
                  icon: Icons.school,
                  label: 'Curso',
                  value: enrollment.cursoTitulo,
                ),
                const SizedBox(height: 12),
                
                // Progreso
                _buildDetailRow(
                  icon: Icons.trending_up,
                  label: 'Progreso',
                  value: '${enrollment.progresoEntero}%',
                ),
                const SizedBox(height: 12),
                
                // Estado
                _buildDetailRow(
                  icon: Icons.info_outline,
                  label: 'Estado',
                  value: enrollment.estadoTexto,
                ),
                const SizedBox(height: 12),
                
                // Fecha de inscripción
                _buildDetailRow(
                  icon: Icons.calendar_today,
                  label: 'Fecha de inscripción',
                  value: '${enrollment.fechaInscripcion.day}/${enrollment.fechaInscripcion.month}/${enrollment.fechaInscripcion.year}',
                ),
                
                if (enrollment.completado && enrollment.fechaCompletado != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.check_circle,
                    label: 'Fecha de completación',
                    value: '${enrollment.fechaCompletado!.day}/${enrollment.fechaCompletado!.month}/${enrollment.fechaCompletado!.year}',
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
