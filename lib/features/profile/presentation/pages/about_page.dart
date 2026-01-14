import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text("Tentang NutriGenius"),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  children: [
                    if (isLandscape)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: _buildAppInfo(context, colorScheme, isDark),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            flex: 5,
                            child: _buildTeamSection(
                              context,
                              colorScheme,
                              isDark,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildAppInfo(context, colorScheme, isDark),
                          const SizedBox(height: 40),
                          _buildTeamSection(context, colorScheme, isDark),
                        ],
                      ),

                    const SizedBox(height: 60),

                    _buildCopyright(isDark),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context, ColorScheme cs, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cs.primary.withOpacity(0.1),
          ),
          child: Image.asset(
            'assets/images/logo.png',
            width: 100,
            height: 100,
            errorBuilder:
                (_, __, ___) =>
                    Icon(Icons.eco_rounded, size: 80, color: cs.primary),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "NutriGenius",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : cs.primary,
            letterSpacing: 1.1,
          ),
        ),
        Text(
          "Versi 1.0.0 (Stable)",
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceVariant.withOpacity(0.2) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Text(
            "NutriGenius adalah asisten kesehatan pintar yang membantumu menghitung kebutuhan kalori harian (TDEE), memantau nutrisi melalui pemindaian AI, dan menjaga pola hidup sehat sesuai kondisi tubuhmu secara personal.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: isDark ? Colors.grey[300] : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamSection(BuildContext context, ColorScheme cs, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? Alignment.centerLeft
                  : Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              "DIBANGUN OLEH KELOMPOK 4",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: cs.primary,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        _buildTeamMember(
          context,
          "Rifqi Falih Ramadhan",
          "Auth & FirstPage Lead",
        ),
        _buildTeamMember(
          context,
          "Januar Surya Mukti",
          "Dashboard & AI Scan Expert",
        ),
        _buildTeamMember(
          context,
          "Royhan Firdaus",
          "Profile & History Architect",
        ),
        _buildTeamMember(
          context,
          "Ardika Fatnurivan",
          "Notification System Specialist",
        ),
      ],
    );
  }

  Widget _buildCopyright(bool isDark) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 20),
        Text(
          "© 2026 NutriGenius Project",
          style: TextStyle(
            color: isDark ? Colors.grey[600] : Colors.grey[400],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMember(BuildContext context, String name, String role) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            isDark
                ? colorScheme.surfaceVariant.withOpacity(0.1)
                : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: colorScheme.primary.withOpacity(0.1),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
