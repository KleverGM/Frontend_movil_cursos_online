import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/states/empty_state_widget.dart';
import '../../../../core/widgets/states/error_state_widget.dart';
import '../../../home/presentation/pages/main_layout.dart';
import '../../domain/entities/course.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/my_course_card.dart';

/// Página de cursos inscritos del usuario
class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  String _selectedFilter = 'todos'; // todos, en_progreso, completados

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CourseBloc>()..add(const GetEnrolledCoursesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Cursos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<CourseBloc>().add(const GetEnrolledCoursesEvent());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildFilterChips(),
            Expanded(
              child: BlocBuilder<CourseBloc, CourseState>(
                builder: (context, state) {
                  if (state is CourseLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is CourseError) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<CourseBloc>().add(const GetEnrolledCoursesEvent());
                      },
                    );
                  }

                  if (state is EnrolledCoursesLoaded) {
                    if (state.courses.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    final filteredCourses = _filterCourses(state.courses);

                    if (filteredCourses.isEmpty) {
                      return _buildNoResultsState();
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<CourseBloc>().add(const GetEnrolledCoursesEvent());
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredCourses.length,
                        itemBuilder: (context, index) {
                          return MyCourseCard(course: filteredCourses[index]);
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'Todos',
              value: 'todos',
              icon: Icons.apps,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'En progreso',
              value: 'en_progreso',
              icon: Icons.pending_actions,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Completados',
              value: 'completados',
              icon: Icons.check_circle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = value;
          });
        }
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  List<Course> _filterCourses(List<Course> courses) {
    // TODO: Implementar filtrado real cuando el backend devuelva progreso
    // Por ahora retornamos todos
    return courses;
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.school_outlined,
      title: 'Aún no tienes cursos',
      message: 'Explora nuestro catálogo y comienza a aprender',
      buttonText: 'Explorar Cursos',
      onButtonPressed: () {
        // Cambiar a la pestaña "Explorar" (index 1)
        final tabNavigator = TabNavigator.of(context);
        if (tabNavigator != null) {
          tabNavigator.onTabChange(1);
        }
      },
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay cursos en esta categoría',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


