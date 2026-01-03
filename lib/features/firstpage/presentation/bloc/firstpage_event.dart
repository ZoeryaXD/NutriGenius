import 'package:equatable/equatable.dart';

abstract class FirstPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateStep1Data extends FirstPageEvent {
  final String gender;
  final double weight, height;
  final DateTime birthDate;

  UpdateStep1Data(this.gender, this.weight, this.height, this.birthDate);

  @override
  List<Object> get props => [gender, weight, height, birthDate];
}

class CalculateStep2Data extends FirstPageEvent {
  final int activityId;

  CalculateStep2Data(this.activityId);

  @override
  List<Object> get props => [activityId];
}

class HealthGoalChanged extends FirstPageEvent {
  final int id;

  HealthGoalChanged(this.id);

  @override
  List<Object> get props => [id];
}

class SubmitProfile extends FirstPageEvent {
  final String email;

  SubmitProfile(this.email);

  @override
  List<Object> get props => [email];
}
