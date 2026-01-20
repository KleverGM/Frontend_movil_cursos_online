import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/analytics_entities.dart';
import '../repositories/analytics_repository.dart';

class GetUserGrowthUseCase implements UseCase<List<UserGrowth>, int> {
  final AnalyticsRepository repository;

  GetUserGrowthUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserGrowth>>> execute(int days) async {
    return await repository.getUserGrowth(days);
  }
}
