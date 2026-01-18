import 'package:equatable/equatable.dart';

abstract class ModuleEvent extends Equatable {
  const ModuleEvent();

  @override
  List<Object?> get props => [];
}

class GetModulesByCourseEvent extends ModuleEvent {
  final int courseId;

  const GetModulesByCourseEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class CreateModuleEvent extends ModuleEvent {
  final int cursoId;
  final String titulo;
  final String? descripcion;
  final int orden;

  const CreateModuleEvent({
    required this.cursoId,
    required this.titulo,
    this.descripcion,
    required this.orden,
  });

  @override
  List<Object?> get props => [cursoId, titulo, descripcion, orden];
}

class UpdateModuleEvent extends ModuleEvent {
  final int moduleId;
  final String titulo;
  final String? descripcion;
  final int orden;

  const UpdateModuleEvent({
    required this.moduleId,
    required this.titulo,
    this.descripcion,
    required this.orden,
  });

  @override
  List<Object?> get props => [moduleId, titulo, descripcion, orden];
}

class DeleteModuleEvent extends ModuleEvent {
  final int moduleId;

  const DeleteModuleEvent(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
