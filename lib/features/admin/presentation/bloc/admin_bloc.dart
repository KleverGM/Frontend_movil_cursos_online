import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../courses/domain/entities/course.dart';
import '../../domain/entities/course_stats_admin.dart';
import '../../domain/entities/enrollment_admin.dart';
import '../../domain/entities/platform_stats.dart';
import '../../domain/entities/popular_course.dart';
import '../../domain/entities/user_summary.dart';
import '../../domain/usecases/activate_course.dart';
import '../../domain/usecases/create_course_as_admin.dart';
import '../../domain/usecases/create_enrollment_as_admin.dart';
import '../../domain/usecases/deactivate_course.dart';
import '../../domain/usecases/delete_course_as_admin.dart';
import '../../domain/usecases/delete_enrollment_as_admin.dart';
import '../../domain/usecases/get_all_courses_admin.dart';
import '../../domain/usecases/get_all_enrollments_admin.dart';
import '../../domain/usecases/get_course_statistics.dart';
import '../../domain/usecases/get_platform_stats.dart';
import '../../domain/usecases/get_popular_courses.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/update_course_as_admin.dart';
import '../../domain/usecases/update_enrollment_as_admin.dart';
import '../../domain/usecases/update_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/change_user_password.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetPlatformStats getPlatformStats;
  final GetPopularCourses getPopularCourses;
  final GetUsers getUsers;
  final CreateUser createUser;
  final UpdateUser updateUser;
  final DeleteUser deleteUser;
  final ChangeUserPassword changeUserPassword;
  final GetAllCoursesAdmin getAllCoursesAdmin;
  final CreateCourseAsAdmin createCourseAsAdmin;
  final UpdateCourseAsAdmin updateCourseAsAdmin;
  final DeleteCourseAsAdmin deleteCourseAsAdmin;
  final ActivateCourse activateCourse;
  final DeactivateCourse deactivateCourse;
  final GetCourseStatistics getCourseStatistics;
  final GetAllEnrollmentsAdmin getAllEnrollmentsAdmin;
  final CreateEnrollmentAsAdmin createEnrollmentAsAdmin;
  final UpdateEnrollmentAsAdmin updateEnrollmentAsAdmin;
  final DeleteEnrollmentAsAdmin deleteEnrollmentAsAdmin;

  AdminBloc({
    required this.getPlatformStats,
    required this.getPopularCourses,
    required this.getUsers,
    required this.createUser,
    required this.updateUser,
    required this.changeUserPassword,
    required this.deleteUser,
    required this.getAllCoursesAdmin,
    required this.createCourseAsAdmin,
    required this.updateCourseAsAdmin,
    required this.deleteCourseAsAdmin,
    required this.activateCourse,
    required this.deactivateCourse,
    required this.getCourseStatistics,
    required this.getAllEnrollmentsAdmin,
    required this.createEnrollmentAsAdmin,
    required this.updateEnrollmentAsAdmin,
    required this.deleteEnrollmentAsAdmin,
  }) : super(AdminInitial()) {
    on<GetPlatformStatsEvent>(_onGetPlatformStats);
    on<GetPopularCoursesEvent>(_onGetPopularCourses);
    on<GetUsersEvent>(_onGetUsers);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
    on<CreateUserEvent>(_onCreateUser);
    on<ChangeUserPasswordEvent>(_onChangeUserPassword);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<GetAllCoursesAdminEvent>(_onGetAllCoursesAdmin);
    on<CreateCourseAsAdminEvent>(_onCreateCourseAsAdmin);
    on<UpdateCourseAsAdminEvent>(_onUpdateCourseAsAdmin);
    on<DeleteCourseAsAdminEvent>(_onDeleteCourseAsAdmin);
    on<ActivateCourseEvent>(_onActivateCourse);
    on<DeactivateCourseEvent>(_onDeactivateCourse);
    on<GetCourseStatisticsEvent>(_onGetCourseStatistics);
    on<GetAllEnrollmentsAdminEvent>(_onGetAllEnrollmentsAdmin);
    on<CreateEnrollmentAsAdminEvent>(_onCreateEnrollmentAsAdmin);
    on<UpdateEnrollmentAsAdminEvent>(_onUpdateEnrollmentAsAdmin);
    on<DeleteEnrollmentAsAdminEvent>(_onDeleteEnrollmentAsAdmin);
  }

  Future<void> _onGetPlatformStats(
    GetPlatformStatsEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await getPlatformStats(GetPlatformStatsParams(dias: event.dias));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (stats) {
        if (state is AdminLoaded) {
          emit((state as AdminLoaded).copyWith(platformStats: stats));
        } else {
          emit(AdminLoaded(platformStats: stats));
        }
      },
    );
  }

  Future<void> _onGetPopularCourses(
    GetPopularCoursesEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await getPopularCourses(GetPopularCoursesParams(dias: event.dias));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (courses) {
        if (state is AdminLoaded) {
          emit((state as AdminLoaded).copyWith(popularCourses: courses));
        } else {
          emit(AdminLoaded(popularCourses: courses));
        }
      },
    );
  }

  Future<void> _onGetUsers(
    GetUsersEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await getUsers(GetUsersParams(
      perfil: event.perfil,
      isActive: event.isActive,
      search: event.search,
    ));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (users) {
        if (state is AdminLoaded) {
          emit((state as AdminLoaded).copyWith(users: users));
        } else {
          emit(AdminLoaded(users: users));
        }
      },
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    // Cargar todos los datos en paralelo
    final statsResult = await getPlatformStats(const GetPlatformStatsParams());
    final coursesResult = await getPopularCourses(const GetPopularCoursesParams());
    final usersResult = await getUsers(const GetUsersParams());

    // Combinar resultados
    PlatformStats? stats;
    List<PopularCourse> courses = [];
    List<UserSummary> users = [];
    String? error;

    statsResult.fold(
      (failure) => error = failure.message,
      (s) => stats = s,
    );

    coursesResult.fold(
      (failure) => error ??= failure.message,
      (c) => courses = c,
    );

    usersResult.fold(
      (failure) => error ??= failure.message,
      (u) => users = u,
    );

    if (error != null) {
      emit(AdminError(error!));
    } else {
      emit(AdminLoaded(
        platformStats: stats,
        popularCourses: courses,
        users: users,
      ));
    }
  }

  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await createUser(CreateUserParams(
      username: event.username,
      email: event.email,
      password: event.password,
      perfil: event.perfil,
      firstName: event.firstName,
      lastName: event.lastName,
    ));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (user) {
        // Recargar lista de usuarios
        add(const GetUsersEvent());
      },
    );
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await updateUser(UpdateUserParams(
      userId: event.userId,
      username: event.username,
      email: event.email,
      perfil: event.perfil,
      firstName: event.firstName,
      lastName: event.lastName,
      isActive: event.isActive,
    ));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (user) {
        // Recargar lista de usuarios
        add(const GetUsersEvent());
      },
    );
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await deleteUser(DeleteUserParams(event.userId));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) {
        // Recargar lista de usuarios
        add(const GetUsersEvent());
      },
    );
  }

  Future<void> _onChangeUserPassword(
    ChangeUserPasswordEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await changeUserPassword(
      userId: event.userId,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) {
        // Recargar lista de usuarios
        add(const GetUsersEvent());
      },
    );
  }

  // ==================== COURSES HANDLERS ====================

  Future<void> _onGetAllCoursesAdmin(
    GetAllCoursesAdminEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await getAllCoursesAdmin(GetAllCoursesParams(
      categoria: event.categoria,
      nivel: event.nivel,
      search: event.search,
      activo: event.activo,
      instructorId: event.instructorId,
    ));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (courses) {
        if (state is AdminLoaded) {
          emit((state as AdminLoaded).copyWith(courses: courses));
        } else {
          emit(AdminLoaded(courses: courses));
        }
      },
    );
  }

  Future<void> _onCreateCourseAsAdmin(
    CreateCourseAsAdminEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await createCourseAsAdmin(CreateCourseParams(
      titulo: event.titulo,
      descripcion: event.descripcion,
      categoria: event.categoria,
      nivel: event.nivel,
      precio: event.precio,
      instructorId: event.instructorId,
      imagenPath: event.imagenPath,
    ));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (course) {
        // Recargar lista de cursos
        add(const GetAllCoursesAdminEvent());
      },
    );
  }

  Future<void> _onUpdateCourseAsAdmin(
    UpdateCourseAsAdminEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await updateCourseAsAdmin(UpdateCourseParams(
      courseId: event.courseId,
      titulo: event.titulo,
      descripcion: event.descripcion,
      categoria: event.categoria,
      nivel: event.nivel,
      precio: event.precio,
      instructorId: event.instructorId,
      imagenPath: event.imagenPath,
    ));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (course) {
        // Recargar lista de cursos
        add(const GetAllCoursesAdminEvent());
      },
    );
  }

  Future<void> _onDeleteCourseAsAdmin(
    DeleteCourseAsAdminEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await deleteCourseAsAdmin(event.courseId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) {
        // Recargar lista de cursos
        add(const GetAllCoursesAdminEvent());
      },
    );
  }

  Future<void> _onActivateCourse(
    ActivateCourseEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await activateCourse(event.courseId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (course) {
        // Recargar lista de cursos
        add(const GetAllCoursesAdminEvent());
      },
    );
  }

  Future<void> _onDeactivateCourse(
    DeactivateCourseEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await deactivateCourse(event.courseId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (course) {
        // Recargar lista de cursos
        add(const GetAllCoursesAdminEvent());
      },
    );
  }

  Future<void> _onGetCourseStatistics(
    GetCourseStatisticsEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await getCourseStatistics(event.courseId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (stats) {
        if (state is AdminLoaded) {
          emit((state as AdminLoaded).copyWith(courseStats: stats));
        } else {
          emit(AdminLoaded(courseStats: stats));
        }
      },
    );
  }

  Future<void> _onGetAllEnrollmentsAdmin(
    GetAllEnrollmentsAdminEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await getAllEnrollmentsAdmin(GetAllEnrollmentsParams(
      cursoId: event.cursoId,
      usuarioId: event.usuarioId,
      completado: event.completado,
    ));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (enrollments) {
        if (state is AdminLoaded) {
          emit((state as AdminLoaded).copyWith(enrollments: enrollments));
        } else {
          emit(AdminLoaded(enrollments: enrollments));
        }
      },
    );
  }

  Future<void> _onCreateEnrollmentAsAdmin(
    CreateEnrollmentAsAdminEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await createEnrollmentAsAdmin(CreateEnrollmentParams(
      cursoId: event.cursoId,
      usuarioId: event.usuarioId,
    ));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (enrollment) {
        // Recargar lista de inscripciones
        add(const GetAllEnrollmentsAdminEvent());
      },
    );
  }

  Future<void> _onUpdateEnrollmentAsAdmin(
    UpdateEnrollmentAsAdminEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await updateEnrollmentAsAdmin(UpdateEnrollmentParams(
      enrollmentId: event.enrollmentId,
      progreso: event.progreso,
      completado: event.completado,
      cursoId: event.cursoId,
      usuarioId: event.usuarioId,
    ));

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (enrollment) {
        // Recargar lista de inscripciones
        add(const GetAllEnrollmentsAdminEvent());
      },
    );
  }

  Future<void> _onDeleteEnrollmentAsAdmin(
    DeleteEnrollmentAsAdminEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await deleteEnrollmentAsAdmin(event.enrollmentId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) {
        // Recargar lista de inscripciones
        add(const GetAllEnrollmentsAdminEvent());
      },
    );
  }
}
