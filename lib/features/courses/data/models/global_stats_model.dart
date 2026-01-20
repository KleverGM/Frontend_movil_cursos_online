import '../../domain/entities/global_stats.dart';

/// Modelo de estadísticas globales
class GlobalStatsModel extends GlobalStats {
  const GlobalStatsModel({
    required super.totalUsuarios,
    required super.totalCursos,
    required super.totalInscripciones,
    required super.totalIngresos,
    required super.tasaCrecimientoUsuarios,
    required super.tasaCrecimientoCursos,
    required super.cursosPorCategoria,
    required super.crecimientoUsuarios,
    required super.topInstructores,
    required super.actividadReciente,
  });

  factory GlobalStatsModel.fromJson(Map<String, dynamic> json) {
    return GlobalStatsModel(
      totalUsuarios: json['total_usuarios'] ?? 0,
      totalCursos: json['total_cursos'] ?? 0,
      totalInscripciones: json['total_inscripciones'] ?? 0,
      totalIngresos: (json['total_ingresos'] ?? 0).toInt(),
      tasaCrecimientoUsuarios:
          (json['tasa_crecimiento_usuarios'] ?? 0.0).toDouble(),
      tasaCrecimientoCursos:
          (json['tasa_crecimiento_cursos'] ?? 0.0).toDouble(),
      cursosPorCategoria: Map<String, int>.from(
        json['cursos_por_categoria'] ?? {},
      ),
      crecimientoUsuarios: (json['crecimiento_usuarios'] as List?)
              ?.map((e) => CrecimientoUsuarioModel.fromJson(e))
              .toList() ??
          [],
      topInstructores: (json['top_instructores'] as List?)
              ?.map((e) => InstructorTopModel.fromJson(e))
              .toList() ??
          [],
      actividadReciente: (json['actividad_reciente'] as List?)
              ?.map((e) => ActividadRecienteModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_usuarios': totalUsuarios,
      'total_cursos': totalCursos,
      'total_inscripciones': totalInscripciones,
      'total_ingresos': totalIngresos,
      'tasa_crecimiento_usuarios': tasaCrecimientoUsuarios,
      'tasa_crecimiento_cursos': tasaCrecimientoCursos,
      'cursos_por_categoria': cursosPorCategoria,
      'crecimiento_usuarios': crecimientoUsuarios
          .map((e) => (e as CrecimientoUsuarioModel).toJson())
          .toList(),
      'top_instructores': topInstructores
          .map((e) => (e as InstructorTopModel).toJson())
          .toList(),
      'actividad_reciente': actividadReciente
          .map((e) => (e as ActividadRecienteModel).toJson())
          .toList(),
    };
  }
}

class CrecimientoUsuarioModel extends CrecimientoUsuario {
  const CrecimientoUsuarioModel({
    required super.mes,
    required super.cantidad,
  });

  factory CrecimientoUsuarioModel.fromJson(Map<String, dynamic> json) {
    return CrecimientoUsuarioModel(
      mes: json['mes'] ?? '',
      cantidad: json['cantidad'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mes': mes,
      'cantidad': cantidad,
    };
  }
}

class InstructorTopModel extends InstructorTop {
  const InstructorTopModel({
    required super.id,
    required super.nombre,
    super.avatar,
    required super.totalCursos,
    required super.totalEstudiantes,
    required super.calificacionPromedio,
  });

  factory InstructorTopModel.fromJson(Map<String, dynamic> json) {
    return InstructorTopModel(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      avatar: json['avatar'],
      totalCursos: json['total_cursos'] ?? 0,
      totalEstudiantes: json['total_estudiantes'] ?? 0,
      calificacionPromedio:
          (json['calificacion_promedio'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'avatar': avatar,
      'total_cursos': totalCursos,
      'total_estudiantes': totalEstudiantes,
      'calificacion_promedio': calificacionPromedio,
    };
  }
}

class ActividadRecienteModel extends ActividadReciente {
  const ActividadRecienteModel({
    required super.tipo,
    required super.descripcion,
    required super.fecha,
    super.usuarioNombre,
  });

  factory ActividadRecienteModel.fromJson(Map<String, dynamic> json) {
    return ActividadRecienteModel(
      tipo: json['tipo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toIso8601String()),
      usuarioNombre: json['usuario_nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
      'usuario_nombre': usuarioNombre,
    };
  }
}
