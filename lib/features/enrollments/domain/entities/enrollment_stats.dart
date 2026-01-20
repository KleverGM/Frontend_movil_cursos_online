import 'package:equatable/equatable.dart';

/// Estadísticas agregadas de inscripciones
class EnrollmentStats extends Equatable {
  final int totalEstudiantes;
  final int estudiantesActivos;
  final int estudiantesCompletados;
  final int estudiantesInactivos;
  final double progresoPromedio;
  final int nuevosUltimaSemana;

  const EnrollmentStats({
    required this.totalEstudiantes,
    required this.estudiantesActivos,
    required this.estudiantesCompletados,
    required this.estudiantesInactivos,
    required this.progresoPromedio,
    required this.nuevosUltimaSemana,
  });

  /// Stats vacías por defecto
  static const empty = EnrollmentStats(
    totalEstudiantes: 0,
    estudiantesActivos: 0,
    estudiantesCompletados: 0,
    estudiantesInactivos: 0,
    progresoPromedio: 0.0,
    nuevosUltimaSemana: 0,
  );

  @override
  List<Object?> get props => [
        totalEstudiantes,
        estudiantesActivos,
        estudiantesCompletados,
        estudiantesInactivos,
        progresoPromedio,
        nuevosUltimaSemana,
      ];
}
