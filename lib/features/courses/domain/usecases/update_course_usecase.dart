import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para actualizar un curso existente
class UpdateCourseUseCase {
  final CourseRepository _repository;

  UpdateCourseUseCase(this._repository);

  Future<Either<Failure, Course>> call(UpdateCourseParams params) async {
    return await _repository.updateCourse(
      courseId: params.courseId,
      titulo: params.titulo,
      descripcion: params.descripcion,
      categoria: params.categoria,
      nivel: params.nivel,
      precio: params.precio,
      imagenPath: params.imagenPath,
    );
  }
}

class UpdateCourseParams extends Equatable {
  final int courseId;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String nivel;
  final double precio;
  final String? imagenPath;

  const UpdateCourseParams({
    required this.courseId,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.nivel,
    required this.precio,
    this.imagenPath,
  });

  @override
  List<Object?> get props => [
        courseId,
        titulo,
        descripcion,
        categoria,
        nivel,
        precio,
        imagenPath,
      ];
}
