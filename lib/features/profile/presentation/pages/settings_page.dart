import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/core/theme/theme_cubit.dart';
import 'package:nutrigenius/features/profile/presentation/pages/about_page.dart';
import 'package:nutrigenius/features/profile/presentation/pages/change_password_page.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../auth/presentation/pages/login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          "Pengaturan",
          style: TextStyle(
            color: isDark ? Colors.white : colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccess || state is DeleteAccountSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (r) => false,
            );
          }
          if (state is DeleteAccountSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Akun Anda telah dihapus secara permanen."),
              ),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            double horizontalPadding =
                constraints.maxWidth > 600 ? constraints.maxWidth * 0.15 : 24.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 24,
                  ),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _sectionHeader("AKUN", colorScheme),
                    _buildSettingsGroup(
                      isDark,
                      colorScheme,
                      children: [
                        _buildListTile(
                          context,
                          Icons.lock_outline_rounded,
                          "Ganti Password",
                          () {
                            final state = context.read<ProfileBloc>().state;
                            String currentEmail = "";
                            if (state is ProfileLoaded)
                              currentEmail = state.profile.email;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider.value(
                                      value: context.read<ProfileBloc>(),
                                      child: ChangePasswordPage(
                                        currentEmail: currentEmail,
                                      ),
                                    ),
                              ),
                            );
                          },
                          colorScheme,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    _sectionHeader("TAMPILAN", colorScheme),
                    _buildSettingsGroup(
                      isDark,
                      colorScheme,
                      children: [
                        BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, themeMode) {
                            return _buildSwitchTile(
                              Icons.dark_mode_outlined,
                              "Mode Gelap",
                              themeMode == ThemeMode.dark,
                              (v) => context.read<ThemeCubit>().toggleTheme(v),
                              colorScheme,
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    _sectionHeader("TENTANG", colorScheme),
                    _buildSettingsGroup(
                      isDark,
                      colorScheme,
                      children: [
                        _buildListTile(
                          context,
                          Icons.info_outline_rounded,
                          "Tentang NutriGenius",
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AboutPage(),
                            ),
                          ),
                          colorScheme,
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                    _buildDeleteButton(context, colorScheme),

                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        "Versi 1.0.0 (Beta)",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(
    bool isDark,
    ColorScheme cs, {
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceVariant.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDeleteButton(BuildContext context, ColorScheme cs) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => _showDeleteConfirmDialog(context),
        icon: const Icon(
          Icons.delete_forever_rounded,
          color: Colors.redAccent,
          size: 20,
        ),
        label: const Text(
          "Hapus Akun Saya",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.redAccent.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Hapus Akun?"),
            content: const Text(
              "Seluruh data kesehatan dan riwayat scan Anda akan dihapus permanen dari sistem.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<ProfileBloc>().add(DeleteAccountRequested());
                },
                child: const Text(
                  "Ya, Hapus",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _sectionHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
    ColorScheme cs,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: cs.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
    ColorScheme cs,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: cs.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeColor: cs.primary,
        onChanged: onChanged,
      ),
    );
  }
}
