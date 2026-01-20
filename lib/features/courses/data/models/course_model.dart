import '../../domain/entities/course.dart';
import 'instructor_model.dart';

/// Modelo de curso para la capa de datos
class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.titulo,
    required super.descripcion,
    required super.categoria,
    required super.nivel,
    required super.fechaCreacion,
    super.instructor,
    required super.precio,
    super.imagen,
    required super.activo,
    super.totalModulos,
    super.totalSecciones,
    super.duracionTotal,
    super.totalEstudiantes,
    super.instructorNombre,
    super.calificacionPromedio,
    super.progreso,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final instructor = json['instructor'] != null
        ? InstructorModel.fromJson(json['instructor'] as Map<String, dynamic>)
        : null;
    
    return CourseModel(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      categoria: json['categoria'] as String,
      nivel: json['nivel'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      instructor: instructor,
      precio: (json['precio'] is String)
          ? double.parse(json['precio'] as String)
          : (json['precio'] as num).toDouble(),
      imagen: json['imagen'] as String?,
      activo: json['activo'] as bool? ?? true,
      totalModulos: json['total_modulos'] as int? ?? 0,
      totalSecciones: json['total_secciones'] as int? ?? 0,
      duracionTotal: json['duracion_total'] as int? ?? 0,
      totalEstudiantes: json['total_estudiantes'] as int? ?? 0,
      instructorNombre: instructor != null 
          ? '${instructor.firstName} ${instructor.lastName}'.trim()
          : null,
      progreso: json['progreso'] != null
          ? (json['progreso'] is String
              ? double.tryParse(json['progreso'] as String)
              : (json['progreso'] as num).toDouble())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'nivel': nivel,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'instructor': instructor != null
          ? InstructorModel.fromEntity(instructor!).toJson()
          : null,
      'precio': precio.toString(),
      'imagen': imagen,
      'activo': activo,
      'total_modulos': totalModulos,
      'total_secciones': totalSecciones,
      'duracion_total': duracionTotal,
      'total_estudiantes': totalEstudiantes,
    };
  }

  factory CourseModel.fromEntity(Course course) {
    return CourseModel(
      id: course.id,
      titulo: course.titulo,
      descripcion: course.descripcion,
      categoria: course.categoria,
      nivel: course.nivel,
      fechaCreacion: course.fechaCreacion,
      instructor: course.instructor,
      precio: course.precio,
      imagen: course.imagen,
      activo: course.activo,
      totalModulos: course.totalModulos,
      totalSecciones: course.totalSecciones,
      duracionTotal: course.duracionTotal,
      totalEstudiantes: course.totalEstudiantes,
      instructorNombre: course.instructorNombre,
      calificacionPromedio: course.calificacionPromedio,
    );
  }
}
