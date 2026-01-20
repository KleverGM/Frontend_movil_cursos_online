import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/analytics_entities.dart';
import '../repositories/analytics_repository.dart';

class GetPopularCoursesUseCase implements UseCase<List<CourseAnalytics>, int> {
  final AnalyticsRepository repository;

  GetPopularCoursesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CourseAnalytics>>> execute(int days) async {
    return await repository.getPopularCourses(days);
  }
}
