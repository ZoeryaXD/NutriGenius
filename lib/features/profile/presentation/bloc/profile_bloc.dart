import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await repository.getProfile();
        final activities = await repository.getActivityLevels();
        final conditions = await repository.getHealthConditions();
        emit(
          ProfileLoaded(
            profile,
            activityLevels: activities,
            healthConditions: conditions,
          ),
        );
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<LoadMasterData>((event, emit) async {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        try {
          final activities = await repository.getActivityLevels();
          final conditions = await repository.getHealthConditions();
          emit(
            ProfileLoaded(
              currentState.profile,
              activityLevels: activities,
              healthConditions: conditions,
            ),
          );
        } catch (e) {}
      }
    });

    on<UpdateProfileData>((event, emit) async {
      emit(ProfileLoading());
      try {
        await repository.updateProfile(event.updatedProfile);
        emit(ProfileUpdateSuccess("Profil berhasil diperbarui!"));
        add(LoadProfile());
      } catch (e) {
        emit(ProfileError("Gagal update: $e"));
      }
    });

    on<UploadProfilePhoto>((event, emit) async {
      emit(ProfileLoading());
      try {
        await repository.uploadPhoto(event.photo);
        emit(PhotoUploadSuccess("Foto berhasil diupload!"));
        add(LoadProfile());
      } catch (e) {
        emit(ProfileError("Gagal upload: $e"));
      }
    });

    on<DeleteProfilePhoto>((event, emit) async {
      try {
        await repository.deletePhoto();
        add(LoadProfile());
      } catch (e) {
        emit(ProfileError("Gagal hapus foto: $e"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await repository.logout();
      emit(LogoutSuccess());
    });
  }
}
