import 'package:flutter_bloc/flutter_bloc.dart';
import 'firstpage_event.dart';
import 'firstpage_state.dart';
import '../../domain/usecase/calculate_tdee.dart';
import '../../domain/repositories/firstpage_repository.dart';

class FirstPageBloc extends Bloc<FirstPageEvent, FirstPageState> {
  final CalculateTDEE calculateTDEE;
  final FirstPageRepository repository;

  FirstPageBloc({required this.calculateTDEE, required this.repository})
    : super(const FirstPageState()) {
    on<UpdateStep1Data>((event, emit) {
      emit(
        state.copyWith(
          gender: event.gender,
          weight: event.weight,
          height: event.height,
          birthDate: event.birthDate,
        ),
      );
    });

    on<CalculateStep2Data>((event, emit) {
      final age = DateTime.now().year - (state.birthDate?.year ?? 2000);
      final result = calculateTDEE(
        state.gender,
        state.weight,
        state.height,
        age,
        event.activityId,
      );
      emit(
        state.copyWith(
          activityId: event.activityId,
          bmr: result['bmr'],
          tdee: result['tdee'],
        ),
      );
    });

    on<HealthGoalChanged>((event, emit) {
      emit(state.copyWith(healthId: event.id));
    });

    on<SubmitProfile>((event, emit) async {
      emit(state.copyWith(status: FirstPageStatus.calculating));
      try {
        await repository.submitProfile(
          email: event.email,
          gender: state.gender,
          birthDate: state.birthDate!,
          weight: state.weight,
          height: state.height,
          activityId: state.activityId,
          healthId: state.healthId,
          bmr: state.bmr,
          tdee: state.tdee,
        );
        emit(state.copyWith(status: FirstPageStatus.successSubmit));
      } catch (e) {
        emit(
          state.copyWith(status: FirstPageStatus.failure, error: e.toString()),
        );
      }
    });
  }
}
