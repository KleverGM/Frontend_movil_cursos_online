import 'package:equatable/equatable.dart';
import 'review_response.dart';

/// Entidad de reseña del dominio
class Review extends Equatable {
  final String id;
  final int cursoId;
  final String cursoTitulo;
  final int estudianteId;
  final String estudianteNombre;
  final int calificacion;
  final String comentario;
  final DateTime fechaCreacion;
  final int utilesCount;
  final bool marcadoUtilPorMi;
  final String? respuestaInstructor;
  final DateTime? fechaRespuesta;
  final List<ReviewResponse> respuestas;

  const Review({
    required this.id,
    required this.cursoId,
    required this.cursoTitulo,
    required this.estudianteId,
    required this.estudianteNombre,
    required this.calificacion,
    required this.comentario,
    required this.fechaCreacion,
    this.utilesCount = 0,
    this.marcadoUtilPorMi = false,
    this.respuestaInstructor,
    this.fechaRespuesta,
    this.respuestas = const [],
  });

  /// Obtiene la respuesta más reciente del instructor
  String? get respuestaInstructorActual {
    if (respuestas.isEmpty) return respuestaInstructor;
    
    final instructorResponses = respuestas
        .where((r) => r.esDelInstructor)
        .toList();
    
    if (instructorResponses.isEmpty) return respuestaInstructor;
    
    // Ordenar por fecha y obtener la más reciente
    instructorResponses.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
    return instructorResponses.first.texto;
  }

  @override
  List<Object?> get props => [
        id,
        cursoId,
        cursoTitulo,
        estudianteId,
        estudianteNombre,
        calificacion,
        comentario,
        fechaCreacion,
        utilesCount,
        marcadoUtilPorMi,
        respuestaInstructor,
        fechaRespuesta,
        respuestas,
      ];
}
