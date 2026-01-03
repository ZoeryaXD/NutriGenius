class CalculateTDEE {
  Map<String, double> call(
    String gender,
    double weight,
    double height,
    int age,
    int activityId,
  ) {
    double bmr;
    if (gender == 'Laki-laki') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    double multiplier = 1.2;
    switch (activityId) {
      case 1:
        multiplier = 1.2;
        break;
      case 2:
        multiplier = 1.375;
        break;
      case 3:
        multiplier = 1.55;
        break;
      case 4:
        multiplier = 1.725;
        break;
    }

    return {'bmr': bmr, 'tdee': bmr * multiplier};
  }
}
