import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
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
        List<FoodModel> data = await dbHelper.getHistory();

        if (data.isEmpty) {
          data = [
            FoodModel(
              id: 1,
              foodName: "Nasi Goreng",
              calories: 550,
              protein: 15,
              carbs: 60,
              fat: 20,
              sugar: 5,
              imagePath: "",
              createdAt: DateTime.now().toIso8601String(),
            ),
            FoodModel(
              id: 2,
              foodName: "Sate Ayam",
              calories: 450,
              protein: 25,
              carbs: 10,
              fat: 15,
              sugar: 8,
              imagePath: "",
              createdAt: DateTime.now()
                  .subtract(const Duration(days: 1))
                  .toIso8601String(),
            ),
            FoodModel(
              id: 3,
              foodName: "Salad Sayur",
              calories: 300,
              protein: 5,
              carbs: 30,
              fat: 2,
              sugar: 10,
              imagePath: "",
              createdAt: DateTime.now()
                  .subtract(const Duration(days: 2))
                  .toIso8601String(),
            ),
          ];
        }

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

    on<DeleteHistory>((event, emit) async {
      try {
        await dbHelper.deleteFood(event.id);

        try {
          await _deleteFromServer(event.id);
        } catch (e) {
          print(e);
        }

        add(LoadHistory());
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });
  }

  Future<void> _deleteFromServer(int id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.1.xxx:3000/api/history/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete from server");
    }
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
