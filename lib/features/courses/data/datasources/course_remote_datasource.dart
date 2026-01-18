import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/course_filters.dart';
import '../models/course_detail_model.dart';
import '../models/course_model.dart';
import '../models/enrollment_model.dart';
import '../models/enrollment_detail_model.dart';

/// DataSource remoto para cursos
abstract class CourseRemoteDataSource {
  /// Obtener lista de cursos con filtros
  Future<List<CourseModel>> getCourses({CourseFilters? filters});

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
  
  /// Crear un nuevo curso
  Future<CourseModel> createCourse({
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    String? imagenPath,
  });
  
  /// Actualizar un curso existente
  Future<CourseModel> updateCourse({
    required int courseId,
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    String? imagenPath,
  });
  
  /// Eliminar un curso (desactivación lógica)
  Future<void> deleteCourse(int courseId);
  
  /// Obtener inscripciones de los cursos del instructor
  Future<List<EnrollmentDetailModel>> getInstructorEnrollments({int? courseId});
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiClient _apiClient;

  CourseRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CourseModel>> getCourses({CourseFilters? filters}) async {
    // Construir query parameters
    final queryParams = <String, dynamic>{};
    
    if (filters != null) {
      if (filters.categoria != null) queryParams['categoria'] = filters.categoria;
      if (filters.nivel != null) queryParams['nivel'] = filters.nivel;
      if (filters.searchQuery != null) queryParams['search'] = filters.searchQuery;
      if (filters.ordenarPor != null) queryParams['ordering'] = filters.ordenarPor;
      // El backend no tiene filtro directo de precio min/max, pero podemos implementarlo en el frontend
    }

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
  
  @override
  Future<CourseModel> createCourse({
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    String? imagenPath,
  }) async {
    // Preparar datos del formulario
    final formData = <String, dynamic>{
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'nivel': nivel,
      'precio': precio.toString(),
    };
    
    // Si hay imagen, usar FormData para subir archivo
    if (imagenPath != null) {
      final dio = _apiClient.dio;
      final formDataDio = FormData.fromMap({
        ...formData,
        'imagen': await MultipartFile.fromFile(imagenPath),
      });
      
      final response = await dio.post(
        ApiConstants.courses,
        data: formDataDio,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CourseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Error al crear curso: ${response.statusCode}');
      }
    } else {
      // Sin imagen, usar JSON simple
      final response = await _apiClient.post(
        ApiConstants.courses,
        data: formData,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CourseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Error al crear curso: ${response.statusCode}');
      }
    }
  }
  
  @override
  Future<CourseModel> updateCourse({
    required int courseId,
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    String? imagenPath,
  }) async {
    // Preparar datos del formulario
    final formData = <String, dynamic>{
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'nivel': nivel,
      'precio': precio.toString(),
    };
    
    // Si hay imagen nueva, usar FormData
    if (imagenPath != null) {
      final dio = _apiClient.dio;
      final formDataDio = FormData.fromMap({
        ...formData,
        'imagen': await MultipartFile.fromFile(imagenPath),
      });
      
      final response = await dio.put(
        ApiConstants.courseDetail(courseId),
        data: formDataDio,
      );
      
      if (response.statusCode == 200) {
        return CourseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Error al actualizar curso: ${response.statusCode}');
      }
    } else {
      // Sin imagen nueva, usar PUT con JSON
      final response = await _apiClient.put(
        ApiConstants.courseDetail(courseId),
        data: formData,
      );
      
      if (response.statusCode == 200) {
        return CourseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Error al actualizar curso: ${response.statusCode}');
      }
    }
  }
  
  @override
  Future<void> deleteCourse(int courseId) async {
    final response = await _apiClient.delete(
      ApiConstants.courseDetail(courseId),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {

  @override
  Future<List<EnrollmentDetailModel>> getInstructorEnrollments({int? courseId}) async {
    // Construir query parameters
    final queryParams = <String, dynamic>{};
    if (courseId != null) {
      queryParams['curso'] = courseId;
    }

    final response = await _apiClient.get(
      ApiConstants.enrollments,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.statusCode == 200) {
      // La API puede devolver paginación o lista directa
      final dynamic responseData = response.data;
      final List<dynamic> data = responseData is Map<String, dynamic>
          ? (responseData['results'] as List<dynamic>? ?? [])
          : (responseData as List<dynamic>);
      
      return data.map((json) => EnrollmentDetailModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener inscripciones: ${response.statusCode}');
    }
  }
      throw Exception('Error al eliminar curso: ${response.statusCode}');
    }
  }
}
