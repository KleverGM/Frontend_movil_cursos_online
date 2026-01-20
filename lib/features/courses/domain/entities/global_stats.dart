import 'package:equatable/equatable.dart';

/// Entidad de estadísticas globales de la plataforma
class GlobalStats extends Equatable {
  final int totalUsuarios;
  final int totalCursos;
  final int totalInscripciones;
  final int totalIngresos;
  final double tasaCrecimientoUsuarios; // Porcentaje
  final double tasaCrecimientoCursos; // Porcentaje
  final Map<String, int> cursosPorCategoria;
  final List<CrecimientoUsuario> crecimientoUsuarios;
  final List<InstructorTop> topInstructores;
  final List<ActividadReciente> actividadReciente;

  const GlobalStats({
    required this.totalUsuarios,
    required this.totalCursos,
    required this.totalInscripciones,
    required this.totalIngresos,
    required this.tasaCrecimientoUsuarios,
    required this.tasaCrecimientoCursos,
    required this.cursosPorCategoria,
    required this.crecimientoUsuarios,
    required this.topInstructores,
    required this.actividadReciente,
  });

  @override
  List<Object?> get props => [
        totalUsuarios,
        totalCursos,
        totalInscripciones,
        totalIngresos,
        tasaCrecimientoUsuarios,
        tasaCrecimientoCursos,
        cursosPorCategoria,
        crecimientoUsuarios,
        topInstructores,
        actividadReciente,
      ];
}

/// Datos de crecimiento de usuarios por mes
class CrecimientoUsuario extends Equatable {
  final String mes; // ej: "Ene", "Feb"
  final int cantidad;

  const CrecimientoUsuario({
    required this.mes,
    required this.cantidad,
  });

  @override
  List<Object?> get props => [mes, cantidad];
}

/// Datos de instructores destacados
class InstructorTop extends Equatable {
  final int id;
  final String nombre;
  final String? avatar;
  final int totalCursos;
  final int totalEstudiantes;
  final double calificacionPromedio;

  const InstructorTop({
    required this.id,
    required this.nombre,
    this.avatar,
    required this.totalCursos,
    required this.totalEstudiantes,
    required this.calificacionPromedio,
  });

  @override
  List<Object?> get props => [
        id,
        nombre,
        avatar,
        totalCursos,
        totalEstudiantes,
        calificacionPromedio,
      ];
}

/// Actividad reciente en la plataforma
class ActividadReciente extends Equatable {
  final String tipo; // 'inscripcion', 'curso_nuevo', 'resena'
  final String descripcion;
  final DateTime fecha;
  final String? usuarioNombre;

  const ActividadReciente({
    required this.tipo,
    required this.descripcion,
    required this.fecha,
    this.usuarioNombre,
  });

  @override
  List<Object?> get props => [tipo, descripcion, fecha, usuarioNombre];
}
