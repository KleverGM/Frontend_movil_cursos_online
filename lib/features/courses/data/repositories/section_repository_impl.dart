import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/section.dart';
import '../../domain/repositories/section_repository.dart';
import '../datasources/section_remote_datasource.dart';

class SectionRepositoryImpl implements SectionRepository {
  final SectionRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  SectionRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<Section>>> getSectionsByModule(int moduleId) async {
    if (await _networkInfo.isConnected) {
      try {
        final sections = await _remoteDataSource.getSectionsByModule(moduleId);
        return Right(sections);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'Sin conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Section>> getSectionDetail(int sectionId) async {
    if (await _networkInfo.isConnected) {
      try {
        final section = await _remoteDataSource.getSectionDetail(sectionId);
        return Right(section);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'Sin conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Section>> createSection({
    required int moduloId,
    required String titulo,
    required String contenido,
    String? videoUrl,
    String? archivoPath,
    required int orden,
    required int duracionMinutos,
    bool esPreview = false,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final section = await _remoteDataSource.createSection(
          moduloId: moduloId,
          titulo: titulo,
          contenido: contenido,
          videoUrl: videoUrl,
          archivoPath: archivoPath,
          orden: orden,
          duracionMinutos: duracionMinutos,
          esPreview: esPreview,
        );
        return Right(section);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'Sin conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Section>> updateSection({
    required int sectionId,
    required String titulo,
    required String contenido,
    String? videoUrl,
    String? archivoPath,
    required int orden,
    required int duracionMinutos,
    bool esPreview = false,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final section = await _remoteDataSource.updateSection(
          sectionId: sectionId,
          titulo: titulo,
          contenido: contenido,
          videoUrl: videoUrl,
          archivoPath: archivoPath,
          orden: orden,
          duracionMinutos: duracionMinutos,
          esPreview: esPreview,
        );
        return Right(section);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'Sin conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSection(int sectionId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteSection(sectionId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'Sin conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> reorderSections({
    required int moduleId,
    required List<int> sectionIds,
  }) async {
    // TODO: Implementar cuando se agregue drag & drop
    return Left(ServerFailure(message: 'No implementado'));
  }
}
