import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class DeleteUser implements UseCase<void, DeleteUserParams> {
  final AdminRepository repository;

  DeleteUser(this.repository);

  Future<Either<Failure, void>> call(DeleteUserParams params) async {
    return await repository.deleteUser(params.userId);
  }

  @override
  Future<Either<Failure, void>> execute(DeleteUserParams params) async {
    return await call(params);
  }
}

class DeleteUserParams extends Equatable {
  final int userId;

  const DeleteUserParams(this.userId);

  @override
  List<Object?> get props => [userId];
}
