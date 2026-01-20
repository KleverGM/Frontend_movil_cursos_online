import '../../domain/entities/user_summary.dart';

class UserSummaryModel extends UserSummary {
  const UserSummaryModel({
    required super.id,
    required super.username,
    required super.email,
    super.firstName,
    super.lastName,
    required super.perfil,
    required super.isActive,
    required super.fechaCreacion,
    super.totalCursosInscritos,
    super.totalCursosCreados,
  });

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserSummaryModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      perfil: json['perfil'] ?? json['tipo_usuario'] ?? 'estudiante',
      isActive: json['is_active'] ?? true,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] ?? DateTime.now().toIso8601String()),
      totalCursosInscritos: json['total_cursos_inscritos'],
      totalCursosCreados: json['total_cursos_creados'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'perfil': perfil,
      'is_active': isActive,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'total_cursos_inscritos': totalCursosInscritos,
      'total_cursos_creados': totalCursosCreados,
    };
  }
}
