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
        title: Text(
          "Pengaturan",
          style: TextStyle(
            color: isDark ? Colors.white : colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
              (r) => false,
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _sectionHeader("AKUN", colorScheme),
            _buildListTile(
              context,
              Icons.lock_outline_rounded,
              "Ganti Password",
              () {
                final state = context.read<ProfileBloc>().state;
                String currentEmail = "";
                if (state is ProfileLoaded) currentEmail = state.profile.email;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider.value(
                          value: context.read<ProfileBloc>(),
                          child: ChangePasswordPage(currentEmail: currentEmail),
                        ),
                  ),
                );
              },
              colorScheme,
            ),
            const Divider(height: 32),

            _sectionHeader("TAMPILAN", colorScheme),

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

            const Divider(height: 32),
            _sectionHeader("TENTANG", colorScheme),
            _buildListTile(
              context,
              Icons.info_outline_rounded,
              "Tentang NutriGenius",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              ),
              colorScheme,
            ),

            const SizedBox(height: 50),
            _buildDeleteButton(context),

            const SizedBox(height: 24),
            const Center(
              child: Text(
                "Versi 1.0.0 (Beta)",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.redAccent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () => _showDeleteConfirmDialog(context),
        child: const Text(
          "Hapus Akun Saya",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<ProfileBloc>().add(DeleteAccountRequested());
                },
                child: const Text("Ya, Hapus"),
              ),
            ],
          ),
    );
  }

  Widget _sectionHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
    ColorScheme colorScheme,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
    ColorScheme colorScheme,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeColor: colorScheme.primary,
        onChanged: onChanged,
      ),
    );
  }
}
