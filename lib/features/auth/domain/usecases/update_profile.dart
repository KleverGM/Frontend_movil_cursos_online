import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case para actualizar el perfil del usuario
class UpdateProfile implements UseCase<User, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, User>> execute(UpdateProfileParams params) async {
    return repository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      username: params.username,
    );
  }
}

/// Parámetros para actualizar el perfil
class UpdateProfileParams extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? username;

  const UpdateProfileParams({
    this.firstName,
    this.lastName,
    this.username,
  });

  @override
  List<Object?> get props => [firstName, lastName, username];
}
