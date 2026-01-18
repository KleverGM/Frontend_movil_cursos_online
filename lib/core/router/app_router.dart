import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/courses/domain/entities/course_detail.dart';
import '../../features/courses/presentation/pages/course_content_page.dart';
import '../../features/courses/presentation/pages/course_detail_page.dart';
import '../../features/courses/presentation/pages/courses_page.dart';
import '../../features/courses/presentation/pages/my_courses_page.dart';
import '../../features/home/presentation/pages/main_layout.dart';

/// Rutas de la aplicación
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String splash = '/';
  static const String courses = '/courses';
  static const String myCourses = '/my-courses';
  static String courseDetail(int id) => '/courses/$id';
  static String courseContent(int id) => '/courses/$id/content';
}

/// Configuración del router
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routes: [
      // Splash / Initial
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const LoginPage(),
      ),

      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),

      // Home
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainLayout(),
      ),

      // Courses Routes - CourseDetail y Content son páginas independientes
      GoRoute(
        path: '/courses/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CourseDetailPage(courseId: id);
        },
      ),
      GoRoute(
        path: '/courses/:id/content',
        builder: (context, state) {
          final courseDetail = state.extra as CourseDetail;
          return CourseContentPage(courseDetail: courseDetail);
        },
      ),
      GoRoute(
        path: AppRoutes.myCourses,
        builder: (context, state) => const MyCoursesPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
