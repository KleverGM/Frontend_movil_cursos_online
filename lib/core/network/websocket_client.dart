import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';

/// Cliente WebSocket para notificaciones en tiempo real
class WebSocketClient {
  final FlutterSecureStorage _secureStorage;
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  bool _isConnected = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);
  static const Duration _heartbeatInterval = Duration(seconds: 30);

  WebSocketClient({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Stream de mensajes recibidos
  Stream<Map<String, dynamic>> get messages =>
      _messageController?.stream ?? const Stream.empty();

  /// Indica si hay conexión activa
  bool get isConnected => _isConnected;

  /// Conecta al WebSocket con autenticación JWT
  Future<void> connect() async {
    if (_isConnected) {
      return;
    }

    try {
      final token = await _secureStorage.read(key: StorageKeys.accessToken);
      
      if (token == null || token.isEmpty) {
        throw Exception('No hay token de acceso para WebSocket');
      }

      // Construir URL con token
      final wsUrl = '${ApiConstants.wsNotificationsUrl}?token=$token';

      // Crear canal WebSocket
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      // Crear controller para mensajes
      _messageController = StreamController<Map<String, dynamic>>.broadcast();

      // Escuchar mensajes
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );

      _isConnected = true;
      _reconnectAttempts = 0;

      // Iniciar heartbeat
      _startHeartbeat();
    } catch (e) {
      _isConnected = false;
      _scheduleReconnect();
      rethrow;
    }
  }

  /// Desconecta del WebSocket
  Future<void> disconnect() async {
    _stopHeartbeat();
    _stopReconnect();
    
    await _channel?.sink.close();
    await _messageController?.close();
    
    _channel = null;
    _messageController = null;
    _isConnected = false;
    _reconnectAttempts = 0;
  }

  /// Envía un mensaje al servidor
  void send(Map<String, dynamic> data) {
    if (!_isConnected || _channel == null) {
      throw Exception('WebSocket no conectado');
    }

    _channel!.sink.add(jsonEncode(data));
  }

  /// Maneja los mensajes recibidos
  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      _messageController?.add(data);
    } catch (e) {
      // Ignorar mensajes mal formados
    }
  }

  /// Maneja errores de conexión
  void _handleError(error) {
    _isConnected = false;
    _scheduleReconnect();
  }

  /// Maneja la desconexión
  void _handleDisconnect() {
    _isConnected = false;
    _stopHeartbeat();
    _scheduleReconnect();
  }

  /// Programa un intento de reconexión
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () async {
      _reconnectAttempts++;
      try {
        await connect();
      } catch (e) {
        // El error se maneja en connect()
      }
    });
  }

  /// Detiene el timer de reconexión
  void _stopReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  /// Inicia el envío periódico de heartbeat
  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      if (_isConnected) {
        try {
          send({'type': 'ping'});
        } catch (e) {
          // Si falla el ping, intentar reconectar
          _handleDisconnect();
        }
      }
    });
  }

  /// Detiene el heartbeat
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Libera recursos
  void dispose() {
    disconnect();
  }
}
