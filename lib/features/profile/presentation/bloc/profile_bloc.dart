import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileState()) {
    on<LoadProfileData>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loading));
      try {
        final profile = await repository.getProfile();
        emit(state.copyWith(status: ProfileStatus.success, profile: profile));
      } catch (e) {
        emit(
          state.copyWith(status: ProfileStatus.error, message: e.toString()),
        );
      }
    });

    on<LoadProfileMasterData>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loadingMaster));
      try {
        final health = await repository.getHealthConditions();
        final activity = await repository.getActivityLevels();
        print("BERHASIL AMBIL: ${health.length} data kesehatan");
        emit(
          state.copyWith(
            status: ProfileStatus.successMaster,
            healthConditions: health,
            activityLevels: activity,
          ),
        );
      } catch (e) {
        print("LOG ERROR MASTER DATA: $e");
        emit(
          state.copyWith(status: ProfileStatus.error, message: e.toString()),
        );
      }
    });

    on<UpdateProfileData>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loading));
      try {
        String? imageUrl;
        if (event.imageFile != null) {
          imageUrl = await repository.uploadPhoto(event.imageFile!);
        }

        final profileToSave = event.updatedProfile.copyWith(
          profilePicture: imageUrl ?? event.updatedProfile.profilePicture,
        );

        await repository.updateProfile(profileToSave);
        final freshProfile = await repository.getProfile();

        emit(
          state.copyWith(
            status: ProfileStatus.success,
            profile: freshProfile,
            message: "Profil berhasil diperbarui!",
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(status: ProfileStatus.error, message: e.toString()),
        );
      }
    });

    on<LogoutRequested>((event, emit) async {
      await repository.logout();
      emit(ProfileState(status: ProfileStatus.initial, profile: null));
    });
  }
}
