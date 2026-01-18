import 'package:flutter/material.dart';
import 'progress_bar_widget.dart';

/// Widget para la sección de progreso de estudiantes
class StudentProgressSectionWidget extends StatelessWidget {
  final int totalEstudiantes;
  final int estudiantesActivos;
  final int estudiantesCompletados;

  const StudentProgressSectionWidget({
    super.key,
    required this.totalEstudiantes,
    required this.estudiantesActivos,
    required this.estudiantesCompletados,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (totalEstudiantes == 0) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progreso de Estudiantes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.school_outlined, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Text(
                      'No hay estudiantes inscritos',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final enProgreso = estudiantesActivos;
    final completados = estudiantesCompletados;
    final sinIniciar = totalEstudiantes - enProgreso - completados;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progreso de Estudiantes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ProgressBarWidget(
              label: 'Completado',
              count: completados,
              total: totalEstudiantes,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            ProgressBarWidget(
              label: 'En Progreso',
              count: enProgreso,
              total: totalEstudiantes,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            ProgressBarWidget(
              label: 'Sin Iniciar',
              count: sinIniciar,
              total: totalEstudiantes,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
