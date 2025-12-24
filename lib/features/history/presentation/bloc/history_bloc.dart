import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/db_helper.dart';
import '../../data/models/food_model.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final DatabaseHelper dbHelper;

  HistoryBloc(this.dbHelper) : super(HistoryInitial()) {
    on<LoadHistory>((event, emit) async {
      emit(HistoryLoading());
      try {
        final data = await dbHelper.getHistory();
        final weeklyData = _calculateWeeklyData(data);

        emit(HistoryLoaded(data, weeklyData));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<AddFoodScan>((event, emit) async {
      try {
        await dbHelper.insertFood(event.food);
        add(LoadHistory());
      } catch (e) {
        emit(HistoryError("Gagal menyimpan data: $e"));
      }
    });
  }

  List<double> _calculateWeeklyData(List<FoodModel> histories) {
    List<double> weekCalories = List.filled(7, 0.0);

    for (var food in histories) {
      try {
        DateTime date = DateTime.parse(food.createdAt);
        int dayIndex = date.weekday - 1;
        weekCalories[dayIndex] += food.calories;
      } catch (e) {
        print("Error parsing date: $e");
      }
    }
    return weekCalories;
  }
}
