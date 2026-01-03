import '../../domain/entities/history_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_data_source.dart';
import '../datasources/history_remote_data_source.dart';
import '../models/history_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource localDataSource;
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<HistoryEntity>> getHistory() async {
    final models = await localDataSource.getHistory();
    return models;
  }

  @override
  Future<void> addFood(HistoryEntity food) async {
    final model = HistoryModel(
      id: food.id,
      foodName: food.foodName,
      calories: food.calories,
      protein: food.protein,
      carbs: food.carbs,
      fat: food.fat,
      sugar: food.sugar,
      imagePath: food.imagePath,
      createdAt: food.createdAt,
    );
    await localDataSource.saveFood(model);
  }

  @override
  Future<void> deleteHistory(int id) async {
    await localDataSource.deleteFood(id);

    await remoteDataSource.deleteHistoryFromServer(id);
  }
}
