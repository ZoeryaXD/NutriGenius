class CalculateTDEE {
  Map<String, double> call(
    String gender,
    double weight,
    double height,
    int age,
    double multiplier,
  ) {
    double bmr;
    if (gender == 'Laki-laki') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    double tdee = bmr * multiplier;

    return {'bmr': bmr, 'tdee': tdee};
  }
}