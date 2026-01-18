import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/module.dart';
import '../repositories/module_repository.dart';

class CreateModuleUseCase {
  final ModuleRepository repository;

  CreateModuleUseCase(this.repository);

  Future<Either<Failure, Module>> call({
    required int cursoId,
    required String titulo,
    String? descripcion,
    required int orden,
  }) async {
    return await repository.createModule(
      cursoId: cursoId,
      titulo: titulo,
      descripcion: descripcion,
      orden: orden,
    );
  }
}
