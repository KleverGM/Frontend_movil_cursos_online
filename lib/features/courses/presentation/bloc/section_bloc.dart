import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_section.dart';
import '../../domain/usecases/delete_section.dart';
import '../../domain/usecases/get_sections_by_module.dart';
import '../../domain/usecases/update_section.dart';
import '../../domain/usecases/mark_section_completed.dart';
import 'section_event.dart';
import 'section_state.dart';

class SectionBloc extends Bloc<SectionEvent, SectionState> {
  final GetSectionsByModuleUseCase _getSectionsByModuleUseCase;
  final CreateSectionUseCase _createSectionUseCase;
  final UpdateSectionUseCase _updateSectionUseCase;
  final DeleteSectionUseCase _deleteSectionUseCase;
  final MarkSectionCompleted _markSectionCompleted;

  SectionBloc(
    this._getSectionsByModuleUseCase,
    this._createSectionUseCase,
    this._updateSectionUseCase,
    this._deleteSectionUseCase,
    this._markSectionCompleted,
  ) : super(const SectionInitial()) {
    on<GetSectionsByModuleEvent>(_onGetSectionsByModule);
    on<CreateSectionEvent>(_onCreateSection);
    on<UpdateSectionEvent>(_onUpdateSection);
    on<DeleteSectionEvent>(_onDeleteSection);
    on<MarkSectionCompletedEvent>(_onMarkSectionCompleted);
  }

  Future<void> _onGetSectionsByModule(
    GetSectionsByModuleEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(const SectionLoading());

    final result = await _getSectionsByModuleUseCase(event.moduleId);

    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (sections) => emit(SectionListLoaded(sections, event.moduleId)),
    );
  }

  Future<void> _onCreateSection(
    CreateSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(const SectionLoading());

    final result = await _createSectionUseCase(
      moduloId: event.moduloId,
      titulo: event.titulo,
      contenido: event.contenido,
      videoUrl: event.videoUrl,
      videoFile: event.videoFile,
      archivoPath: event.archivoPath,
      orden: event.orden,
      duracionMinutos: event.duracionMinutos,
      esPreview: event.esPreview,
    );

    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (section) {
        emit(SectionCreated(section));
        // Recargar la lista de secciones después de crear
        add(GetSectionsByModuleEvent(event.moduloId));
      },
    );
  }

  Future<void> _onUpdateSection(
    UpdateSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(const SectionLoading());

    final result = await _updateSectionUseCase(
      sectionId: event.sectionId,
      titulo: event.titulo,
      contenido: event.contenido,
      videoUrl: event.videoUrl,
      videoFile: event.videoFile,
      archivoPath: event.archivoPath,
      orden: event.orden,
      duracionMinutos: event.duracionMinutos,
      esPreview: event.esPreview,
    );

    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (section) {
        emit(SectionUpdated(section));
        // Recargar la lista de secciones después de actualizar
        add(GetSectionsByModuleEvent(event.moduleId));
      },
    );
  }

  Future<void> _onDeleteSection(
    DeleteSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(const SectionLoading());

    final result = await _deleteSectionUseCase(event.sectionId);

    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (_) {
        emit(const SectionDeleted());
        // Recargar la lista de secciones después de eliminar
        add(GetSectionsByModuleEvent(event.moduleId));
      },
    );
  }

  Future<void> _onMarkSectionCompleted(
    MarkSectionCompletedEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(const SectionLoading());

    final result = await _markSectionCompleted(
      MarkSectionParams(sectionId: event.sectionId),
    );

    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (_) => emit(SectionCompletedSuccess(event.sectionId)),
    );
  }
}
