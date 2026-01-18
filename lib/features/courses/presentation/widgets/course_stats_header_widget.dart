import 'package:flutter/material.dart';
import '../../domain/entities/course.dart';

/// Widget para mostrar el header con información del curso
class CourseStatsHeaderWidget extends StatelessWidget {
  final Course course;
  final int totalEstudiantes;

  const CourseStatsHeaderWidget({
    super.key,
    required this.course,
    required this.totalEstudiantes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: theme.colorScheme.primaryContainer,
                child: course.imagen != null
                    ? Image.network(
                        course.imagen!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.school,
                          size: 40,
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : Icon(
                        Icons.school,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.titulo,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$totalEstudiantes estudiantes',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
