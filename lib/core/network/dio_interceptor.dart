import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';
import '../errors/exceptions.dart';

/// Interceptor para manejar autenticación JWT
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final Dio _dio;

  AuthInterceptor({
    required FlutterSecureStorage secureStorage,
    required Dio dio,
  })  : _secureStorage = secureStorage,
        _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Rutas que no requieren autenticación
    final publicRoutes = [
      ApiConstants.login,
      ApiConstants.register,
      ApiConstants.refreshToken,
    ];

    // Si la ruta es pública, no agregar token
    if (publicRoutes.any((route) => options.path.contains(route))) {
      return handler.next(options);
    }

    // Agregar access token a las peticiones
    final accessToken = await _secureStorage.read(
      key: StorageKeys.accessToken,
    );

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Si el error es 401 (Unauthorized), intentar refrescar el token
    if (err.response?.statusCode == 401) {
      try {
        // Intentar refrescar el token
        await _refreshToken();

        // Reintentar la petición original con el nuevo token
        final response = await _retry(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        // Si falla el refresh, limpiar tokens y propagar el error
        await _clearTokens();
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const InvalidTokenException('Token inválido o expirado'),
            type: DioExceptionType.badResponse,
            response: err.response,
          ),
        );
      }
    }

    // Para otros errores, propagar normalmente
    return handler.next(err);
  }

  /// Refresca el access token usando el refresh token
  Future<void> _refreshToken() async {
    final refreshToken = await _secureStorage.read(
      key: StorageKeys.refreshToken,
    );

    if (refreshToken == null || refreshToken.isEmpty) {
      throw const InvalidTokenException('No hay refresh token disponible');
    }

    try {
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refresh': refreshToken},
        options: Options(
          headers: {'Authorization': null}, // No enviar token en refresh
        ),
      );

      final newAccessToken = response.data['access'] as String?;
      
      if (newAccessToken == null || newAccessToken.isEmpty) {
        throw const TokenExpiredException('Token expirado');
      }

      // Guardar el nuevo access token
      await _secureStorage.write(
        key: StorageKeys.accessToken,
        value: newAccessToken,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const TokenExpiredException('Refresh token expirado');
      }
      rethrow;
    }
  }

  /// Reintenta una petición con el nuevo token
  Future<Response> _retry(RequestOptions requestOptions) async {
    final accessToken = await _secureStorage.read(
      key: StorageKeys.accessToken,
    );

    // Actualizar el token en los headers
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $accessToken',
      },
    );

    return await _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Limpia los tokens del almacenamiento seguro
  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: StorageKeys.accessToken);
    await _secureStorage.delete(key: StorageKeys.refreshToken);
  }
}
