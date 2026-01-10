import 'package:flutter_bloc/flutter_bloc.dart';
import 'firstpage_event.dart';
import 'firstpage_state.dart';
import '../../domain/usecase/calculate_tdee.dart';
import '../../domain/repositories/firstpage_repository.dart';
import '../../domain/entities/firstpage_entity.dart';

class FirstPageBloc extends Bloc<FirstPageEvent, FirstPageState> {
  final CalculateTDEE calculateTDEE;
  final FirstPageRepository repository;

  FirstPageBloc({required this.calculateTDEE, required this.repository})
    : super(const FirstPageState()) {
    on<LoadMasterData>((event, emit) async {
      emit(state.copyWith(status: FirstPageStatus.loadingMaster));
      try {
        final results = await Future.wait([
          repository.getActivityLevels(),
          repository.getHealthConditions(),
        ]);

        final activities = results[0] as List<ActivityLevel>;
        final conditions = results[1] as List<HealthCondition>;

        emit(
          state.copyWith(
            status: FirstPageStatus.successMaster,
            activityLevels: activities,
            healthConditions: conditions,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: FirstPageStatus.failure,
            error: "Gagal memuat data: $e",
          ),
        );
      }
    });

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
      double selectedMultiplier = 1.2;

      try {
        final selectedActivity = state.activityLevels.firstWhere(
          (act) => act.id == event.activityId,
        );
        selectedMultiplier = selectedActivity.multiplier;
      } catch (e) {
        print("Activity ID tidak ditemukan di master data");
      }

      final result = calculateTDEE(
        state.gender,
        state.weight,
        state.height,
        age,
        selectedMultiplier,
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
