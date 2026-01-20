import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

/// Use case para registro
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, AuthResponse>> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      username: params.username,
      password: params.password,
      perfil: params.perfil,
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String username;
  final String password;
  final String perfil; // estudiante, instructor, administrador
  final String? firstName;
  final String? lastName;

  const RegisterParams({
    required this.email,
    required this.username,
    required this.password,
    required this.perfil,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [
        email,
        username,
        password,
        perfil,
        firstName,
        lastName,
      ];
}
