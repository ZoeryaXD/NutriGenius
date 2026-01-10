import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../injection_container.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import 'about_page.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_switch_tile.dart';
import 'change_password_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifMakan = true;
  bool _notifGula = true;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _notifMakan = pref.getBool('notifMakan') ?? true;
      _notifGula = pref.getBool('notifGula') ?? true;
      _darkMode = pref.getBool('darkMode') ?? false;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(key, value);
  }

  void _settingsListener(BuildContext context, ProfileState state) {
    if (state.status == ProfileStatus.initial && state.profile == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (r) => false,
      );
    }
    if (state.status == ProfileStatus.error && state.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message!), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pengaturan",
          style: TextStyle(
            color: isDark ? Colors.white : theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: isDark ? Colors.white : theme.primaryColor),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: _settingsListener,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              children: [
                _sectionHeader("AKUN", theme),
                ProfileMenuItem(
                  icon: Icons.lock_outline,
                  label: "Ganti Password",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 32),
                _sectionHeader("NOTIFIKASI", theme),
                ProfileSwitchTile(
                  icon: Icons.access_time,
                  title: "Ingatkan Makan",
                  value: _notifMakan,
                  onChanged: (v) {
                    setState(() => _notifMakan = v);
                    _saveSetting('notifMakan', v);
                  },
                ),
                ProfileSwitchTile(
                  icon: Icons.security,
                  title: "Peringatan Gula Tinggi",
                  value: _notifGula,
                  onChanged: (v) {
                    setState(() => _notifGula = v);
                    _saveSetting('notifGula', v);
                  },
                ),
                const Divider(height: 32),
                _sectionHeader("TAMPILAN", theme),
                ProfileSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: "Mode Gelap",
                  value: _darkMode,
                  onChanged: (v) => _onDarkModeChanged(v),
                ),
                const Divider(height: 32),
                _sectionHeader("TENTANG", theme),
                ProfileMenuItem(
                  icon: Icons.info_outline,
                  label: "Tentang NutriGenius",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutPage()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ProfileMenuItem(
                  icon: Icons.delete_forever,
                  label: "Hapus Akun Saya",
                  isDestructive: true,
                  onTap: () => _showDeleteConfirmDialog(context),
                ),
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
        ),
      ),
    );
  }

  void _onDarkModeChanged(bool value) async {
    final pref = sl<SharedPreferences>();
    await pref.setBool('darkMode', value);
    themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
    setState(() => _darkMode = value);
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Hapus Akun?"),
            content: const Text("Semua data Anda akan hilang secara permanen."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<ProfileBloc>().add(LogoutRequested());
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
