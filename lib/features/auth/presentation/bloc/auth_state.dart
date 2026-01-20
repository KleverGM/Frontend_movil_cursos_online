import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// Estados del AuthBloc
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuthInitial extends AuthState {}

/// Estado de carga
class AuthLoading extends AuthState {}

/// Estado autenticado
class Authenticated extends AuthState {
  final User user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Estado no autenticado
class Unauthenticated extends AuthState {}

/// Estado de error
class AuthError extends AuthState {
  final String message;
  final Map<String, dynamic>? errors;

  const AuthError({
    required this.message,
    this.errors,
  });

  @override
  List<Object?> get props => [message, errors];
}

class PasswordChanging extends AuthState {}

class PasswordChanged extends AuthState {
  final String message;

  const PasswordChanged(this.message);

  @override
  List<Object?> get props => [message];
}
