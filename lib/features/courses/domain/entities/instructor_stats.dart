import 'package:equatable/equatable.dart';

/// Entidad para estadísticas del instructor
class InstructorStats extends Equatable {
  final int totalCursos;
  final int totalEstudiantes;
  final double calificacionPromedio;
  final int totalResenas;
  final double ingresosEstimados;

  const InstructorStats({
    required this.totalCursos,
    required this.totalEstudiantes,
    required this.calificacionPromedio,
    required this.totalResenas,
    required this.ingresosEstimados,
  });

  @override
  List<Object?> get props => [
        totalCursos,
        totalEstudiantes,
        calificacionPromedio,
        totalResenas,
        ingresosEstimados,
      ];
}
