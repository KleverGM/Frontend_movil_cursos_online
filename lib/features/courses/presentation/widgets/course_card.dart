import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/course.dart';
import '../../../../core/router/app_router.dart';

/// Tarjeta de curso para la página de exploración
class CourseCard extends StatelessWidget {
  final Course course;
  final bool isGuestMode;

  const CourseCard({
    super.key,
    required this.course,
    this.isGuestMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navegar a la ruta correcta según el modo
          if (isGuestMode) {
            context.push(AppRoutes.guestCourseDetail(course.id));
          } else {
            context.push(AppRoutes.courseDetail(course.id));
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseImage(theme),
              const SizedBox(height: 12),
              _buildTitle(theme),
              const SizedBox(height: 8),
              _buildDescription(theme),
              const SizedBox(height: 12),
              _buildInfoRow(theme),
              const SizedBox(height: 8),
              _buildStatsRow(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseImage(ThemeData theme) {
    if (course.imagen != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          course.imagen!,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholderImage(theme),
        ),
      );
    }
    return _buildPlaceholderImage(theme);
  }

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.school,
          size: 64,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      course.titulo,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      course.descripcion,
      style: theme.textTheme.bodyMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfoRow(ThemeData theme) {
    return Row(
      children: [
        _buildCategoryChip(theme),
        const SizedBox(width: 8),
        _buildLevelChip(theme),
        const Spacer(),
        _buildPriceText(theme),
      ],
    );
  }

  Widget _buildCategoryChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        course.categoriaDisplay,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  Widget _buildLevelChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        course.nivelDisplay,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onTertiaryContainer,
        ),
      ),
    );
  }

  Widget _buildPriceText(ThemeData theme) {
    return Text(
      course.esGratuito ? 'Gratis' : '\$${course.precio.toStringAsFixed(2)}',
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.people_outline,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          '${course.totalEstudiantes} estudiantes',
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(width: 16),
        Icon(
          Icons.video_library_outlined,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          '${course.totalSecciones} lecciones',
          style: theme.textTheme.labelMedium,
        ),
        if (course.duracionTotal > 0) ...[
          const SizedBox(width: 16),
          Icon(
            Icons.access_time,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            course.duracionFormateada,
            style: theme.textTheme.labelMedium,
          ),
        ],
      ],
    );
  }
}
