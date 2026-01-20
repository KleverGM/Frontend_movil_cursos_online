import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notice.dart';
import '../repositories/notice_repository.dart';

/// Caso de uso para actualizar un aviso (solo admin)
class UpdateNoticeUseCase {
  final NoticeRepository _repository;

  UpdateNoticeUseCase(this._repository);

  Future<Either<Failure, Notice>> call({
    required int noticeId,
    String? titulo,
    String? mensaje,
    NoticeType? tipo,
  }) async {
    return await _repository.updateNotice(
      noticeId: noticeId,
      titulo: titulo,
      mensaje: mensaje,
      tipo: tipo,
    );
  }
}
