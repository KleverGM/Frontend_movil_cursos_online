import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/section.dart';
import '../repositories/section_repository.dart';

class GetSectionsByModuleUseCase {
  final SectionRepository repository;

  GetSectionsByModuleUseCase(this.repository);

  Future<Either<Failure, List<Section>>> call(int moduleId) async {
    return await repository.getSectionsByModule(moduleId);
  }
}
