import 'package:flutter/material.dart';
import '../../domain/entities/section.dart';

/// Widget para mostrar el contenido de la sección
class SectionContentView extends StatelessWidget {
  final Section section;
  final VoidCallback onMarkCompleted;
  final bool isCompleting;

  const SectionContentView({
    super.key,
    required this.section,
    required this.onMarkCompleted,
    this.isCompleting = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Text(
            section.titulo,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          // Duración
          if (section.duracionMinutos > 0)
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${section.duracionMinutos} minutos',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Contenido
          Text(
            section.contenido,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          // Archivo adjunto
          if (section.tieneArchivo) ...[
            Card(
              child: ListTile(
                leading: const Icon(Icons.attach_file, color: Colors.blue),
                title: const Text('Archivo adjunto'),
                subtitle: Text(section.archivo ?? ''),
                trailing: const Icon(Icons.download),
                onTap: () {
                  // TODO: Implementar descarga de archivo
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          // Botón de marcar como completado
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isCompleting ? null : onMarkCompleted,
              icon: isCompleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.check_circle),
              label: Text(
                isCompleting
                    ? 'Marcando...'
                    : 'Marcar como completado',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
