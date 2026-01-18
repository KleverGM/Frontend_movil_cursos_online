import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/review.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';
import '../bloc/review_state.dart';
import '../widgets/rating_display.dart';
import '../widgets/review_card.dart';
import 'create_review_dialog.dart';

/// Página para mostrar las reseñas de un curso
class CourseReviewsPage extends StatelessWidget {
  final int cursoId;
  final String cursoTitulo;
  final bool canReview;

  const CourseReviewsPage({
    super.key,
    required this.cursoId,
    required this.cursoTitulo,
    this.canReview = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReviewBloc>()
        ..add(GetCourseReviewsEvent(cursoId))
        ..add(GetCourseReviewStatsEvent(cursoId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reseñas'),
        ),
        body: BlocConsumer<ReviewBloc, ReviewState>(
          listener: (context, state) {
            if (state is ReviewCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Reseña publicada exitosamente!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Recargar reseñas
              context.read<ReviewBloc>()
                ..add(GetCourseReviewsEvent(cursoId))
                ..add(GetCourseReviewStatsEvent(cursoId));
            } else if (state is ReviewMarkedHelpful) {
              // Recargar reseñas para ver el cambio
              context.read<ReviewBloc>().add(GetCourseReviewsEvent(cursoId));
            } else if (state is ReviewError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ReviewLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReviewsLoaded) {
              return _buildContent(context, state.reviews, state.stats);
            }

            return const Center(child: Text('No se pudieron cargar las reseñas'));
          },
        ),
        floatingActionButton: canReview
            ? Builder(
                builder: (context) => FloatingActionButton.extended(
                  onPressed: () => _showCreateReviewDialog(context),
                  icon: const Icon(Icons.rate_review),
                  label: const Text('Escribir reseña'),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Review> reviews, stats) {
    return Column(
      children: [
        // Estadísticas
        if (stats != null) _buildStatsHeader(context, stats),
        // Lista de reseñas
        Expanded(
          child: reviews.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return ReviewCard(
                      review: review,
                      onMarkHelpful: () {
                        context.read<ReviewBloc>().add(
                              MarkReviewHelpfulEvent(review.id),
                            );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatsHeader(BuildContext context, stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                stats.calificacionPromedio.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/ 5',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RatingDisplay(
            rating: stats.calificacionPromedio,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            '${stats.totalResenas} ${stats.totalResenas == 1 ? "reseña" : "reseñas"}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Aún no hay reseñas',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            '¡Sé el primero en compartir tu opinión!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showCreateReviewDialog(BuildContext context) {
    final reviewBloc = context.read<ReviewBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => CreateReviewDialog(
        cursoId: cursoId,
        cursoTitulo: cursoTitulo,
        reviewBloc: reviewBloc,
      ),
    );
  }
}
