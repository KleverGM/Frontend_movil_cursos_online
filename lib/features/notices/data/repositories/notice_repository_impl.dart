import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/notice.dart';
import '../../domain/repositories/notice_repository.dart';
import '../datasources/notice_remote_datasource.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NoticeRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<Notice>>> getMyNotices() async {
    if (await _networkInfo.isConnected) {
      try {
        final notices = await _remoteDataSource.getMyNotices();
        return Right(notices);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Notice>> markAsRead(int noticeId) async {
    if (await _networkInfo.isConnected) {
      try {
        final notice = await _remoteDataSource.markAsRead(noticeId);
        return Right(notice);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.markAllAsRead();
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotice(int noticeId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteNotice(noticeId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Notice>> createNotice({
    required int usuarioId,
    required String titulo,
    required String mensaje,
    required NoticeType tipo,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final notice = await _remoteDataSource.createNotice(
          usuarioId: usuarioId,
          titulo: titulo,
          mensaje: mensaje,
          tipo: tipo.toBackendString(),
        );
        return Right(notice);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    if (await _networkInfo.isConnected) {
      try {
        final count = await _remoteDataSource.getUnreadCount();
        return Right(count);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<Notice>>> getAllNotices() async {
    if (await _networkInfo.isConnected) {
      try {
        final notices = await _remoteDataSource.getAllNotices();
        return Right(notices);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Notice>> updateNotice({
    required int noticeId,
    String? titulo,
    String? mensaje,
    NoticeType? tipo,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final notice = await _remoteDataSource.updateNotice(
          noticeId: noticeId,
          titulo: titulo,
          mensaje: mensaje,
          tipo: tipo?.toBackendString(),
        );
        return Right(notice);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<Notice>>> createBroadcastNotice({
    required String titulo,
    required String mensaje,
    required NoticeType tipo,
    List<int>? usuarioIds,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final notices = await _remoteDataSource.createBroadcastNotice(
          titulo: titulo,
          mensaje: mensaje,
          tipo: tipo.toBackendString(),
          usuarioIds: usuarioIds,
        );
        return Right(notices);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }
}
