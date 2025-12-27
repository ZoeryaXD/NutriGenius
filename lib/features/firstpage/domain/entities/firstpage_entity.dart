import 'package:equatable/equatable.dart';

class FirstpageEntity extends Equatable {
  final String gender;
  final double weight;
  final double height;
  final DateTime birthDate;
  final int activityId;
  final int healthId;

  // Getter untuk menghitung umur secara dinamis
  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  const FirstpageEntity({
    required this.gender,
    required this.weight,
    required this.height,
    required this.birthDate,
    required this.activityId,
    required this.healthId,
  });

  @override
  List<Object?> get props => [gender, weight, height, birthDate, activityId, healthId];
}