import '../../domain/entities/enrollment_detail.dart';

/// Modelo de inscripción detallada para la capa de datos
class EnrollmentDetailModel extends EnrollmentDetail {
  const EnrollmentDetailModel({
    required super.id,
    required super.usuarioId,
    required super.usuarioNombre,
    required super.usuarioEmail,
    required super.cursoId,
    required super.cursoTitulo,
    required super.fechaInscripcion,
    super.progreso,
    super.completado,
    super.fechaCompletado,
  });

  factory EnrollmentDetailModel.fromJson(Map<String, dynamic> json) {
    // Extraer información del usuario
    final usuario = json['usuario'] as Map<String, dynamic>?;
    final usuarioId = json['usuario_id'] as int? ?? usuario?['id'] as int;
    
    String usuarioNombre = 'Usuario desconocido';
    if (usuario != null) {
      final firstName = usuario['first_name'] as String? ?? '';
      final lastName = usuario['last_name'] as String? ?? '';
      if (firstName.isNotEmpty || lastName.isNotEmpty) {
        usuarioNombre = '$firstName $lastName'.trim();
      } else {
        usuarioNombre = usuario['username'] as String? ?? usuario['email'] as String? ?? 'Usuario';
      }
    }

    final usuarioEmail = usuario?['email'] as String? ?? 'No disponible';

    // Extraer información del curso
    final curso = json['curso'] as Map<String, dynamic>?;
    final cursoId = json['curso_id'] as int? ?? curso?['id'] as int;
    final cursoTitulo = curso?['titulo'] as String? ?? 'Curso desconocido';

    return EnrollmentDetailModel(
      id: json['id'] as int,
      usuarioId: usuarioId,
      usuarioNombre: usuarioNombre,
      usuarioEmail: usuarioEmail,
      cursoId: cursoId,
      cursoTitulo: cursoTitulo,
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
      'usuario_nombre': usuarioNombre,
      'usuario_email': usuarioEmail,
      'curso_id': cursoId,
      'curso_titulo': cursoTitulo,
      'fecha_inscripcion': fechaInscripcion.toIso8601String(),
      'progreso': progreso.toString(),
      'completado': completado,
      'fecha_completado': fechaCompletado?.toIso8601String(),
    };
  }
}
