import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/notice_repository.dart';

class DeleteNoticeUseCase {
  final NoticeRepository repository;

  DeleteNoticeUseCase(this.repository);

  Future<Either<Failure, void>> call(int noticeId) async {
    return await repository.deleteNotice(noticeId);
  }
}
