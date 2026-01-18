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
    final response = await _apiClient.post(
      '/api/avisos/',
      data: {
        'usuario_id': usuarioId,
        'titulo': titulo,
        'mensaje': mensaje,
        'tipo': tipo,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return NoticeModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al crear aviso: ${response.statusCode}');
    }
  }

  @override
  Future<int> getUnreadCount() async {
    final notices = await getMyNotices();
    return notices.where((n) => !n.leido).length;
  }
}
