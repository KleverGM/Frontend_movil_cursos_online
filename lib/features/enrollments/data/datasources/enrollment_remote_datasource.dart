import '../models/enrollment_model.dart';

/// Datasource para inscripciones
abstract class EnrollmentRemoteDataSource {
  /// Obtiene todas las inscripciones del instructor
  Future<List<EnrollmentModel>> getInstructorEnrollments();

  /// Obtiene inscripciones de un curso específico
  Future<List<EnrollmentModel>> getEnrollmentsByCourse(int cursoId);
}
