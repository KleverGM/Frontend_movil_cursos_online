import 'package:equatable/equatable.dart';

/// Entidad de instructor (simplificada para cursos)
class Instructor extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;

  const Instructor({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return username;
  }

  @override
  List<Object?> get props => [id, username, email, firstName, lastName];
}
