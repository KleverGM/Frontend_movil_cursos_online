import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/section_repository.dart';

class DeleteSectionUseCase {
  final SectionRepository repository;

  DeleteSectionUseCase(this.repository);

  Future<Either<Failure, void>> call(int sectionId) async {
    return await repository.deleteSection(sectionId);
  }
}
