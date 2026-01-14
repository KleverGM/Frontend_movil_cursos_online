import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/courses/presentation/pages/course_detail_page.dart';
import '../../features/courses/presentation/pages/courses_page.dart';

/// Rutas de la aplicación
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String splash = '/';
  static const String courses = '/courses';
  static String courseDetail(int id) => '/courses/$id';
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
        builder: (context, state) => const CoursesPage(),
      ),

      // Courses Routes
      GoRoute(
        path: AppRoutes.courses,
        builder: (context, state) => const CoursesPage(),
      ),
      GoRoute(
        path: '/courses/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CourseDetailPage(courseId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
