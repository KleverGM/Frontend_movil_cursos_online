import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/analytics_entities.dart';
import '../repositories/analytics_repository.dart';

class GetGlobalTrendsUseCase implements UseCase<GlobalTrends, int> {
  final AnalyticsRepository repository;

  GetGlobalTrendsUseCase(this.repository);

  @override
  Future<Either<Failure, GlobalTrends>> execute(int days) async {
    return await repository.getGlobalTrends(days);
  }
}
