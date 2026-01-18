import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/module.dart';
import '../repositories/module_repository.dart';

class GetModulesByCourseUseCase {
  final ModuleRepository repository;

  GetModulesByCourseUseCase(this.repository);

  Future<Either<Failure, List<Module>>> call(int courseId) async {
    return await repository.getModulesByCourse(courseId);
  }
}
