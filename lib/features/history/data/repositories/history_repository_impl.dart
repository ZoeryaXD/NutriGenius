import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/history_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_data_source.dart';
import '../datasources/history_remote_data_source.dart';
import '../models/history_model.dart';

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
        final remoteData = await remoteDataSource.getHistory(email);

        final historyList =
            remoteData.map((item) {
              final dynamic data = item;

              return HistoryModel(
                id: data.id,
                foodName: data.foodName,
                calories: (data.calories as num).toDouble(),
                protein: (data.protein as num?)?.toDouble(),
                carbs: (data.carbs as num?)?.toDouble(),
                fat: (data.fat as num?)?.toDouble(),
                sugar: (data.sugar as num?)?.toDouble(),
                imagePath: data.imagePath ?? '',
                mealType: data.mealType ?? data.mealName ?? 'Umum',
                createdAt: data.createdAt ?? data.date ?? DateTime.now(),
              );
            }).toList();

        await localDataSource.cacheHistory(historyList);
        return Right(historyList);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
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
  Future<Either<Failure, void>> deleteHistory(List<int> ids) async {
    try {
      if (await networkInfo.hasConnection) {
        await remoteDataSource.deleteHistory(ids);
        await localDataSource.deleteHistoryLocal(ids);
        return const Right(null);
      } else {
        return Left(
          ServerFailure(message: "Butuh internet untuk menghapus data."),
        );
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
