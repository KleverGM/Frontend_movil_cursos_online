import '../../domain/entities/notice.dart';

/// Modelo de aviso para la capa de datos
class NoticeModel extends Notice {
  const NoticeModel({
    required super.id,
    required super.titulo,
    required super.mensaje,
    required super.tipo,
    required super.fechaCreacion,
    required super.leido,
    required super.usuarioId,
    super.importante = false,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      mensaje: json['mensaje'] ?? json['descripcion'] as String,
      tipo: NoticeType.fromString(json['tipo'] as String),
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      leido: json['leido'] as bool? ?? false,
      usuarioId: json['usuario'] is Map ? json['usuario']['id'] as int : json['usuario'] as int,
      importante: json['importante'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': mensaje,
      'tipo': tipo.toBackendString(),
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'leido': leido,
      'usuario': usuarioId,
      'importante': importante,
    };
  }

  factory NoticeModel.fromEntity(Notice notice) {
    return NoticeModel(
      id: notice.id,
      titulo: notice.titulo,
      mensaje: notice.mensaje,
      tipo: notice.tipo,
      fechaCreacion: notice.fechaCreacion,
      leido: notice.leido,
      usuarioId: notice.usuarioId,
      importante: notice.importante,
    );
  }
}
