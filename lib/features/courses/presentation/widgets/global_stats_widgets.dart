import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/global_stats.dart';

/// Tarjeta de estadística global con tendencia opcional
class GlobalStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;

  const GlobalStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity( 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      trend!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid de tarjetas de estadísticas principales
class GlobalStatsCardsGrid extends StatelessWidget {
  final GlobalStats stats;

  const GlobalStatsCardsGrid({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'es_ES');

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GlobalStatCard(
                title: 'Total Usuarios',
                value: formatter.format(stats.totalUsuarios),
                icon: Icons.people,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlobalStatCard(
                title: 'Total Cursos',
                value: formatter.format(stats.totalCursos),
                icon: Icons.school,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GlobalStatCard(
                title: 'Inscripciones',
                value: formatter.format(stats.totalInscripciones),
                icon: Icons.assignment,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlobalStatCard(
                title: 'Ingresos',
                value: '\$${formatter.format(stats.totalIngresos)}',
                icon: Icons.attach_money,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Gráfico de distribución de cursos por categoría
class CategoryDistributionChart extends StatelessWidget {
  final Map<String, int> categorias;

  const CategoryDistributionChart({
    super.key,
    required this.categorias,
  });

  @override
  Widget build(BuildContext context) {
    if (categorias.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text('No hay cursos disponibles'),
          ),
        ),
      );
    }

    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: Row(
            children: [
              // Gráfico de torta
              Expanded(
                flex: 2,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: categorias.entries.toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final categoria = entry.value;
                      final total = categorias.values.reduce((a, b) => a + b);
                      final percentage = (categoria.value / total * 100).toStringAsFixed(1);

                      return PieChartSectionData(
                        color: colors[index % colors.length],
                        value: categoria.value.toDouble(),
                        title: '$percentage%',
                        radius: 80,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Leyenda
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: categorias.entries.toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final categoria = entry.value;
                      final categoryName = categoria.key.replaceFirst(
                        categoria.key[0],
                        categoria.key[0].toUpperCase(),
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: colors[index % colors.length],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '$categoryName (${categoria.value})',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lista de top instructores
class TopInstructorsList extends StatelessWidget {
  final List<InstructorTop> instructores;

  const TopInstructorsList({
    super.key,
    required this.instructores,
  });

  @override
  Widget build(BuildContext context) {
    if (instructores.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text('No hay instructores disponibles'),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: instructores.length > 5 ? 5 : instructores.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final instructor = instructores[index];
          final formatter = NumberFormat('#,###', 'es_ES');

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              instructor.nombre,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text('${instructor.totalCursos} cursos'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      instructor.calificacionPromedio.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${formatter.format(instructor.totalEstudiantes)} estudiantes',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Título de sección reutilizable
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
