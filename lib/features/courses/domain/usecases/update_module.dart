import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/module.dart';
import '../repositories/module_repository.dart';

class UpdateModuleUseCase {
  final ModuleRepository repository;

  UpdateModuleUseCase(this.repository);

  Future<Either<Failure, Module>> call({
    required int moduleId,
    required String titulo,
    String? descripcion,
    required int orden,
  }) async {
    return await repository.updateModule(
      moduleId: moduleId,
      titulo: titulo,
      descripcion: descripcion,
      orden: orden,
    );
  }
}
