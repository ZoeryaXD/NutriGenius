abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String email;
  final String? gender;
  final double weight;
  final double height;
  final DateTime birthDate;

  UpdateProfileEvent({
    required this.name,
    required this.email,
    this.gender,
    required this.weight,
    required this.height,
    required this.birthDate,
  });
}
