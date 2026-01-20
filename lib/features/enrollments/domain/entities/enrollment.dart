import 'package:equatable/equatable.dart';

/// Entidad que representa una inscripción de estudiante a un curso
class Enrollment extends Equatable {
  final int id;
  final int usuarioId;
  final String usuarioNombre;
  final String? usuarioEmail;
  final int cursoId;
  final String cursoTitulo;
  final DateTime fechaInscripcion;
  final double progreso;
  final bool completado;
  final DateTime? fechaCompletado;

  const Enrollment({
    required this.id,
    required this.usuarioId,
    required this.usuarioNombre,
    this.usuarioEmail,
    required this.cursoId,
    required this.cursoTitulo,
    required this.fechaInscripcion,
    required this.progreso,
    required this.completado,
    this.fechaCompletado,
  });

  /// Progreso formateado como porcentaje
  String get progresoFormateado => '${progreso.toInt()}%';

  /// Días desde la inscripción
  int get diasDesdeInscripcion {
    return DateTime.now().difference(fechaInscripcion).inDays;
  }

  /// Estado del estudiante: completado, activo o inactivo
  String get estadoEstudiante {
    if (completado) return 'Completado';
    if (progreso > 0) return 'Activo';
    return 'Inactivo';
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
