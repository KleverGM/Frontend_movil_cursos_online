import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para obtener los cursos inscritos del usuario
class GetEnrolledCoursesUseCase {
  final CourseRepository _repository;

  GetEnrolledCoursesUseCase(this._repository);

  Future<Either<Failure, List<Course>>> call(NoParams params) async {
    return await _repository.getEnrolledCourses();
  }
}
