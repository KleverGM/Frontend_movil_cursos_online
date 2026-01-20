import 'package:equatable/equatable.dart';

/// Estadísticas detalladas de un curso para el admin
class CourseStatsAdmin extends Equatable {
  final int totalEstudiantes;
  final int estudiantesActivos;
  final int estudiantesCompletados;
  final double tasaCompletacion;
  final double progresoPromedio;
  final double calificacionPromedio;
  final int totalResenas;
  final double ingresosTotales;
  final Map<String, int> distribucionCalificaciones;

  const CourseStatsAdmin({
    required this.totalEstudiantes,
    required this.estudiantesActivos,
    required this.estudiantesCompletados,
    required this.tasaCompletacion,
    required this.progresoPromedio,
    required this.calificacionPromedio,
    required this.totalResenas,
    required this.ingresosTotales,
    required this.distribucionCalificaciones,
  });

  @override
  List<Object?> get props => [
        totalEstudiantes,
        estudiantesActivos,
        estudiantesCompletados,
        tasaCompletacion,
        progresoPromedio,
        calificacionPromedio,
        totalResenas,
        ingresosTotales,
        distribucionCalificaciones,
      ];
}
