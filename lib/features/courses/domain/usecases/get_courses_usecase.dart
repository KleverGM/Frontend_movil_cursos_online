import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para obtener lista de cursos con filtros
class GetCoursesUseCase {
  final CourseRepository _repository;

  GetCoursesUseCase(this._repository);

  Future<Either<Failure, List<Course>>> call(GetCoursesParams params) async {
    return await _repository.getCourses(
      categoria: params.categoria,
      nivel: params.nivel,
      search: params.search,
      ordering: params.ordering,
    );
  }
}

class GetCoursesParams extends Equatable {
  final String? categoria;
  final String? nivel;
  final String? search;
  final String? ordering;

  const GetCoursesParams({
    this.categoria,
    this.nivel,
    this.search,
    this.ordering,
  });

  @override
  List<Object?> get props => [categoria, nivel, search, ordering];
}
