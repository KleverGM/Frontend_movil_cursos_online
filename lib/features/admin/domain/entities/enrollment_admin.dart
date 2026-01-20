import 'package:equatable/equatable.dart';

/// Entidad de inscripción para gestión de admin
class EnrollmentAdmin extends Equatable {
  final int id;
  final int cursoId;
  final String cursoTitulo;
  final String? cursoImagen;
  final int usuarioId;
  final String usuarioNombre;
  final String usuarioEmail;
  final DateTime fechaInscripcion;
  final double progreso;
  final DateTime? fechaCompletado;
  final bool completado;

  const EnrollmentAdmin({
    required this.id,
    required this.cursoId,
    required this.cursoTitulo,
    this.cursoImagen,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.usuarioEmail,
    required this.fechaInscripcion,
    required this.progreso,
    this.fechaCompletado,
    required this.completado,
  });

  @override
  List<Object?> get props => [
        id,
        cursoId,
        cursoTitulo,
        cursoImagen,
        usuarioId,
        usuarioNombre,
        usuarioEmail,
        fechaInscripcion,
        progreso,
        fechaCompletado,
        completado,
      ];
}
