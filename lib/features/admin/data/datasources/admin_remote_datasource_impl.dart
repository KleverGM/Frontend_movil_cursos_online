import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../courses/data/models/course_model.dart';
import 'package:dio/dio.dart' as dio;
import '../models/course_stats_admin_model.dart';
import '../models/enrollment_admin_model.dart';
import '../models/platform_stats_model.dart';
import '../models/popular_course_model.dart';
import '../models/user_summary_model.dart';
import 'admin_remote_datasource.dart';

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final ApiClient apiClient;
  final AuthLocalDataSource authLocalDataSource;

  AdminRemoteDataSourceImpl({
    required this.apiClient,
    required this.authLocalDataSource,
  });

  @override
  Future<PlatformStatsModel> getPlatformStats({int dias = 7}) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      // Llamar a múltiples endpoints y combinar resultados
      final analyticsResponse = await apiClient.get(
        ApiConstants.globalStats,
        queryParameters: {'dias': dias},
      );

      final usersResponse = await apiClient.get(ApiConstants.users);
      final coursesResponse = await apiClient.get(ApiConstants.courses);
      final enrollmentsResponse = await apiClient.get(ApiConstants.enrollments);

      // Extraer datos de analytics
      final analyticsData = analyticsResponse.data as Map<String, dynamic>;

      // Contar usuarios por rol
      final usersList = (usersResponse.data is List)
          ? usersResponse.data as List
          : (usersResponse.data['results'] as List? ?? []);

      int totalInstructores = 0;
      int totalEstudiantes = 0;
      int totalAdministradores = 0;

      for (var user in usersList) {
        final perfil = user['perfil'] ?? user['tipo_usuario'] ?? '';
        switch (perfil) {
          case 'instructor':
            totalInstructores++;
            break;
          case 'estudiante':
            totalEstudiantes++;
            break;
          case 'administrador':
            totalAdministradores++;
            break;
        }
      }

      // Contar cursos activos
      final coursesList = (coursesResponse.data is List)
          ? coursesResponse.data as List
          : (coursesResponse.data['results'] as List? ?? []);

      final cursosActivos = coursesList.where((c) => c['activo'] == true).length;

      // Contar inscripciones
      final enrollmentsList = (enrollmentsResponse.data is List)
          ? enrollmentsResponse.data as List
          : (enrollmentsResponse.data['results'] as List? ?? []);

      // Combinar en un solo modelo
      final combinedData = {
        'total_usuarios': usersList.length,
        'total_cursos': coursesList.length,
        'total_inscripciones': enrollmentsList.length,
        'usuarios_activos': analyticsData['usuarios_activos'] ?? 0,
        'cursos_activos': cursosActivos,
        'total_instructores': totalInstructores,
        'total_estudiantes': totalEstudiantes,
        'total_administradores': totalAdministradores,
        'eventos_por_tipo': analyticsData['eventos_por_tipo'] ?? {},
        'eventos_por_dia': analyticsData['eventos_por_dia'] ?? {},
        'periodo_dias': dias,
      };

      return PlatformStatsModel.fromJson(combinedData);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PopularCourseModel>> getPopularCourses({int dias = 30}) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final response = await apiClient.get(
        ApiConstants.popularCourses,
        queryParameters: {'dias': dias},
      );

      final data = response.data;
      List<dynamic> cursosData;

      // Manejar diferentes estructuras de respuesta
      if (data is Map && data.containsKey('cursos')) {
        cursosData = data['cursos'] as List;
      } else if (data is Map && data.containsKey('results')) {
        cursosData = data['results'] as List;
      } else if (data is List) {
        cursosData = data;
      } else {
        cursosData = [];
      }

      return cursosData
          .map((json) => PopularCourseModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserSummaryModel>> getUsers({
    String? perfil,
    bool? isActive,
    String? search,
  }) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final queryParams = <String, dynamic>{};
      if (perfil != null) queryParams['perfil'] = perfil;
      if (isActive != null) queryParams['is_active'] = isActive;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await apiClient.get(
        ApiConstants.users,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      List<dynamic> usersData;

      if (data is Map && data.containsKey('results')) {
        usersData = data['results'] as List;
      } else if (data is List) {
        usersData = data;
      } else {
        usersData = [];
      }

      return usersData
          .map((json) => UserSummaryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, int>> getUserCountByRole() async {
    try {
      final users = await getUsers();
      final Map<String, int> counts = {
        'estudiante': 0,
        'instructor': 0,
        'administrador': 0,
      };

      for (var user in users) {
        counts[user.perfil] = (counts[user.perfil] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<int> getActiveCourseCount() async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final response = await apiClient.get(ApiConstants.courses);

      final data = response.data;
      List<dynamic> coursesData;

      if (data is Map && data.containsKey('results')) {
        coursesData = data['results'] as List;
      } else if (data is List) {
        coursesData = data;
      } else {
        return 0;
      }

      return coursesData.where((c) => c['activo'] == true).length;
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<int> getTotalEnrollmentCount() async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final response = await apiClient.get(ApiConstants.enrollments);

      final data = response.data;

      if (data is Map && data.containsKey('count')) {
        return data['count'] as int;
      } else if (data is Map && data.containsKey('results')) {
        return (data['results'] as List).length;
      } else if (data is List) {
        return data.length;
      }

      return 0;
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserSummaryModel> createUser({
    required String username,
    required String email,
    required String password,
    required String perfil,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final response = await apiClient.post(
        ApiConstants.users,
        data: {
          'username': username,
          'email': email,
          'password': password,
          'tipo_usuario': perfil,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
        },
      );

      return UserSummaryModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserSummaryModel> updateUser({
    required int userId,
    String? username,
    String? email,
    String? perfil,
    String? firstName,
    String? lastName,
    bool? isActive,
  }) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final data = <String, dynamic>{};
      if (username != null) data['username'] = username;
      if (email != null) data['email'] = email;
      if (perfil != null) data['perfil'] = perfil;  // Enviar perfil directamente, no tipo_usuario
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (isActive != null) data['is_active'] = isActive;

      final response = await apiClient.patch(
        '${ApiConstants.users}$userId/',
        data: data,
      );

      return UserSummaryModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteUser(int userId) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      await apiClient.delete('${ApiConstants.users}$userId/');
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> changeUserPassword({
    required int userId,
    required String newPassword,
  }) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      await apiClient.post(
        '${ApiConstants.users}$userId/cambiar_password/',
        data: {
          'new_password': newPassword,
        },
      );
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  // ==================== COURSES MANAGEMENT ====================

  @override
  Future<List<CourseModel>> getAllCourses({
    String? categoria,
    String? nivel,
    String? search,
    bool? activo,
    int? instructorId,
  }) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final queryParams = <String, dynamic>{};
      if (categoria != null) queryParams['categoria'] = categoria;
      if (nivel != null) queryParams['nivel'] = nivel;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (activo != null) queryParams['activo'] = activo;
      if (instructorId != null) queryParams['instructor'] = instructorId;

      final response = await apiClient.get(
        ApiConstants.courses,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      List<dynamic> coursesData;

      if (data is Map && data.containsKey('results')) {
        coursesData = data['results'] as List;
      } else if (data is List) {
        coursesData = data;
      } else {
        coursesData = [];
      }

      return coursesData
          .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CourseModel> createCourseAsAdmin({
    required String titulo,
    required String descripcion,
    required String categoria,
    required String nivel,
    required double precio,
    required int instructorId,
    String? imagenPath,
  }) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final formData = dio.FormData.fromMap({
        'titulo': titulo,
        'descripcion': descripcion,
        'categoria': categoria,
        'nivel': nivel,
        'precio': precio.toString(),
        'instructor_id': instructorId,
        'activo': true,
      });

      // Si hay imagen, agregarla al FormData
      if (imagenPath != null) {
        formData.files.add(
          MapEntry(
            'imagen',
            await dio.MultipartFile.fromFile(imagenPath),
          ),
        );
      }

      final response = await apiClient.post(
        ApiConstants.courses,
        data: formData,
      );

      return CourseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CourseModel> updateCourseAsAdmin({
    required int courseId,
    String? titulo,
    String? descripcion,
    String? categoria,
    String? nivel,
    double? precio,
    int? instructorId,
    String? imagenPath,
  }) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final dataMap = <String, dynamic>{};
      if (titulo != null) dataMap['titulo'] = titulo;
      if (descripcion != null) dataMap['descripcion'] = descripcion;
      if (categoria != null) dataMap['categoria'] = categoria;
      if (nivel != null) dataMap['nivel'] = nivel;
      if (precio != null) dataMap['precio'] = precio.toString();
      if (instructorId != null) dataMap['instructor_id'] = instructorId;

      dynamic requestData;
      if (imagenPath != null) {
        // Si hay imagen, usar FormData
        final formData = dio.FormData.fromMap(dataMap);
        formData.files.add(
          MapEntry(
            'imagen',
            await dio.MultipartFile.fromFile(imagenPath),
          ),
        );
        requestData = formData;
      } else {
        requestData = dataMap;
      }

      final response = await apiClient.put(
        '${ApiConstants.courses}$courseId/',
        data: requestData,
      );

      return CourseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteCourseAsAdmin(int courseId) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      await apiClient.delete('${ApiConstants.courses}$courseId/');
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 400 && e.response?.data != null) {
        // Error específico del backend (ej: curso con estudiantes inscritos)
        final errorMessage = e.response?.data['error'] ?? 'No se puede eliminar el curso';
        throw ServerException(errorMessage);
      }
      throw ServerException(e.toString());
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CourseModel> activateCourse(int courseId) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final response = await apiClient.post(
        '${ApiConstants.courses}$courseId/activar/',
      );

      return CourseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CourseModel> deactivateCourse(int courseId) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final response = await apiClient.post(
        '${ApiConstants.courses}$courseId/desactivar/',
      );

      return CourseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CourseStatsAdminModel> getCourseStatistics(int courseId) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final response = await apiClient.get(
        '${ApiConstants.courses}$courseId/estadisticas/',
      );

      return CourseStatsAdminModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<EnrollmentAdminModel>> getAllEnrollments({
    int? cursoId,
    int? usuarioId,
    bool? completado,
  }) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final queryParams = <String, dynamic>{};
      if (cursoId != null) queryParams['curso'] = cursoId;
      if (usuarioId != null) queryParams['usuario'] = usuarioId;
      if (completado != null) queryParams['completado'] = completado;

      final response = await apiClient.get(
        ApiConstants.enrollments,
        queryParameters: queryParams,
      );

      final List<dynamic> enrollmentsJson = response.data is List
          ? response.data as List
          : (response.data['results'] as List? ?? []);

      return enrollmentsJson
          .map((json) => EnrollmentAdminModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<EnrollmentAdminModel> createEnrollment({
    required int cursoId,
    required int usuarioId,
  }) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final response = await apiClient.post(
        ApiConstants.enrollments,
        data: {
          'curso_id': cursoId,
          'usuario_id': usuarioId,
        },
      );

      return EnrollmentAdminModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<EnrollmentAdminModel> updateEnrollment({
    required int enrollmentId,
    double? progreso,
    bool? completado,
    int? cursoId,
    int? usuarioId,
  }) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      final data = <String, dynamic>{};
      // Convertir progreso a String con 2 decimales para evitar problemas de precisión
      if (progreso != null) data['progreso'] = progreso.toStringAsFixed(2);
      if (completado != null) data['completado'] = completado;
      if (cursoId != null) data['curso_id'] = cursoId;
      if (usuarioId != null) data['usuario_id'] = usuarioId;

      final response = await apiClient.patch(
        '${ApiConstants.enrollments}$enrollmentId/',
        data: data,
      );

      return EnrollmentAdminModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteEnrollment(int enrollmentId) async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      if (token == null) throw const AuthenticationException();

      await apiClient.delete('${ApiConstants.enrollments}$enrollmentId/');
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
