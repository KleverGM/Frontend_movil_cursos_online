import 'package:flutter/material.dart';

import '../../domain/entities/course_detail.dart';

/// Widget para mostrar el progreso del usuario en un curso
class CourseProgressCard extends StatelessWidget {
  final CourseDetail courseDetail;

  const CourseProgressCard({
    super.key,
    required this.courseDetail,
  });

  @override
  Widget build(BuildContext context) {
    final progreso = courseDetail.progreso ?? 0.0;
    
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tu Progreso',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${progreso.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progreso / 100,
              minHeight: 8,
              backgroundColor: Theme.of(context).dividerColor,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
