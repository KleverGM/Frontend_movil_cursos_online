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
      id: json['_id'] as String,
      cursoId: json['curso'] as int,
      estudianteId: json['estudiante'] as int,
      estudianteNombre: json['estudiante_nombre'] as String? ?? 'Anónimo',
      calificacion: json['calificacion'] as int,
      comentario: json['comentario'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      utilesCount: json['utiles_count'] as int? ?? 0,
      marcadoUtilPorMi: json['marcado_util_por_mi'] as bool? ?? false,
      respuestaInstructor: json['respuesta_instructor'] as String?,
      fechaRespuesta: json['fecha_respuesta'] != null
          ? DateTime.parse(json['fecha_respuesta'] as String)
          : null,
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
