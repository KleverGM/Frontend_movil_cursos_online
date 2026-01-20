import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/admin_repository.dart';

class ChangeUserPassword {
  final AdminRepository repository;

  ChangeUserPassword(this.repository);

  Future<Either<Failure, void>> call({
    required int userId,
    required String newPassword,
  }) {
    return repository.changeUserPassword(
      userId: userId,
      newPassword: newPassword,
    );
  }
}
