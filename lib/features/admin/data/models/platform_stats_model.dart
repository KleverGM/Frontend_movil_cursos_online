import '../../domain/entities/platform_stats.dart';

class PlatformStatsModel extends PlatformStats {
  const PlatformStatsModel({
    required super.totalUsuarios,
    required super.totalCursos,
    required super.totalInscripciones,
    required super.usuariosActivos,
    required super.cursosActivos,
    required super.totalInstructores,
    required super.totalEstudiantes,
    required super.totalAdministradores,
    required super.eventosPorTipo,
    required super.eventosPorDia,
    super.periodoDias,
  });

  factory PlatformStatsModel.fromJson(Map<String, dynamic> json) {
    // Parsear eventos por tipo
    Map<String, int> eventosPorTipo = {};
    if (json['eventos_por_tipo'] != null) {
      (json['eventos_por_tipo'] as Map<String, dynamic>).forEach((key, value) {
        eventosPorTipo[key] = value is int ? value : int.tryParse(value.toString()) ?? 0;
      });
    }

    // Parsear eventos por día
    Map<String, int> eventosPorDia = {};
    if (json['eventos_por_dia'] != null) {
      (json['eventos_por_dia'] as Map<String, dynamic>).forEach((key, value) {
        eventosPorDia[key] = value is int ? value : int.tryParse(value.toString()) ?? 0;
      });
    }

    return PlatformStatsModel(
      totalUsuarios: json['total_usuarios'] ?? 0,
      totalCursos: json['total_cursos'] ?? 0,
      totalInscripciones: json['total_inscripciones'] ?? 0,
      usuariosActivos: json['usuarios_activos'] ?? 0,
      cursosActivos: json['cursos_activos'] ?? 0,
      totalInstructores: json['total_instructores'] ?? 0,
      totalEstudiantes: json['total_estudiantes'] ?? 0,
      totalAdministradores: json['total_administradores'] ?? 0,
      eventosPorTipo: eventosPorTipo,
      eventosPorDia: eventosPorDia,
      periodoDias: json['periodo_dias'] ?? 7,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_usuarios': totalUsuarios,
      'total_cursos': totalCursos,
      'total_inscripciones': totalInscripciones,
      'usuarios_activos': usuariosActivos,
      'cursos_activos': cursosActivos,
      'total_instructores': totalInstructores,
      'total_estudiantes': totalEstudiantes,
      'total_administradores': totalAdministradores,
      'eventos_por_tipo': eventosPorTipo,
      'eventos_por_dia': eventosPorDia,
      'periodo_dias': periodoDias,
    };
  }
}
