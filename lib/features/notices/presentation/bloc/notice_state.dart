import 'package:equatable/equatable.dart';
import '../../domain/entities/notice.dart';

abstract class NoticeState extends Equatable {
  const NoticeState();

  @override
  List<Object?> get props => [];
}

class NoticeInitial extends NoticeState {
  const NoticeInitial();
}

class NoticeLoading extends NoticeState {
  const NoticeLoading();
}

class NoticesLoaded extends NoticeState {
  final List<Notice> notices;

  const NoticesLoaded(this.notices);

  @override
  List<Object> get props => [notices];
}

class NoticeMarkedAsRead extends NoticeState {
  final Notice notice;

  const NoticeMarkedAsRead(this.notice);

  @override
  List<Object> get props => [notice];
}

class NoticeDeleted extends NoticeState {
  final int noticeId;

  const NoticeDeleted(this.noticeId);

  @override
  List<Object> get props => [noticeId];
}

class NoticeCreated extends NoticeState {
  final Notice notice;

  const NoticeCreated(this.notice);

  @override
  List<Object> get props => [notice];
}

class NoticeError extends NoticeState {
  final String message;

  const NoticeError(this.message);

  @override
  List<Object> get props => [message];
}
