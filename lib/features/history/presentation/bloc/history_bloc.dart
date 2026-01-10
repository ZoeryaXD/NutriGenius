import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/delete_history_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';
import '../../domain/entities/history_entity.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase getHistory;
  final DeleteHistoryUseCase deleteHistory;

  HistoryBloc({required this.getHistory, required this.deleteHistory})
    : super(HistoryInitial()) {
    on<LoadHistoryEvent>((event, emit) async {
      emit(HistoryLoading());

      // final result = await getHistory(event.email);

      // result.fold((failure) => emit(HistoryFailure(failure.message)), (data) {
      //   final stats = _calculateWeeklyStats(data);

      //   emit(
      //     HistoryLoaded(
      //       histories: data,
      //       weeklyCalories: stats['weeklyChart'] as List<double>,
      //       totalCaloriesThisWeek: stats['total'] as double,
      //       dailyAverage: stats['average'] as double,
      //     ),
      //   );

      final List<HistoryEntity> dummyData = [
        HistoryEntity(
          id: 1,
          foodName: "Nasi Goreng Spesial",
          calories: 700.0,
          protein: 15.0,
          carbs: 80.0,
          fat: 25.0,
          sugar: 5.0,
          imagePath: "",
          createdAt: DateTime.now(),
        ),
        HistoryEntity(
          id: 2,
          foodName: "Ayam Bakar Madu",
          calories: 450.0,
          protein: 30.0,
          carbs: 10.0,
          fat: 15.0,
          sugar: 12.0,
          imagePath: "",
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        HistoryEntity(
          id: 3,
          foodName: "Salad Sayur Mozzarella",
          calories: 250.0,
          protein: 8.0,
          carbs: 15.0,
          fat: 12.0,
          sugar: 3.0,
          imagePath: "",
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

      final stats = _calculateWeeklyStats(dummyData);

      emit(
        HistoryLoaded(
          histories: dummyData,
          weeklyCalories: stats['weeklyChart'] as List<double>,
          totalCaloriesThisWeek: stats['total'] as double,
          dailyAverage: stats['average'] as double,
        ),
      );
    });

    on<DeleteHistoryEvent>((event, emit) async {
      final result = await deleteHistory(event.id);

      result.fold((failure) => emit(HistoryFailure(failure.message)), (_) {
        add(LoadHistoryEvent(event.email));
      });
    });
  }

  Map<String, dynamic> _calculateWeeklyStats(List<HistoryEntity> data) {
    List<double> weeklyChart = [0, 0, 0, 0, 0, 0, 0];
    double total = 0;

    final now = DateTime.now();

    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    for (var item in data) {
      final itemDate = item.createdAt;

      if (itemDate.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
          itemDate.isBefore(endOfWeek)) {
        int dayIndex = itemDate.weekday - 1;
        weeklyChart[dayIndex] += item.calories;

        total += item.calories;
      }
    }

    double average = total / 7;

    return {'weeklyChart': weeklyChart, 'total': total, 'average': average};
  }
}
