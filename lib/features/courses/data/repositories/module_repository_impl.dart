import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/module.dart';
import '../../domain/repositories/module_repository.dart';
import '../datasources/module_remote_datasource.dart';

class ModuleRepositoryImpl implements ModuleRepository {
  final ModuleRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ModuleRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<Module>>> getModulesByCourse(int courseId) async {
    if (await _networkInfo.isConnected) {
      try {
        final modules = await _remoteDataSource.getModulesByCourse(courseId);
        return Right(modules);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Module>> createModule({
    required int cursoId,
    required String titulo,
    String? descripcion,
    required int orden,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final module = await _remoteDataSource.createModule(
          cursoId: cursoId,
          titulo: titulo,
          descripcion: descripcion,
          orden: orden,
        );
        return Right(module);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Module>> updateModule({
    required int moduleId,
    required String titulo,
    String? descripcion,
    required int orden,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final module = await _remoteDataSource.updateModule(
          moduleId: moduleId,
          titulo: titulo,
          descripcion: descripcion,
          orden: orden,
        );
        return Right(module);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteModule(int moduleId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteModule(moduleId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> reorderModules({
    required int courseId,
    required List<int> moduleIds,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.reorderModules(
          courseId: courseId,
          moduleIds: moduleIds,
        );
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }
}
