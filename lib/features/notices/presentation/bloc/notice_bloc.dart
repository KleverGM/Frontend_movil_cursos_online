import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_notice.dart';
import '../../domain/usecases/delete_notice.dart';
import '../../domain/usecases/get_my_notices.dart';
import '../../domain/usecases/mark_notice_as_read.dart';
import '../../domain/usecases/get_all_notices.dart';
import '../../domain/usecases/update_notice.dart';
import '../../domain/usecases/create_broadcast_notice.dart';
import 'notice_event.dart';
import 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final GetMyNoticesUseCase _getMyNoticesUseCase;
  final MarkNoticeAsReadUseCase _markNoticeAsReadUseCase;
  final DeleteNoticeUseCase _deleteNoticeUseCase;
  final CreateNoticeUseCase _createNoticeUseCase;
  final GetAllNoticesUseCase _getAllNoticesUseCase;
  final UpdateNoticeUseCase _updateNoticeUseCase;
  final CreateBroadcastNoticeUseCase _createBroadcastNoticeUseCase;

  NoticeBloc(
    this._getMyNoticesUseCase,
    this._markNoticeAsReadUseCase,
    this._deleteNoticeUseCase,
    this._createNoticeUseCase,
    this._getAllNoticesUseCase,
    this._updateNoticeUseCase,
    this._createBroadcastNoticeUseCase,
  ) : super(const NoticeInitial()) {
    on<GetMyNoticesEvent>(_onGetMyNotices);
    on<MarkNoticeAsReadEvent>(_onMarkNoticeAsRead);
    on<DeleteNoticeEvent>(_onDeleteNotice);
    on<CreateNoticeEvent>(_onCreateNotice);
    on<GetAllNoticesEvent>(_onGetAllNotices);
    on<UpdateNoticeEvent>(_onUpdateNotice);
    on<CreateBroadcastNoticeEvent>(_onCreateBroadcastNotice);
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

  Future<void> _onGetAllNotices(
    GetAllNoticesEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(const NoticeLoading());

    final result = await _getAllNoticesUseCase();

    result.fold(
      (failure) => emit(NoticeError(failure.message)),
      (notices) => emit(AllNoticesLoaded(notices)),
    );
  }

  Future<void> _onUpdateNotice(
    UpdateNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    final result = await _updateNoticeUseCase(
      noticeId: event.noticeId,
      titulo: event.titulo,
      mensaje: event.mensaje,
      tipo: event.tipo,
    );

    result.fold(
      (failure) => emit(NoticeError(failure.message)),
      (notice) => emit(NoticeUpdated(notice)),
    );
  }

  Future<void> _onCreateBroadcastNotice(
    CreateBroadcastNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(const NoticeLoading());

    final result = await _createBroadcastNoticeUseCase(
      titulo: event.titulo,
      mensaje: event.mensaje,
      tipo: event.tipo,
      usuarioIds: event.usuarioIds,
    );

    result.fold(
      (failure) => emit(NoticeError(failure.message)),
      (notices) => emit(BroadcastNoticesCreated(notices)),
    );
  }
}
