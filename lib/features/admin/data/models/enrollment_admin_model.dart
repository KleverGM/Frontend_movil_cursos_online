import '../../domain/entities/enrollment_admin.dart';

/// Modelo de inscripción para la capa de datos
class EnrollmentAdminModel extends EnrollmentAdmin {
  const EnrollmentAdminModel({
    required super.id,
    required super.cursoId,
    required super.cursoTitulo,
    super.cursoImagen,
    required super.usuarioId,
    required super.usuarioNombre,
    required super.usuarioEmail,
    required super.fechaInscripcion,
    required super.progreso,
    super.fechaCompletado,
    required super.completado,
  });

  factory EnrollmentAdminModel.fromJson(Map<String, dynamic> json) {
    // El backend devuelve objetos curso y usuario anidados
    final curso = json['curso'] as Map<String, dynamic>?;
    final usuario = json['usuario'] as Map<String, dynamic>?;

    // Parsear progreso que puede venir como String o num
    double parseProgreso(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return EnrollmentAdminModel(
      id: json['id'] as int,
      cursoId: curso?['id'] as int? ?? 0,
      cursoTitulo: curso?['titulo'] as String? ?? 'Curso sin nombre',
      cursoImagen: curso?['imagen'] as String?,
      usuarioId: usuario?['id'] as int? ?? 0,
      usuarioNombre: '${usuario?['first_name'] ?? ''} ${usuario?['last_name'] ?? ''}'.trim(),
      usuarioEmail: usuario?['email'] as String? ?? '',
      fechaInscripcion: DateTime.parse(json['fecha_inscripcion'] as String),
      progreso: parseProgreso(json['progreso']),
      fechaCompletado: json['fecha_completado'] != null
          ? DateTime.parse(json['fecha_completado'] as String)
          : null,
      completado: json['completado'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'curso': cursoId,
      'usuario': usuarioId,
      'fecha_inscripcion': fechaInscripcion.toIso8601String(),
      'progreso': progreso,
      'fecha_completado': fechaCompletado?.toIso8601String(),
      'completado': completado,
    };
  }
}
