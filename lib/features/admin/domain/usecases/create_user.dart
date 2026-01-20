import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_summary.dart';
import '../repositories/admin_repository.dart';

class CreateUser implements UseCase<UserSummary, CreateUserParams> {
  final AdminRepository repository;

  CreateUser(this.repository);

  Future<Either<Failure, UserSummary>> call(CreateUserParams params) async {
    return await repository.createUser(
      username: params.username,
      email: params.email,
      password: params.password,
      perfil: params.perfil,
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }

  @override
  Future<Either<Failure, UserSummary>> execute(CreateUserParams params) async {
    return await call(params);
  }
}

class CreateUserParams extends Equatable {
  final String username;
  final String email;
  final String password;
  final String perfil;
  final String? firstName;
  final String? lastName;

  const CreateUserParams({
    required this.username,
    required this.email,
    required this.password,
    required this.perfil,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [username, email, password, perfil, firstName, lastName];
}
