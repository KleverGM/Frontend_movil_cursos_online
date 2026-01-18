import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar información del instructor
class InstructorCard extends StatelessWidget {
  final String username;
  final String? firstName;
  final String? lastName;
  final String email;

  const InstructorCard({
    super.key,
    required this.username,
    this.firstName,
    this.lastName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            username[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          firstName != null && lastName != null
              ? '$firstName $lastName'
              : username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(email),
        trailing: const Icon(Icons.verified, color: Colors.blue),
      ),
    );
  }
}
