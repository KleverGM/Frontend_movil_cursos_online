import 'package:flutter/material.dart';
import '../widgets/ratings_distribution_chart.dart';

/// Widget para la sección de distribución de ratings
class RatingsSectionWidget extends StatelessWidget {
  final int totalResenas;
  final Map<int, int> distribucionRatings;

  const RatingsSectionWidget({
    super.key,
    required this.totalResenas,
    required this.distribucionRatings,
  });

  @override
  Widget build(BuildContext context) {
    if (totalResenas == 0) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.star_border, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 8),
              Text(
                'Aún no hay calificaciones',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return RatingsDistributionChart(
      ratingsCount: distribucionRatings,
    );
  }
}
