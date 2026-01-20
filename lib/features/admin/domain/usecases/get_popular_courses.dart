import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/popular_course.dart';
import '../repositories/admin_repository.dart';

class GetPopularCourses implements UseCase<List<PopularCourse>, GetPopularCoursesParams> {
  final AdminRepository repository;

  GetPopularCourses(this.repository);

  Future<Either<Failure, List<PopularCourse>>> call(GetPopularCoursesParams params) async {
    return await repository.getPopularCourses(dias: params.dias);
  }

  @override
  Future<Either<Failure, List<PopularCourse>>> execute(GetPopularCoursesParams params) async {
    return await call(params);
  }
}

class GetPopularCoursesParams extends Equatable {
  final int dias;

  const GetPopularCoursesParams({this.dias = 30});

  @override
  List<Object?> get props => [dias];
}
