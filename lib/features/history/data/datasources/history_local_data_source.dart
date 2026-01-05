import 'package:nutrigenius/core/usecases/database_helper.dart';
import 'package:nutrigenius/features/history/data/models/history_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<HistoryModel>> getHistory();
  Future<void> saveFood(HistoryModel food);
  Future<void> deleteFood(int id);
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  final DatabaseHelper databaseHelper;

  HistoryLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<HistoryModel>> getHistory() async {
    final List<Map<String, dynamic>> rawData =
        await databaseHelper.getHistory();

    return rawData.map((map) => HistoryModel.fromMap(map)).toList();
  }

  @override
  Future<void> saveFood(HistoryModel food) async {
    await databaseHelper.insertFood(food.toMap());
  }

  @override
  Future<void> deleteFood(int id) async {
    await databaseHelper.deleteFood(id);
  }
}
