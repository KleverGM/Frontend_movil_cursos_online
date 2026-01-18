import '../../domain/entities/review_stats.dart';

/// Modelo de estadísticas de reseñas para la capa de datos
class ReviewStatsModel extends ReviewStats {
  const ReviewStatsModel({
    required super.calificacionPromedio,
    required super.totalResenas,
    required super.distribucionEstrellas,
  });

  factory ReviewStatsModel.fromJson(Map<String, dynamic> json) {
    final distribucion = <int, int>{};
    if (json['distribucion_estrellas'] != null) {
      final dist = json['distribucion_estrellas'] as Map<String, dynamic>;
      dist.forEach((key, value) {
        distribucion[int.parse(key)] = value as int;
      });
    }

    return ReviewStatsModel(
      calificacionPromedio: (json['calificacion_promedio'] as num?)?.toDouble() ?? 0.0,
      totalResenas: json['total_resenas'] as int? ?? 0,
      distribucionEstrellas: distribucion,
    );
  }
}
