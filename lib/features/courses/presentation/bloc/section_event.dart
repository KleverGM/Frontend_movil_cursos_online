import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

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
  final PlatformFile? videoFile;
  final String? archivoPath;
  final int orden;
  final int duracionMinutos;
  final bool esPreview;

  const CreateSectionEvent({
    required this.moduloId,
    required this.titulo,
    required this.contenido,
    this.videoUrl,
    this.videoFile,
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
        videoFile,
        archivoPath,
        orden,
        duracionMinutos,
        esPreview,
      ];
}

class UpdateSectionEvent extends SectionEvent {
  final int sectionId;
  final int moduleId;
  final String titulo;
  final String contenido;
  final String? videoUrl;
  final PlatformFile? videoFile;
  final String? archivoPath;
  final int orden;
  final int duracionMinutos;
  final bool esPreview;

  const UpdateSectionEvent({
    required this.sectionId,
    required this.moduleId,
    required this.titulo,
    required this.contenido,
    this.videoUrl,
    this.videoFile,
    this.archivoPath,
    required this.orden,
    required this.duracionMinutos,
    this.esPreview = false,
  });

  @override
  List<Object?> get props => [
        sectionId,
        moduleId,
        titulo,
        contenido,
        videoUrl,
        videoFile,
        archivoPath,
        orden,
        duracionMinutos,
        esPreview,
      ];
}

class DeleteSectionEvent extends SectionEvent {
  final int sectionId;
  final int moduleId;

  const DeleteSectionEvent(this.sectionId, this.moduleId);

  @override
  List<Object> get props => [sectionId, moduleId];
}

class MarkSectionCompletedEvent extends SectionEvent {
  final int sectionId;

  const MarkSectionCompletedEvent(this.sectionId);

  @override
  List<Object> get props => [sectionId];
}
