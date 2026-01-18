import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Widget para mostrar distribución de calificaciones de cursos
class RatingsDistributionChart extends StatelessWidget {
  final Map<int, int> ratingsCount; // {5: 10, 4: 5, 3: 2, 2: 1, 1: 0}

  const RatingsDistributionChart({
    super.key,
    required this.ratingsCount,
  });

  @override
  Widget build(BuildContext context) {
    final totalReviews = ratingsCount.values.fold<int>(0, (sum, count) => sum + count);
    
    if (totalReviews == 0) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Distribución de Calificaciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Icon(Icons.star_outline, size: 60, color: Colors.grey[300]),
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

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribución de Calificaciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$totalReviews reseña${totalReviews != 1 ? "s" : ""} totales',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            
            // Barras horizontales
            ...List.generate(5, (index) {
              final stars = 5 - index;
              final count = ratingsCount[stars] ?? 0;
              final percentage = totalReviews > 0 ? (count / totalReviews) : 0.0;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    // Estrellas
                    Row(
                      children: [
                        Text(
                          '$stars',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ),
                    const SizedBox(width: 12),
                    
                    // Barra de progreso
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: percentage,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getColorForRating(stars),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Cantidad
                    SizedBox(
                      width: 35,
                      child: Text(
                        '$count',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getColorForRating(int stars) {
    switch (stars) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.deepOrange;
      case 1:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
