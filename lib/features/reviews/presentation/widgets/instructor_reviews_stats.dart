import 'package:flutter/material.dart';
import '../../domain/entities/review.dart';

/// Widget que muestra estadísticas de reseñas para instructores
class InstructorReviewsStats extends StatelessWidget {
  final List<Review> reviews;

  const InstructorReviewsStats({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final totalReviews = reviews.length;
    final averageRating = totalReviews > 0
        ? reviews.map((r) => r.calificacion).reduce((a, b) => a + b) / totalReviews
        : 0.0;
    final pendingResponses = reviews
        .where((r) => r.respuestaInstructorActual == null || r.respuestaInstructorActual!.isEmpty)
        .length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Reseñas',
                value: totalReviews.toString(),
                icon: Icons.star_outline,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Calificación Promedio',
                value: averageRating.toStringAsFixed(1),
                icon: Icons.star,
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Pendientes',
                value: pendingResponses.toString(),
                icon: Icons.schedule,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}