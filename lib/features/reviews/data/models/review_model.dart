import '../../domain/entities/review.dart';

/// Modelo de reseña para la capa de datos
class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.cursoId,
    required super.estudianteId,
    required super.estudianteNombre,
    required super.calificacion,
    required super.comentario,
    required super.fechaCreacion,
    super.utilesCount,
    super.marcadoUtilPorMi,
    super.respuestaInstructor,
    super.fechaRespuesta,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      cursoId: json['curso_id'] as int,
      estudianteId: json['usuario_id'] as int,
      estudianteNombre: json['nombre_usuario'] as String? ?? 'Anónimo',
      calificacion: (json['rating'] as num).toInt(),
      comentario: json['comentario'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      utilesCount: json['util_count'] as int? ?? 0,
      marcadoUtilPorMi: (json['usuarios_util'] as List?)?.contains(json['usuario_id']) ?? false,
      respuestaInstructor: null, // Extraer de respuestas si existe
      fechaRespuesta: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'curso': cursoId,
      'estudiante': estudianteId,
      'estudiante_nombre': estudianteNombre,
      'calificacion': calificacion,
      'comentario': comentario,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'utiles_count': utilesCount,
      'marcado_util_por_mi': marcadoUtilPorMi,
      'respuesta_instructor': respuestaInstructor,
      'fecha_respuesta': fechaRespuesta?.toIso8601String(),
    };
  }
}
