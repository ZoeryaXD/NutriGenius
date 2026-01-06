import '../../../../core/usecases/database_helper.dart';
import '../models/history_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<HistoryModel>> getLastHistory();
  Future<void> cacheHistory(List<HistoryModel> historyList);
  Future<void> deleteHistory(int id);
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  final DatabaseHelper databaseHelper;

  HistoryLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<HistoryModel>> getLastHistory() async {
    final result = await databaseHelper.getHistory();
    return result.map((e) => HistoryModel.fromMap(e)).toList();
  }

  @override
  Future<void> cacheHistory(List<HistoryModel> historyList) async {
    await databaseHelper.clearHistory();
    for (var item in historyList) {
      await databaseHelper.insertFood(item.toMap());
    }
  }

  @override
  Future<void> deleteHistory(int id) async {
    await databaseHelper.deleteFood(id);
  }
}
