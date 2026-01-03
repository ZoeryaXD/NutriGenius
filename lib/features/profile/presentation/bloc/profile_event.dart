import 'dart:io';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfileData extends ProfileEvent {
  final ProfileEntity updatedProfile;
  UpdateProfileData(this.updatedProfile);
}

class UploadProfilePhoto extends ProfileEvent {
  final File photo;
  UploadProfilePhoto(this.photo);
}

class DeleteProfilePhoto extends ProfileEvent {}

class DeleteAccountRequested extends ProfileEvent {}

class LogoutRequested extends ProfileEvent {}
