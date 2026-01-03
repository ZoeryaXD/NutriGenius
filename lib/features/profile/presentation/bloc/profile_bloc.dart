import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfile;
  final UpdateProfileUseCase updateProfile;

  ProfileBloc({required this.getProfile, required this.updateProfile})
    : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      try {
        final updatedProfile = ProfileEntity(
          name: event.name,
          email: event.email,
          gender: event.gender ?? 'Laki-Laki',
          weight: event.weight,
          height: event.height,
          birthDate: event.birthDate.toIso8601String().split('T')[0],
        );

        await updateProfile(updatedProfile);

        add(LoadProfile());
      } catch (e) {
        emit(ProfileError("Gagal simpan: ${e.toString()}"));
      }
    });
  }
}
