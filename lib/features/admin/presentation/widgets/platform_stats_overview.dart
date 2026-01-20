import 'package:flutter/material.dart';
import '../../domain/entities/platform_stats.dart';
import 'simple_stat_card.dart';

class PlatformStatsOverview extends StatelessWidget {
  final PlatformStats stats;

  const PlatformStatsOverview({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.6,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            SimpleStatCard(
              title: 'Total Usuarios',
              value: '${stats.totalUsuarios}',
              icon: Icons.people,
              color: Colors.blue,
              subtitle: '${stats.usuariosActivos} activos',
            ),
            SimpleStatCard(
              title: 'Total Cursos',
              value: '${stats.totalCursos}',
              icon: Icons.school,
              color: Colors.green,
              subtitle: '${stats.cursosActivos} activos',
            ),
            SimpleStatCard(
              title: 'Inscripciones',
              value: '${stats.totalInscripciones}',
              icon: Icons.assignment,
              color: Colors.orange,
              subtitle: 'Total inscritos',
            ),
            SimpleStatCard(
              title: 'Eventos',
              value: '${stats.totalEventos}',
              icon: Icons.analytics,
              color: Colors.purple,
              subtitle: 'Registros totales',
            ),
          ],
        ),
        // Distribución de usuarios por rol
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distribución de Usuarios',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildRoleRow(
                    context,
                    'Estudiantes',
                    stats.totalEstudiantes,
                    stats.totalUsuarios,
                    Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  _buildRoleRow(
                    context,
                    'Instructores',
                    stats.totalInstructores,
                    stats.totalUsuarios,
                    Colors.green,
                  ),
                  const SizedBox(height: 8),
                  _buildRoleRow(
                    context,
                    'Administradores',
                    stats.totalAdministradores,
                    stats.totalUsuarios,
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleRow(
    BuildContext context,
    String label,
    int count,
    int total,
    Color color,
  ) {
    final percentage = total > 0 ? (count / total) * 100 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '$count (${percentage.toStringAsFixed(1)}%)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: color.withOpacity( 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}
