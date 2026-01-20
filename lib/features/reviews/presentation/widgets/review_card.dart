import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/review.dart';
import 'rating_display.dart';

/// Tarjeta para mostrar una reseña
class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onMarkHelpful;
  final VoidCallback? onDelete;
  final VoidCallback? onReply;
  final bool isMyReview;
  final bool canReply;

  const ReviewCard({
    super.key,
    required this.review,
    this.onMarkHelpful,
    this.onDelete,
    this.onReply,
    this.isMyReview = false,
    this.canReply = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con nombre y calificación
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity( 0.1),
                  child: Text(
                    review.estudianteNombre[0].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.estudianteNombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          RatingDisplay(
                            rating: review.calificacion.toDouble(),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(review.fechaCreacion),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isMyReview && onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    color: Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Comentario
            Text(
              review.comentario,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            // Respuesta del instructor
            if (review.respuestaInstructor != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity( 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.school, size: 16, color: Colors.blue[700]),
                        const SizedBox(width: 4),
                        Text(
                          'Respuesta del instructor',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.respuestaInstructor!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            // Botón de útil y responder
            Row(
              children: [
                if (!isMyReview && onMarkHelpful != null)
                  TextButton.icon(
                    onPressed: review.marcadoUtilPorMi ? null : onMarkHelpful,
                    icon: Icon(
                      review.marcadoUtilPorMi
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                      size: 16,
                    ),
                    label: Text(
                      'Útil (${review.utilesCount})',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                if (canReply && onReply != null && review.respuestaInstructor == null) ...[
                  const Spacer(),
                  TextButton.icon(
                    onPressed: onReply,
                    icon: const Icon(Icons.reply, size: 16),
                    label: const Text(
                      'Responder',
                      style: TextStyle(fontSize: 13),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
