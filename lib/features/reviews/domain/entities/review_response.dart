import 'package:equatable/equatable.dart';

/// Entidad de respuesta a una reseña
class ReviewResponse extends Equatable {
  final int usuarioId;
  final String texto;
  final DateTime fechaCreacion;
  final bool esDelInstructor;

  const ReviewResponse({
    required this.usuarioId,
    required this.texto,
    required this.fechaCreacion,
    required this.esDelInstructor,
  });

  @override
  List<Object?> get props => [usuarioId, texto, fechaCreacion, esDelInstructor];
}
