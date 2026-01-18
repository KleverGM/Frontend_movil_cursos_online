import 'package:equatable/equatable.dart';
import '../../domain/entities/module.dart';

abstract class ModuleState extends Equatable {
  const ModuleState();

  @override
  List<Object?> get props => [];
}

class ModuleInitial extends ModuleState {
  const ModuleInitial();
}

class ModuleLoading extends ModuleState {
  const ModuleLoading();
}

class ModulesLoaded extends ModuleState {
  final List<Module> modules;

  const ModulesLoaded(this.modules);

  @override
  List<Object> get props => [modules];
}

class ModuleCreated extends ModuleState {
  final Module module;

  const ModuleCreated(this.module);

  @override
  List<Object> get props => [module];
}

class ModuleUpdated extends ModuleState {
  final Module module;

  const ModuleUpdated(this.module);

  @override
  List<Object> get props => [module];
}

class ModuleDeleted extends ModuleState {
  final int moduleId;

  const ModuleDeleted(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}

class ModuleError extends ModuleState {
  final String message;

  const ModuleError(this.message);

  @override
  List<Object> get props => [message];
}
