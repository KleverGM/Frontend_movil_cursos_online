import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/enrollment.dart';

/// Repository para inscripciones
abstract class EnrollmentRepository {
  /// Obtiene todas las inscripciones del instructor
  Future<Either<Failure, List<Enrollment>>> getInstructorEnrollments();

  /// Obtiene inscripciones de un curso específico
  Future<Either<Failure, List<Enrollment>>> getEnrollmentsByCourse(int cursoId);
}
