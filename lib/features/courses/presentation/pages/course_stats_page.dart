import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/course_stats.dart';
import '../../domain/usecases/get_course_stats_usecase.dart';
import '../widgets/course_stats_header_widget.dart';
import '../widgets/stats_cards_row_widget.dart';
import '../widgets/ratings_section_widget.dart';
import '../widgets/student_progress_section_widget.dart';
import '../widgets/recent_activity_section_widget.dart';
import '../widgets/error_state_widget.dart';

/// Página de estadísticas detalladas de un curso específico
class CourseStatsPage extends StatefulWidget {
  final Course course;

  const CourseStatsPage({
    super.key,
    required this.course,
  });

  @override
  State<CourseStatsPage> createState() => _CourseStatsPageState();
}

class _CourseStatsPageState extends State<CourseStatsPage> {
  final _getCourseStatsUseCase = getIt<GetCourseStatsUseCase>();
  CourseStats? _stats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _getCourseStatsUseCase(widget.course.id);
    
    result.fold(
      (failure) => setState(() {
        _error = failure.message;
        _isLoading = false;
      }),
      (stats) => setState(() {
        _stats = stats;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas del Curso'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorStateWidget(
                  errorMessage: _error,
                  onRetry: _loadStats,
                )
              : RefreshIndicator(
                  onRefresh: _loadStats,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CourseStatsHeaderWidget(
                          course: widget.course,
                          totalEstudiantes: _stats?.totalEstudiantes ?? 0,
                        ),
                        const SizedBox(height: 24),
                        StatsCardsRowWidget(
                          totalEstudiantes: _stats?.totalEstudiantes ?? 0,
                          ratingPromedio: _stats?.ratingPromedio ?? 0,
                          ingresosTotales: _stats?.ingresosTotales ?? 0,
                        ),
                        const SizedBox(height: 24),
                        RatingsSectionWidget(
                          totalResenas: _stats?.totalResenas ?? 0,
                          distribucionRatings: _stats?.distribucionRatings ?? {},
                        ),
                        const SizedBox(height: 24),
                        StudentProgressSectionWidget(
                          totalEstudiantes: _stats?.totalEstudiantes ?? 0,
                          estudiantesActivos: _stats?.estudiantesActivos ?? 0,
                          estudiantesCompletados: _stats?.estudiantesCompletados ?? 0,
                        ),
                        const SizedBox(height: 24),
                        RecentActivitySectionWidget(
                          nuevosEstudiantesSemana: _stats?.nuevosEstudiantesSemana ?? 0,
                          nuevasResenasSemana: _stats?.nuevasResenasSemana ?? 0,
                          completadosSemana: _stats?.completadosSemana ?? 0,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
