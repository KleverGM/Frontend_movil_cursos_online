import 'package:flutter/material.dart';
import '../../domain/entities/enrollment_detail.dart';

/// Widget reutilizable para mostrar estadísticas de progreso de estudiantes
class StudentStatsCard extends StatelessWidget {
  final List<EnrollmentDetail> enrollments;

  const StudentStatsCard({
    super.key,
    required this.enrollments,
  });

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();

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
            const Text(
              'Resumen de Estudiantes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.people,
                    label: 'Total',
                    value: stats['total'].toString(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.check_circle,
                    label: 'Completados',
                    value: stats['completados'].toString(),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.play_circle,
                    label: 'En progreso',
                    value: stats['enProgreso'].toString(),
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.circle_outlined,
                    label: 'No iniciado',
                    value: stats['noIniciado'].toString(),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressSummary(stats),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSummary(Map<String, dynamic> stats) {
    final promedioProgreso = stats['promedioProgreso'] as double;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso Promedio',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '${promedioProgreso.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: promedioProgreso / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateStats() {
    if (enrollments.isEmpty) {
      return {
        'total': 0,
        'completados': 0,
        'enProgreso': 0,
        'noIniciado': 0,
        'promedioProgreso': 0.0,
      };
    }

    int completados = 0;
    int enProgreso = 0;
    int noIniciado = 0;
    double sumaProgreso = 0.0;

    for (var enrollment in enrollments) {
      sumaProgreso += enrollment.progreso;
      
      if (enrollment.completado) {
        completados++;
      } else if (enrollment.enProgreso) {
        enProgreso++;
      } else {
        noIniciado++;
      }
    }

    return {
      'total': enrollments.length,
      'completados': completados,
      'enProgreso': enProgreso,
      'noIniciado': noIniciado,
      'promedioProgreso': sumaProgreso / enrollments.length,
    };
  }
}
