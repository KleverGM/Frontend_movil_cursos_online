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
    
    // Verificar correctamente si el usuario está inscrito
    // Debe tener inscripcion_usuario con un ID válido
    final inscripcionData = courseData['inscripcion_usuario'];
    final estaInscrito = inscripcionData != null && 
                         inscripcionData is Map && 
                         inscripcionData.isNotEmpty &&
                         (inscripcionData['id'] != null || 
                          inscripcionData['fecha_inscripcion'] != null);
    
    return CourseDetailModel(
      course: CourseModel.fromJson(courseData as Map<String, dynamic>),
      modulos: courseData['modulos'] != null
          ? (courseData['modulos'] as List)
              .map((m) => ModuleModel.fromJson(m as Map<String, dynamic>))
              .toList()
          : [],
      inscrito: estaInscrito,
      progreso: inscripcionData != null && inscripcionData['progreso'] != null
          ? (inscripcionData['progreso'] is String)
              ? double.tryParse(inscripcionData['progreso'] as String) ?? 0.0
              : (inscripcionData['progreso'] as num).toDouble()
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
