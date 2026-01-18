import 'package:equatable/equatable.dart';

/// Entidad para estadísticas detalladas de un curso
class CourseStats extends Equatable {
  final int totalEstudiantes;
  final int estudiantesActivos;
  final int estudiantesCompletados;
  final double promedioProgreso;
  final double ratingPromedio;
  final int totalResenas;
  final Map<int, int> distribucionRatings; // {5: 10, 4: 5, etc}
  final int nuevosEstudiantesSemana;
  final int nuevasResenasSemana;
  final int completadosSemana;
  final double ingresosTotales;

  const CourseStats({
    required this.totalEstudiantes,
    required this.estudiantesActivos,
    required this.estudiantesCompletados,
    required this.promedioProgreso,
    required this.ratingPromedio,
    required this.totalResenas,
    required this.distribucionRatings,
    required this.nuevosEstudiantesSemana,
    required this.nuevasResenasSemana,
    required this.completadosSemana,
    required this.ingresosTotales,
  });

  @override
  List<Object?> get props => [
        totalEstudiantes,
        estudiantesActivos,
        estudiantesCompletados,
        promedioProgreso,
        ratingPromedio,
        totalResenas,
        distribucionRatings,
        nuevosEstudiantesSemana,
        nuevasResenasSemana,
        completadosSemana,
        ingresosTotales,
      ];
}
