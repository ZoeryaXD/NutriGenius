import '../../../../core/usecases/database_helper.dart';
import '../models/history_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<HistoryModel>> getLastHistory();
  Future<void> cacheHistory(List<HistoryModel> historyList);
  Future<void> deleteHistoryLocal(List<int> ids);
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
    await Future.wait(
      historyList.map((item) => databaseHelper.insertFood(item.toMap())),
    );
  }

  @override
  Future<void> deleteHistoryLocal(List<int> ids) async {
    for (var id in ids) {
      await databaseHelper.deleteFood(id);
    }

    final sisaData = await databaseHelper.getHistory();
    print(
      "🕵️ SQLITE DEBUG: Berhasil hapus ${ids.length} data. Sisa: ${sisaData.length}",
    );
  }
}
