import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/course_filters.dart';
import '../models/course_detail_model.dart';
import '../models/course_model.dart';
import '../models/enrollment_model.dart';
import '../models/enrollment_detail_model.dart';
import '../models/course_stats_model.dart';
import '../models/global_stats_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses({CourseFilters? filters});

  Future<CourseDetailModel> getCourseDetail(int courseId);

  Future<EnrollmentModel> enrollInCourse(int courseId);

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
  
  /// Activar un curso
  Future<CourseModel> activateCourse(int courseId);
  
  /// Desactivar un curso
  Future<CourseModel> deactivateCourse(int courseId);
  
  /// Obtener inscripciones de los cursos del instructor
  Future<List<EnrollmentDetailModel>> getInstructorEnrollments({int? courseId});
  
  /// Obtener estadísticas detalladas de un curso
  Future<CourseStatsModel> getCourseStats(int courseId);
  
  /// Obtener estadísticas globales de la plataforma (solo administradores)
  Future<GlobalStatsModel> getGlobalStats();
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

    print('🔍 getEnrolledCourses - Status: ${response.statusCode}');
    print('🔍 getEnrolledCourses - Data: ${response.data}');

    if (response.statusCode == 200) {
      // Verificar si la respuesta es paginada o un array directo
      final responseData = response.data;
      final List<dynamic> data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
        // Respuesta paginada
        data = responseData['results'] as List<dynamic>;
      } else if (responseData is List) {
        // Array directo
        data = responseData as List<dynamic>;
      } else {
        // Podría ser un objeto con key diferente o vacío
        print('⚠️ Formato inesperado de respuesta: $responseData');
        return [];
      }
      
      print('🔍 Total inscripciones encontradas: ${data.length}');
      
      // Las inscripciones vienen con objeto curso anidado
      final courses = data
          .map((json) {
            final enrollment = json as Map<String, dynamic>;
            if (enrollment['curso'] != null) {
              // Agregar el progreso del enrollment al objeto curso
              final cursoData = Map<String, dynamic>.from(enrollment['curso'] as Map<String, dynamic>);
              cursoData['progreso'] = enrollment['progreso'];
              return CourseModel.fromJson(cursoData);
            }
            return null;
          })
          .whereType<CourseModel>()
          .toList();
      
      print('🔍 Cursos procesados: ${courses.length}');
      return courses;
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
    try {
      final response = await _apiClient.post(
        ApiConstants.markSectionCompleted(sectionId),
        data: {},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al marcar sección como completada: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('La conexión tardó demasiado. Verifica tu internet e intenta de nuevo.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No se pudo conectar al servidor. Verifica tu conexión a internet.');
      }
      throw Exception('Error al marcar sección como completada: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al marcar sección: ${e.toString()}');
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
    final formData = <String, dynamic>{
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'nivel': nivel,
      'precio': precio.toString(),
      'activo': true,
    };

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
    try {
      final response = await _apiClient.delete(
        ApiConstants.courseDetail(courseId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar curso: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception('No tienes permisos para eliminar este curso');
      } else if (e.response?.statusCode == 400) {
        final error = e.response?.data;
        if (error is Map && error.containsKey('error')) {
          throw Exception(error['error']);
        }
        throw Exception('No se puede eliminar el curso: ${e.response?.data}');
      }
      throw Exception('Error al eliminar curso: ${e.message}');
    }
  }

  @override
  Future<CourseModel> activateCourse(int courseId) async {
    final response = await _apiClient.post(
      '${ApiConstants.courseDetail(courseId)}/activar/',
      data: {},
    );

    if (response.statusCode == 200) {
      return CourseModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al activar curso: ${response.statusCode}');
    }
  }

  @override
  Future<CourseModel> deactivateCourse(int courseId) async {
    final response = await _apiClient.post(
      '${ApiConstants.courseDetail(courseId)}/desactivar/',
      data: {},
    );

    if (response.statusCode == 200) {
      return CourseModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al desactivar curso: ${response.statusCode}');
    }
  }

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

  @override
  Future<CourseStatsModel> getCourseStats(int courseId) async {
    final response = await _apiClient.get(
      '${ApiConstants.courseDetail(courseId)}/estadisticas/',
    );

    if (response.statusCode == 200) {
      return CourseStatsModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al obtener estadísticas del curso: ${response.statusCode}');
    }
  }

  @override
  Future<GlobalStatsModel> getGlobalStats() async {
    try {
      final coursesResponse = await _apiClient.get(ApiConstants.courses);
      final coursesData = coursesResponse.data as Map<String, dynamic>;
      final int totalCursos = coursesData['count'] ?? 0;
      final List<dynamic> cursos = coursesData['results'] as List<dynamic>;
      
      int totalEstudiantes = 0;
      double totalIngresos = 0;
      final Map<String, int> cursosPorCategoria = {};
      final Map<int, Map<String, dynamic>> instructoresMap = {};
      
      for (var curso in cursos) {
        final estudiantes = curso['total_estudiantes'] as int? ?? 0;
        totalEstudiantes += estudiantes;
        
        final precioValue = curso['precio'];
        double precio = 0.0;
        if (precioValue is String) {
          precio = double.tryParse(precioValue) ?? 0.0;
        } else if (precioValue is num) {
          precio = precioValue.toDouble();
        }
        totalIngresos += precio * estudiantes;
        
        final categoria = curso['categoria'] as String? ?? 'otros';
        cursosPorCategoria[categoria] = (cursosPorCategoria[categoria] ?? 0) + 1;
        
        final instructor = curso['instructor'];
        if (instructor is Map) {
          final instructorId = instructor['id'] as int?;
          if (instructorId != null) {
            if (!instructoresMap.containsKey(instructorId)) {
              String nombre = 'Instructor';
              final firstName = instructor['first_name'];
              final lastName = instructor['last_name'];
              if (firstName != null && firstName.toString().isNotEmpty) {
                nombre = '$firstName ${lastName ?? ''}'.trim();
              } else if (instructor['username'] != null) {
                nombre = instructor['username'].toString();
              }
              
              instructoresMap[instructorId] = {
                'id': instructorId,
                'nombre': nombre,
                'avatar': instructor['avatar'],
                'total_cursos': 0,
                'total_estudiantes': 0,
                'calificacion_promedio': 4.5,
              };
            }
            instructoresMap[instructorId]!['total_cursos'] = 
                (instructoresMap[instructorId]!['total_cursos'] as int) + 1;
            instructoresMap[instructorId]!['total_estudiantes'] = 
                (instructoresMap[instructorId]!['total_estudiantes'] as int) + estudiantes;
          }
        }
      }
      
      final topInstructores = instructoresMap.values.toList()
        ..sort((a, b) => (b['total_estudiantes'] as int).compareTo(a['total_estudiantes'] as int));
      
      return GlobalStatsModel(
        totalUsuarios: totalEstudiantes,
        totalCursos: totalCursos,
        totalInscripciones: totalEstudiantes,
        totalIngresos: totalIngresos.toInt(),
        tasaCrecimientoUsuarios: 0.0,
        tasaCrecimientoCursos: 0.0,
        cursosPorCategoria: cursosPorCategoria,
        crecimientoUsuarios: [],
        topInstructores: topInstructores.take(5).map((e) => 
          InstructorTopModel.fromJson(e)
        ).toList(),
        actividadReciente: [],
      );
    } catch (e) {
      throw Exception('Error al obtener estadísticas globales: $e');
    }
  }
}
