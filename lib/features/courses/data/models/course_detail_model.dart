import '../../domain/entities/course_detail.dart';
import 'course_model.dart';
import 'module_model.dart';

/// Modelo de detalle de curso para la capa de datos
class CourseDetailModel extends CourseDetail {
  const CourseDetailModel({
    required super.course,
    required super.modulos,
    super.inscrito,
    super.progreso,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    // El backend puede devolver el curso detallado directamente
    final courseData = json['curso'] ?? json;
    
    return CourseDetailModel(
      course: CourseModel.fromJson(courseData as Map<String, dynamic>),
      modulos: courseData['modulos'] != null
          ? (courseData['modulos'] as List)
              .map((m) => ModuleModel.fromJson(m as Map<String, dynamic>))
              .toList()
          : [],
      inscrito: courseData['inscripcion_usuario'] != null,
      progreso: courseData['inscripcion_usuario']?['progreso'] != null
          ? (courseData['inscripcion_usuario']['progreso'] is String)
              ? double.parse(courseData['inscripcion_usuario']['progreso'] as String)
              : (courseData['inscripcion_usuario']['progreso'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final courseJson = CourseModel.fromEntity(course).toJson();
    courseJson['modulos'] = modulos.map((m) => ModuleModel.fromEntity(m).toJson()).toList();
    if (inscrito) {
      courseJson['inscripcion_usuario'] = {
        'progreso': progreso?.toString(),
      };
    }
    return courseJson;
  }

  factory CourseDetailModel.fromEntity(CourseDetail detail) {
    return CourseDetailModel(
      course: detail.course,
      modulos: detail.modulos,
      inscrito: detail.inscrito,
      progreso: detail.progreso,
    );
  }
}
