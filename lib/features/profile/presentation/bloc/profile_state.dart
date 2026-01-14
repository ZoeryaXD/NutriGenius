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
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileActionSuccess extends ProfileState {
  final String message;
  ProfileActionSuccess(this.message);
}

class ProfileUpdateSuccess extends ProfileActionSuccess {
  ProfileUpdateSuccess(String message) : super(message);
}

class PhotoUploadSuccess extends ProfileActionSuccess {
  PhotoUploadSuccess(String message) : super(message);
}

class LogoutSuccess extends ProfileState {}

class DeleteAccountSuccess extends ProfileState {}
