import 'package:flutter/material.dart';
import 'stat_card_widget.dart';

/// Widget para mostrar las tarjetas de estadísticas principales
class StatsCardsRowWidget extends StatelessWidget {
  final int totalEstudiantes;
  final double ratingPromedio;
  final double ingresosTotales;

  const StatsCardsRowWidget({
    super.key,
    required this.totalEstudiantes,
    required this.ratingPromedio,
    required this.ingresosTotales,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCardWidget(
            icon: Icons.people_alt,
            label: 'Estudiantes',
            value: totalEstudiantes.toString(),
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCardWidget(
            icon: Icons.star,
            label: 'Calificación',
            value: ratingPromedio.toStringAsFixed(1),
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCardWidget(
            icon: Icons.attach_money,
            label: 'Ingresos',
            value: '\$${ingresosTotales.toStringAsFixed(0)}',
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
