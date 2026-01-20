import 'package:equatable/equatable.dart';

/// Entidad que representa un resumen de usuario para el dashboard
class UserSummary extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String perfil; // estudiante, instructor, administrador
  final bool isActive;
  final DateTime fechaCreacion;
  final int? totalCursosInscritos;
  final int? totalCursosCreados;

  const UserSummary({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    required this.perfil,
    required this.isActive,
    required this.fechaCreacion,
    this.totalCursosInscritos,
    this.totalCursosCreados,
  });

  String get nombreCompleto {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName'.trim();
    }
    return username;
  }

  String get perfilFormateado {
    switch (perfil) {
      case 'estudiante':
        return 'Estudiante';
      case 'instructor':
        return 'Instructor';
      case 'administrador':
        return 'Administrador';
      default:
        return perfil;
    }
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        firstName,
        lastName,
        perfil,
        isActive,
        fechaCreacion,
        totalCursosInscritos,
        totalCursosCreados,
      ];
}
