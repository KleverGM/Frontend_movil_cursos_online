import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/module_repository.dart';

class DeleteModuleUseCase {
  final ModuleRepository repository;

  DeleteModuleUseCase(this.repository);

  Future<Either<Failure, void>> call(int moduleId) async {
    return await repository.deleteModule(moduleId);
  }
}
