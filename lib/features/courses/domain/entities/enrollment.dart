import 'package:equatable/equatable.dart';

/// Entidad de inscripción del dominio
class Enrollment extends Equatable {
  final int id;
  final int usuarioId;
  final int cursoId;
  final DateTime fechaInscripcion;
  final double progreso;
  final bool completado;
  final DateTime? fechaCompletado;

  const Enrollment({
    required this.id,
    required this.usuarioId,
    required this.cursoId,
    required this.fechaInscripcion,
    this.progreso = 0.0,
    this.completado = false,
    this.fechaCompletado,
  });

  bool get enProgreso => progreso > 0 && !completado;
  bool get noIniciado => progreso == 0;
  int get progresoEntero => progreso.round();

  @override
  List<Object?> get props => [
        id,
        usuarioId,
        cursoId,
        fechaInscripcion,
        progreso,
        completado,
        fechaCompletado,
      ];
}
