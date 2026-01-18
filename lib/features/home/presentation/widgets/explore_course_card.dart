import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../courses/domain/entities/course.dart';

/// Tarjeta de curso para la sección de exploración
class ExploreCourseCard extends StatelessWidget {
  final Course course;

  const ExploreCourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push(AppRoutes.courseDetail(course.id)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseImage(context),
              const SizedBox(width: 12),
              Expanded(child: _buildCourseInfo(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: course.imagen != null
          ? Image.network(
              course.imagen!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(context),
            )
          : _buildPlaceholder(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.school,
        size: 40,
        color: Theme.of(context).primaryColor.withOpacity(0.3),
      ),
    );
  }

  Widget _buildCourseInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        if (course.instructor != null)
          Text(
            course.instructor!.username,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Chip(
              label: Text(
                course.nivel,
                style: const TextStyle(fontSize: 11),
              ),
              backgroundColor: Colors.orange[100],
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            Text(
              '\$${course.precio.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
