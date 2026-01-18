import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/course_detail_model.dart';
import '../models/course_model.dart';
import '../models/enrollment_model.dart';

/// DataSource remoto para cursos
abstract class CourseRemoteDataSource {
  /// Obtener lista de cursos con filtros
  Future<List<CourseModel>> getCourses({
    String? categoria,
    String? nivel,
    String? search,
    String? ordering,
  });

  /// Obtener detalle de un curso
  Future<CourseDetailModel> getCourseDetail(int courseId);

  /// Inscribirse a un curso
  Future<EnrollmentModel> enrollInCourse(int courseId);

  /// Obtener cursos inscritos del usuario
  Future<List<CourseModel>> getEnrolledCourses();

  /// Obtener cursos creados por el instructor
  Future<List<CourseModel>> getMyCourses();

  /// Marcar una sección como completada
  Future<void> markSectionCompleted(int sectionId);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiClient _apiClient;

  CourseRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CourseModel>> getCourses({
    String? categoria,
    String? nivel,
    String? search,
    String? ordering,
  }) async {
    // Construir query parameters
    final queryParams = <String, dynamic>{};
    if (categoria != null) queryParams['categoria'] = categoria;
    if (nivel != null) queryParams['nivel'] = nivel;
    if (search != null) queryParams['search'] = search;
    if (ordering != null) queryParams['ordering'] = ordering;

    final response = await _apiClient.get(
      ApiConstants.courses,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.statusCode == 200) {
      // La API devuelve un objeto con paginación: {count, next, previous, results}
      final responseData = response.data as Map<String, dynamic>;
      final List<dynamic> data = responseData['results'] as List<dynamic>;
      return data.map((json) => CourseModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener cursos: ${response.statusCode}');
    }
  }

  @override
  Future<CourseDetailModel> getCourseDetail(int courseId) async {
    final response = await _apiClient.get(ApiConstants.courseDetail(courseId));

    if (response.statusCode == 200) {
      return CourseDetailModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al obtener detalle del curso: ${response.statusCode}');
    }
  }

  @override
  Future<EnrollmentModel> enrollInCourse(int courseId) async {
    final response = await _apiClient.post(
      ApiConstants.courseEnroll(courseId),
      data: {},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EnrollmentModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al inscribirse en el curso: ${response.statusCode}');
    }
  }

  @override
  Future<List<CourseModel>> getEnrolledCourses() async {
    final response = await _apiClient.get(ApiConstants.enrolledCourses);

    if (response.statusCode == 200) {
      // Verificar si la respuesta es paginada o un array directo
      final responseData = response.data;
      final List<dynamic> data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
        // Respuesta paginada
        data = responseData['results'] as List<dynamic>;
      } else {
        // Array directo
        data = responseData as List<dynamic>;
      }
      
      // Las inscripciones vienen con objeto curso anidado
      return data
          .map((json) {
            final enrollment = json as Map<String, dynamic>;
            if (enrollment['curso'] != null) {
              return CourseModel.fromJson(enrollment['curso'] as Map<String, dynamic>);
            }
            return null;
          })
          .whereType<CourseModel>()
          .toList();
    } else {
      throw Exception('Error al obtener cursos inscritos: ${response.statusCode}');
    }
  }

  @override
  Future<List<CourseModel>> getMyCourses() async {
    final response = await _apiClient.get(ApiConstants.myCourses);

    if (response.statusCode == 200) {
      // Verificar si la respuesta es paginada o un array directo
      final responseData = response.data;
      final List<dynamic> data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
        // Respuesta paginada
        data = responseData['results'] as List<dynamic>;
      } else {
        // Array directo
        data = responseData as List<dynamic>;
      }
      
      return data.map((json) => CourseModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener mis cursos: ${response.statusCode}');
    }
  }

  @override
  Future<void> markSectionCompleted(int sectionId) async {
    final response = await _apiClient.post(
      ApiConstants.markSectionCompleted(sectionId),
      data: {},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al marcar sección como completada: ${response.statusCode}');
    }
  }
}
