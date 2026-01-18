import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

/// UseCase para activar un curso
class ActivateCourseUseCase {
  final CourseRepository repository;

  ActivateCourseUseCase(this.repository);

  Future<Either<Failure, Course>> call(int courseId) async {
    return await repository.activateCourse(courseId);
  }
}

/// UseCase para desactivar un curso
class DeactivateCourseUseCase {
  final CourseRepository repository;

  DeactivateCourseUseCase(this.repository);

  Future<Either<Failure, Course>> call(int courseId) async {
    return await repository.deactivateCourse(courseId);
  }
}
