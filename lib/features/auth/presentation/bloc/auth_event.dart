import 'package:equatable/equatable.dart';

/// Eventos del AuthBloc
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Evento de login
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Evento de registro
class RegisterRequested extends AuthEvent {
  final String email;
  final String username;
  final String password;
  final String perfil;
  final String? firstName;
  final String? lastName;

  const RegisterRequested({
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

/// Evento de logout
class LogoutRequested extends AuthEvent {}

class ChangePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// Evento para actualizar perfil
class UpdateProfileRequested extends AuthEvent {
  final String? firstName;
  final String? lastName;
  final String? username;

  const UpdateProfileRequested({
    this.firstName,
    this.lastName,
    this.username,
  });

  @override
  List<Object?> get props => [firstName, lastName, username];
}


/// Evento para verificar autenticación
class CheckAuthenticationStatus extends AuthEvent {}

/// Evento para obtener usuario actual
class GetCurrentUser extends AuthEvent {}
