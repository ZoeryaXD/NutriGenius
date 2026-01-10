import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required String displayName,
    required String email,
    required String healthCondition,
    required double tdee,
    required double caloriesConsumed,
    required double caloriesRemaining,
    required int caloriesPercentage,
    required int scanCountToday,
    required double proteinTarget,
    required double proteinConsumed,
    required double proteinRemaining,
    required int proteinPercentage,
    required double carbsTarget,
    required double carbsConsumed,
    required double carbsRemaining,
    required int carbsPercentage,
    required double fatTarget,
    required double fatConsumed,
    required double fatRemaining,
    required int fatPercentage,
    required double sugarConsumed,
  }) : super(
         displayName: displayName,
         email: email,
         healthCondition: healthCondition,
         tdee: tdee,
         caloriesConsumed: caloriesConsumed,
         caloriesRemaining: caloriesRemaining,
         caloriesPercentage: caloriesPercentage,
         scanCountToday: scanCountToday,
         proteinTarget: proteinTarget,
         proteinConsumed: proteinConsumed,
         proteinRemaining: proteinRemaining,
         proteinPercentage: proteinPercentage,
         carbsTarget: carbsTarget,
         carbsConsumed: carbsConsumed,
         carbsRemaining: carbsRemaining,
         carbsPercentage: carbsPercentage,
         fatTarget: fatTarget,
         fatConsumed: fatConsumed,
         fatRemaining: fatRemaining,
         fatPercentage: fatPercentage,
         sugarConsumed: sugarConsumed,
       );

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final userInfo = json['user_info'] ?? {};
    final dailySummary = json['daily_summary'] ?? {};
    final macronutrients = json['macronutrients'] ?? {};
    final otherNutrients = json['other_nutrients'] ?? {};

    return DashboardModel(
      displayName: userInfo['full_name'] ?? '',
      email: userInfo['email'] ?? '',
      healthCondition: userInfo['health_condition'] ?? 'Normal',
      tdee: _toDouble(dailySummary['tdee']),
      caloriesConsumed: _toDouble(dailySummary['calories_consumed']),
      caloriesRemaining: _toDouble(dailySummary['calories_remaining']),
      caloriesPercentage: _toInt(dailySummary['calories_percentage']),
      scanCountToday: _toInt(dailySummary['scan_count_today']),
      proteinTarget: _toDouble((macronutrients['protein'] ?? {})['target']),
      proteinConsumed: _toDouble((macronutrients['protein'] ?? {})['consumed']),
      proteinRemaining: _toDouble(
        (macronutrients['protein'] ?? {})['remaining'],
      ),
      proteinPercentage: _toInt(
        (macronutrients['protein'] ?? {})['percentage'],
      ),
      carbsTarget: _toDouble((macronutrients['carbs'] ?? {})['target']),
      carbsConsumed: _toDouble((macronutrients['carbs'] ?? {})['consumed']),
      carbsRemaining: _toDouble((macronutrients['carbs'] ?? {})['remaining']),
      carbsPercentage: _toInt((macronutrients['carbs'] ?? {})['percentage']),
      fatTarget: _toDouble((macronutrients['fat'] ?? {})['target']),
      fatConsumed: _toDouble((macronutrients['fat'] ?? {})['consumed']),
      fatRemaining: _toDouble((macronutrients['fat'] ?? {})['remaining']),
      fatPercentage: _toInt((macronutrients['fat'] ?? {})['percentage']),
      sugarConsumed: _toDouble(otherNutrients['sugar_consumed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_info': {
        'full_name': displayName,
        'email': email,
        'health_condition': healthCondition,
      },
      'daily_summary': {
        'tdee': tdee,
        'calories_consumed': caloriesConsumed,
        'calories_remaining': caloriesRemaining,
        'calories_percentage': caloriesPercentage,
        'scan_count_today': scanCountToday,
      },
      'macronutrients': {
        'protein': {
          'target': proteinTarget,
          'consumed': proteinConsumed,
          'remaining': proteinRemaining,
          'percentage': proteinPercentage,
        },
        'carbs': {
          'target': carbsTarget,
          'consumed': carbsConsumed,
          'remaining': carbsRemaining,
          'percentage': carbsPercentage,
        },
        'fat': {
          'target': fatTarget,
          'consumed': fatConsumed,
          'remaining': fatRemaining,
          'percentage': fatPercentage,
        },
      },
      'other_nutrients': {'sugar_consumed': sugarConsumed},
    };
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) return int.tryParse(val) ?? 0;
    return 0;
  }
}
