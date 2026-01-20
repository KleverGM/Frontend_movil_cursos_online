import '../../domain/entities/analytics_entities.dart';

class CourseAnalyticsModel extends CourseAnalytics {
  const CourseAnalyticsModel({
    required super.cursoId,
    required super.vistas,
    required super.usuariosUnicos,
    super.cursoTitulo,
    super.ingresos,
  });

  factory CourseAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return CourseAnalyticsModel(
      cursoId: json['curso_id'] as int,
      vistas: json['vistas'] as int,
      usuariosUnicos: json['usuarios_unicos'] as int,
      cursoTitulo: json['curso_titulo'] as String?,
      ingresos: (json['ingresos'] as num?)?.toDouble(),
    );
  }
}

class InstructorAnalyticsModel extends InstructorAnalytics {
  const InstructorAnalyticsModel({
    required super.instructorId,
    required super.instructorNombre,
    required super.totalCursos,
    required super.totalEstudiantes,
    required super.totalIngresos,
    required super.promedioCalificacion,
  });

  factory InstructorAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return InstructorAnalyticsModel(
      instructorId: json['instructor_id'] as int,
      instructorNombre: json['instructor_nombre'] as String,
      totalCursos: json['total_cursos'] as int,
      totalEstudiantes: json['total_estudiantes'] as int,
      totalIngresos: (json['total_ingresos'] as num).toDouble(),
      promedioCalificacion: (json['promedio_calificacion'] as num).toDouble(),
    );
  }
}

class UserGrowthModel extends UserGrowth {
  const UserGrowthModel({
    required super.fecha,
    required super.nuevosUsuarios,
    required super.usuariosActivos,
    required super.totalUsuarios,
  });

  factory UserGrowthModel.fromJson(Map<String, dynamic> json) {
    return UserGrowthModel(
      fecha: json['fecha'] as String,
      nuevosUsuarios: json['nuevos_usuarios'] as int,
      usuariosActivos: json['usuarios_activos'] as int,
      totalUsuarios: json['total_usuarios'] as int,
    );
  }
}

class GlobalTrendsModel extends GlobalTrends {
  const GlobalTrendsModel({
    required super.periodoDias,
    required super.totalEventos,
    required super.usuariosActivos,
    required super.eventosPorTipo,
    required super.eventosPorDia,
  });

  factory GlobalTrendsModel.fromJson(Map<String, dynamic> json) {
    return GlobalTrendsModel(
      periodoDias: json['periodo_dias'] as int,
      totalEventos: json['total_eventos'] as int,
      usuariosActivos: json['usuarios_activos'] as int,
      eventosPorTipo: Map<String, int>.from(json['eventos_por_tipo'] as Map? ?? {}),
      eventosPorDia: Map<String, int>.from(json['eventos_por_dia'] as Map? ?? {}),
    );
  }
}

class CourseStatsModel extends CourseStats {
  const CourseStatsModel({
    required super.cursoId,
    required super.vistas,
    required super.inscripciones,
    required super.tasaConversion,
    required super.tiempoPromedioEnCurso,
    required super.progresoDistribucion,
  });

  factory CourseStatsModel.fromJson(Map<String, dynamic> json) {
    return CourseStatsModel(
      cursoId: json['curso_id'] as int,
      vistas: json['vistas'] as int,
      inscripciones: json['inscripciones'] as int,
      tasaConversion: (json['tasa_conversion'] as num).toDouble(),
      tiempoPromedioEnCurso: (json['tiempo_promedio'] as num).toDouble(),
      progresoDistribucion: Map<String, int>.from(json['progreso_distribucion'] as Map? ?? {}),
    );
  }
}
