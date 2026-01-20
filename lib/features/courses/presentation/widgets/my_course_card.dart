import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../domain/entities/course.dart';

/// Tarjeta de curso inscrito con progreso
class MyCourseCard extends StatelessWidget {
  final Course course;
  final double progreso;

  const MyCourseCard({
    super.key,
    required this.course,
    this.progreso = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push(AppRoutes.courseDetail(course.id));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del curso con badge de progreso
            Stack(
              children: [
                _buildCourseImage(context),
                _buildProgressBadge(),
              ],
            ),

            // Información del curso
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (course.instructor != null) _buildInstructorInfo(),
                  const SizedBox(height: 12),
                  _buildProgressBar(context),
                  const SizedBox(height: 12),
                  _buildActionButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseImage(BuildContext context) {
    if (course.imagen != null) {
      return Image.network(
        course.imagen!,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage(context);
        },
      );
    }
    return _buildPlaceholderImage(context);
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity( 0.7),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.school,
          size: 64,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProgressBadge() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '${progreso.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructorInfo() {
    return Row(
      children: [
        const Icon(Icons.person, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          course.instructor!.username,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return LinearProgressIndicator(
      value: progreso / 100,
      minHeight: 6,
      backgroundColor: Theme.of(context).dividerColor,
      valueColor: AlwaysStoppedAnimation<Color>(
        progreso == 100 ? Colors.green : Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          context.push(AppRoutes.courseDetail(course.id));
        },
        icon: Icon(
          progreso == 100 ? Icons.replay : Icons.play_arrow,
        ),
        label: Text(
          progreso == 100 ? 'Ver de nuevo' : 'Continuar',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: progreso == 100 ? Colors.green : null,
        ),
      ),
    );
  }
}
