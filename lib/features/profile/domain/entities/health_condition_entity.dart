import 'package:equatable/equatable.dart';

class HealthConditionEntity extends Equatable {
  final int id;
  final String conditionName;
  final double sugarLimit;
  final String description;

  const HealthConditionEntity({
    required this.id,
    required this.conditionName,
    required this.sugarLimit,
    required this.description,
  });

  @override
  List<Object?> get props => [id, conditionName, sugarLimit, description];
}
