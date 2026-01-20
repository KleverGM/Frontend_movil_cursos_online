import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_summary.dart';
import '../repositories/admin_repository.dart';

class UpdateUser implements UseCase<UserSummary, UpdateUserParams> {
  final AdminRepository repository;

  UpdateUser(this.repository);

  Future<Either<Failure, UserSummary>> call(UpdateUserParams params) async {
    return await repository.updateUser(
      userId: params.userId,
      username: params.username,
      email: params.email,
      perfil: params.perfil,
      firstName: params.firstName,
      lastName: params.lastName,
      isActive: params.isActive,
    );
  }

  @override
  Future<Either<Failure, UserSummary>> execute(UpdateUserParams params) async {
    return await call(params);
  }
}

class UpdateUserParams extends Equatable {
  final int userId;
  final String? username;
  final String? email;
  final String? perfil;
  final String? firstName;
  final String? lastName;
  final bool? isActive;

  const UpdateUserParams({
    required this.userId,
    this.username,
    this.email,
    this.perfil,
    this.firstName,
    this.lastName,
    this.isActive,
  });

  @override
  List<Object?> get props => [userId, username, email, perfil, firstName, lastName, isActive];
}
