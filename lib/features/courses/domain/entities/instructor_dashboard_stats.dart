import 'package:equatable/equatable.dart';

/// Entidad para estadísticas completas del dashboard de instructor
class InstructorDashboardStats extends Equatable {
  // Stats de cursos
  final int totalCursos;
  final int cursosActivos;
  final int cursosInactivos;
  
  // Stats de estudiantes
  final int totalEstudiantes;
  
  // Stats de reseñas
  final int totalResenas;
  final double calificacionPromedio;
  final int resenasSinResponder;
  final Map<int, int> distribucionRatings; // {5: count, 4: count, ...}
  
  // Stats financieros
  final double ingresosEstimados;
  final double ingresosMesActual;
  
  // Engagement
  final double tasaCompletado; // Promedio de cursos completados
  final int seccionesCreadas;
  final int modulosCreados;
  
  // Top cursos
  final List<CoursePerformance> topCursos;
  
  // Actividad reciente
  final DateTime? ultimaActualizacion;

  const InstructorDashboardStats({
    required this.totalCursos,
    required this.cursosActivos,
    required this.cursosInactivos,
    required this.totalEstudiantes,
    required this.totalResenas,
    required this.calificacionPromedio,
    required this.resenasSinResponder,
    required this.distribucionRatings,
    required this.ingresosEstimados,
    required this.ingresosMesActual,
    required this.tasaCompletado,
    required this.seccionesCreadas,
    required this.modulosCreados,
    required this.topCursos,
    this.ultimaActualizacion,
  });

  @override
  List<Object?> get props => [
        totalCursos,
        cursosActivos,
        cursosInactivos,
        totalEstudiantes,
        totalResenas,
        calificacionPromedio,
        resenasSinResponder,
        distribucionRatings,
        ingresosEstimados,
        ingresosMesActual,
        tasaCompletado,
        seccionesCreadas,
        modulosCreados,
        topCursos,
        ultimaActualizacion,
      ];
}

/// Rendimiento de un curso individual
class CoursePerformance extends Equatable {
  final int cursoId;
  final String titulo;
  final int totalEstudiantes;
  final double calificacionPromedio;
  final int totalResenas;
  final double tasaCompletado;
  final double ingresos;

  const CoursePerformance({
    required this.cursoId,
    required this.titulo,
    required this.totalEstudiantes,
    required this.calificacionPromedio,
    required this.totalResenas,
    required this.tasaCompletado,
    required this.ingresos,
  });

  @override
  List<Object?> get props => [
        cursoId,
        titulo,
        totalEstudiantes,
        calificacionPromedio,
        totalResenas,
        tasaCompletado,
        ingresos,
      ];
}
