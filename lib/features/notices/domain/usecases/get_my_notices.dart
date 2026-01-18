import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notice.dart';
import '../repositories/notice_repository.dart';

class GetMyNoticesUseCase {
  final NoticeRepository repository;

  GetMyNoticesUseCase(this.repository);

  Future<Either<Failure, List<Notice>>> call() async {
    return await repository.getMyNotices();
  }
}
