import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/module.dart';

/// Repositorio para la gestión de módulos
abstract class ModuleRepository {
  /// Obtener módulos de un curso
  Future<Either<Failure, List<Module>>> getModulesByCourse(int courseId);
  
  /// Crear un nuevo módulo
  Future<Either<Failure, Module>> createModule({
    required int cursoId,
    required String titulo,
    String? descripcion,
    required int orden,
  });
  
  /// Actualizar un módulo existente
  Future<Either<Failure, Module>> updateModule({
    required int moduleId,
    required String titulo,
    String? descripcion,
    required int orden,
  });
  
  /// Eliminar un módulo
  Future<Either<Failure, void>> deleteModule(int moduleId);
  
  /// Reordenar módulos
  Future<Either<Failure, void>> reorderModules({
    required int courseId,
    required List<int> moduleIds,
  });
}
