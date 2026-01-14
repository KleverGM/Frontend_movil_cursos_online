import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/course_detail.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para obtener el detalle de un curso
class GetCourseDetailUseCase {
  final CourseRepository _repository;

  GetCourseDetailUseCase(this._repository);

  Future<Either<Failure, CourseDetail>> call(GetCourseDetailParams params) async {
    return await _repository.getCourseDetail(params.courseId);
  }
}

class GetCourseDetailParams extends Equatable {
  final int courseId;

  const GetCourseDetailParams(this.courseId);

  @override
  List<Object> get props => [courseId];
}
