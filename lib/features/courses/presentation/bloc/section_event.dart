import 'package:equatable/equatable.dart';

abstract class SectionEvent extends Equatable {
  const SectionEvent();

  @override
  List<Object?> get props => [];
}

class GetSectionsByModuleEvent extends SectionEvent {
  final int moduleId;

  const GetSectionsByModuleEvent(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}

class CreateSectionEvent extends SectionEvent {
  final int moduloId;
  final String titulo;
  final String contenido;
  final String? videoUrl;
  final String? archivoPath;
  final int orden;
  final int duracionMinutos;
  final bool esPreview;

  const CreateSectionEvent({
    required this.moduloId,
    required this.titulo,
    required this.contenido,
    this.videoUrl,
    this.archivoPath,
    required this.orden,
    required this.duracionMinutos,
    this.esPreview = false,
  });

  @override
  List<Object?> get props => [
        moduloId,
        titulo,
        contenido,
        videoUrl,
        archivoPath,
        orden,
        duracionMinutos,
        esPreview,
      ];
}

class UpdateSectionEvent extends SectionEvent {
  final int sectionId;
  final String titulo;
  final String contenido;
  final String? videoUrl;
  final String? archivoPath;
  final int orden;
  final int duracionMinutos;
  final bool esPreview;

  const UpdateSectionEvent({
    required this.sectionId,
    required this.titulo,
    required this.contenido,
    this.videoUrl,
    this.archivoPath,
    required this.orden,
    required this.duracionMinutos,
    this.esPreview = false,
  });

  @override
  List<Object?> get props => [
        sectionId,
        titulo,
        contenido,
        videoUrl,
        archivoPath,
        orden,
        duracionMinutos,
        esPreview,
      ];
}

class DeleteSectionEvent extends SectionEvent {
  final int sectionId;

  const DeleteSectionEvent(this.sectionId);

  @override
  List<Object> get props => [sectionId];
}
