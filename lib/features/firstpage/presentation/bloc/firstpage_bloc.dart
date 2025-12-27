import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecase/calculate_tdee.dart';
import '../../domain/repositories/firstpage_repository.dart';

// EVENTS
abstract class FirstPageEvent extends Equatable {
  @override List<Object> get props => [];
}
class UpdateStep1Data extends FirstPageEvent {
  final String gender;
  final double weight, height;
  final DateTime birthDate;
  UpdateStep1Data(this.gender, this.weight, this.height, this.birthDate);
  @override List<Object> get props => [gender, weight, height, birthDate];
}
class CalculateStep2Data extends FirstPageEvent {
  final int activityId, healthId;
  CalculateStep2Data(this.activityId, this.healthId);
  @override List<Object> get props => [activityId, healthId];
}
class SubmitProfile extends FirstPageEvent {
  final String email;
  SubmitProfile(this.email);
  @override List<Object> get props => [email];
}

// STATE
enum FirstPageStatus { initial, calculating, success, successSubmit, failure }
class FirstPageState extends Equatable {
  final String gender;
  final double weight, height, bmr, tdee;
  final DateTime? birthDate;
  final int activityId, healthId;
  final FirstPageStatus status;
  final String? error;

  const FirstPageState({
    this.gender = 'Laki-laki',
    this.weight = 0, this.height = 0, this.bmr = 0, this.tdee = 0,
    this.birthDate,
    this.activityId = 1, this.healthId = 1,
    this.status = FirstPageStatus.initial,
    this.error,
  });

  FirstPageState copyWith({
    String? gender, double? weight, double? height, double? bmr, double? tdee,
    DateTime? birthDate, int? activityId, int? healthId,
    FirstPageStatus? status, String? error,
  }) {
    return FirstPageState(
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bmr: bmr ?? this.bmr,
      tdee: tdee ?? this.tdee,
      birthDate: birthDate ?? this.birthDate,
      activityId: activityId ?? this.activityId,
      healthId: healthId ?? this.healthId,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
  @override List<Object?> get props => [gender, weight, height, bmr, tdee, birthDate, activityId, healthId, status, error];
}

// BLOC
class FirstPageBloc extends Bloc<FirstPageEvent, FirstPageState> {
  final CalculateTDEE calculateTDEE;
  final FirstPageRepository repository;

  FirstPageBloc({required this.calculateTDEE, required this.repository}) : super(const FirstPageState()) {
    on<UpdateStep1Data>((event, emit) {
      emit(state.copyWith(
        gender: event.gender, weight: event.weight, height: event.height, birthDate: event.birthDate
      ));
    });

    on<CalculateStep2Data>((event, emit) {
      final age = DateTime.now().year - (state.birthDate?.year ?? 2000);
      final result = calculateTDEE(state.gender, state.weight, state.height, age, event.activityId);
      emit(state.copyWith(
        activityId: event.activityId, healthId: event.healthId,
        bmr: result['bmr'], tdee: result['tdee']
      ));
    });

    on<SubmitProfile>((event, emit) async {
      emit(state.copyWith(status: FirstPageStatus.calculating)); // Loading state
      try {
        await repository.submitProfile(
          email: event.email, gender: state.gender, birthDate: state.birthDate!,
          weight: state.weight, height: state.height, activityId: state.activityId, healthId: state.healthId,
          bmr: state.bmr, tdee: state.tdee
        );
        emit(state.copyWith(status: FirstPageStatus.successSubmit));
      } catch (e) {
        emit(state.copyWith(status: FirstPageStatus.failure, error: e.toString()));
      }
    });
  }
}