import 'package:equatable/equatable.dart';

/// Entidad de Analytics para cursos populares
class CourseAnalytics extends Equatable {
  final int cursoId;
  final int vistas;
  final int usuariosUnicos;
  final String? cursoTitulo;
  final double? ingresos;

  const CourseAnalytics({
    required this.cursoId,
    required this.vistas,
    required this.usuariosUnicos,
    this.cursoTitulo,
    this.ingresos,
  });

  @override
  List<Object?> get props => [cursoId, vistas, usuariosUnicos, cursoTitulo, ingresos];
}

/// Entidad de Analytics de instructor
class InstructorAnalytics extends Equatable {
  final int instructorId;
  final String instructorNombre;
  final int totalCursos;
  final int totalEstudiantes;
  final double totalIngresos;
  final double promedioCalificacion;

  const InstructorAnalytics({
    required this.instructorId,
    required this.instructorNombre,
    required this.totalCursos,
    required this.totalEstudiantes,
    required this.totalIngresos,
    required this.promedioCalificacion,
  });

  @override
  List<Object> get props => [
        instructorId,
        instructorNombre,
        totalCursos,
        totalEstudiantes,
        totalIngresos,
        promedioCalificacion,
      ];
}

/// Entidad de evolución de usuarios en el tiempo
class UserGrowth extends Equatable {
  final String fecha;
  final int nuevosUsuarios;
  final int usuariosActivos;
  final int totalUsuarios;

  const UserGrowth({
    required this.fecha,
    required this.nuevosUsuarios,
    required this.usuariosActivos,
    required this.totalUsuarios,
  });

  @override
  List<Object> get props => [fecha, nuevosUsuarios, usuariosActivos, totalUsuarios];
}

/// Entidad de tendencias globales
class GlobalTrends extends Equatable {
  final int periodoDias;
  final int totalEventos;
  final int usuariosActivos;
  final Map<String, int> eventosPorTipo;
  final Map<String, int> eventosPorDia;

  const GlobalTrends({
    required this.periodoDias,
    required this.totalEventos,
    required this.usuariosActivos,
    required this.eventosPorTipo,
    required this.eventosPorDia,
  });

  @override
  List<Object> get props => [
        periodoDias,
        totalEventos,
        usuariosActivos,
        eventosPorTipo,
        eventosPorDia,
      ];
}

/// Entidad de estadísticas de curso individual
class CourseStats extends Equatable {
  final int cursoId;
  final int vistas;
  final int inscripciones;
  final double tasaConversion;
  final double tiempoPromedioEnCurso;
  final Map<String, int> progresoDistribucion;

  const CourseStats({
    required this.cursoId,
    required this.vistas,
    required this.inscripciones,
    required this.tasaConversion,
    required this.tiempoPromedioEnCurso,
    required this.progresoDistribucion,
  });

  @override
  List<Object> get props => [
        cursoId,
        vistas,
        inscripciones,
        tasaConversion,
        tiempoPromedioEnCurso,
        progresoDistribucion,
      ];
}
