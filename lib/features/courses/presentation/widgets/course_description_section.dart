import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar la descripción de un curso
class CourseDescriptionSection extends StatelessWidget {
  final String description;
  final String title;

  const CourseDescriptionSection({
    super.key,
    required this.description,
    this.title = 'Descripción',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }
}
