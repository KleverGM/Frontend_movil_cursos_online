import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notice.dart';

/// Repositorio para la gestión de avisos
abstract class NoticeRepository {
  /// Obtener todos los avisos del usuario
  Future<Either<Failure, List<Notice>>> getMyNotices();
  
  /// Marcar un aviso como leído
  Future<Either<Failure, Notice>> markAsRead(int noticeId);
  
  /// Marcar todos los avisos como leídos
  Future<Either<Failure, void>> markAllAsRead();
  
  /// Eliminar un aviso
  Future<Either<Failure, void>> deleteNotice(int noticeId);
  
  /// Crear un aviso (solo instructores/admins)
  Future<Either<Failure, Notice>> createNotice({
    required int usuarioId,
    required String titulo,
    required String mensaje,
    required NoticeType tipo,
  });
  
  /// Obtener avisos no leídos
  Future<Either<Failure, int>> getUnreadCount();
  
  // Métodos para administradores
  /// Obtener todos los avisos del sistema (admin)
  Future<Either<Failure, List<Notice>>> getAllNotices();
  
  /// Actualizar un aviso (admin)
  Future<Either<Failure, Notice>> updateNotice({
    required int noticeId,
    String? titulo,
    String? mensaje,
    NoticeType? tipo,
  });
  
  /// Crear avisos broadcast para múltiples usuarios (admin)
  Future<Either<Failure, List<Notice>>> createBroadcastNotice({
    required String titulo,
    required String mensaje,
    required NoticeType tipo,
    List<int>? usuarioIds, // Si es null, envía a todos
  });
}
