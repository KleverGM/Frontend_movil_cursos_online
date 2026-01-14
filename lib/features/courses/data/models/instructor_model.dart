import '../../../auth/domain/entities/user.dart' as auth_user;
import '../../domain/entities/instructor.dart';

/// Modelo de instructor para la capa de datos
class InstructorModel extends Instructor {
  const InstructorModel({
    required super.id,
    required super.username,
    required super.email,
    super.firstName,
    super.lastName,
  });

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }

  factory InstructorModel.fromUser(auth_user.User user) {
    return InstructorModel(
      id: user.id,
      username: user.username,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  factory InstructorModel.fromEntity(Instructor instructor) {
    return InstructorModel(
      id: instructor.id,
      username: instructor.username,
      email: instructor.email,
      firstName: instructor.firstName,
      lastName: instructor.lastName,
    );
  }
}
