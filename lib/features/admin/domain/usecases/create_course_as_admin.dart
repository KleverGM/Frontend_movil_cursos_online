import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../courses/domain/entities/course.dart';
import '../repositories/admin_repository.dart';

/// Caso de uso para crear un curso como admin
class CreateCourseAsAdmin implements UseCase<Course, CreateCourseParams> {
  final AdminRepository repository;

  CreateCourseAsAdmin(this.repository);

  @override
  Future<Either<Failure, Course>> execute(CreateCourseParams params) async {
    return await repository.createCourseAsAdmin(
      titulo: params.titulo,
      descripcion: params.descripcion,
      categoria: params.categoria,
      nivel: params.nivel,
      precio: params.precio,
      instructorId: params.instructorId,
      imagenPath: params.imagenPath,
    );
  }

  Future<Either<Failure, Course>> call(CreateCourseParams params) async {
    return execute(params);
  }
}

class CreateCourseParams {
  final String titulo;
  final String descripcion;
  final String categoria;
  final String nivel;
  final double precio;
  final int instructorId;
  final String? imagenPath;

  CreateCourseParams({
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.nivel,
    required this.precio,
    required this.instructorId,
    this.imagenPath,
  });
}
