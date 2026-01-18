import '../../domain/entities/course_stats.dart';

/// Modelo de estadísticas del curso para la capa de datos
class CourseStatsModel extends CourseStats {
  const CourseStatsModel({
    required super.totalEstudiantes,
    required super.estudiantesActivos,
    required super.estudiantesCompletados,
    required super.promedioProgreso,
    required super.ratingPromedio,
    required super.totalResenas,
    required super.distribucionRatings,
    required super.nuevosEstudiantesSemana,
    required super.nuevasResenasSemana,
    required super.completadosSemana,
    required super.ingresosTotales,
  });

  factory CourseStatsModel.fromJson(Map<String, dynamic> json) {
    // Convertir distribución de ratings
    final distribucion = <int, int>{};
    if (json['distribucion_ratings'] != null) {
      final dist = json['distribucion_ratings'] as Map<String, dynamic>;
      dist.forEach((key, value) {
        distribucion[int.parse(key)] = value as int;
      });
    }

    return CourseStatsModel(
      totalEstudiantes: json['total_estudiantes'] ?? 0,
      estudiantesActivos: json['estudiantes_activos'] ?? 0,
      estudiantesCompletados: json['estudiantes_completados'] ?? 0,
      promedioProgreso: (json['promedio_progreso'] ?? 0).toDouble(),
      ratingPromedio: (json['rating_promedio'] ?? 0).toDouble(),
      totalResenas: json['total_resenas'] ?? 0,
      distribucionRatings: distribucion,
      nuevosEstudiantesSemana: json['nuevos_estudiantes_semana'] ?? 0,
      nuevasResenasSemana: json['nuevas_resenas_semana'] ?? 0,
      completadosSemana: json['completados_semana'] ?? 0,
      ingresosTotales: (json['ingresos_totales'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final distribucion = <String, int>{};
    distribucionRatings.forEach((key, value) {
      distribucion[key.toString()] = value;
    });

    return {
      'total_estudiantes': totalEstudiantes,
      'estudiantes_activos': estudiantesActivos,
      'estudiantes_completados': estudiantesCompletados,
      'promedio_progreso': promedioProgreso,
      'rating_promedio': ratingPromedio,
      'total_resenas': totalResenas,
      'distribucion_ratings': distribucion,
      'nuevos_estudiantes_semana': nuevosEstudiantesSemana,
      'nuevas_resenas_semana': nuevasResenasSemana,
      'completados_semana': completadosSemana,
      'ingresos_totales': ingresosTotales,
    };
  }
}
