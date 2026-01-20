import 'package:equatable/equatable.dart';

/// Entidad que representa un curso popular con estadísticas
class PopularCourse extends Equatable {
  final int cursoId;
  final String titulo;
  final int vistas;
  final int inscripciones;
  final String? imagenUrl;
  final String categoria;
  final String nivel;

  const PopularCourse({
    required this.cursoId,
    required this.titulo,
    required this.vistas,
    required this.inscripciones,
    this.imagenUrl,
    required this.categoria,
    required this.nivel,
  });

  double get conversionRate => vistas > 0 ? (inscripciones / vistas) * 100 : 0.0;

  @override
  List<Object?> get props => [
        cursoId,
        titulo,
        vistas,
        inscripciones,
        imagenUrl,
        categoria,
        nivel,
      ];
}
