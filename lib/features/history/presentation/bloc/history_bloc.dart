import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/history_entity.dart';
import '../../domain/usecases/add_food_usecase.dart';
import '../../domain/usecases/delete_history_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase getHistory;
  final AddFoodUseCase addFood;
  final DeleteHistoryUseCase deleteHistory;

  HistoryBloc({
    required this.getHistory,
    required this.addFood,
    required this.deleteHistory,
  }) : super(HistoryInitial()) {
    on<LoadHistory>((event, emit) async {
      emit(HistoryLoading());
      try {
        List<HistoryEntity> data = await getHistory();

        if (data.isEmpty) {
          data = _generateDummyData();
        }

        final weeklyData = _calculateWeeklyData(data);
        emit(HistoryLoaded(data, weeklyData));
      } catch (e) {
        emit(HistoryError("Gagal memuat: $e"));
      }
    });

    on<AddFoodScan>((event, emit) async {
      try {
        await addFood(event.food);
        add(LoadHistory());
      } catch (e) {
        emit(HistoryError("Gagal menyimpan: $e"));
      }
    });

    on<DeleteHistory>((event, emit) async {
      try {
        await deleteHistory(event.id);
        add(LoadHistory());
      } catch (e) {
        emit(HistoryError("Gagal menghapus: $e"));
      }
    });
  }

  List<double> _calculateWeeklyData(List<HistoryEntity> histories) {
    List<double> weekCalories = List.filled(7, 0.0);
    DateTime now = DateTime.now();
    DateTime startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    for (var food in histories) {
      try {
        DateTime date = DateTime.parse(food.createdAt);
        if (date.isAfter(startOfWeek.subtract(const Duration(seconds: 1)))) {
          int dayIndex = date.weekday - 1;
          if (dayIndex >= 0 && dayIndex < 7) {
            weekCalories[dayIndex] += food.calories;
          }
        }
      } catch (e) {
        print("Error parsing date: $e");
      }
    }
    return weekCalories;
  }

  List<HistoryEntity> _generateDummyData() {
    DateTime now = DateTime.now();
    return [
      HistoryEntity(
        id: 1,
        foodName: "Nasi Goreng",
        calories: 550,
        protein: 15,
        carbs: 60,
        fat: 20,
        sugar: 5,
        imagePath: "",
        createdAt: now.toIso8601String(),
      ),
    ];
  }
}
