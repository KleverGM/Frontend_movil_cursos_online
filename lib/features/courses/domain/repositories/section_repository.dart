import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/section.dart';

/// Repositorio para la gestión de secciones
abstract class SectionRepository {
  /// Obtener secciones de un módulo
  Future<Either<Failure, List<Section>>> getSectionsByModule(int moduleId);
  
  /// Obtener detalle de una sección
  Future<Either<Failure, Section>> getSectionDetail(int sectionId);
  
  /// Crear una nueva sección
  Future<Either<Failure, Section>> createSection({
    required int moduloId,
    required String titulo,
    required String contenido,
    String? videoUrl,
    String? archivoPath,
    required int orden,
    required int duracionMinutos,
    bool esPreview = false,
  });
  
  /// Actualizar una sección existente
  Future<Either<Failure, Section>> updateSection({
    required int sectionId,
    required String titulo,
    required String contenido,
    String? videoUrl,
    String? archivoPath,
    required int orden,
    required int duracionMinutos,
    bool esPreview = false,
  });
  
  /// Eliminar una sección
  Future<Either<Failure, void>> deleteSection(int sectionId);
  
  /// Reordenar secciones
  Future<Either<Failure, void>> reorderSections({
    required int moduleId,
    required List<int> sectionIds,
  });
}
