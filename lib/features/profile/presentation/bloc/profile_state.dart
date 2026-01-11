import '../../domain/entities/profile_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  final List<ActivityLevel> activityLevels;
  final List<HealthCondition> healthConditions;

  ProfileLoaded(
    this.profile, {
    this.activityLevels = const [],
    this.healthConditions = const [],
  });

  List<Object> get props => [profile, activityLevels, healthConditions];
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileActionSuccess extends ProfileState {
  final String message;
  ProfileActionSuccess(this.message);
}

class LogoutSuccess extends ProfileState {}
