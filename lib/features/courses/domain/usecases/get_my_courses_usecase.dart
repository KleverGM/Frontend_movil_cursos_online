import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para obtener los cursos creados por el instructor
class GetMyCoursesUseCase {
  final CourseRepository _repository;

  GetMyCoursesUseCase(this._repository);

  Future<Either<Failure, List<Course>>> call(NoParams params) async {
    return await _repository.getMyCourses();
  }
}
