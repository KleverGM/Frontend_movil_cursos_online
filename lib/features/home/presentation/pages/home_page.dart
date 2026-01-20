import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../courses/domain/entities/course.dart';
import '../../../courses/presentation/bloc/course_bloc.dart';
import '../../../courses/presentation/bloc/course_event.dart';
import '../../../courses/presentation/bloc/course_state.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/explore_course_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/progress_pie_chart.dart';

/// Página principal (Dashboard) para estudiantes
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> enrolledCourses = [];
  List<Course> allCourses = [];
  bool isLoadingEnrolled = true;
  bool isLoadingAll = true;

  @override
  void initState() {
    super.initState();
    _loadEnrolledCourses();
  }

  void _loadEnrolledCourses() {
    setState(() => isLoadingEnrolled = true);
    context.read<CourseBloc>().add(const GetEnrolledCoursesEvent());
  }

  void _loadAllCourses() {
    setState(() => isLoadingAll = true);
    context.read<CourseBloc>().add(const GetCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseBloc, CourseState>(
      listener: (context, state) {
        if (state is EnrolledCoursesLoaded) {
          setState(() {
            enrolledCourses = state.courses;
            isLoadingEnrolled = false;
          });
          // Después de cargar inscritos, cargar todos los cursos
          _loadAllCourses();
        } else if (state is CoursesLoaded) {
          setState(() {
            allCourses = state.courses;
            isLoadingAll = false;
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              _loadEnrolledCourses();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: DashboardHeader()),
                SliverToBoxAdapter(child: _buildStats()),
                SliverToBoxAdapter(child: _buildCharts()),
                SliverToBoxAdapter(child: _buildContinueLearning()),
                SliverToBoxAdapter(child: _buildExploreCourses()),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    // Calcular estadísticas reales basadas en el progreso
    final completedCourses = enrolledCourses.where((course) => 
      course.progreso != null && course.progreso! >= 100
    ).length;
    
    final inProgressCourses = enrolledCourses.where((course) => 
      course.progreso != null && course.progreso! > 0 && course.progreso! < 100
    ).length;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.school,
              label: 'Cursos',
              value: enrolledCourses.length.toString(),
              color: Colors.blue,
              onTap: () => context.push(AppRoutes.myCourses),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.pending_actions,
              label: 'En progreso',
              value: inProgressCourses.toString(),
              color: Colors.orange,
              onTap: () => context.push(AppRoutes.myCourses),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.check_circle,
              label: 'Completados',
              value: completedCourses.toString(),
              color: Colors.green,
              onTap: () => context.push(AppRoutes.myCourses),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharts() {
    if (isLoadingEnrolled) {
      return const SizedBox.shrink();
    }

    // Calcular cursos completados, en progreso y sin iniciar desde el backend
    final completedCourses = enrolledCourses.where((course) => 
      course.progreso != null && course.progreso! >= 100
    ).length;
    
    final inProgressCourses = enrolledCourses.where((course) => 
      course.progreso != null && course.progreso! > 0 && course.progreso! < 100
    ).length;
    
    final notStartedCourses = enrolledCourses.where((course) => 
      course.progreso == null || course.progreso! == 0
    ).length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ProgressPieChart(
        completedCourses: completedCourses,
        inProgressCourses: inProgressCourses,
        notStartedCourses: notStartedCourses,
      ),
    );
  }

  Widget _buildContinueLearning() {
    if (isLoadingEnrolled) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (enrolledCourses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Continuar aprendiendo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.myCourses),
                child: const Text('Ver todos'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: enrolledCourses.take(3).length,
            itemBuilder: (context, index) {
              return ContinueLearningCard(course: enrolledCourses[index]);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildExploreCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Explorar cursos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Ver todos'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (isLoadingAll)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (allCourses.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('No hay cursos disponibles')),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: allCourses.take(4).length,
            itemBuilder: (context, index) {
              return ExploreCourseCard(course: allCourses[index]);
            },
          ),
      ],
    );
  }
}
