import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../notices/presentation/pages/notices_page.dart';
import '../../../notices/presentation/bloc/notice_bloc.dart';
import '../../../enrollments/presentation/pages/instructor_students_page.dart';
import '../../../enrollments/presentation/bloc/enrollment_bloc.dart';
import '../../../reviews/presentation/bloc/review_bloc.dart';
import '../../../reviews/presentation/bloc/review_event.dart';
import '../../../reviews/presentation/bloc/review_state.dart';
import '../../../reviews/domain/entities/review.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/states/common_states.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/instructor_dashboard_stats.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/instructor_course_card.dart';
import '../widgets/enhanced_stats_widgets.dart';
import '../widgets/students_bar_chart.dart';
import '../widgets/ratings_distribution_chart.dart';
import 'course_form_page.dart';

/// Dashboard para instructores
class InstructorDashboardPage extends StatefulWidget {
  const InstructorDashboardPage({super.key});

  @override
  State<InstructorDashboardPage> createState() => _InstructorDashboardPageState();
}

class _InstructorDashboardPageState extends State<InstructorDashboardPage> {
  List<Course>? _myCourses;
  List<Review>? _myReviews;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    context.read<CourseBloc>().add(const GetMyCoursesEvent());
    context.read<ReviewBloc>().add(const GetMyReviewsEvent());
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
                  builder: (context) => BlocProvider(
                    create: (context) => getIt<EnrollmentBloc>(),
                    child: const InstructorStudentsPage(),
                  ),
                ),
              );
            },
            tooltip: 'Mis Estudiantes',
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CourseBloc, CourseState>(
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
              } else if (state is CourseDeletedSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Curso desactivado correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadMyCourses();
              } else if (state is CourseActivatedSuccess || state is CourseDeactivatedSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state is CourseActivatedSuccess 
                        ? 'Curso activado correctamente'
                        : 'Curso desactivado correctamente',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadMyCourses();
              } else if (state is CourseError) {
                setState(() {
                  _isLoading = false;
                  _errorMessage = state.message;
                });
              }
            },
          ),
          BlocListener<ReviewBloc, ReviewState>(
            listener: (context, state) {
              if (state is MyReviewsLoaded) {
                setState(() {
                  _myReviews = state.reviews;
                });
              }
            },
          ),
        ],
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
    // Ordenar: cursos activos primero, inactivos al final
    final sortedCourses = List<Course>.from(courses)
      ..sort((a, b) {
        if (a.activo == b.activo) return 0;
        return a.activo ? -1 : 1;
      });
    
    final stats = _calculateEnhancedStats(courses, _myReviews ?? []);

    return RefreshIndicator(
      onRefresh: () async {
        _loadDashboardData();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estadísticas principales mejoradas
            _buildEnhancedStatsSection(context, stats),
            const SizedBox(height: 24),

            // Métricas rápidas
            if (_myReviews != null) ...[
              _buildQuickMetricsSection(context, stats),
              const SizedBox(height: 24),
            ],

            // Top cursos
            if (stats.topCursos.isNotEmpty) ...[
              _buildTopCoursesSection(context, stats.topCursos),
              const SizedBox(height: 24),
            ],

            // Gráficos
            if (courses.isNotEmpty) ...[
              StudentsBarChart(
                courseStudents: _getCourseStudentsMap(courses),
              ),
              const SizedBox(height: 16),
              RatingsDistributionChart(
                ratingsCount: stats.distribucionRatings,
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

            if (sortedCourses.isEmpty)
              _buildEmptyState()
            else
              ...sortedCourses.map((course) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InstructorCourseCard(course: course),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const EmptyStateWidget(
      icon: Icons.school_outlined,
      title: 'No tienes cursos creados',
      message: 'Crea tu primer curso usando el botón de abajo',
    );
  }

  Map<String, int> _getCourseStudentsMap(List<Course> courses) {
    final map = <String, int>{};
    for (final course in courses.take(5)) {
      final shortTitle = course.titulo.length > 15
          ? '${course.titulo.substring(0, 15)}...'
          : course.titulo;
      map[shortTitle] = course.totalEstudiantes;
    }
    return map;
  }

  InstructorDashboardStats _calculateEnhancedStats(List<Course> courses, List<Review> reviews) {
    // Stats de cursos
    final cursosActivos = courses.where((c) => c.activo).length;
    final cursosInactivos = courses.length - cursosActivos;

    // Stats de estudiantes
    int totalEstudiantes = 0;
    double ingresos = 0;
    int totalModulos = 0;
    int totalSecciones = 0;

    for (var course in courses) {
      totalEstudiantes += course.totalEstudiantes;
      ingresos += (course.precio * course.totalEstudiantes);
      totalModulos += course.totalModulos;
      totalSecciones += course.totalSecciones;
    }

    // Stats de reseñas
    final totalResenas = reviews.length;
    double sumaRatings = 0;
    int resenasSinResponder = 0;
    final distribucionRatings = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (var review in reviews) {
      sumaRatings += review.calificacion.toDouble();
      distribucionRatings[review.calificacion] = 
          (distribucionRatings[review.calificacion] ?? 0) + 1;
      
      if (review.respuestaInstructorActual == null) {
        resenasSinResponder++;
      }
    }

    final calificacionPromedio = totalResenas > 0 ? sumaRatings / totalResenas : 0.0;

    // Top cursos por estudiantes
    final sortedCourses = List<Course>.from(courses)
      ..sort((a, b) => b.totalEstudiantes.compareTo(a.totalEstudiantes));

    final topCursos = sortedCourses.take(5).map((course) {
      // Contar reseñas de este curso
      final courseReviews = reviews.where((r) => r.cursoId == course.id).toList();
      final courseRating = courseReviews.isNotEmpty
          ? courseReviews.fold<double>(0, (sum, r) => sum + r.calificacion) / courseReviews.length
          : 0.0;

      return CoursePerformance(
        cursoId: course.id,
        titulo: course.titulo,
        totalEstudiantes: course.totalEstudiantes,
        calificacionPromedio: courseRating,
        totalResenas: courseReviews.length,
        tasaCompletado: 0.0, // No tenemos este dato aún
        ingresos: course.precio * course.totalEstudiantes,
      );
    }).toList();

    return InstructorDashboardStats(
      totalCursos: courses.length,
      cursosActivos: cursosActivos,
      cursosInactivos: cursosInactivos,
      totalEstudiantes: totalEstudiantes,
      totalResenas: totalResenas,
      calificacionPromedio: calificacionPromedio,
      resenasSinResponder: resenasSinResponder,
      distribucionRatings: distribucionRatings,
      ingresosEstimados: ingresos,
      ingresosMesActual: ingresos * 0.15, // Estimado 15% este mes
      tasaCompletado: 0.0,
      seccionesCreadas: totalSecciones,
      modulosCreados: totalModulos,
      topCursos: topCursos,
      ultimaActualizacion: DateTime.now(),
    );
  }

  Widget _buildEnhancedStatsSection(BuildContext context, InstructorDashboardStats stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: EnhancedStatsCard(
                icon: Icons.school,
                label: 'Total Cursos',
                value: stats.totalCursos.toString(),
                color: Colors.blue,
                subtitle: '${stats.cursosActivos} activos',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: EnhancedStatsCard(
                icon: Icons.people,
                label: 'Estudiantes',
                value: stats.totalEstudiantes.toString(),
                color: Colors.green,
                subtitle: '${stats.cursosActivos} cursos',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: EnhancedStatsCard(
                icon: Icons.star,
                label: 'Calificación',
                value: stats.calificacionPromedio > 0
                    ? stats.calificacionPromedio.toStringAsFixed(1)
                    : 'N/A',
                color: Colors.amber,
                subtitle: '${stats.totalResenas} reseñas',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: EnhancedStatsCard(
                icon: Icons.attach_money,
                label: 'Ingresos Est.',
                value: '\$${(stats.ingresosEstimados / 1000).toStringAsFixed(1)}k',
                color: Colors.purple,
                subtitle: 'Total acumulado',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickMetricsSection(BuildContext context, InstructorDashboardStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Métricas Adicionales',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickMetricsRow(
                label: 'Sin responder',
                value: stats.resenasSinResponder.toString(),
                icon: Icons.chat_bubble_outline,
                color: stats.resenasSinResponder > 0 ? Colors.orange : Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickMetricsRow(
                label: 'Módulos creados',
                value: stats.modulosCreados.toString(),
                icon: Icons.folder_open,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopCoursesSection(BuildContext context, List<CoursePerformance> topCursos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cursos Destacados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Scroll automaticamente a la sección de cursos
              },
              child: const Text('Ver todos'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...topCursos.take(3).map((course) => TopCourseCard(
          titulo: course.titulo,
          estudiantes: course.totalEstudiantes,
          rating: course.calificacionPromedio,
          resenas: course.totalResenas,
          onTap: () {
            // Navegar al detalle del curso si es necesario
          },
        )),
      ],
    );
  }
}
