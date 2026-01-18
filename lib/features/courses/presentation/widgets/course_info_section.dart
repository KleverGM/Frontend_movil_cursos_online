import 'package:flutter/material.dart';
import '../../domain/entities/course.dart';
import 'info_chip.dart';

/// Widget reutilizable para mostrar la información básica del curso
class CourseInfoSection extends StatelessWidget {
  final Course course;

  const CourseInfoSection({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InfoChip(
                  icon: Icons.star,
                  label: course.nivel,
                  color: Colors.orange,
                ),
                InfoChip(
                  icon: Icons.category,
                  label: course.categoria,
                  color: Colors.blue,
                ),
                InfoChip(
                  icon: Icons.people,
                  label: '${course.totalEstudiantes ?? 0}',
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.attach_money, size: 28, color: Colors.green),
                Text(
                  course.precio.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
