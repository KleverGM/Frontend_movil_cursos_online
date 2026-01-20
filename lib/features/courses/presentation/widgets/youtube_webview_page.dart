import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class YouTubeWebViewPage extends StatefulWidget {
  final String videoUrl;

  const YouTubeWebViewPage({
    super.key,
    required this.videoUrl,
  });

  @override
  State<YouTubeWebViewPage> createState() => _YouTubeWebViewPageState();
}

class _YouTubeWebViewPageState extends State<YouTubeWebViewPage> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  String? _error;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    debugPrint('📺 YouTubeWebView iniciado');
    debugPrint('📺 URL recibida: ${widget.videoUrl}');
  }

  String _extractVideoId() {
    String url = widget.videoUrl;
    String? videoId;
    
    debugPrint('📺 Extrayendo ID de: $url');
    
    // Formato: https://www.youtube.com/watch?v=VIDEO_ID
    if (url.contains('youtube.com/watch?v=')) {
      final uri = Uri.parse(url);
      videoId = uri.queryParameters['v'];
    }
    // Formato: https://youtu.be/VIDEO_ID
    else if (url.contains('youtu.be/')) {
      videoId = url.split('youtu.be/').last.split('?').first.split('&').first;
    }
    // Formato: https://www.youtube.com/embed/VIDEO_ID
    else if (url.contains('youtube.com/embed/')) {
      videoId = url.split('embed/').last.split('?').first.split('&').first;
    }

    debugPrint('📺 Video ID extraído: $videoId');
    return videoId ?? '';
  }

  String _getHtmlContent() {
    final videoId = _extractVideoId();
    
    if (videoId.isEmpty) {
      debugPrint('❌ No se pudo extraer el video ID');
      return '<html><body><h1>Error: URL inválida</h1></body></html>';
    }

    debugPrint('✅ Generando HTML para video: $videoId');
    
    // HTML con iframe de YouTube
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            * {
                margin: 0;
                padding: 0;
            }
            body {
                background-color: #000;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                width: 100vw;
            }
            .video-container {
                position: relative;
                width: 100%;
                padding-bottom: 56.25%; /* 16:9 */
            }
            iframe {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                border: none;
            }
        </style>
    </head>
    <body>
        <div class="video-container">
            <iframe 
                src="https://www.youtube.com/embed/$videoId?autoplay=1&playsinline=1&rel=0&modestbranding=1"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen>
            </iframe>
        </div>
    </body>
    </html>
    ''';
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
      body: SafeArea(
        child: Column(
          children: [
            if (_isLoading)
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            Expanded(
              child: _error != null
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
                  : InAppWebView(
                      initialData: InAppWebViewInitialData(
                        data: _getHtmlContent(),
                        baseUrl: WebUri('https://www.youtube.com'),
                      ),
                      initialSettings: InAppWebViewSettings(
                        mediaPlaybackRequiresUserGesture: false,
                        allowsInlineMediaPlayback: true,
                        javaScriptEnabled: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                        useHybridComposition: true,
                        transparentBackground: false,
                        supportZoom: false,
                        useShouldOverrideUrlLoading: false,
                        mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                      ),
                      onWebViewCreated: (controller) {
                        _webViewController = controller;
                        debugPrint('✅ WebView creada');
                      },
                      onLoadStart: (controller, url) {
                        debugPrint('📺 Iniciando carga: $url');
                        setState(() {
                          _isLoading = true;
                          _error = null;
                        });
                      },
                      onLoadStop: (controller, url) async {
                        debugPrint('✅ Carga completada: $url');
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      onProgressChanged: (controller, progress) {
                        setState(() {
                          _progress = progress / 100;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        debugPrint('🌐 Console: ${consoleMessage.message}');
                      },
                      onLoadError: (controller, url, code, message) {
                        debugPrint('❌ Error al cargar: $code - $message');
                        setState(() {
                          _isLoading = false;
                          _error = 'Este video tiene restricciones de YouTube.\n\n'
                              'Muchos videos de YouTube no permiten\n'
                              'reproducción en aplicaciones externas.\n\n'
                              '💡 Solución:\n'
                              'Cierra esta ventana y presiona el botón\n'
                              '"Abrir" para ver el video en YouTube.';
                        });
                      },
                      onLoadHttpError: (controller, url, code, message) {
                        debugPrint('❌ Error HTTP: $code - $message');
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
