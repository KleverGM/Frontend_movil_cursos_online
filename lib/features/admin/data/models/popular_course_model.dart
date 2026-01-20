import '../../domain/entities/popular_course.dart';

class PopularCourseModel extends PopularCourse {
  const PopularCourseModel({
    required super.cursoId,
    required super.titulo,
    required super.vistas,
    required super.inscripciones,
    super.imagenUrl,
    required super.categoria,
    required super.nivel,
  });

  factory PopularCourseModel.fromJson(Map<String, dynamic> json) {
    return PopularCourseModel(
      cursoId: json['curso_id'] ?? json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      vistas: json['vistas'] ?? json['total_vistas'] ?? 0,
      inscripciones: json['inscripciones'] ?? json['total_estudiantes'] ?? 0,
      imagenUrl: json['imagen'] ?? json['imagen_url'],
      categoria: json['categoria'] ?? '',
      nivel: json['nivel'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'curso_id': cursoId,
      'titulo': titulo,
      'vistas': vistas,
      'inscripciones': inscripciones,
      'imagen_url': imagenUrl,
      'categoria': categoria,
      'nivel': nivel,
    };
  }
}
