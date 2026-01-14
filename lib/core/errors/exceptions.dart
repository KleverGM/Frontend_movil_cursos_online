/// Excepción base
class AppException implements Exception {
  final String message;
  final int? statusCode;
  
  const AppException(this.message, [this.statusCode]);
  
  @override
  String toString() => message;
}

/// Excepción de servidor
class ServerException extends AppException {
  const ServerException([
    String message = 'Error del servidor',
    int? statusCode,
  ]) : super(message, statusCode);
}

/// Excepción de caché
class CacheException extends AppException {
  const CacheException([String message = 'Error de caché'])
      : super(message, null);
}

/// Excepción de red
class NetworkException extends AppException {
  const NetworkException([String message = 'Sin conexión a internet'])
      : super(message, null);
}

/// Excepción de autenticación
class AuthenticationException extends AppException {
  const AuthenticationException([
    String message = 'Error de autenticación',
    int? statusCode = 401,
  ]) : super(message, statusCode);
}

/// Excepción de autorización
class AuthorizationException extends AppException {
  const AuthorizationException([
    String message = 'Sin permisos',
    int? statusCode = 403,
  ]) : super(message, statusCode);
}

/// Excepción de recurso no encontrado
class NotFoundException extends AppException {
  const NotFoundException([
    String message = 'Recurso no encontrado',
    int? statusCode = 404,
  ]) : super(message, statusCode);
}

/// Excepción de validación
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;
  
  const ValidationException([
    String message = 'Error de validación',
    this.errors,
    int? statusCode = 400,
  ]) : super(message, statusCode);
}

/// Excepción de conflicto
class ConflictException extends AppException {
  const ConflictException([
    String message = 'Conflicto de recursos',
    int? statusCode = 409,
  ]) : super(message, statusCode);
}

/// Excepción de timeout
class TimeoutException extends AppException {
  const TimeoutException([String message = 'Tiempo de espera agotado'])
      : super(message, 408);
}

/// Excepción de formato
class FormatException extends AppException {
  const FormatException([String message = 'Formato de datos inválido'])
      : super(message, null);
}

/// Excepción de token inválido
class InvalidTokenException extends AppException {
  const InvalidTokenException([String message = 'Token inválido o expirado'])
      : super(message, 401);
}

/// Excepción de token expirado
class TokenExpiredException extends AppException {
  const TokenExpiredException([String message = 'Token expirado'])
      : super(message, 401);
}
