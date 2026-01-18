import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../courses/domain/entities/course.dart';

/// Tarjeta horizontal para mostrar cursos en progreso
class ContinueLearningCard extends StatelessWidget {
  final Course course;

  const ContinueLearningCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.courseDetail(course.id)),
        child: SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseImage(context),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildProgressBar(),
                    const SizedBox(height: 4),
                    Text(
                      '0% completado',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseImage(BuildContext context) {
    if (course.imagen != null) {
      return Image.network(
        course.imagen!,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(context),
      );
    }
    return _buildPlaceholder(context);
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Icon(
        Icons.school,
        size: 48,
        color: Theme.of(context).primaryColor.withOpacity(0.3),
      ),
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: 0,
      minHeight: 4,
      backgroundColor: Colors.grey[300],
    );
  }
}
