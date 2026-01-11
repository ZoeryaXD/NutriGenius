import 'package:flutter/material.dart';

enum PasswordStrength { weak, medium, strong }

class PasswordStrengthMeter extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthMeter({Key? key, required this.strength})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    double value;
    String text;

    switch (strength) {
      case PasswordStrength.weak:
        color = Colors.red;
        value = 0.33;
        text = "Lemah";
        break;
      case PasswordStrength.medium:
        color = Colors.orange;
        value = 0.66;
        text = "Sedang";
        break;
      case PasswordStrength.strong:
        color = Colors.green;
        value = 1.0;
        text = "Kuat";
        break;
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ],
    );
  }
}