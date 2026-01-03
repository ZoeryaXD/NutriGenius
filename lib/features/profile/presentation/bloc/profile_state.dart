import '../../domain/entities/profile_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  ProfileLoaded(this.profile);
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
