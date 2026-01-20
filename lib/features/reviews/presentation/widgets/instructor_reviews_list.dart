import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/review.dart';
import 'instructor_review_card.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';

/// Lista de reseñas para instructores con manejo de respuestas
class InstructorReviewsList extends StatelessWidget {
  final List<Review> reviews;
  final VoidCallback? onRefresh;

  const InstructorReviewsList({
    super.key,
    required this.reviews,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return InstructorReviewCard(
          review: review,
          onReply: () => _showReplyDialog(context, review),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay reseñas aún',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Las reseñas de tus cursos aparecerán aquí',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, Review review) {
    // Si ya tiene respuesta, mostrar la respuesta actual
    if (review.respuestaInstructorActual != null && review.respuestaInstructorActual!.isNotEmpty) {
      _showCurrentReplyDialog(context, review);
      return;
    }

    // Mostrar diálogo para crear nueva respuesta
    _showNewReplyDialog(context, review);
  }

  void _showCurrentReplyDialog(BuildContext context, Review review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Respuesta actual'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tu respuesta:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Text(review.respuestaInstructorActual!),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showNewReplyDialog(context, review);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  void _showNewReplyDialog(BuildContext context, Review review) {
    final TextEditingController controller = TextEditingController(
      text: review.respuestaInstructorActual,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Responder reseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reseña de ${review.estudianteNombre}:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(review.comentario),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Escribe tu respuesta...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<ReviewBloc>().add(
                  ReplyToReviewEvent(
                    reviewId: review.id,
                    respuesta: controller.text.trim(),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Enviar respuesta'),
          ),
        ],
      ),
    );
  }
}
