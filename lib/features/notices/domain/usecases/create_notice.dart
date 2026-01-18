import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notice.dart';
import '../repositories/notice_repository.dart';

class CreateNoticeUseCase {
  final NoticeRepository repository;

  CreateNoticeUseCase(this.repository);

  Future<Either<Failure, Notice>> call({
    required int usuarioId,
    required String titulo,
    required String mensaje,
    required NoticeType tipo,
  }) async {
    return await repository.createNotice(
      usuarioId: usuarioId,
      titulo: titulo,
      mensaje: mensaje,
      tipo: tipo,
    );
  }
}
