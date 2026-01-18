import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/course_detail.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/course_progress_card.dart';
import '../widgets/info_chip.dart';
import '../widgets/instructor_card.dart';
import '../widgets/module_card.dart';
import '../../../reviews/presentation/bloc/review_bloc.dart';
import '../../../reviews/presentation/bloc/review_event.dart';
import '../../../reviews/presentation/bloc/review_state.dart';
import '../../../reviews/presentation/widgets/rating_display.dart';
import '../../../reviews/presentation/pages/course_reviews_page.dart';

/// Página de detalle del curso
class CourseDetailPage extends StatelessWidget {
  final int courseId;

  const CourseDetailPage({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CourseBloc>()
        ..add(GetCourseDetailEvent(courseId)),
      child: BlocConsumer<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is EnrollmentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Recargar detalle del curso después de inscribirse
            context.read<CourseBloc>().add(GetCourseDetailEvent(courseId));
          }
        },
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is CourseError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Volver'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CourseDetailLoaded) {
            return Scaffold(
              body: _CourseDetailContent(courseDetail: state.courseDetail),
              floatingActionButton: _buildFloatingButton(
                context,
                state.courseDetail,
              ),
            );
          }

          return const Scaffold(
            body: SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildFloatingButton(BuildContext context, CourseDetail courseDetail) {
    if (courseDetail.inscrito) {
      // Usuario ya inscrito - Botón para continuar
      return FloatingActionButton.extended(
        onPressed: () {
          context.push(
            AppRoutes.courseContent(courseDetail.course.id),
            extra: courseDetail,
          );
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Continuar'),
        backgroundColor: Colors.green,
      );
    } else {
      // Usuario no inscrito - Botón para inscribirse
      return FloatingActionButton.extended(
        onPressed: () => _showEnrollDialog(context, courseDetail),
        icon: const Icon(Icons.add_circle),
        label: Text('Inscribirse \$${courseDetail.course.precio.toStringAsFixed(2)}'),
        backgroundColor: Theme.of(context).primaryColor,
      );
    }
  }

  void _showEnrollDialog(BuildContext context, CourseDetail courseDetail) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar Inscripción'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Deseas inscribirte en el curso "${courseDetail.course.titulo}"?'),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                Text(
                  'Precio: \$${courseDetail.course.precio.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${courseDetail.course.totalModulos ?? 0} módulos • ${courseDetail.course.totalSecciones ?? 0} secciones',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CourseBloc>().add(EnrollInCourseEvent(courseId));
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

/// Widget con el contenido del detalle del curso
class _CourseDetailContent extends StatefulWidget {
  final CourseDetail courseDetail;

  const _CourseDetailContent({required this.courseDetail});

  @override
  State<_CourseDetailContent> createState() => _CourseDetailContentState();
}

class _CourseDetailContentState extends State<_CourseDetailContent> {
  Key _reviewsKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final course = widget.courseDetail.course;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // App Bar con imagen
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              course.titulo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            background: course.imagen != null
                ? Image.network(
                    course.imagen!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.school,
                          size: 80,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),

        // Contenido
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información básica
                _buildInfoSection(context, course),
                const SizedBox(height: 24),

                // Descripción
                _buildDescriptionSection(course),
                const SizedBox(height: 24),

                // Instructor
                if (course.instructor != null) ...[
                  _buildInstructorSection(course),
                  const SizedBox(height: 24),
                ],

                // Progreso (si está inscrito)
                if (widget.courseDetail.inscrito) ...[
                  _buildProgressSection(widget.courseDetail),
                  const SizedBox(height: 24),
                ],

                // Reseñas
                _buildReviewsSection(context, widget.courseDetail),
                const SizedBox(height: 24),

                // Módulos y Secciones
                _buildModulesSection(context, widget.courseDetail),
                const SizedBox(height: 100), // Espacio para el botón flotante
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, course) {
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

  Widget _buildDescriptionSection(course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descripción',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          course.descripcion,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildInstructorSection(course) {
    final instructor = course.instructor!;
    return InstructorCard(
      username: instructor.username,
      firstName: instructor.firstName,
      lastName: instructor.lastName,
      email: instructor.email,
    );
  }

  Widget _buildProgressSection(CourseDetail courseDetail) {
    return CourseProgressCard(courseDetail: courseDetail);
  }

  Widget _buildReviewsSection(BuildContext context, CourseDetail courseDetail) {
    return BlocProvider(
      key: _reviewsKey,
      create: (context) => getIt<ReviewBloc>()
        ..add(GetCourseReviewStatsEvent(courseDetail.course.id)),
      child: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          if (state is ReviewsLoaded && state.stats != null) {
            final stats = state.stats!;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reseñas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CourseReviewsPage(
                                  cursoId: courseDetail.course.id,
                                  cursoTitulo: courseDetail.course.titulo,
                                  canReview: courseDetail.inscrito,
                                ),
                              ),
                            );
                            // Recargar estadísticas al regresar
                            if (mounted) {
                              setState(() {
                                _reviewsKey = UniqueKey();
                              });
                            }
                          },
                          child: const Text('Ver todas'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              stats.calificacionPromedio.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RatingDisplay(
                              rating: stats.calificacionPromedio,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${stats.totalResenas} reseñas',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Column(
                            children: List.generate(5, (index) {
                              final stars = 5 - index;
                              final count = stats.distribucionEstrellas[stars] ?? 0;
                              final percentage = stats.totalResenas > 0
                                  ? (count / stats.totalResenas * 100)
                                  : 0.0;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      '$stars',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: percentage / 100,
                                        backgroundColor: Colors.grey[300],
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          Colors.amber,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 40,
                                      child: Text(
                                        '${percentage.toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          // Si no hay estadísticas o hubo un error, mostrar sección básica
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reseñas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (courseDetail.inscrito)
                        TextButton(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CourseReviewsPage(
                                  cursoId: courseDetail.course.id,
                                  cursoTitulo: courseDetail.course.titulo,
                                  canReview: true,
                                ),
                              ),
                            );
                            // Recargar estadísticas al regresar
                            if (mounted) {
                              setState(() {
                                _reviewsKey = UniqueKey();
                              });
                            }
                          },
                          child: const Text('Escribir reseña'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aún no hay reseñas',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModulesSection(BuildContext context, CourseDetail courseDetail) {
    if (courseDetail.modulos.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.folder_open, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Este curso aún no tiene módulos',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contenido del Curso',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...courseDetail.modulos.map((modulo) => ModuleCard(
              modulo: modulo,
              inscrito: courseDetail.inscrito,
            )),
      ],
    );
  }
}
