import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_section.dart';
import '../../domain/usecases/delete_section.dart';
import '../../domain/usecases/get_sections_by_module.dart';
import '../../domain/usecases/update_section.dart';
import 'section_event.dart';
import 'section_state.dart';

class SectionBloc extends Bloc<SectionEvent, SectionState> {
  final GetSectionsByModuleUseCase _getSectionsByModuleUseCase;
  final CreateSectionUseCase _createSectionUseCase;
  final UpdateSectionUseCase _updateSectionUseCase;
  final DeleteSectionUseCase _deleteSectionUseCase;

  SectionBloc(
    this._getSectionsByModuleUseCase,
    this._createSectionUseCase,
    this._updateSectionUseCase,
    this._deleteSectionUseCase,
  ) : super(const SectionInitial()) {
    on<GetSectionsByModuleEvent>(_onGetSectionsByModule);
    on<CreateSectionEvent>(_onCreateSection);
    on<UpdateSectionEvent>(_onUpdateSection);
    on<DeleteSectionEvent>(_onDeleteSection);
  }

  Future<void> _onGetSectionsByModule(
    GetSectionsByModuleEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(const SectionLoading());

    final result = await _getSectionsByModuleUseCase(event.moduleId);

    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (sections) => emit(SectionsLoaded(sections)),
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
      archivoPath: event.archivoPath,
      orden: event.orden,
      duracionMinutos: event.duracionMinutos,
      esPreview: event.esPreview,
    );

    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (section) => emit(SectionCreated(section)),
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
      archivoPath: event.archivoPath,
      orden: event.orden,
      duracionMinutos: event.duracionMinutos,
      esPreview: event.esPreview,
    );

    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (section) => emit(SectionUpdated(section)),
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
      (_) => emit(const SectionDeleted()),
    );
  }
}
