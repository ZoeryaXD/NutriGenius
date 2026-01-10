import 'dart:io';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileEvent {}

class LoadProfileData extends ProfileEvent {}

class LoadProfileMasterData extends ProfileEvent {}

class LogoutRequested extends ProfileEvent {}

class DeleteAccountRequested extends ProfileEvent {}

class UploadProfilePhoto extends ProfileEvent {
  final File photo;
  UploadProfilePhoto(this.photo);
}

class ChangePasswordRequested extends ProfileEvent {
  final String newPassword;
  ChangePasswordRequested(this.newPassword);
}

class UpdateProfileData extends ProfileEvent {
  final ProfileEntity updatedProfile;
  final File? imageFile;
  UpdateProfileData(this.updatedProfile, {this.imageFile});
}
