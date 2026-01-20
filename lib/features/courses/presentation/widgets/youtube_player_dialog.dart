import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerDialog extends StatefulWidget {
  final String videoUrl;

  const YouTubePlayerDialog({
    super.key,
    required this.videoUrl,
  });

  @override
  State<YouTubePlayerDialog> createState() => _YouTubePlayerDialogState();
}

class _YouTubePlayerDialogState extends State<YouTubePlayerDialog> {
  YoutubePlayerController? _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _initializePlayer() {
    try {
      debugPrint('📺 Inicializando YouTube Player');
      debugPrint('📺 URL recibida: ${widget.videoUrl}');
      
      // Extraer el ID del video de YouTube
      final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      
      debugPrint('📺 Video ID extraído: $videoId');

      if (videoId == null) {
        setState(() {
          _error = 'No se pudo extraer el ID del video de YouTube.\n\n'
              'URL recibida: ${widget.videoUrl}\n\n'
              'Asegúrate de que sea una URL válida de YouTube.';
          _isLoading = false;
        });
        return;
      }

      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          forceHD: false,
          isLive: false,
          controlsVisibleAtStart: true,
        ),
      );

      // Listener para errores
      _controller!.addListener(() {
        if (_controller!.value.hasError) {
          debugPrint('❌ Error del reproductor: ${_controller!.value.errorCode}');
          setState(() {
            _error = 'No se pudo reproducir el video.\n\n'
                'Posibles causas:\n'
                '• El video no permite reproducción externa\n'
                '• Restricciones de región\n'
                '• Video privado o eliminado\n\n'
                'Intenta usar el botón "Abrir" para verlo en YouTube.';
            _isLoading = false;
          });
        }
      });

      setState(() {
        _isLoading = false;
      });
      
      debugPrint('✅ YouTube Player inicializado correctamente');
    } catch (e) {
      debugPrint('❌ Error al inicializar: $e');
      setState(() {
        _error = 'Error al inicializar el reproductor:\n\n${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Video de YouTube'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cargando video de YouTube...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Error al cargar el video',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          label: const Text('Cerrar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                      bufferedColor: Colors.white30,
                      backgroundColor: Colors.black,
                    ),
                    onReady: () {
                      debugPrint('✅ YouTube Player Ready');
                    },
                    onEnded: (data) {
                      debugPrint('🎬 Video terminado');
                    },
                  ),
                  builder: (context, player) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        player,
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Desliza hacia abajo o presiona el botón de cerrar para salir',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
