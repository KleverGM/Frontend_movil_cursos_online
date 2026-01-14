import '../../domain/entities/auth_response.dart';
import 'user_model.dart';

/// Modelo de respuesta de autenticación
class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required super.user,
    required super.tokens,
  });

  /// Crear desde JSON (respuesta Django: {message, user, refresh, access})
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokens(
        accessToken: json['access'] as String,
        refreshToken: json['refresh'] as String,
      ),
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'user': (user as UserModel).toJson(),
      'access': tokens.accessToken,
      'refresh': tokens.refreshToken,
    };
  }
}
