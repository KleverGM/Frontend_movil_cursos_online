import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/platform_stats.dart';
import '../repositories/admin_repository.dart';

class GetPlatformStats implements UseCase<PlatformStats, GetPlatformStatsParams> {
  final AdminRepository repository;

  GetPlatformStats(this.repository);

  Future<Either<Failure, PlatformStats>> call(GetPlatformStatsParams params) async {
    return await repository.getPlatformStats(dias: params.dias);
  }

  @override
  Future<Either<Failure, PlatformStats>> execute(GetPlatformStatsParams params) async {
    return await call(params);
  }
}

class GetPlatformStatsParams extends Equatable {
  final int dias;

  const GetPlatformStatsParams({this.dias = 7});

  @override
  List<Object?> get props => [dias];
}
