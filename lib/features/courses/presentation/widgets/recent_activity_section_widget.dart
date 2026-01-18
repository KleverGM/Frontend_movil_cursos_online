import 'package:flutter/material.dart';
import 'activity_item_widget.dart';

/// Widget para la sección de actividad reciente
class RecentActivitySectionWidget extends StatelessWidget {
  final int nuevosEstudiantesSemana;
  final int nuevasResenasSemana;
  final int completadosSemana;

  const RecentActivitySectionWidget({
    super.key,
    required this.nuevosEstudiantesSemana,
    required this.nuevasResenasSemana,
    required this.completadosSemana,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actividad Reciente (últimos 7 días)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ActivityItemWidget(
              icon: Icons.person_add,
              title: 'Nuevos estudiantes',
              subtitle: 'Últimos 7 días',
              value: nuevosEstudiantesSemana.toString(),
              color: Colors.blue,
            ),
            const Divider(height: 24),
            ActivityItemWidget(
              icon: Icons.rate_review,
              title: 'Nuevas reseñas',
              subtitle: 'Últimos 7 días',
              value: nuevasResenasSemana.toString(),
              color: Colors.orange,
            ),
            const Divider(height: 24),
            ActivityItemWidget(
              icon: Icons.check_circle,
              title: 'Cursos completados',
              subtitle: 'Últimos 7 días',
              value: completadosSemana.toString(),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
