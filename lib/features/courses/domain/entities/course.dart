import 'package:equatable/equatable.dart';
import 'instructor.dart';

/// Entidad de curso del dominio
class Course extends Equatable {
  final int id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String nivel;
  final DateTime fechaCreacion;
  final Instructor? instructor;
  final double precio;
  final String? imagen;
  final bool activo;
  final int totalModulos;
  final int totalSecciones;
  final int duracionTotal;
  final int totalEstudiantes;
  final String? instructorNombre;
  final double calificacionPromedio;

  const Course({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.nivel,
    required this.fechaCreacion,
    this.instructor,
    required this.precio,
    this.imagen,
    required this.activo,
    this.totalModulos = 0,
    this.totalSecciones = 0,
    this.duracionTotal = 0,
    this.totalEstudiantes = 0,
    this.instructorNombre,
    this.calificacionPromedio = 0.0,
  });

  // Getters de utilidad
  String get categoriaDisplay {
    switch (categoria) {
      case 'programacion':
        return 'Programación';
      case 'diseño':
        return 'Diseño';
      case 'marketing':
        return 'Marketing';
      case 'negocios':
        return 'Negocios';
      case 'idiomas':
        return 'Idiomas';
      case 'musica':
        return 'Música';
      case 'fotografia':
        return 'Fotografía';
      case 'otros':
        return 'Otros';
      default:
        return categoria;
    }
  }

  String get nivelDisplay {
    switch (nivel) {
      case 'principiante':
        return 'Principiante';
      case 'intermedio':
        return 'Intermedio';
      case 'avanzado':
        return 'Avanzado';
      default:
        return nivel;
    }
  }

  bool get esGratuito => precio == 0.0;

  String get duracionFormateada {
    if (duracionTotal < 60) {
      return '$duracionTotal min';
    }
    final horas = duracionTotal ~/ 60;
    final minutos = duracionTotal % 60;
    return minutos > 0 ? '${horas}h ${minutos}min' : '${horas}h';
  }

  @override
  List<Object?> get props => [
        id,
        titulo,
        descripcion,
        categoria,
        nivel,
        fechaCreacion,
        instructor,
        precio,
        imagen,
        activo,
        totalModulos,
        totalSecciones,
        duracionTotal,
        totalEstudiantes,
        instructorNombre,
        calificacionPromedio,
      ];
}
