import '../../domain/entities/profile_entity.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  error,
  loadingMaster,
  successMaster,
}

class ProfileState {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final List<dynamic> healthConditions;
  final List<dynamic> activityLevels;
  final String? message;

  ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.healthConditions = const [],
    this.activityLevels = const [],
    this.message,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    List<dynamic>? healthConditions,
    List<dynamic>? activityLevels,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      healthConditions: healthConditions ?? this.healthConditions,
      activityLevels: activityLevels ?? this.activityLevels,
      message: message ?? this.message,
    );
  }
}
