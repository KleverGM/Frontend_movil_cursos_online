import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/analytics_entities.dart';
import '../repositories/analytics_repository.dart';

class GetInstructorRankingsUseCase implements UseCase<List<InstructorAnalytics>, NoParams> {
  final AnalyticsRepository repository;

  GetInstructorRankingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<InstructorAnalytics>>> execute(NoParams params) async {
    return await repository.getInstructorRankings();
  }
}
