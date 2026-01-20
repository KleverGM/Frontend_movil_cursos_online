import '../../../../core/network/api_client.dart';
import '../models/notice_model.dart';

/// DataSource remoto para avisos
abstract class NoticeRemoteDataSource {
  Future<List<NoticeModel>> getMyNotices();
  Future<NoticeModel> markAsRead(int noticeId);
  Future<void> markAllAsRead();
  Future<void> deleteNotice(int noticeId);
  Future<NoticeModel> createNotice({
    required int usuarioId,
    required String titulo,
    required String mensaje,
    required String tipo,
  });
  Future<int> getUnreadCount();
  
  // Métodos para administradores
  Future<List<NoticeModel>> getAllNotices();
  Future<NoticeModel> updateNotice({
    required int noticeId,
    String? titulo,
    String? mensaje,
    String? tipo,
  });
  Future<List<NoticeModel>> createBroadcastNotice({
    required String titulo,
    required String mensaje,
    required String tipo,
    List<int>? usuarioIds, // Si es null, envía a todos
  });
}

class NoticeRemoteDataSourceImpl implements NoticeRemoteDataSource {
  final ApiClient _apiClient;

  NoticeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<NoticeModel>> getMyNotices() async {
    final response = await _apiClient.get('/api/avisos/');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data is List
          ? response.data as List<dynamic>
          : (response.data as Map<String, dynamic>)['results'] as List<dynamic>;
      
      return data.map((json) => NoticeModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener avisos: ${response.statusCode}');
    }
  }

  @override
  Future<NoticeModel> markAsRead(int noticeId) async {
    final response = await _apiClient.patch(
      '/api/avisos/$noticeId/',
      data: {'leido': true},
    );

    if (response.statusCode == 200) {
      return NoticeModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al marcar como leído: ${response.statusCode}');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final notices = await getMyNotices();
    final unreadNotices = notices.where((n) => !n.leido);
    
    for (final notice in unreadNotices) {
      await markAsRead(notice.id);
    }
  }

  @override
  Future<void> deleteNotice(int noticeId) async {
    final response = await _apiClient.delete('/api/avisos/$noticeId/');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar aviso: ${response.statusCode}');
    }
  }

  @override
  Future<NoticeModel> createNotice({
    required int usuarioId,
    required String titulo,
    required String mensaje,
    required String tipo,
  }) async {
    // Mapear tipos del frontend a backend
    final backendTipo = _mapTipoToBackend(tipo);
    
    final response = await _apiClient.post(
      '/api/avisos/',
      data: {
        'usuario_id': usuarioId,  // El serializer espera 'usuario_id' para escritura
        'titulo': titulo,
        'descripcion': mensaje,  // Backend usa 'descripcion', no 'mensaje'
        'tipo': backendTipo,  // Tipos válidos: general, curso, sistema, promocion
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return NoticeModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al crear aviso: ${response.statusCode}');
    }
  }
  
  /// Mapea los tipos del frontend (NoticeType) a los tipos del backend
  String _mapTipoToBackend(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'info':
        return 'general';
      case 'announcement':
        return 'promocion';
      case 'warning':
        return 'sistema';
      case 'error':
        return 'sistema';
      case 'success':
        return 'general';
      default:
        return 'general';
    }
  }

  @override
  Future<int> getUnreadCount() async {
    final notices = await getMyNotices();
    return notices.where((n) => !n.leido).length;
  }

  @override
  Future<List<NoticeModel>> getAllNotices() async {
    final response = await _apiClient.get('/api/avisos/');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data is List
          ? response.data as List<dynamic>
          : (response.data as Map<String, dynamic>)['results'] as List<dynamic>;
      
      return data.map((json) => NoticeModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener todos los avisos: ${response.statusCode}');
    }
  }

  @override
  Future<NoticeModel> updateNotice({
    required int noticeId,
    String? titulo,
    String? mensaje,
    String? tipo,
  }) async {
    final Map<String, dynamic> data = {};
    if (titulo != null) data['titulo'] = titulo;
    if (mensaje != null) data['descripcion'] = mensaje;  // Backend usa 'descripcion'
    if (tipo != null) data['tipo'] = _mapTipoToBackend(tipo);  // Mapear tipo

    final response = await _apiClient.patch(
      '/api/avisos/$noticeId/',
      data: data,
    );

    if (response.statusCode == 200) {
      return NoticeModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al actualizar aviso: ${response.statusCode}');
    }
  }

  @override
  Future<List<NoticeModel>> createBroadcastNotice({
    required String titulo,
    required String mensaje,
    required String tipo,
    List<int>? usuarioIds,
  }) async {
    final List<NoticeModel> createdNotices = [];
    
    // Si no se especifican usuarios, obtenerlos del backend
    if (usuarioIds == null || usuarioIds.isEmpty) {
      // Obtener todos los usuarios y crear avisos para cada uno
      final usersResponse = await _apiClient.get('/api/users/');
      if (usersResponse.statusCode == 200) {
        final List<dynamic> users = usersResponse.data is List
            ? usersResponse.data as List<dynamic>
            : (usersResponse.data as Map<String, dynamic>)['results'] as List<dynamic>;
        
        usuarioIds = users.map((u) => u['id'] as int).toList();
      }
    }

    // Crear aviso para cada usuario
    if (usuarioIds != null) {
      for (final userId in usuarioIds) {
        try {
          final notice = await createNotice(
            usuarioId: userId,
            titulo: titulo,
            mensaje: mensaje,
            tipo: tipo,
          );
          createdNotices.add(notice);
        } catch (e) {
          // Continuar con el siguiente usuario si falla uno
          print('Error creando aviso para usuario $userId: $e');
        }
      }
    }

    return createdNotices;
  }
}
