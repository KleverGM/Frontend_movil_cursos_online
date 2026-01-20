import '../../domain/entities/course_stats_admin.dart';

/// Modelo de estadísticas de curso para admin
class CourseStatsAdminModel extends CourseStatsAdmin {
  const CourseStatsAdminModel({
    required super.totalEstudiantes,
    required super.estudiantesActivos,
    required super.estudiantesCompletados,
    required super.tasaCompletacion,
    required super.progresoPromedio,
    required super.calificacionPromedio,
    required super.totalResenas,
    required super.ingresosTotales,
    required super.distribucionCalificaciones,
  });

  factory CourseStatsAdminModel.fromJson(Map<String, dynamic> json) {
    return CourseStatsAdminModel(
      totalEstudiantes: json['total_estudiantes'] as int? ?? 0,
      estudiantesActivos: json['estudiantes_activos'] as int? ?? 0,
      estudiantesCompletados: json['estudiantes_completados'] as int? ?? 0,
      tasaCompletacion: (json['tasa_completacion'] as num?)?.toDouble() ?? 0.0,
      progresoPromedio: (json['progreso_promedio'] as num?)?.toDouble() ?? 0.0,
      calificacionPromedio: (json['calificacion_promedio'] as num?)?.toDouble() ?? 0.0,
      totalResenas: json['total_resenas'] as int? ?? 0,
      ingresosTotales: (json['ingresos_totales'] is String)
          ? double.parse(json['ingresos_totales'] as String)
          : (json['ingresos_totales'] as num?)?.toDouble() ?? 0.0,
      distribucionCalificaciones:
          _parseDistribucionCalificaciones(json['distribucion_calificaciones']),
    );
  }

  static Map<String, int> _parseDistribucionCalificaciones(dynamic data) {
    if (data == null) return {};
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value as int));
    }
    return {};
  }
}
