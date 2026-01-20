import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/states/common_states.dart';
import '../../../../core/widgets/filters/filter_widgets.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/student_course_card.dart';
import 'courses_page.dart';

/// Página que muestra los cursos inscritos del estudiante
class StudentCoursesPage extends StatefulWidget {
  const StudentCoursesPage({super.key});

  @override
  State<StudentCoursesPage> createState() => _StudentCoursesPageState();
}

class _StudentCoursesPageState extends State<StudentCoursesPage> {
  String _filterStatus = 'todos';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CourseBloc>()..add(const GetEnrolledCoursesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Cursos'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<CourseBloc>().add(const GetEnrolledCoursesEvent());
              },
              tooltip: 'Actualizar',
            ),
          ],
        ),
        body: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            print('🎨 UI: BlocBuilder construyendo con estado: ${state.runtimeType}');
          
          if (state is CourseLoading) {
            print('🎨 UI: Mostrando loading');
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CourseError) {
            print('🎨 UI: Mostrando error: ${state.message}');
            return _buildError(state.message);
          }

          if (state is EnrolledCoursesLoaded) {
            print('📚 EnrolledCoursesLoaded - Total cursos: ${state.courses.length}');
            
            if (state.courses.isEmpty) {
              return _buildEmptyState();
            }

            final filteredCourses = _filterCourses(state.courses);
            print('📚 Cursos filtrados: ${filteredCourses.length}');

            return Column(
              children: [
                _buildFilterChips(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<CourseBloc>().add(const GetEnrolledCoursesEvent());
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: filteredCourses.isEmpty
                        ? _buildEmptyFilterState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredCourses.length,
                            itemBuilder: (context, index) {
                              print('📚 Renderizando curso $index: ${filteredCourses[index].titulo}');
                              return StudentCourseCard(
                                course: filteredCourses[index],
                              );
                            },
                          ),
                  ),
                ),
              ],
            );
          }

          print('⚠️ UI: Estado no manejado: ${state.runtimeType}');
          return const Center(
            child: Text('Carga tus cursos inscritos'),
          );
        },
      ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChipWidget(
              label: 'Todos',
              isSelected: _filterStatus == 'todos',
              onTap: () => setState(() => _filterStatus = 'todos'),
              icon: Icons.list,
            ),
            const SizedBox(width: 8),
            FilterChipWidget(
              label: 'En Progreso',
              isSelected: _filterStatus == 'en_progreso',
              onTap: () => setState(() => _filterStatus = 'en_progreso'),
              icon: Icons.play_circle,
            ),
            const SizedBox(width: 8),
            FilterChipWidget(
              label: 'Completados',
              isSelected: _filterStatus == 'completados',
              onTap: () => setState(() => _filterStatus = 'completados'),
              icon: Icons.check_circle,
            ),
            const SizedBox(width: 8),
            FilterChipWidget(
              label: 'No Iniciados',
              isSelected: _filterStatus == 'no_iniciado',
              onTap: () => setState(() => _filterStatus = 'no_iniciado'),
              icon: Icons.schedule,
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _filterCourses(List<dynamic> courses) {
    // Necesitaríamos tener información de progreso en Course
    // Por ahora, retornamos todos
    switch (_filterStatus) {
      case 'en_progreso':
        // TODO: Filtrar por progreso > 0 && < 100
        return courses;
      case 'completados':
        // TODO: Filtrar por progreso == 100
        return courses;
      case 'no_iniciado':
        // TODO: Filtrar por progreso == 0
        return courses;
      default:
        return courses;
    }
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.school_outlined,
      title: 'No tienes cursos inscritos',
      message: 'Explora nuestro catálogo y encuentra cursos que te interesen',
      action: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => getIt<CourseBloc>()
                  ..add(const GetCoursesEvent()),
                child: const CoursesPage(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.explore),
        label: const Text('Explorar Cursos'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFilterState() {
    return EmptyStateWidget(
      icon: Icons.filter_list_off,
      title: 'No hay cursos con este filtro',
      message: 'Intenta con otros filtros',
    );
  }

  Widget _buildError(String message) {
    return ErrorStateWidget(
      message: message,
      onRetry: () {
        context.read<CourseBloc>().add(const GetEnrolledCoursesEvent());
      },
    );
  }
}
