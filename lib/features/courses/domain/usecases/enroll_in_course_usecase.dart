import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/enrollment.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para inscribirse a un curso
class EnrollInCourseUseCase {
  final CourseRepository _repository;

  EnrollInCourseUseCase(this._repository);

  Future<Either<Failure, Enrollment>> call(EnrollInCourseParams params) async {
    return await _repository.enrollInCourse(params.courseId);
  }
}

class EnrollInCourseParams extends Equatable {
  final int courseId;

  const EnrollInCourseParams(this.courseId);

  @override
  List<Object> get props => [courseId];
}
