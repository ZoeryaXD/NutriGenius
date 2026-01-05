import 'package:nutrigenius/features/history/domain/entities/history_entity.dart';

abstract class HistoryEvent {}

class LoadHistory extends HistoryEvent {}

class AddFoodScan extends HistoryEvent {
  final HistoryEntity food;
  AddFoodScan(this.food);
}

class DeleteHistory extends HistoryEvent {
  final int id;
  DeleteHistory(this.id);
}
