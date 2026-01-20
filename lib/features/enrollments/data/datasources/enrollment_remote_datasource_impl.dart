import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../models/enrollment_model.dart';
import 'enrollment_remote_datasource.dart';

class EnrollmentRemoteDataSourceImpl implements EnrollmentRemoteDataSource {
  final ApiClient apiClient;
  final AuthLocalDataSource authLocalDataSource;

  EnrollmentRemoteDataSourceImpl({
    required this.apiClient,
    required this.authLocalDataSource,
  });

  @override
  Future<List<EnrollmentModel>> getInstructorEnrollments() async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) {
        throw const AuthenticationException('No hay token de autenticación');
      }

      final response = await apiClient.get(
        ApiConstants.enrollments,
      );

      // El backend devuelve paginación con {count, next, previous, results}
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['results'] is List) {
          return (data['results'] as List)
              .map((json) => EnrollmentModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }

      // Fallback: si es una lista directa
      if (response.data is List) {
        return (response.data as List)
            .map((json) => EnrollmentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw const ServerException('Formato de respuesta inválido');
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      throw ServerException('Error al obtener inscripciones: ${e.toString()}');
    }
  }

  @override
  Future<List<EnrollmentModel>> getEnrollmentsByCourse(int cursoId) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) {
        throw const AuthenticationException('No hay token de autenticación');
      }

      final response = await apiClient.get(
        ApiConstants.enrollments,
        queryParameters: {'curso': cursoId},
      );

      // El backend devuelve paginación con {count, next, previous, results}
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['results'] is List) {
          return (data['results'] as List)
              .map((json) => EnrollmentModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }

      // Fallback: si es una lista directa
      if (response.data is List) {
        return (response.data as List)
            .map((json) => EnrollmentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw const ServerException('Formato de respuesta inválido');
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      throw ServerException('Error al obtener inscripciones del curso: ${e.toString()}');
    }
  }
}
