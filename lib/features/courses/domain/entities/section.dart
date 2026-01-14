import 'package:equatable/equatable.dart';

/// Entidad de sección del dominio
class Section extends Equatable {
  final int id;
  final String titulo;
  final String contenido;
  final String? videoUrl;
  final String? archivo;
  final int orden;
  final int moduloId;
  final int duracionMinutos;
  final bool esPreview;

  const Section({
    required this.id,
    required this.titulo,
    required this.contenido,
    this.videoUrl,
    this.archivo,
    required this.orden,
    required this.moduloId,
    this.duracionMinutos = 0,
    this.esPreview = false,
  });

  bool get tieneVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get tieneArchivo => archivo != null && archivo!.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        titulo,
        contenido,
        videoUrl,
        archivo,
        orden,
        moduloId,
        duracionMinutos,
        esPreview,
      ];
}
