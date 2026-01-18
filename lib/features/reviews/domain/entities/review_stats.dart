import 'package:equatable/equatable.dart';

/// Estadísticas de reseñas de un curso
class ReviewStats extends Equatable {
  final double calificacionPromedio;
  final int totalResenas;
  final Map<int, int> distribucionEstrellas;

  const ReviewStats({
    required this.calificacionPromedio,
    required this.totalResenas,
    required this.distribucionEstrellas,
  });

  @override
  List<Object?> get props => [
        calificacionPromedio,
        totalResenas,
        distribucionEstrellas,
      ];
}
