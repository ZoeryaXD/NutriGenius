import 'package:equatable/equatable.dart';

class ActivityLevelEntity extends Equatable {
  final int id;
  final String levelName;
  final double multiplier;
  final String description;

  const ActivityLevelEntity({
    required this.id,
    required this.levelName,
    required this.multiplier,
    required this.description,
  });

  @override
  List<Object?> get props => [id, levelName, multiplier, description];
}
