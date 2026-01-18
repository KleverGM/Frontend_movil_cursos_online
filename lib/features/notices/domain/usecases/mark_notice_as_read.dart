import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notice.dart';
import '../repositories/notice_repository.dart';

class MarkNoticeAsReadUseCase {
  final NoticeRepository repository;

  MarkNoticeAsReadUseCase(this.repository);

  Future<Either<Failure, Notice>> call(int noticeId) async {
    return await repository.markAsRead(noticeId);
  }
}
