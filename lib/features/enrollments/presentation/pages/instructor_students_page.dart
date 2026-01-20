import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/enrollment_bloc.dart';
import '../bloc/enrollment_event.dart';
import '../bloc/enrollment_state.dart';
import '../widgets/enrollment_card.dart';
import '../widgets/enrollment_stats_card.dart';

/// Página para ver estudiantes del instructor
class InstructorStudentsPage extends StatefulWidget {
  final int? cursoId; // Opcional: filtrar por curso específico

  const InstructorStudentsPage({
    super.key,
    this.cursoId,
  });

  @override
  State<InstructorStudentsPage> createState() => _InstructorStudentsPageState();
}

class _InstructorStudentsPageState extends State<InstructorStudentsPage> {
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, active, completed, inactive

  @override
  void initState() {
    super.initState();
    _loadEnrollments();
  }

  void _loadEnrollments() {
    if (widget.cursoId != null) {
      context.read<EnrollmentBloc>().add(
            GetEnrollmentsByCourseEvent(widget.cursoId!),
          );
    } else {
      context.read<EnrollmentBloc>().add(const GetInstructorEnrollmentsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cursoId != null ? 'Estudiantes del Curso' : 'Mis Estudiantes'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEnrollments,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda y filtros
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Buscar estudiante...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Todos',
                        selected: _filterStatus == 'all',
                        onSelected: () => setState(() => _filterStatus = 'all'),
                      ),
                      _FilterChip(
                        label: 'Activos',
                        selected: _filterStatus == 'active',
                        onSelected: () => setState(() => _filterStatus = 'active'),
                      ),
                      _FilterChip(
                        label: 'Completados',
                        selected: _filterStatus == 'completed',
                        onSelected: () => setState(() => _filterStatus = 'completed'),
                      ),
                      _FilterChip(
                        label: 'Inactivos',
                        selected: _filterStatus == 'inactive',
                        onSelected: () => setState(() => _filterStatus = 'inactive'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Contenido
          Expanded(
            child: BlocBuilder<EnrollmentBloc, EnrollmentState>(
              builder: (context, state) {
                if (state is EnrollmentLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is EnrollmentError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar estudiantes',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  );
                }

                if (state is EnrollmentLoaded) {
                  // Filtrar inscripciones
                  var filteredEnrollments = state.enrollments.where((e) {
                    // Filtro de búsqueda
                    if (_searchQuery.isNotEmpty) {
                      final matchesName = e.usuarioNombre.toLowerCase().contains(_searchQuery);
                      final matchesEmail = e.usuarioEmail?.toLowerCase().contains(_searchQuery) ?? false;
                      final matchesCourse = e.cursoTitulo.toLowerCase().contains(_searchQuery);
                      if (!matchesName && !matchesEmail && !matchesCourse) {
                        return false;
                      }
                    }

                    // Filtro de estado
                    switch (_filterStatus) {
                      case 'active':
                        return !e.completado && e.progreso > 0;
                      case 'completed':
                        return e.completado;
                      case 'inactive':
                        return !e.completado && e.progreso == 0;
                      default:
                        return true;
                    }
                  }).toList();

                  // Ordenar por fecha de inscripción (más recientes primero)
                  filteredEnrollments.sort((a, b) => b.fechaInscripcion.compareTo(a.fechaInscripcion));

                  if (filteredEnrollments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty || _filterStatus != 'all'
                                ? 'No se encontraron estudiantes'
                                : 'No hay estudiantes inscritos',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _loadEnrollments(),
                    child: ListView(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      children: [
                        // Estadísticas
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: EnrollmentStatsCard(stats: state.stats),
                        ),
                        const SizedBox(height: 8),

                        // Contador de resultados
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            '${filteredEnrollments.length} estudiante${filteredEnrollments.length != 1 ? 's' : ''}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),

                        // Lista de estudiantes
                        ...filteredEnrollments.map(
                          (enrollment) => EnrollmentCard(
                            enrollment: enrollment,
                            onTap: () {
                              // TODO: Navegar a detalle del estudiante
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        backgroundColor: Colors.white,
        selectedColor: Colors.white,
        checkmarkColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: selected ? Theme.of(context).primaryColor : Colors.grey[700],
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: selected ? Theme.of(context).primaryColor : Colors.grey[300]!,
          width: selected ? 2 : 1,
        ),
      ),
    );
  }
}
