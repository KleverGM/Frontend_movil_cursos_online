import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/course.dart';
import '../entities/course_filters.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para obtener lista de cursos con filtros
class GetCoursesUseCase {
  final CourseRepository _repository;

  GetCoursesUseCase(this._repository);

  Future<Either<Failure, List<Course>>> call(GetCoursesParams params) async {
    return await _repository.getCourses(filters: params.filters);
  }
}

class GetCoursesParams extends Equatable {
  final CourseFilters? filters;

  const GetCoursesParams({this.filters});

  @override
  List<Object?> get props => [filters];
}
