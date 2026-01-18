import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../reviews/presentation/bloc/review_bloc.dart';
import '../../../reviews/presentation/bloc/review_event.dart';
import '../../../reviews/presentation/bloc/review_state.dart';
import '../../../reviews/presentation/widgets/rating_display.dart';
import '../../../reviews/presentation/pages/course_reviews_page.dart';

/// Widget reutilizable para mostrar la sección de reseñas del curso
class CourseReviewsSection extends StatelessWidget {
  final int courseId;
  final String courseName;

  const CourseReviewsSection({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReviewBloc>()
        ..add(GetCourseReviewStatsEvent(courseId)),
      child: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          if (state is ReviewsLoaded && state.stats != null) {
            final stats = state.stats!;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reseñas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseReviewsPage(
                                  cursoId: courseId,
                                  cursoTitulo: courseName,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Ver todas'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    RatingDisplay(
                      rating: stats.calificacionPromedio,
                      size: 24,
                      showValue: true,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Basado en ${stats.totalResenas} reseña${stats.totalResenas == 1 ? '' : 's'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
