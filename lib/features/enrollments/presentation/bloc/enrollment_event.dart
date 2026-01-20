import 'package:equatable/equatable.dart';

/// Eventos para el EnrollmentBloc
abstract class EnrollmentEvent extends Equatable {
  const EnrollmentEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para obtener todas las inscripciones del instructor
class GetInstructorEnrollmentsEvent extends EnrollmentEvent {
  const GetInstructorEnrollmentsEvent();
}

/// Evento para obtener inscripciones de un curso específico
class GetEnrollmentsByCourseEvent extends EnrollmentEvent {
  final int cursoId;

  const GetEnrollmentsByCourseEvent(this.cursoId);

  @override
  List<Object?> get props => [cursoId];
}
