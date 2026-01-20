import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

/// Caso de uso para eliminar un curso como admin
class DeleteCourseAsAdmin implements UseCase<void, int> {
  final AdminRepository repository;

  DeleteCourseAsAdmin(this.repository);

  @override
  Future<Either<Failure, void>> execute(int courseId) async {
    return await repository.deleteCourseAsAdmin(courseId);
  }

  Future<Either<Failure, void>> call(int courseId) async {
    return execute(courseId);
  }
}
