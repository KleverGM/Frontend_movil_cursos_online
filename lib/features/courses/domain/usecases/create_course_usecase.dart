import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para crear un nuevo curso
class CreateCourseUseCase {
  final CourseRepository _repository;

  CreateCourseUseCase(this._repository);

  Future<Either<Failure, Course>> call(CreateCourseParams params) async {
    return await _repository.createCourse(
      titulo: params.titulo,
      descripcion: params.descripcion,
      categoria: params.categoria,
      nivel: params.nivel,
      precio: params.precio,
      imagenPath: params.imagenPath,
    );
  }
}

class CreateCourseParams extends Equatable {
  final String titulo;
  final String descripcion;
  final String categoria;
  final String nivel;
  final double precio;
  final String? imagenPath;

  const CreateCourseParams({
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.nivel,
    required this.precio,
    this.imagenPath,
  });

  @override
  List<Object?> get props => [
        titulo,
        descripcion,
        categoria,
        nivel,
        precio,
        imagenPath,
      ];
}
