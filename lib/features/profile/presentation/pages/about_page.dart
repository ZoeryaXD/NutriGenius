import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tentang NutriGenius",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.1),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                width: 80,
                height: 80,
                errorBuilder:
                    (_, __, ___) =>
                        Icon(Icons.eco, size: 80, color: primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "NutriGenius",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const Text(
              "Versi 1.0.0 (Beta)",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Text(
                "NutriGenius adalah asisten kesehatan pintar yang membantumu menghitung kebutuhan kalori harian (TDEE), memantau nutrisi, dan menjaga pola hidup sehat sesuai kondisi tubuhmu.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: theme.textTheme.bodyLarge?.color,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Kelompok 4",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTeamMember(
              context,
              "Rifqi Falih Ramadhan",
              "Auth & FirstPage",
            ),
            _buildTeamMember(
              context,
              "Januar Surya Mukti",
              "Dashboard & AI Food Scan",
            ),
            _buildTeamMember(
              context,
              "Royhan Firdaus",
              "History Log & Profile",
            ),
            _buildTeamMember(
              context,
              "Ardika Fatnurivan",
              "Notification System",
            ),

            const SizedBox(height: 40),
            Text(
              "© 2026 NutriGenius Project",
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(BuildContext context, String name, String role) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : "?",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(fontSize: 13, color: theme.hintColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
