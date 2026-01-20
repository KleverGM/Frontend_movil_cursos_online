import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/section.dart';
import 'youtube_webview_page.dart';
import 'video_player_dialog.dart';

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
          // Video
          if (section.tieneVideo) ...[
            Card(
              elevation: 2,
              child: InkWell(
                onTap: () => _openVideo(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.play_circle_filled,
                          color: Colors.red,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Video de la lección',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Toca para reproducir',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
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

  void _openVideo(BuildContext context) {
    if (section.videoUrl == null || section.videoUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay video disponible'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final videoUrl = section.videoUrl!;
    final isYouTube = videoUrl.contains('youtube.com') || 
                      videoUrl.contains('youtu.be');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.video_library, color: Colors.red),
            SizedBox(width: 8),
            Text('Video'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('URL:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              videoUrl.length > 60 
                ? '${videoUrl.substring(0, 60)}...' 
                : videoUrl,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: videoUrl));
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('URL copiada al portapapeles'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copiar'),
          ),
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                final uri = Uri.parse(videoUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No se pudo abrir el video'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Abrir'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (isYouTube) {
                // Usar WebView para videos de YouTube
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YouTubeWebViewPage(
                      videoUrl: videoUrl,
                    ),
                  ),
                );
              } else {
                // Usar reproductor normal para videos directos
                showDialog(
                  context: context,
                  builder: (context) => VideoPlayerDialog(
                    videoUrl: videoUrl,
                    title: section.titulo,
                  ),
                );
              }
            },
            icon: const Icon(Icons.play_circle_filled),
            label: const Text('Reproducir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
