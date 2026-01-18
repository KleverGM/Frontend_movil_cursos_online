import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/enrollment_detail.dart';
import '../repositories/course_repository.dart';

/// Caso de uso para obtener inscripciones de los cursos del instructor
class GetInstructorEnrollmentsUseCase implements UseCase<List<EnrollmentDetail>, GetInstructorEnrollmentsParams> {
  final CourseRepository repository;

  GetInstructorEnrollmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<EnrollmentDetail>>> execute(GetInstructorEnrollmentsParams params) async {
    return await repository.getInstructorEnrollments(courseId: params.courseId);
  }
  
  // Alias para compatibilidad con BLoC
  Future<Either<Failure, List<EnrollmentDetail>>> call(GetInstructorEnrollmentsParams params) async {
    return execute(params);
  }
}

class GetInstructorEnrollmentsParams extends Equatable {
  final int? courseId;

  const GetInstructorEnrollmentsParams({this.courseId});

  @override
  List<Object?> get props => [courseId];
}
