import '../../domain/entities/user.dart';

/// Modelo de usuario para la capa de datos
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.firstName,
    super.lastName,
    required super.perfil,
    required super.isActive,
    required super.fechaCreacion,
  });

  /// Crear desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      perfil: json['tipo_usuario'] as String? ?? json['perfil'] as String,
      isActive: json['is_active'] as bool? ?? true,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
    );
  }

  /// Crear desde entidad
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      firstName: user.firstName,
      lastName: user.lastName,
      perfil: user.perfil,
      isActive: user.isActive,
      fechaCreacion: user.fechaCreacion,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'tipo_usuario': perfil,
      'is_active': isActive,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }

  /// Convertir a entidad
  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      perfil: perfil,
      isActive: isActive,
      fechaCreacion: fechaCreacion,
    );
  }
}
