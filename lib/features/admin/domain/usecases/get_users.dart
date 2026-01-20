import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_summary.dart';
import '../repositories/admin_repository.dart';

class GetUsers implements UseCase<List<UserSummary>, GetUsersParams> {
  final AdminRepository repository;

  GetUsers(this.repository);

  Future<Either<Failure, List<UserSummary>>> call(GetUsersParams params) async {
    return await repository.getUsers(
      perfil: params.perfil,
      isActive: params.isActive,
      search: params.search,
    );
  }

  @override
  Future<Either<Failure, List<UserSummary>>> execute(GetUsersParams params) async {
    return await call(params);
  }
}

class GetUsersParams extends Equatable {
  final String? perfil;
  final bool? isActive;
  final String? search;

  const GetUsersParams({
    this.perfil,
    this.isActive,
    this.search,
  });

  @override
  List<Object?> get props => [perfil, isActive, search];
}
