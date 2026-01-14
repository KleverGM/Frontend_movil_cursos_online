import '../../domain/entities/section.dart';

/// Modelo de sección para la capa de datos
class SectionModel extends Section {
  const SectionModel({
    required super.id,
    required super.titulo,
    required super.contenido,
    super.videoUrl,
    super.archivo,
    required super.orden,
    required super.moduloId,
    super.duracionMinutos,
    super.esPreview,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      contenido: json['contenido'] as String? ?? '',
      videoUrl: json['video_url'] as String?,
      archivo: json['archivo'] as String?,
      orden: json['orden'] as int,
      moduloId: json['modulo'] as int? ?? json['modulo_id'] as int,
      duracionMinutos: json['duracion_minutos'] as int? ?? 0,
      esPreview: json['es_preview'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'contenido': contenido,
      'video_url': videoUrl,
      'archivo': archivo,
      'orden': orden,
      'modulo_id': moduloId,
      'duracion_minutos': duracionMinutos,
      'es_preview': esPreview,
    };
  }

  factory SectionModel.fromEntity(Section section) {
    return SectionModel(
      id: section.id,
      titulo: section.titulo,
      contenido: section.contenido,
      videoUrl: section.videoUrl,
      archivo: section.archivo,
      orden: section.orden,
      moduloId: section.moduloId,
      duracionMinutos: section.duracionMinutos,
      esPreview: section.esPreview,
    );
  }
}
