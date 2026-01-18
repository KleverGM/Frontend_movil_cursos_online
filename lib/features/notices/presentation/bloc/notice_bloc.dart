import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_notice.dart';
import '../../domain/usecases/delete_notice.dart';
import '../../domain/usecases/get_my_notices.dart';
import '../../domain/usecases/mark_notice_as_read.dart';
import 'notice_event.dart';
import 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final GetMyNoticesUseCase _getMyNoticesUseCase;
  final MarkNoticeAsReadUseCase _markNoticeAsReadUseCase;
  final DeleteNoticeUseCase _deleteNoticeUseCase;
  final CreateNoticeUseCase _createNoticeUseCase;

  NoticeBloc(
    this._getMyNoticesUseCase,
    this._markNoticeAsReadUseCase,
    this._deleteNoticeUseCase,
    this._createNoticeUseCase,
  ) : super(const NoticeInitial()) {
    on<GetMyNoticesEvent>(_onGetMyNotices);
    on<MarkNoticeAsReadEvent>(_onMarkNoticeAsRead);
    on<DeleteNoticeEvent>(_onDeleteNotice);
    on<CreateNoticeEvent>(_onCreateNotice);
  }

  Future<void> _onGetMyNotices(
    GetMyNoticesEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(const NoticeLoading());

    final result = await _getMyNoticesUseCase();

    result.fold(
      (failure) => emit(NoticeError(failure.message)),
      (notices) => emit(NoticesLoaded(notices)),
    );
  }

  Future<void> _onMarkNoticeAsRead(
    MarkNoticeAsReadEvent event,
    Emitter<NoticeState> emit,
  ) async {
    final result = await _markNoticeAsReadUseCase(event.noticeId);

    result.fold(
      (failure) => emit(NoticeError(failure.message)),
      (notice) => emit(NoticeMarkedAsRead(notice)),
    );
  }

  Future<void> _onDeleteNotice(
    DeleteNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    final result = await _deleteNoticeUseCase(event.noticeId);

    result.fold(
      (failure) => emit(NoticeError(failure.message)),
      (_) => emit(NoticeDeleted(event.noticeId)),
    );
  }

  Future<void> _onCreateNotice(
    CreateNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(const NoticeLoading());

    final result = await _createNoticeUseCase(
      usuarioId: event.usuarioId,
      titulo: event.titulo,
      mensaje: event.mensaje,
      tipo: event.tipo,
    );

    result.fold(
      (failure) => emit(NoticeError(failure.message)),
      (notice) => emit(NoticeCreated(notice)),
    );
  }
}
