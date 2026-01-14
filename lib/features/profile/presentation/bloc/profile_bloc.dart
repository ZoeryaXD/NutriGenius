import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfile;
  final LogoutUseCase logout;
  final DeleteAccountUseCase deleteAccount;
  final ProfileRepository repository;

  ProfileBloc({
    required this.getProfile,
    required this.logout,
    required this.deleteAccount,
    required this.repository,
  }) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getProfile();
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
        } catch (e) {
          print("Gagal muat master data: $e");
        }
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        await logout();
        emit(LogoutSuccess());
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<DeleteAccountRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        await deleteAccount();
        emit(LogoutSuccess());
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<ChangePasswordRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        await repository.sendPasswordResetEmail(event.email);
        emit(ProfileUpdateSuccess("Link reset password berhasil dikirim!"));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
