import 'package:equatable/equatable.dart';

/// Entidad que representa las estadísticas globales de la plataforma
class PlatformStats extends Equatable {
  final int totalUsuarios;
  final int totalCursos;
  final int totalInscripciones;
  final int usuariosActivos;
  final int cursosActivos;
  final int totalInstructores;
  final int totalEstudiantes;
  final int totalAdministradores;
  final Map<String, int> eventosPorTipo;
  final Map<String, int> eventosPorDia;
  final int periodoDias;

  const PlatformStats({
    required this.totalUsuarios,
    required this.totalCursos,
    required this.totalInscripciones,
    required this.usuariosActivos,
    required this.cursosActivos,
    required this.totalInstructores,
    required this.totalEstudiantes,
    required this.totalAdministradores,
    required this.eventosPorTipo,
    required this.eventosPorDia,
    this.periodoDias = 7,
  });

  double get promedioInscripcionesPorCurso =>
      totalCursos > 0 ? totalInscripciones / totalCursos : 0.0;

  double get tasaUsuariosActivos =>
      totalUsuarios > 0 ? (usuariosActivos / totalUsuarios) * 100 : 0.0;

  int get totalEventos => eventosPorTipo.values.fold(0, (a, b) => a + b);

  @override
  List<Object?> get props => [
        totalUsuarios,
        totalCursos,
        totalInscripciones,
        usuariosActivos,
        cursosActivos,
        totalInstructores,
        totalEstudiantes,
        totalAdministradores,
        eventosPorTipo,
        eventosPorDia,
        periodoDias,
      ];
}
