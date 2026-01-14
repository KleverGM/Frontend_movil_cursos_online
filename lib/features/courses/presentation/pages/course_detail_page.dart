import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/course_detail.dart';
import '../../domain/entities/module.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';

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
      child: Scaffold(
        body: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is CourseError) {
              return Center(
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
              );
            }

            if (state is CourseDetailLoaded) {
              return _CourseDetailContent(courseDetail: state.courseDetail);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

/// Widget con el contenido del detalle del curso
class _CourseDetailContent extends StatelessWidget {
  final CourseDetail courseDetail;

  const _CourseDetailContent({required this.courseDetail});

  @override
  Widget build(BuildContext context) {
    final course = courseDetail.course;

    return CustomScrollView(
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
                if (courseDetail.inscrito) ...[
                  _buildProgressSection(courseDetail),
                  const SizedBox(height: 24),
                ],

                // Módulos y Secciones
                _buildModulesSection(context, courseDetail),
                const SizedBox(height: 80), // Espacio para el botón flotante
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
                _buildInfoChip(
                  icon: Icons.star,
                  label: course.nivel,
                  color: Colors.orange,
                ),
                _buildInfoChip(
                  icon: Icons.category,
                  label: course.categoria,
                  color: Colors.blue,
                ),
                _buildInfoChip(
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

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
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
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            instructor.username[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          instructor.firstName != null && instructor.lastName != null
              ? '${instructor.firstName} ${instructor.lastName}'
              : instructor.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(instructor.email),
        trailing: const Icon(Icons.verified, color: Colors.blue),
      ),
    );
  }

  Widget _buildProgressSection(CourseDetail courseDetail) {
    final progreso = courseDetail.progreso ?? 0.0;
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tu Progreso',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${progreso.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progreso / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ],
        ),
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
        ...courseDetail.modulos.map((modulo) => _ModuleCard(
              modulo: modulo,
              inscrito: courseDetail.inscrito,
            )),
      ],
    );
  }
}

/// Card de módulo con lista de secciones
class _ModuleCard extends StatefulWidget {
  final Module modulo;
  final bool inscrito;

  const _ModuleCard({
    required this.modulo,
    required this.inscrito,
  });

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final totalSecciones = widget.modulo.secciones?.length ?? 0;
    final duracionTotal = widget.modulo.secciones?.fold<int>(
          0,
          (sum, seccion) => sum + (seccion.duracionMinutos ?? 0),
        ) ??
        0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                '${widget.modulo.orden}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              widget.modulo.titulo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '$totalSecciones secciones • $duracionTotal min',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
          ),
          if (_isExpanded && widget.modulo.secciones != null) ...[
            const Divider(height: 1),
            ...widget.modulo.secciones!.map((seccion) => ListTile(
                  leading: Icon(
                    seccion.videoUrl != null
                        ? Icons.play_circle_outline
                        : Icons.article_outlined,
                    color: Colors.grey[600],
                  ),
                  title: Text(seccion.titulo),
                  subtitle: Text('${seccion.duracionMinutos ?? 0} min'),
                  trailing: seccion.esPreview == true
                      ? Chip(
                          label: const Text(
                            'Preview',
                            style: TextStyle(fontSize: 10),
                          ),
                          backgroundColor: Colors.blue[100],
                        )
                      : widget.inscrito
                          ? const Icon(Icons.lock_open, color: Colors.green)
                          : const Icon(Icons.lock, color: Colors.grey),
                  onTap: widget.inscrito || seccion.esPreview == true
                      ? () {
                          // TODO: Navegar al contenido de la sección
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Abrir: ${seccion.titulo}'),
                            ),
                          );
                        }
                      : null,
                )),
          ],
        ],
      ),
    );
  }
}
