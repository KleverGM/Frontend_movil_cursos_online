import 'package:equatable/equatable.dart';
import '../../domain/entities/notice.dart';

abstract class NoticeEvent extends Equatable {
  const NoticeEvent();

  @override
  List<Object?> get props => [];
}

class GetMyNoticesEvent extends NoticeEvent {
  const GetMyNoticesEvent();
}

class MarkNoticeAsReadEvent extends NoticeEvent {
  final int noticeId;

  const MarkNoticeAsReadEvent(this.noticeId);

  @override
  List<Object> get props => [noticeId];
}

class DeleteNoticeEvent extends NoticeEvent {
  final int noticeId;

  const DeleteNoticeEvent(this.noticeId);

  @override
  List<Object> get props => [noticeId];
}

class CreateNoticeEvent extends NoticeEvent {
  final int usuarioId;
  final String titulo;
  final String mensaje;
  final NoticeType tipo;

  const CreateNoticeEvent({
    required this.usuarioId,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
  });

  @override
  List<Object> get props => [usuarioId, titulo, mensaje, tipo];
}
