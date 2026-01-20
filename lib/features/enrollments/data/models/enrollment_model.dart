import '../../domain/entities/enrollment.dart';

/// Modelo de datos para inscripción
class EnrollmentModel extends Enrollment {
  const EnrollmentModel({
    required super.id,
    required super.usuarioId,
    required super.usuarioNombre,
    super.usuarioEmail,
    required super.cursoId,
    required super.cursoTitulo,
    required super.fechaInscripcion,
    required super.progreso,
    required super.completado,
    super.fechaCompletado,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'] as int,
      usuarioId: json['usuario']?['id'] ?? json['usuario_id'] ?? 0,
      usuarioNombre: json['usuario']?['nombre_completo'] ?? 
                      '${json['usuario']?['first_name'] ?? ''} ${json['usuario']?['last_name'] ?? ''}'.trim(),
      usuarioEmail: json['usuario']?['email'],
      cursoId: json['curso']?['id'] ?? json['curso_id'] ?? 0,
      cursoTitulo: json['curso']?['titulo'] ?? json['curso_titulo'] ?? '',
      fechaInscripcion: DateTime.parse(json['fecha_inscripcion'] as String),
      progreso: _parseDouble(json['progreso']),
      completado: json['completado'] as bool? ?? false,
      fechaCompletado: json['fecha_completado'] != null
          ? DateTime.parse(json['fecha_completado'] as String)
          : null,
    );
  }

  /// Parsea un valor que puede ser String o num a double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'curso_id': cursoId,
      'fecha_inscripcion': fechaInscripcion.toIso8601String(),
      'progreso': progreso,
      'completado': completado,
      'fecha_completado': fechaCompletado?.toIso8601String(),
    };
  }

  Enrollment toEntity() {
    return Enrollment(
      id: id,
      usuarioId: usuarioId,
      usuarioNombre: usuarioNombre,
      usuarioEmail: usuarioEmail,
      cursoId: cursoId,
      cursoTitulo: cursoTitulo,
      fechaInscripcion: fechaInscripcion,
      progreso: progreso,
      completado: completado,
      fechaCompletado: fechaCompletado,
    );
  }
}
