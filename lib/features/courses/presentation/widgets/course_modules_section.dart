import 'package:flutter/material.dart';
import '../../domain/entities/module.dart';
import 'module_card.dart';

/// Widget reutilizable para mostrar la sección de módulos del curso
class CourseModulesSection extends StatelessWidget {
  final List<Module> modulos;
  final bool inscrito;

  const CourseModulesSection({
    super.key,
    required this.modulos,
    required this.inscrito,
  });

  @override
  Widget build(BuildContext context) {
    if (modulos.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.folder_open, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Este curso aún no tiene módulos',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contenido del Curso',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...modulos.map((modulo) => ModuleCard(
              modulo: modulo,
              inscrito: inscrito,
            )),
      ],
    );
  }
}
