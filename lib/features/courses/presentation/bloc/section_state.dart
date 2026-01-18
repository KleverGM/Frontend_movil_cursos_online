import 'package:equatable/equatable.dart';
import '../../domain/entities/section.dart';

abstract class SectionState extends Equatable {
  const SectionState();

  @override
  List<Object?> get props => [];
}

class SectionInitial extends SectionState {
  const SectionInitial();
}

class SectionLoading extends SectionState {
  const SectionLoading();
}

class SectionsLoaded extends SectionState {
  final List<Section> sections;

  const SectionsLoaded(this.sections);

  @override
  List<Object> get props => [sections];
}

class SectionCreated extends SectionState {
  final Section section;

  const SectionCreated(this.section);

  @override
  List<Object> get props => [section];
}

class SectionUpdated extends SectionState {
  final Section section;

  const SectionUpdated(this.section);

  @override
  List<Object> get props => [section];
}

class SectionDeleted extends SectionState {
  const SectionDeleted();
}

class SectionError extends SectionState {
  final String message;

  const SectionError(this.message);

  @override
  List<Object> get props => [message];
}
