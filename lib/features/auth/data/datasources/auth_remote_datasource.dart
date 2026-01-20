import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Datasource remoto para autenticación
abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register({
    required String email,
    required String username,
    required String password,
    required String perfil,
    String? firstName,
    String? lastName,
  });

  Future<UserModel> getCurrentUser();

  Future<void> logout();

  Future<void> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  });

  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          'Error en login',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthenticationException('Credenciales incorrectas');
      } else if (e.response?.statusCode == 400) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        throw ValidationException(
          'Datos inválidos',
          errors,
        );
      }
      throw ServerException(
        e.message ?? 'Error de conexión',
        e.response?.statusCode,
      );
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String username,
    required String password,
    required String perfil,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'email': email,
          'username': username,
          'password': password,
          'tipo_usuario': perfil, // El backend espera tipo_usuario
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
        },
      );

      if (response.statusCode == 201) {
        return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          'Error en registro',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        throw ValidationException(
          'Datos inválidos',
          errors,
        );
      } else if (e.response?.statusCode == 409) {
        throw const ConflictException('El usuario ya existe');
      }
      throw ServerException(
        e.message ?? 'Error de conexión',
        e.response?.statusCode,
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiConstants.userProfile);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          'Error al obtener perfil',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthenticationException('No autenticado');
      }
      throw ServerException(
        e.message ?? 'Error de conexión',
        e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> logout() async {
    // El logout es principalmente local (eliminar tokens)
    // Si tu backend tiene endpoint de logout, se puede implementar aquí
    return;
  }

  @override
  Future<void> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.users}$userId/cambiar_password/',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          'Error al cambiar contraseña',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthenticationException('No autenticado');
      }
      if (e.response?.statusCode == 400) {
        final errorMsg = e.response?.data['error'] ?? 'Contraseña actual incorrecta';
        throw ServerException(errorMsg, 400);
      }
      throw ServerException(
        e.message ?? 'Error de conexión',
        e.response?.statusCode,
      );
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
  }) async {
    try {
      // Construir el body solo con los campos proporcionados
      final Map<String, dynamic> data = {};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (username != null) data['username'] = username;

      final response = await _apiClient.get(ApiConstants.userProfile);
      final userId = response.data['id'];

      final updateResponse = await _apiClient.patch(
        '${ApiConstants.users}$userId/',
        data: data,
      );

      return UserModel.fromJson(updateResponse.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthenticationException('No autenticado');
      }
      if (e.response?.statusCode == 400) {
        final errors = e.response?.data;
        String errorMsg = 'Error de validación';
        
        if (errors is Map) {
          if (errors.containsKey('username')) {
            errorMsg = errors['username'][0];
          } else if (errors.containsKey('email')) {
            errorMsg = errors['email'][0];
          } else {
            errorMsg = errors.values.first.toString();
          }
        }
        throw ValidationException(errorMsg);
      }
      throw ServerException(
        e.message ?? 'Error de conexión',
        e.response?.statusCode,
      );
    }
  }
}
