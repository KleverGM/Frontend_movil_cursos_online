import '../../domain/entities/review_response.dart';

/// Modelo de respuesta a reseña para la capa de datos
class ReviewResponseModel extends ReviewResponse {
  const ReviewResponseModel({
    required super.usuarioId,
    required super.texto,
    required super.fechaCreacion,
    required super.esDelInstructor,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json, {int? instructorId}) {
    final usuarioId = json['usuario_id'] as int;
    final esDelInstructor = instructorId != null && usuarioId == instructorId;
    
    return ReviewResponseModel(
      usuarioId: usuarioId,
      texto: json['texto'] as String,
      fechaCreacion: DateTime.parse(json['fecha'] as String),
      esDelInstructor: esDelInstructor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'texto': texto,
      'fecha': fechaCreacion.toIso8601String(),
    };
  }
}
