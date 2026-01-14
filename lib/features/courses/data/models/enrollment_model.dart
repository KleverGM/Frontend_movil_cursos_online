import '../../domain/entities/enrollment.dart';

/// Modelo de inscripción para la capa de datos
class EnrollmentModel extends Enrollment {
  const EnrollmentModel({
    required super.id,
    required super.usuarioId,
    required super.cursoId,
    required super.fechaInscripcion,
    super.progreso,
    super.completado,
    super.fechaCompletado,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'] as int,
      usuarioId: json['usuario_id'] as int? ?? json['usuario']['id'] as int,
      cursoId: json['curso_id'] as int? ?? json['curso']['id'] as int,
      fechaInscripcion: DateTime.parse(json['fecha_inscripcion'] as String),
      progreso: (json['progreso'] is String)
          ? double.parse(json['progreso'] as String)
          : (json['progreso'] as num?)?.toDouble() ?? 0.0,
      completado: json['completado'] as bool? ?? false,
      fechaCompletado: json['fecha_completado'] != null
          ? DateTime.parse(json['fecha_completado'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'curso_id': cursoId,
      'fecha_inscripcion': fechaInscripcion.toIso8601String(),
      'progreso': progreso.toString(),
      'completado': completado,
      'fecha_completado': fechaCompletado?.toIso8601String(),
    };
  }

  factory EnrollmentModel.fromEntity(Enrollment enrollment) {
    return EnrollmentModel(
      id: enrollment.id,
      usuarioId: enrollment.usuarioId,
      cursoId: enrollment.cursoId,
      fechaInscripcion: enrollment.fechaInscripcion,
      progreso: enrollment.progreso,
      completado: enrollment.completado,
      fechaCompletado: enrollment.fechaCompletado,
    );
  }
}
