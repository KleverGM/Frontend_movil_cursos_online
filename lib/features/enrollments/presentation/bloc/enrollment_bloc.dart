import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/entities/enrollment_stats.dart';
import '../../domain/usecases/get_enrollments_by_course.dart';
import '../../domain/usecases/get_instructor_enrollments.dart';
import 'enrollment_event.dart';
import 'enrollment_state.dart';

class EnrollmentBloc extends Bloc<EnrollmentEvent, EnrollmentState> {
  final GetInstructorEnrollments getInstructorEnrollments;
  final GetEnrollmentsByCourse getEnrollmentsByCourse;

  EnrollmentBloc({
    required this.getInstructorEnrollments,
    required this.getEnrollmentsByCourse,
  }) : super(const EnrollmentInitial()) {
    on<GetInstructorEnrollmentsEvent>(_onGetInstructorEnrollments);
    on<GetEnrollmentsByCourseEvent>(_onGetEnrollmentsByCourse);
  }

  Future<void> _onGetInstructorEnrollments(
    GetInstructorEnrollmentsEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(const EnrollmentLoading());

    final result = await getInstructorEnrollments(NoParams());

    result.fold(
      (failure) => emit(EnrollmentError(failure.message)),
      (enrollments) {
        final stats = _calculateStats(enrollments);
        emit(EnrollmentLoaded(enrollments: enrollments, stats: stats));
      },
    );
  }

  Future<void> _onGetEnrollmentsByCourse(
    GetEnrollmentsByCourseEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(const EnrollmentLoading());

    final result = await getEnrollmentsByCourse(
      GetEnrollmentsByCourseParams(cursoId: event.cursoId),
    );

    result.fold(
      (failure) => emit(EnrollmentError(failure.message)),
      (enrollments) {
        final stats = _calculateStats(enrollments);
        emit(EnrollmentLoaded(enrollments: enrollments, stats: stats));
      },
    );
  }

  /// Calcula estadísticas de las inscripciones
  EnrollmentStats _calculateStats(List<Enrollment> enrollments) {
    if (enrollments.isEmpty) return EnrollmentStats.empty;

    final total = enrollments.length;
    final completados = enrollments.where((e) => e.completado).length;
    final activos = enrollments.where((e) => !e.completado && e.progreso > 0).length;
    final inactivos = enrollments.where((e) => !e.completado && e.progreso == 0).length;

    final progresoTotal = enrollments.fold<double>(
      0.0,
      (sum, e) => sum + e.progreso,
    );
    final progresoPromedio = progresoTotal / total;

    // Nuevos última semana
    final haceSieteDias = DateTime.now().subtract(const Duration(days: 7));
    final nuevos = enrollments.where((e) => e.fechaInscripcion.isAfter(haceSieteDias)).length;

    return EnrollmentStats(
      totalEstudiantes: total,
      estudiantesActivos: activos,
      estudiantesCompletados: completados,
      estudiantesInactivos: inactivos,
      progresoPromedio: progresoPromedio,
      nuevosUltimaSemana: nuevos,
    );
  }
}
