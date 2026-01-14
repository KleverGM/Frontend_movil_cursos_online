import 'package:equatable/equatable.dart';

/// Clase base para fallos
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => message;
}

/// Fallo de red
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Fallo del servidor
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Fallo de cache
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Fallo de validación
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({required super.message, this.errors});

  @override
  List<Object> get props => [message, errors ?? {}];
}

/// Fallo de autenticación
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Fallo general/desconocido
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
