import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Widget para mostrar gráfico circular de progreso general
class ProgressPieChart extends StatelessWidget {
  final int completedCourses;
  final int inProgressCourses;
  final int notStartedCourses;

  const ProgressPieChart({
    super.key,
    required this.completedCourses,
    required this.inProgressCourses,
    required this.notStartedCourses,
  });

  @override
  Widget build(BuildContext context) {
    final total = completedCourses + inProgressCourses + notStartedCourses;
    
    if (total == 0) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Progreso General',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Icon(Icons.school_outlined, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 8),
              Text(
                'Aún no tienes cursos',
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
              'Progreso General',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Gráfico circular
                Expanded(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          if (completedCourses > 0)
                            PieChartSectionData(
                              value: completedCourses.toDouble(),
                              title: '$completedCourses',
                              color: Colors.green,
                              radius: 60,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          if (inProgressCourses > 0)
                            PieChartSectionData(
                              value: inProgressCourses.toDouble(),
                              title: '$inProgressCourses',
                              color: Colors.orange,
                              radius: 60,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          if (notStartedCourses > 0)
                            PieChartSectionData(
                              value: notStartedCourses.toDouble(),
                              title: '$notStartedCourses',
                              color: Colors.grey,
                              radius: 60,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Leyenda
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(
                        'Completados',
                        completedCourses,
                        Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _buildLegendItem(
                        'En progreso',
                        inProgressCourses,
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _buildLegendItem(
                        'Sin iniciar',
                        notStartedCourses,
                        Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'Total: $total cursos',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
