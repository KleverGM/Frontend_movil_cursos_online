import 'package:equatable/equatable.dart';

/// Entidad de reseña del dominio
class Review extends Equatable {
  final String id;
  final int cursoId;
  final int estudianteId;
  final String estudianteNombre;
  final int calificacion;
  final String comentario;
  final DateTime fechaCreacion;
  final int utilesCount;
  final bool marcadoUtilPorMi;
  final String? respuestaInstructor;
  final DateTime? fechaRespuesta;

  const Review({
    required this.id,
    required this.cursoId,
    required this.estudianteId,
    required this.estudianteNombre,
    required this.calificacion,
    required this.comentario,
    required this.fechaCreacion,
    this.utilesCount = 0,
    this.marcadoUtilPorMi = false,
    this.respuestaInstructor,
    this.fechaRespuesta,
  });

  @override
  List<Object?> get props => [
        id,
        cursoId,
        estudianteId,
        estudianteNombre,
        calificacion,
        comentario,
        fechaCreacion,
        utilesCount,
        marcadoUtilPorMi,
        respuestaInstructor,
        fechaRespuesta,
      ];
}
