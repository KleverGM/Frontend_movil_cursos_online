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
import '../widgets/instructor_card.dart';
import '../widgets/course_info_section.dart';
import '../widgets/course_description_section.dart';
import '../widgets/course_reviews_section.dart';
import '../widgets/course_modules_section.dart';

/// PÃ¡gina de detalle del curso
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
            // Recargar detalle del curso despuÃ©s de inscribirse
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
      // Usuario ya inscrito - BotÃ³n para continuar
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
      // Usuario no inscrito - BotÃ³n para inscribirse
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
        title: const Text('Confirmar InscripciÃ³n'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Â¿Deseas inscribirte en el curso "${courseDetail.course.titulo}"?'),
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
              '${courseDetail.course.totalModulos ?? 0} mÃ³dulos â€¢ ${courseDetail.course.totalSecciones ?? 0} secciones',
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
                // InformaciÃ³n bÃ¡sica
                CourseInfoSection(course: course),
                const SizedBox(height: 24),

                // DescripciÃ³n
                CourseDescriptionSection(description: course.descripcion),
                const SizedBox(height: 24),

                // Instructor
                if (course.instructor != null) ...[
                  InstructorCard(
                    username: course.instructor!.username,
                    firstName: course.instructor!.firstName,
                    lastName: course.instructor!.lastName,
                    email: course.instructor!.email,
                  ),
                  const SizedBox(height: 24),
                ],

                // Progreso (si estÃ¡ inscrito)
                if (widget.courseDetail.inscrito) ...[
                  CourseProgressCard(courseDetail: widget.courseDetail),
                  const SizedBox(height: 24),
                ],

                // ReseÃ±as
                CourseReviewsSection(
                  courseId: course.id,
                  courseName: course.titulo,
                ),
                const SizedBox(height: 24),

                // MÃ³dulos y Secciones
                CourseModulesSection(
                  modulos: widget.courseDetail.modulos,
                  inscrito: widget.courseDetail.inscrito,
                ),
                const SizedBox(height: 100), // Espacio para el botÃ³n flotante
              ],
            ),
          ),
        ),
      ],
    );
  }
}
