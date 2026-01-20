import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../courses/domain/entities/course.dart';
import '../repositories/admin_repository.dart';

/// Caso de uso para activar un curso
class ActivateCourse implements UseCase<Course, int> {
  final AdminRepository repository;

  ActivateCourse(this.repository);

  @override
  Future<Either<Failure, Course>> execute(int courseId) async {
    return await repository.activateCourse(courseId);
  }

  Future<Either<Failure, Course>> call(int courseId) async {
    return execute(courseId);
  }
}
