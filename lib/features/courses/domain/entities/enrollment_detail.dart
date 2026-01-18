import 'package:equatable/equatable.dart';

/// Entidad detallada de inscripción con información del estudiante y curso
class EnrollmentDetail extends Equatable {
  final int id;
  final int usuarioId;
  final String usuarioNombre;
  final String usuarioEmail;
  final int cursoId;
  final String cursoTitulo;
  final DateTime fechaInscripcion;
  final double progreso;
  final bool completado;
  final DateTime? fechaCompletado;

  const EnrollmentDetail({
    required this.id,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.usuarioEmail,
    required this.cursoId,
    required this.cursoTitulo,
    required this.fechaInscripcion,
    this.progreso = 0.0,
    this.completado = false,
    this.fechaCompletado,
  });

  bool get enProgreso => progreso > 0 && !completado;
  bool get noIniciado => progreso == 0;
  int get progresoEntero => progreso.round();

  String get estadoTexto {
    if (completado) return 'Completado';
    if (enProgreso) return 'En progreso';
    return 'No iniciado';
  }

  @override
  List<Object?> get props => [
        id,
        usuarioId,
        usuarioNombre,
        usuarioEmail,
        cursoId,
        cursoTitulo,
        fechaInscripcion,
        progreso,
        completado,
        fechaCompletado,
      ];
}
