import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/enroll_in_course_usecase.dart';
import '../../domain/usecases/get_course_detail_usecase.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import '../../domain/usecases/get_enrolled_courses_usecase.dart';
import '../../domain/usecases/get_my_courses_usecase.dart';
import 'course_event.dart';
import 'course_state.dart';

/// BLoC para gestionar el estado de los cursos
class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesUseCase _getCoursesUseCase;
  final GetCourseDetailUseCase _getCourseDetailUseCase;
  final EnrollInCourseUseCase _enrollInCourseUseCase;
  final GetEnrolledCoursesUseCase _getEnrolledCoursesUseCase;
  final GetMyCoursesUseCase _getMyCoursesUseCase;

  CourseBloc(
    this._getCoursesUseCase,
    this._getCourseDetailUseCase,
    this._enrollInCourseUseCase,
    this._getEnrolledCoursesUseCase,
    this._getMyCoursesUseCase,
  ) : super(const CourseInitial()) {
    on<GetCoursesEvent>(_onGetCourses);
    on<GetCourseDetailEvent>(_onGetCourseDetail);
    on<EnrollInCourseEvent>(_onEnrollInCourse);
    on<GetEnrolledCoursesEvent>(_onGetEnrolledCourses);
    on<GetMyCoursesEvent>(_onGetMyCourses);
    on<RefreshCoursesEvent>(_onRefreshCourses);
  }

  Future<void> _onGetCourses(
    GetCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await _getCoursesUseCase(
      GetCoursesParams(
        categoria: event.categoria,
        nivel: event.nivel,
        search: event.search,
        ordering: event.ordering,
      ),
    );

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (courses) {
        final filter = event.categoria ?? event.nivel ?? event.search;
        emit(CoursesLoaded(courses, activeFilter: filter));
      },
    );
  }

  Future<void> _onGetCourseDetail(
    GetCourseDetailEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await _getCourseDetailUseCase(
      GetCourseDetailParams(event.courseId),
    );

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (courseDetail) => emit(CourseDetailLoaded(courseDetail)),
    );
  }

  Future<void> _onEnrollInCourse(
    EnrollInCourseEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await _enrollInCourseUseCase(
      EnrollInCourseParams(event.courseId),
    );

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (enrollment) => emit(
        EnrollmentSuccess('¡Te has inscrito exitosamente!', event.courseId),
      ),
    );
  }

  Future<void> _onGetEnrolledCourses(
    GetEnrolledCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await _getEnrolledCoursesUseCase(NoParams());

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (courses) => emit(EnrolledCoursesLoaded(courses)),
    );
  }

  Future<void> _onGetMyCourses(
    GetMyCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await _getMyCoursesUseCase(NoParams());

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (courses) => emit(MyCoursesLoaded(courses)),
    );
  }

  Future<void> _onRefreshCourses(
    RefreshCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    // Recargar la lista de cursos sin filtros
    add(const GetCoursesEvent());
  }
}
