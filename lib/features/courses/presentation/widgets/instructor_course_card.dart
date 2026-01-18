import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/course.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../pages/course_enrollments_page.dart';
import '../pages/course_stats_page.dart';
import '../pages/course_form_page.dart';

/// Tarjeta de curso para instructores con acciones adicionales
class InstructorCourseCard extends StatelessWidget {
  final Course course;

  const InstructorCourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: course.activo
            ? BorderSide.none
            : BorderSide(color: Colors.orange, width: 2),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  context.push('/courses/${course.id}');
                },
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
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
              const Divider(height: 1),
              _buildActionButtons(context, theme),
            ],
          ),
          // Badge de estado inactivo
          if (!course.activo)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'INACTIVO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
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
          '${course.totalEstudiantes ?? 0} estudiantes',
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
          '${course.totalSecciones ?? 0} lecciones',
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

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Botón toggle de activar/desactivar
          BlocConsumer<CourseBloc, CourseState>(
            listener: (context, state) {
              if (state is CourseActivatedSuccess || state is CourseDeactivatedSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state is CourseActivatedSuccess
                          ? 'Curso activado exitosamente'
                          : 'Curso desactivado exitosamente',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                // Recargar la lista de cursos
                context.read<CourseBloc>().add(const GetMyCoursesEvent());
              } else if (state is CourseError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is CourseLoading;
              
              return IconButton(
                icon: Icon(
                  course.activo ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        if (course.activo) {
                          context.read<CourseBloc>().add(
                                DeactivateCourseEvent(course.id),
                              );
                        } else {
                          context.read<CourseBloc>().add(
                                ActivateCourseEvent(course.id),
                              );
                        }
                      },
                tooltip: course.activo ? 'Desactivar curso' : 'Activar curso',
                color: course.activo ? Colors.orange : Colors.green,
              );
            },
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CourseEnrollmentsPage(
                      courseId: course.id,
                      courseTitle: course.titulo,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.people, size: 18),
              label: Text(
                '${course.totalEstudiantes ?? 0}',
                style: const TextStyle(fontSize: 13),
              ),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseFormPage(course: course),
                ),
              );
            },
            tooltip: 'Editar curso',
            color: theme.colorScheme.secondary,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseStatsPage(course: course),
                ),
              );
            },
            tooltip: 'Ver estadísticas',
            color: theme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}
