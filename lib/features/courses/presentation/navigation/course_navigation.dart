import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../domain/entities/course.dart';
import 'bloc/course_bloc.dart';
import 'pages/course_form_page.dart';
import 'pages/manage_courses_page.dart';

/// Utilidades de navegación para cursos
class CourseNavigation {
  /// Navegar a la página de gestión de cursos
  static Future<bool?> toManageCourses(BuildContext context) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => getIt<CourseBloc>(),
          child: const ManageCoursesPage(),
        ),
      ),
    );
  }

  /// Navegar al formulario de creación de curso
  static Future<bool?> toCreateCourse(BuildContext context) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => getIt<CourseBloc>(),
          child: const CourseFormPage(),
        ),
      ),
    );
  }

  /// Navegar al formulario de edición de curso
  static Future<bool?> toEditCourse(BuildContext context, Course course) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => getIt<CourseBloc>(),
          child: CourseFormPage(course: course),
        ),
      ),
    );
  }

  /// Navegar con BLoC existente (útil cuando ya tienes un BLoC activo)
  static Future<bool?> toManageCoursesWithBloc(
    BuildContext context,
    CourseBloc bloc,
  ) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: bloc,
          child: const ManageCoursesPage(),
        ),
      ),
    );
  }

  /// Navegar al formulario con BLoC existente
  static Future<bool?> toFormWithBloc(
    BuildContext context,
    CourseBloc bloc, {
    Course? course,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: bloc,
          child: CourseFormPage(course: course),
        ),
      ),
    );
  }
}

/// Extension methods para facilitar la navegación
extension BuildContextCourseNavigation on BuildContext {
  /// Navegar a gestión de cursos
  Future<bool?> navigateToManageCourses() {
    return CourseNavigation.toManageCourses(this);
  }

  /// Navegar a crear curso
  Future<bool?> navigateToCreateCourse() {
    return CourseNavigation.toCreateCourse(this);
  }

  /// Navegar a editar curso
  Future<bool?> navigateToEditCourse(Course course) {
    return CourseNavigation.toEditCourse(this, course);
  }
}
