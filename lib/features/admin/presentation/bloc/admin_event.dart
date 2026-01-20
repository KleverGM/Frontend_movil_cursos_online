part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class GetPlatformStatsEvent extends AdminEvent {
  final int dias;

  const GetPlatformStatsEvent({this.dias = 7});

  @override
  List<Object?> get props => [dias];
}

class GetPopularCoursesEvent extends AdminEvent {
  final int dias;

  const GetPopularCoursesEvent({this.dias = 30});

  @override
  List<Object?> get props => [dias];
}

class GetUsersEvent extends AdminEvent {
  final String? perfil;
  final bool? isActive;
  final String? search;

  const GetUsersEvent({
    this.perfil,
    this.isActive,
    this.search,
  });

  @override
  List<Object?> get props => [perfil, isActive, search];
}

class RefreshDashboardEvent extends AdminEvent {
  const RefreshDashboardEvent();
}

class CreateUserEvent extends AdminEvent {
  final String username;
  final String email;
  final String password;
  final String perfil;
  final String? firstName;
  final String? lastName;

  const CreateUserEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.perfil,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [username, email, password, perfil, firstName, lastName];
}

class UpdateUserEvent extends AdminEvent {
  final int userId;
  final String? username;
  final String? email;
  final String? perfil;
  final String? firstName;
  final String? lastName;
  final bool? isActive;

  const UpdateUserEvent({
    required this.userId,
    this.username,
    this.email,
    this.perfil,
    this.firstName,
    this.lastName,
    this.isActive,
  });

  @override
  List<Object?> get props => [userId, username, email, perfil, firstName, lastName, isActive];
}

class DeleteUserEvent extends AdminEvent {
  final int userId;

  const DeleteUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ChangeUserPasswordEvent extends AdminEvent {
  final int userId;
  final String newPassword;

  const ChangeUserPasswordEvent({
    required this.userId,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [userId, newPassword];
}

// ==================== COURSES EVENTS ====================

class GetAllCoursesAdminEvent extends AdminEvent {
  final String? categoria;
  final String? nivel;
  final String? search;
  final bool? activo;
  final int? instructorId;

  const GetAllCoursesAdminEvent({
    this.categoria,
    this.nivel,
    this.search,
    this.activo,
    this.instructorId,
  });

  @override
  List<Object?> get props => [categoria, nivel, search, activo, instructorId];
}

class CreateCourseAsAdminEvent extends AdminEvent {
  final String titulo;
  final String descripcion;
  final String categoria;
  final String nivel;
  final double precio;
  final int instructorId;
  final String? imagenPath;

  const CreateCourseAsAdminEvent({
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.nivel,
    required this.precio,
    required this.instructorId,
    this.imagenPath,
  });

  @override
  List<Object?> get props => [titulo, descripcion, categoria, nivel, precio, instructorId, imagenPath];
}

class UpdateCourseAsAdminEvent extends AdminEvent {
  final int courseId;
  final String? titulo;
  final String? descripcion;
  final String? categoria;
  final String? nivel;
  final double? precio;
  final int? instructorId;
  final String? imagenPath;

  const UpdateCourseAsAdminEvent({
    required this.courseId,
    this.titulo,
    this.descripcion,
    this.categoria,
    this.nivel,
    this.precio,
    this.instructorId,
    this.imagenPath,
  });

  @override
  List<Object?> get props => [courseId, titulo, descripcion, categoria, nivel, precio, instructorId, imagenPath];
}

class DeleteCourseAsAdminEvent extends AdminEvent {
  final int courseId;

  const DeleteCourseAsAdminEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class ActivateCourseEvent extends AdminEvent {
  final int courseId;

  const ActivateCourseEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class DeactivateCourseEvent extends AdminEvent {
  final int courseId;

  const DeactivateCourseEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class GetCourseStatisticsEvent extends AdminEvent {
  final int courseId;

  const GetCourseStatisticsEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

// ==================== ENROLLMENTS EVENTS ====================

class GetAllEnrollmentsAdminEvent extends AdminEvent {
  final int? cursoId;
  final int? usuarioId;
  final bool? completado;

  const GetAllEnrollmentsAdminEvent({
    this.cursoId,
    this.usuarioId,
    this.completado,
  });

  @override
  List<Object?> get props => [cursoId, usuarioId, completado];
}

class CreateEnrollmentAsAdminEvent extends AdminEvent {
  final int cursoId;
  final int usuarioId;

  const CreateEnrollmentAsAdminEvent({
    required this.cursoId,
    required this.usuarioId,
  });

  @override
  List<Object?> get props => [cursoId, usuarioId];
}

class DeleteEnrollmentAsAdminEvent extends AdminEvent {
  final int enrollmentId;

  const DeleteEnrollmentAsAdminEvent(this.enrollmentId);

  @override
  List<Object?> get props => [enrollmentId];
}

class UpdateEnrollmentAsAdminEvent extends AdminEvent {
  final int enrollmentId;
  final double? progreso;
  final bool? completado;
  final int? cursoId;
  final int? usuarioId;

  const UpdateEnrollmentAsAdminEvent({
    required this.enrollmentId,
    this.progreso,
    this.completado,
    this.cursoId,
    this.usuarioId,
  });

  @override
  List<Object?> get props => [enrollmentId, progreso, completado, cursoId, usuarioId];
}
