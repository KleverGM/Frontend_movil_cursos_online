import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_module.dart';
import '../../domain/usecases/delete_module.dart';
import '../../domain/usecases/get_modules_by_course.dart';
import '../../domain/usecases/update_module.dart';
import 'module_event.dart';
import 'module_state.dart';

class ModuleBloc extends Bloc<ModuleEvent, ModuleState> {
  final GetModulesByCourseUseCase _getModulesByCourseUseCase;
  final CreateModuleUseCase _createModuleUseCase;
  final UpdateModuleUseCase _updateModuleUseCase;
  final DeleteModuleUseCase _deleteModuleUseCase;

  ModuleBloc(
    this._getModulesByCourseUseCase,
    this._createModuleUseCase,
    this._updateModuleUseCase,
    this._deleteModuleUseCase,
  ) : super(const ModuleInitial()) {
    on<GetModulesByCourseEvent>(_onGetModulesByCourse);
    on<CreateModuleEvent>(_onCreateModule);
    on<UpdateModuleEvent>(_onUpdateModule);
    on<DeleteModuleEvent>(_onDeleteModule);
  }

  Future<void> _onGetModulesByCourse(
    GetModulesByCourseEvent event,
    Emitter<ModuleState> emit,
  ) async {
    emit(const ModuleLoading());

    final result = await _getModulesByCourseUseCase(event.courseId);

    result.fold(
      (failure) => emit(ModuleError(failure.message)),
      (modules) => emit(ModulesLoaded(modules)),
    );
  }

  Future<void> _onCreateModule(
    CreateModuleEvent event,
    Emitter<ModuleState> emit,
  ) async {
    emit(const ModuleLoading());

    final result = await _createModuleUseCase(
      cursoId: event.cursoId,
      titulo: event.titulo,
      descripcion: event.descripcion,
      orden: event.orden,
    );

    result.fold(
      (failure) => emit(ModuleError(failure.message)),
      (module) => emit(ModuleCreated(module)),
    );
  }

  Future<void> _onUpdateModule(
    UpdateModuleEvent event,
    Emitter<ModuleState> emit,
  ) async {
    emit(const ModuleLoading());

    final result = await _updateModuleUseCase(
      moduleId: event.moduleId,
      titulo: event.titulo,
      descripcion: event.descripcion,
      orden: event.orden,
    );

    result.fold(
      (failure) => emit(ModuleError(failure.message)),
      (module) => emit(ModuleUpdated(module)),
    );
  }

  Future<void> _onDeleteModule(
    DeleteModuleEvent event,
    Emitter<ModuleState> emit,
  ) async {
    emit(const ModuleLoading());

    final result = await _deleteModuleUseCase(event.moduleId);

    result.fold(
      (failure) => emit(ModuleError(failure.message)),
      (_) => emit(ModuleDeleted(event.moduleId)),
    );
  }
}
