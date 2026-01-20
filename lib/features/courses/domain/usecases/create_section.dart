import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/error/failures.dart';
import '../entities/section.dart';
import '../repositories/section_repository.dart';

class CreateSectionUseCase {
  final SectionRepository repository;

  CreateSectionUseCase(this.repository);

  Future<Either<Failure, Section>> call({
    required int moduloId,
    required String titulo,
    required String contenido,
    String? videoUrl,
    PlatformFile? videoFile,
    String? archivoPath,
    required int orden,
    required int duracionMinutos,
    bool esPreview = false,
  }) async {
    return await repository.createSection(
      moduloId: moduloId,
      titulo: titulo,
      contenido: contenido,
      videoUrl: videoUrl,
      videoFile: videoFile,
      archivoPath: archivoPath,
      orden: orden,
      duracionMinutos: duracionMinutos,
      esPreview: esPreview,
    );
  }
}
