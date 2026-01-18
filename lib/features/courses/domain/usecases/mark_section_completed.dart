import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para marcar una sección como completada
class MarkSectionCompleted {
  final CourseRepository repository;

  MarkSectionCompleted(this.repository);

  Future<Either<Failure, void>> call(MarkSectionParams params) async {
    return await repository.markSectionCompleted(params.sectionId);
  }
}

/// Parámetros para marcar sección completada
class MarkSectionParams {
  final int sectionId;

  const MarkSectionParams({required this.sectionId});
}
