import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para eliminar (desactivar) un curso
class DeleteCourseUseCase {
  final CourseRepository _repository;

  DeleteCourseUseCase(this._repository);

  Future<Either<Failure, void>> call(DeleteCourseParams params) async {
    return await _repository.deleteCourse(params.courseId);
  }
}

class DeleteCourseParams extends Equatable {
  final int courseId;

  const DeleteCourseParams(this.courseId);

  @override
  List<Object> get props => [courseId];
}
