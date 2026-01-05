import 'package:nutrigenius/features/history/domain/entities/history_entity.dart';

abstract class HistoryRepository {
  Future<List<HistoryEntity>> getHistory();
  Future<void> addFood(HistoryEntity food);
  Future<void> deleteHistory(int id);
}
