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
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfileData>((event, emit) async {
      emit(ProfileLoading());
      try {
        await repository.updateProfile(event.updatedProfile);
        emit(ProfileActionSuccess("Profil berhasil diperbarui!"));
        add(LoadProfile());
      } catch (e) {
        emit(ProfileError("Gagal update: $e"));
      }
    });

    on<UploadProfilePhoto>((event, emit) async {
      emit(ProfileLoading());
      try {
        await repository.uploadPhoto(event.photo);
        emit(ProfileActionSuccess("Foto berhasil diupload!"));
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

    on<DeleteAccountRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        await repository.deleteAccount();
        emit(LogoutSuccess());
      } catch (e) {
        emit(ProfileError("Gagal hapus akun: $e"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await repository.logout();
      emit(LogoutSuccess());
    });
  }
}
