import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../notices/presentation/pages/notices_page.dart';
import '../../../notices/presentation/bloc/notice_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/course.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/instructor_course_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/students_bar_chart.dart';
import '../widgets/ratings_distribution_chart.dart';
import 'course_enrollments_page.dart';
import 'course_form_page.dart';

/// Dashboard para instructores
class InstructorDashboardPage extends StatefulWidget {
  const InstructorDashboardPage({super.key});

  @override
  State<InstructorDashboardPage> createState() => _InstructorDashboardPageState();
}

class _InstructorDashboardPageState extends State<InstructorDashboardPage> {
  List<Course>? _myCourses;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMyCourses();
  }

  void _loadMyCourses() {
    context.read<CourseBloc>().add(const GetMyCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Instructor'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => getIt<NoticeBloc>(),
                    child: const NoticesPage(),
                  ),
                ),
              );
            },
            tooltip: 'Avisos',
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CourseEnrollmentsPage(),
                ),
              );
            },
            tooltip: 'Ver todos los estudiantes',
          ),
        ],
      ),
      body: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseLoading) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          } else if (state is MyCoursesLoaded) {
            setState(() {
              _myCourses = state.courses;
              _isLoading = false;
              _errorMessage = null;
            });
          } else if (state is CourseError) {
            setState(() {
              _isLoading = false;
              _errorMessage = state.message;
            });
          }
        },
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CourseFormPage(),
            ),
          );
          
          // Si se creó un curso exitosamente, recargar la lista
          if (result == true) {
            _loadMyCourses();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Crear Curso'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _myCourses == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _myCourses == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMyCourses,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_myCourses == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return _buildDashboardContent(context, _myCourses!);
  }

  Widget _buildDashboardContent(BuildContext context, List<Course> courses) {
    final stats = _calculateStats(courses);

    return RefreshIndicator(
      onRefresh: () async {
        _loadMyCourses();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estadísticas
            _buildStatsSection(context, stats),
            const SizedBox(height: 24),

            // Gráficos
            if (courses.isNotEmpty) ...[
              StudentsBarChart(
                courseStudents: _getCourseStudentsMap(courses),
              ),
              const SizedBox(height: 16),
              RatingsDistributionChart(
                ratingsCount: stats['ratingsDistribution'] ?? {},
              ),
              const SizedBox(height: 24),
            ],

            // Mis cursos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mis Cursos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${courses.length} ${courses.length == 1 ? "curso" : "cursos"}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (courses.isEmpty)
              _buildEmptyState()
            else
              ...courses.map((course) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InstructorCourseCard(course: course),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, Map<String, dynamic> stats) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.school,
                    label: 'Cursos',
                    value: stats['totalCursos'].toString(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.people,
                    label: 'Estudiantes',
                    value: stats['totalEstudiantes'].toString(),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.star,
                    label: 'Calificación',
                    value: stats['calificacionPromedio'] > 0
                        ? stats['calificacionPromedio'].toStringAsFixed(1)
                        : 'N/A',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.attach_money,
                    label: 'Ingresos',
                    value: '\$${stats['ingresos'].toStringAsFixed(0)}',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.school_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes cursos creados',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crea tu primer curso usando el botón de abajo',
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

  Map<String, int> _getCourseStudentsMap(List<Course> courses) {
    final map = <String, int>{};
    for (final course in courses.take(5)) {
      final shortTitle = course.titulo.length > 15
          ? '${course.titulo.substring(0, 15)}...'
          : course.titulo;
      map[shortTitle] = course.totalEstudiantes ?? 0;
    }
    return map;
  }

  Map<String, dynamic> _calculateStats(List<Course> courses) {
    int totalEstudiantes = 0;
    double sumaCalificaciones = 0;
    int cursosConCalificacion = 0;
    double ingresos = 0;

    for (var course in courses) {
      totalEstudiantes += course.totalEstudiantes ?? 0;
      ingresos += (course.precio * (course.totalEstudiantes ?? 0));
      
      // TODO: Obtener calificación promedio de cada curso
      // Por ahora dejamos esto pendiente hasta tener el endpoint
    }

    // Simular distribución de ratings (puedes obtener datos reales del backend)
    final ratingsDistribution = <int, int>{
      5: (totalEstudiantes * 0.4).toInt(),
      4: (totalEstudiantes * 0.3).toInt(),
      3: (totalEstudiantes * 0.2).toInt(),
      2: (totalEstudiantes * 0.07).toInt(),
      1: (totalEstudiantes * 0.03).toInt(),
    };

    return {
      'totalCursos': courses.length,
      'totalEstudiantes': totalEstudiantes,
      'calificacionPromedio': cursosConCalificacion > 0 
          ? sumaCalificaciones / cursosConCalificacion 
          : 0.0,
      'ingresos': ingresos,
      'ratingsDistribution': ratingsDistribution,
    };
  }
}
