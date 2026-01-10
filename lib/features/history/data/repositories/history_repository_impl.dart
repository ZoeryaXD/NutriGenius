import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/history_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_data_source.dart';
import '../datasources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;
  final HistoryLocalDataSource localDataSource;
  final InternetConnectionChecker networkInfo;

  HistoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<HistoryEntity>>> getHistory(String email) async {
    if (await networkInfo.hasConnection) {
      try {
        final historyList = await remoteDataSource.getHistory(email);

        await localDataSource.cacheHistory(historyList);

        return Right(historyList);
      } catch (e) {
        final localData = await localDataSource.getLastHistory();
        return Right(localData);
      }
    } else {
      try {
        final localData = await localDataSource.getLastHistory();
        return Right(localData);
      } catch (e) {
        return Left(CacheFailure(message: "Data Offline Kosong"));
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteHistory(int id) async {
    try {
      if (await networkInfo.hasConnection) {
        await remoteDataSource.deleteHistory(id);
      }
      await localDataSource.deleteHistory(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
