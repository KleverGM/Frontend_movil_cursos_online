import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/course.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';

/// Página de detalle de curso para invitados
class GuestCourseDetailPage extends StatelessWidget {
  final int courseId;

  const GuestCourseDetailPage({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CourseBloc>()..add(GetCourseDetailEvent(courseId)),
      child: _GuestCourseDetailContent(courseId: courseId),
    );
  }
}

class _GuestCourseDetailContent extends StatelessWidget {
  final int courseId;

  const _GuestCourseDetailContent({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseDetailLoaded) {
            final detail = state.courseDetail;

            return CustomScrollView(
              slivers: [
                // Header con imagen del curso
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildCourseImage(detail.course),
                  ),
                ),

                // Banner de invitado
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity( 0.1),
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).primaryColor.withOpacity( 0.2),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Inicia sesión para inscribirte',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Crea una cuenta o inicia sesión para acceder al contenido completo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Información del curso
                SliverToBoxAdapter(
                  child: _buildCourseInfo(context, detail.course),
                ),

                // Lista de módulos (vista previa)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contenido del curso',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${detail.modulos.length} módulos',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Módulos (bloqueados)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final module = detail.modulos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.lock,
                              color: Colors.grey[600],
                            ),
                          ),
                          title: Text(
                            module.titulo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          subtitle: Text(
                            module.descripcion ?? 'Sin descripción',
                            style: TextStyle(color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(
                            Icons.lock_outline,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                    childCount: detail.modulos.length,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          }

          if (state is CourseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildCourseImage(Course course) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (course.imagen != null && course.imagen!.isNotEmpty)
          Image.network(
            course.imagen!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Icon(Icons.school, size: 80, color: Colors.grey[600]),
              );
            },
          )
        else
          Container(
            color: Colors.grey[300],
            child: Icon(Icons.school, size: 80, color: Colors.grey[600]),
          ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseInfo(BuildContext context, Course course) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.titulo,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (course.instructor != null) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  child: Text(
                    course.instructor!.fullName.substring(0, 1).toUpperCase(),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  course.instructor!.fullName,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          // Chips de información
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (course.categoria != null)
                Chip(
                  label: Text(course.categoria!),
                  avatar: const Icon(Icons.category, size: 16),
                ),
              if (course.nivel != null)
                Chip(
                  label: Text(course.nivel!),
                  avatar: const Icon(Icons.signal_cellular_alt, size: 16),
                ),
              Chip(
                label: Text('${course.totalEstudiantes ?? 0} estudiantes'),
                avatar: const Icon(Icons.people, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (course.descripcion != null && course.descripcion!.isNotEmpty) ...[
            const Text(
              'Descripción',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              course.descripcion!,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => context.push(AppRoutes.login),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Iniciar Sesión para Inscribirte',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push(AppRoutes.register),
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
