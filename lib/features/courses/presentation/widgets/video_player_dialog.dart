import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

/// Diálogo con reproductor de video integrado
class VideoPlayerDialog extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerDialog({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Convertir URL de YouTube a formato compatible
      String videoUrl = widget.videoUrl;
      
      // Si es YouTube, intentar extraer el ID del video
      if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
        setState(() {
          _error = 'Para videos de YouTube:\n\n'
              '1. Copia el enlace del video\n'
              '2. Usa el botón "Abrir" para verlo en YouTube\n\n'
              'O usa una URL directa de video (.mp4, .m3u8, etc.)';
          _isLoading = false;
        });
        return;
      }

      // Validar que la URL sea válida
      final uri = Uri.tryParse(videoUrl);
      if (uri == null || !uri.hasScheme) {
        setState(() {
          _error = 'URL de video no válida.\n\nURL recibida: $videoUrl\n\n'
              'Debe ser una URL completa (http://... o https://...)';
          _isLoading = false;
        });
        return;
      }

      _videoPlayerController = VideoPlayerController.networkUrl(uri);

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Error al cargar el video',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Verifica:\n• La URL del video es correcta\n• El archivo existe en el servidor\n• Tienes conexión a internet',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al inicializar el reproductor:\n\n${e.toString()}\n\n'
            'URL: ${widget.videoUrl}\n\n'
            'Sugerencias:\n'
            '• Verifica que la URL sea una URL directa de video\n'
            '• Intenta abrir el video con el botón "Abrir"';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Video Player
          Container(
            color: Colors.black,
            child: _isLoading
                ? const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : _error != null
                    ? Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, 
                                color: Colors.red, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cerrar'),
                            ),
                          ],
                        ),
                      )
                    : _chewieController != null
                        ? AspectRatio(
                            aspectRatio: _chewieController!.aspectRatio ?? 16 / 9,
                            child: Chewie(controller: _chewieController!),
                          )
                        : const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text(
                                'No se pudo cargar el video',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
