import 'package:equatable/equatable.dart';

/// Clase base abstracta para fallos
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}

/// Fallo de servidor
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Error del servidor. Intenta de nuevo.'])
      : super(message);
}

/// Fallo de caché
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Error al cargar datos almacenados.'])
      : super(message);
}

/// Fallo de red/conexión
class NetworkFailure extends Failure {
  const NetworkFailure([
    String message = 'Sin conexión a internet. Verifica tu conexión.',
  ]) : super(message);
}

/// Fallo de autenticación
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([
    String message = 'Error de autenticación. Inicia sesión nuevamente.',
  ]) : super(message);
}

/// Fallo de validación
class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Datos inválidos.']) : super(message);
}

/// Fallo de autorización (permisos)
class AuthorizationFailure extends Failure {
  const AuthorizationFailure([
    String message = 'No tienes permisos para realizar esta acción.',
  ]) : super(message);
}

/// Fallo de recurso no encontrado
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Recurso no encontrado.'])
      : super(message);
}

/// Fallo de timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure([
    String message = 'La solicitud ha tardado demasiado. Intenta de nuevo.',
  ]) : super(message);
}

/// Fallo desconocido
class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Ha ocurrido un error inesperado.'])
      : super(message);
}

/// Fallo de conflicto (ej: inscripción duplicada)
class ConflictFailure extends Failure {
  const ConflictFailure([String message = 'Ya existe este recurso.'])
      : super(message);
}

/// Fallo de formato de datos
class FormatFailure extends Failure {
  const FormatFailure([String message = 'Formato de datos inválido.'])
      : super(message);
}
