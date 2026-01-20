import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notice.dart';
import '../repositories/notice_repository.dart';

/// Caso de uso para obtener todos los avisos del sistema (solo admin)
class GetAllNoticesUseCase {
  final NoticeRepository _repository;

  GetAllNoticesUseCase(this._repository);

  Future<Either<Failure, List<Notice>>> call() async {
    return await _repository.getAllNotices();
  }
}
