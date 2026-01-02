import '../../../../core/models/food_model.dart';

abstract class HistoryEvent {}

class LoadHistory extends HistoryEvent {}

class AddFoodScan extends HistoryEvent {
  final FoodModel food;
  AddFoodScan(this.food);
}

class DeleteHistory extends HistoryEvent {
  final int id;
  DeleteHistory(this.id);
}
