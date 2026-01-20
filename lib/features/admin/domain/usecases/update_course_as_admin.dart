import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../courses/domain/entities/course.dart';
import '../repositories/admin_repository.dart';

/// Caso de uso para actualizar un curso como admin
class UpdateCourseAsAdmin implements UseCase<Course, UpdateCourseParams> {
  final AdminRepository repository;

  UpdateCourseAsAdmin(this.repository);

  @override
  Future<Either<Failure, Course>> execute(UpdateCourseParams params) async {
    return await repository.updateCourseAsAdmin(
      courseId: params.courseId,
      titulo: params.titulo,
      descripcion: params.descripcion,
      categoria: params.categoria,
      nivel: params.nivel,
      precio: params.precio,
      instructorId: params.instructorId,
      imagenPath: params.imagenPath,
    );
  }

  Future<Either<Failure, Course>> call(UpdateCourseParams params) async {
    return execute(params);
  }
}

class UpdateCourseParams {
  final int courseId;
  final String? titulo;
  final String? descripcion;
  final String? categoria;
  final String? nivel;
  final double? precio;
  final int? instructorId;
  final String? imagenPath;

  UpdateCourseParams({
    required this.courseId,
    this.titulo,
    this.descripcion,
    this.categoria,
    this.nivel,
    this.precio,
    this.instructorId,
    this.imagenPath,
  });
}
