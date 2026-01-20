import '../../../../core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/analytics_models.dart';

abstract class AnalyticsRemoteDataSource {
  Future<List<CourseAnalyticsModel>> getPopularCourses(int days);
  Future<GlobalTrendsModel> getGlobalTrends(int days);
  Future<List<InstructorAnalyticsModel>> getInstructorRankings();
  Future<List<UserGrowthModel>> getUserGrowth(int days);
  Future<CourseStatsModel> getCourseStats(int cursoId, int days);
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final ApiClient _apiClient;

  AnalyticsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CourseAnalyticsModel>> getPopularCourses(int days) async {
    final response = await _apiClient.get(
      '/api/analytics/eventos/cursos_populares/',
      queryParameters: {'dias': days},
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final cursos = data['cursos'] as List<dynamic>? ?? [];
      
      return cursos
          .map((json) => CourseAnalyticsModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException('Error al obtener cursos populares: ${response.statusCode}');
    }
  }

  @override
  Future<GlobalTrendsModel> getGlobalTrends(int days) async {
    final response = await _apiClient.get(
      '/api/analytics/eventos/estadisticas_globales/',
      queryParameters: {'dias': days},
    );

    if (response.statusCode == 200) {
      return GlobalTrendsModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw ServerException('Error al obtener tendencias globales: ${response.statusCode}');
    }
  }

  @override
  Future<List<InstructorAnalyticsModel>> getInstructorRankings() async {
    // Este endpoint necesitaría ser implementado en el backend
    // Por ahora, calculamos desde los cursos
    final response = await _apiClient.get('/api/cursos/');

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final cursos = data['results'] as List<dynamic>? ?? [];
      
      // Agrupar por instructor y calcular estadísticas
      final Map<int, Map<String, dynamic>> instructoresStats = {};
      
      for (var curso in cursos) {
        final instructor = curso['instructor'] as Map<String, dynamic>;
        final instructorId = instructor['id'] as int;
        
        if (!instructoresStats.containsKey(instructorId)) {
          instructoresStats[instructorId] = {
            'instructor_id': instructorId,
            'instructor_nombre': '${instructor['first_name']} ${instructor['last_name']}'.trim(),
            'total_cursos': 0,
            'total_estudiantes': 0,
            'total_ingresos': 0.0,
            'promedio_calificacion': 0.0,
          };
        }
        
        instructoresStats[instructorId]!['total_cursos'] = 
            (instructoresStats[instructorId]!['total_cursos'] as int) + 1;
        instructoresStats[instructorId]!['total_estudiantes'] = 
            (instructoresStats[instructorId]!['total_estudiantes'] as int) + 
            (curso['total_estudiantes'] as int);
        
        final precio = double.tryParse(curso['precio']?.toString() ?? '0') ?? 0.0;
        final estudiantes = curso['total_estudiantes'] as int;
        instructoresStats[instructorId]!['total_ingresos'] = 
            (instructoresStats[instructorId]!['total_ingresos'] as double) + 
            (precio * estudiantes);
      }
      
      // Calcular promedio de calificación (simplificado)
      for (var stats in instructoresStats.values) {
        stats['promedio_calificacion'] = 4.5; // Placeholder
      }
      
      final instructores = instructoresStats.values
          .map((stats) => InstructorAnalyticsModel.fromJson(stats))
          .toList();
      
      instructores.sort((a, b) => b.totalEstudiantes.compareTo(a.totalEstudiantes));
      
      return instructores;
    } else {
      throw ServerException('Error al obtener rankings de instructores: ${response.statusCode}');
    }
  }

  @override
  Future<List<UserGrowthModel>> getUserGrowth(int days) async {
    // Este endpoint necesitaría ser implementado en el backend
    // Por ahora, obtenemos usuarios y simulamos crecimiento
    final response = await _apiClient.get('/api/users/');

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final usuarios = data['results'] as List<dynamic>? ?? [];
      
      // Agrupar por fecha de creación
      final Map<String, Map<String, int>> growth = {};
      
      for (var usuario in usuarios) {
        final fechaCreacion = DateTime.parse(usuario['fecha_creacion'] as String);
        final fecha = fechaCreacion.toIso8601String().substring(0, 10);
        
        if (!growth.containsKey(fecha)) {
          growth[fecha] = {
            'nuevos_usuarios': 0,
            'usuarios_activos': 0,
            'total_usuarios': 0,
          };
        }
        
        growth[fecha]!['nuevos_usuarios'] = growth[fecha]!['nuevos_usuarios']! + 1;
      }
      
      // Calcular acumulado
      int acumulado = 0;
      final fechasOrdenadas = growth.keys.toList()..sort();
      
      final growthList = <UserGrowthModel>[];
      for (var fecha in fechasOrdenadas) {
        acumulado += growth[fecha]!['nuevos_usuarios']!;
        growthList.add(UserGrowthModel(
          fecha: fecha,
          nuevosUsuarios: growth[fecha]!['nuevos_usuarios']!,
          usuariosActivos: growth[fecha]!['nuevos_usuarios']!, // Simplificado
          totalUsuarios: acumulado,
        ));
      }
      
      // Filtrar últimos N días
      if (growthList.length > days) {
        return growthList.sublist(growthList.length - days);
      }
      
      return growthList;
    } else {
      throw ServerException('Error al obtener crecimiento de usuarios: ${response.statusCode}');
    }
  }

  @override
  Future<CourseStatsModel> getCourseStats(int cursoId, int days) async {
    // Este endpoint necesitaría ser implementado en el backend
    // Por ahora retornamos datos simplificados
    final response = await _apiClient.get('/api/cursos/$cursoId/');

    if (response.statusCode == 200) {
      final curso = response.data as Map<String, dynamic>;
      
      return CourseStatsModel(
        cursoId: cursoId,
        vistas: 0, // Placeholder
        inscripciones: curso['total_estudiantes'] as int,
        tasaConversion: 0.0,
        tiempoPromedioEnCurso: 0.0,
        progresoDistribucion: {},
      );
    } else {
      throw ServerException('Error al obtener estadísticas del curso: ${response.statusCode}');
    }
  }
}
