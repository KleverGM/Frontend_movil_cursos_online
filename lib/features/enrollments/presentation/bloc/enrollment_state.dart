import 'package:equatable/equatable.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/entities/enrollment_stats.dart';

/// Estados del EnrollmentBloc
abstract class EnrollmentState extends Equatable {
  const EnrollmentState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class EnrollmentInitial extends EnrollmentState {
  const EnrollmentInitial();
}

/// Estado de carga
class EnrollmentLoading extends EnrollmentState {
  const EnrollmentLoading();
}

/// Estado con inscripciones cargadas
class EnrollmentLoaded extends EnrollmentState {
  final List<Enrollment> enrollments;
  final EnrollmentStats stats;

  const EnrollmentLoaded({
    required this.enrollments,
    required this.stats,
  });

  @override
  List<Object?> get props => [enrollments, stats];
}

/// Estado de error
class EnrollmentError extends EnrollmentState {
  final String message;

  const EnrollmentError(this.message);

  @override
  List<Object?> get props => [message];
}
