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

      final result = await getHistory(event.email);

      result.fold((failure) => emit(HistoryFailure(failure.message)), (data) {
        final stats = _calculateWeeklyStats(data);

        emit(
          HistoryLoaded(
            histories: data,
            weeklyCalories: stats['weeklyChart'] as List<double>,
            totalCaloriesThisWeek: stats['total'] as double,
            dailyAverage: stats['average'] as double,
          ),
        );
      });
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
