import '../../domain/entities/module.dart';
import 'section_model.dart';

/// Modelo de módulo para la capa de datos
class ModuleModel extends Module {
  const ModuleModel({
    required super.id,
    required super.titulo,
    super.descripcion,
    required super.orden,
    required super.cursoId,
    super.secciones,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String?,
      orden: json['orden'] as int,
      cursoId: json['curso'] as int? ?? json['curso_id'] as int,
      secciones: json['secciones'] != null
          ? (json['secciones'] as List)
              .map((s) => SectionModel.fromJson(s as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'orden': orden,
      'curso_id': cursoId,
      'secciones': secciones.map((s) => SectionModel.fromEntity(s).toJson()).toList(),
    };
  }

  factory ModuleModel.fromEntity(Module module) {
    return ModuleModel(
      id: module.id,
      titulo: module.titulo,
      descripcion: module.descripcion,
      orden: module.orden,
      cursoId: module.cursoId,
      secciones: module.secciones,
    );
  }
}
