import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;
  final String perfil; 
  final bool isActive;
  final DateTime fechaCreacion;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    required this.perfil,
    required this.isActive,
    required this.fechaCreacion,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return username;
  }

  bool get isStudent => perfil == 'estudiante';
  bool get isInstructor => perfil == 'instructor';
  bool get isAdmin => perfil == 'administrador';

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        firstName,
        lastName,
        perfil,
        isActive,
        fechaCreacion,
      ];
}
