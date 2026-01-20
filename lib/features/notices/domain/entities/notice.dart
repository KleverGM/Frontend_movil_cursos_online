import 'package:equatable/equatable.dart';

/// Entidad de aviso del dominio
class Notice extends Equatable {
  final int id;
  final String titulo;
  final String mensaje;
  final NoticeType tipo;
  final DateTime fechaCreacion;
  final bool leido;
  final int usuarioId;
  final bool importante;

  const Notice({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    required this.fechaCreacion,
    required this.leido,
    required this.usuarioId,
    this.importante = false,
  });

  @override
  List<Object?> get props => [
        id,
        titulo,
        mensaje,
        tipo,
        fechaCreacion,
        leido,
        usuarioId,
        importante,
      ];
}

/// Tipos de avisos
enum NoticeType {
  info,
  warning,
  success,
  error,
  announcement;

  String get displayName {
    switch (this) {
      case NoticeType.info:
        return 'Información';
      case NoticeType.warning:
        return 'Advertencia';
      case NoticeType.success:
        return 'Éxito';
      case NoticeType.error:
        return 'Error';
      case NoticeType.announcement:
        return 'Anuncio';
    }
  }

  static NoticeType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'info':
      case 'informacion':
        return NoticeType.info;
      case 'warning':
      case 'advertencia':
        return NoticeType.warning;
      case 'success':
      case 'exito':
        return NoticeType.success;
      case 'error':
        return NoticeType.error;
      case 'announcement':
      case 'anuncio':
        return NoticeType.announcement;
      default:
        return NoticeType.info;
    }
  }

  String toBackendString() {
    switch (this) {
      case NoticeType.info:
        return 'informacion';
      case NoticeType.warning:
        return 'advertencia';
      case NoticeType.success:
        return 'exito';
      case NoticeType.error:
        return 'error';
      case NoticeType.announcement:
        return 'anuncio';
    }
  }
}
