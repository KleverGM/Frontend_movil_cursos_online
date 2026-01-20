import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notice.dart';
import '../repositories/notice_repository.dart';

/// Caso de uso para crear avisos broadcast (solo admin)
class CreateBroadcastNoticeUseCase {
  final NoticeRepository _repository;

  CreateBroadcastNoticeUseCase(this._repository);

  Future<Either<Failure, List<Notice>>> call({
    required String titulo,
    required String mensaje,
    required NoticeType tipo,
    List<int>? usuarioIds,
  }) async {
    return await _repository.createBroadcastNotice(
      titulo: titulo,
      mensaje: mensaje,
      tipo: tipo,
      usuarioIds: usuarioIds,
    );
  }
}
