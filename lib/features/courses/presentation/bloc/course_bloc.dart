import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_course_usecase.dart';
import '../../domain/usecases/delete_course_usecase.dart';
import '../../domain/usecases/enroll_in_course_usecase.dart';
import '../../domain/usecases/get_course_detail_usecase.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import '../../domain/usecases/get_enrolled_courses_usecase.dart';
import '../../domain/usecases/get_instructor_enrollments_usecase.dart';
import '../../domain/usecases/get_my_courses_usecase.dart';
import '../../domain/usecases/mark_section_completed.dart';
import '../../domain/usecases/update_course_usecase.dart';
import 'course_event.dart';
import 'course_state.dart';

/// BLoC para gestionar el estado de los cursos
class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesUseCase _getCoursesUseCase;
  final GetCourseDetailUseCase _getCourseDetailUseCase;
  final EnrollInCourseUseCase _enrollInCourseUseCase;
  final GetEnrolledCoursesUseCase _getEnrolledCoursesUseCase;
  final GetMyCoursesUseCase _getMyCoursesUseCase;
  final MarkSectionCompleted _markSectionCompleted;
  final CreateCourseUseCase _createCourseUseCase;
  final UpdateCourseUseCase _updateCourseUseCase;
  final DeleteCourseUseCase _deleteCourseUseCase;
  final GetInstructorEnrollmentsUseCase _getInstructorEnrollmentsUseCase;

  CourseBloc(
    this._getCoursesUseCase,
    this._getCourseDetailUseCase,
    this._enrollInCourseUseCase,
    this._getEnrolledCoursesUseCase,
    this._getMyCoursesUseCase,
    this._markSectionCompleted,
    this._createCourseUseCase,
    this._updateCourseUseCase,
    this._deleteCourseUseCase,
    this._getInstructorEnrollmentsUseCase,
  ) : super(const CourseInitial()) {
    on<GetCoursesEvent>(_onGetCourses);
    on<GetCourseDetailEvent>(_onGetCourseDetail);
    on<EnrollInCourseEvent>(_onEnrollInCourse);
    on<GetEnrolledCoursesEvent>(_onGetEnrolledCourses);
    on<GetMyCoursesEvent>(_onGetMyCourses);
    on<RefreshCoursesEvent>(_onRefreshCourses);
    on<MarkSectionCompletedEvent>(_onMarkSectionCompleted);
    on<CreateCourseEvent>(_onCreateCourse);
    on<UpdateCourseEvent>(_onUpdateCourse);
    on<DeleteCourseEvent>(_onDeleteCourse);
    on<GetInstructorEnrollmentsEvent>(_onGetInstructorEnrollments);
  }

  Future<void> _onGetCourses(
    GetCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await _getCoursesUseCase(
      GetCoursesParams(filters: event.filters),
    );

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (courses) {
        // Aplicar filtros de precio en el frontend si están definidos
        var filteredCourses = courses;
        if (event.filters?.precioMin != null || event.filters?.precioMax != null) {
          filteredCourses = courses.where((course) {
            if (event.filters?.precioMin != null && course.precio < event.filters!.precioMin!) {
              return false;
            }
            if (event.filters?.precioMax != null && course.precio > event.filters!.precioMax!) {
              return false;
            }
            return true;
          }).toList();
        }
        
        final hasFilters = event.filters?.hasActiveFilters ?? false;
        emit(CoursesLoaded(filteredCourses, activeFilter: hasFilters ? 'filtered' : null));
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

  Future<void> _onMarkSectionCompleted(
    MarkSectionCompletedEvent event,
    Emitter<CourseState> emit,
  ) async {
    final result = await _markSectionCompleted(
      MarkSectionParams(sectionId: event.sectionId),
    );

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (_) => emit(SectionCompletedSuccess(event.sectionId)),
    );
  }

  Future<void> _onCreateCourse(
    CreateCourseEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await _createCourseUseCase(
      CreateCourseParams(
        titulo: event.titulo,
        descripcion: event.descripcion,
        categoria: event.categoria,
        nivel: event.nivel,
        precio: event.precio,
        imagenPath: event.imagenPath,
      ),
    );

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (course) => emit(CourseCreatedSuccess(course)),
    );
  }

  Future<void> _onUpdateCourse(
    UpdateCourseEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await _updateCourseUseCase(
      UpdateCourseParams(
        courseId: event.courseId,
        titulo: event.titulo,
        descripcion: event.descripcion,
        categoria: event.categoria,
        nivel: event.nivel,
        precio: event.precio,
        imagenPath: event.imagenPath,
      ),
    );

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (course) => emit(CourseUpdatedSuccess(course)),
    );
  }

  Future<void> _onDeleteCourse(
    DeleteCourseEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await _deleteCourseUseCase(
      DeleteCourseParams(event.courseId),
    );

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (_) => emit(CourseDeletedSuccess(event.courseId)),
    );
  }

  Future<void> _onGetInstructorEnrollments(
    GetInstructorEnrollmentsEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await _getInstructorEnrollmentsUseCase(
      GetInstructorEnrollmentsParams(courseId: event.courseId),
    );

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (enrollments) => emit(InstructorEnrollmentsLoaded(enrollments)),
    );
  }
}
