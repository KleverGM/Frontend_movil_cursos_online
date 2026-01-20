import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../bloc/global_stats_bloc.dart';
import '../widgets/admin_course_card.dart';
import 'global_stats_page.dart';

/// Página de administración de todos los cursos de la plataforma
class AdminCoursesPage extends StatefulWidget {
  const AdminCoursesPage({super.key});

  @override
  State<AdminCoursesPage> createState() => _AdminCoursesPageState();
}

class _AdminCoursesPageState extends State<AdminCoursesPage> with WidgetsBindingObserver {
  String _filterStatus = 'todos';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCourses();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Recargar cuando la app vuelve al frente
      _loadCourses();
    }
  }

  void _loadCourses() {
    // Los admin ven todos los cursos (activos e inactivos)
    context.read<CourseBloc>().add(const GetCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Cursos'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GlobalStatsPage(
                    bloc: getIt<GlobalStatsBloc>(),
                  ),
                ),
              );
            },
            tooltip: 'Estadísticas Globales',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCourses,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CourseError) {
            return _buildError(state.message);
          }

          if (state is CoursesLoaded) {
            final filteredCourses = _filterAndSearchCourses(state.courses);

            return Column(
              children: [
                _buildSearchBar(),
                _buildFilterChips(state.courses),
                _buildStatsRow(state.courses),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _loadCourses();
                    },
                    child: filteredCourses.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredCourses.length,
                            itemBuilder: (context, index) {
                              return AdminCourseCard(
                                course: filteredCourses[index],
                                onCourseUpdated: _loadCourses,
                              );
                            },
                          ),
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: Text('Carga los cursos de la plataforma'),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TextField(
        controller: _searchController,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Buscar cursos...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildFilterChips(List<dynamic> allCourses) {
    final activeCourses = allCourses.where((c) => c.activo).length;
    final inactiveCourses = allCourses.where((c) => !c.activo).length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              'todos',
              'Todos (${allCourses.length})',
              Icons.list,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              'activos',
              'Activos ($activeCourses)',
              Icons.check_circle,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              'inactivos',
              'Inactivos ($inactiveCourses)',
              Icons.block,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildStatsRow(List<dynamic> allCourses) {
    final totalStudents = allCourses.fold<int>(
      0,
      (int sum, course) => sum + (course.totalEstudiantes as int),
    );
    final avgRating = allCourses.isEmpty
        ? 0.0
        : allCourses.fold<double>(
              0,
              (sum, course) => sum + course.calificacionPromedio,
            ) /
            allCourses.length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.school,
            allCourses.length.toString(),
            'Cursos',
            Colors.blue,
          ),
          _buildStatItem(
            Icons.people,
            totalStudents.toString(),
            'Estudiantes',
            Colors.green,
          ),
          _buildStatItem(
            Icons.star,
            avgRating.toStringAsFixed(1),
            'Rating Promedio',
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
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

  List<dynamic> _filterAndSearchCourses(List<dynamic> courses) {
    var filtered = courses;

    // Aplicar filtro de estado
    switch (_filterStatus) {
      case 'activos':
        filtered = filtered.where((c) => c.activo).toList();
        break;
      case 'inactivos':
        filtered = filtered.where((c) => !c.activo).toList();
        break;
      default:
        break;
    }

    // Aplicar búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((course) {
        return course.titulo.toLowerCase().contains(_searchQuery) ||
            course.descripcion.toLowerCase().contains(_searchQuery) ||
            course.instructorNombre.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Ordenar: activos primero
    filtered.sort((a, b) {
      if (a.activo == b.activo) {
        return b.id.compareTo(a.id);
      }
      return a.activo ? -1 : 1;
    });

    return filtered;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty
                  ? Icons.search_off
                  : Icons.school_outlined,
              size: 120,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No se encontraron cursos'
                  : 'No hay cursos en la plataforma',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Intenta con otros términos de búsqueda'
                  : 'Los instructores pueden crear cursos desde su panel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
              'Error al cargar cursos',
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
              onPressed: _loadCourses,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
