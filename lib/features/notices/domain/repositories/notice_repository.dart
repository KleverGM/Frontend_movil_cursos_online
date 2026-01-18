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
}
