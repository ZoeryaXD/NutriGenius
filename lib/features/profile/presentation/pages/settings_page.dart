import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../injection_container.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../auth/presentation/pages/login_page.dart';

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
    if (state is LogoutSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
        (r) => false,
      );
    }
    if (state is ProfileError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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
                _buildListTile(Icons.lock_outline, "Ganti Password", () {
                  _openChangePassword(context);
                }),
                const Divider(),
                _sectionHeader("NOTIFIKASI", theme),
                _buildSwitchTile(
                  Icons.access_time,
                  "Ingatkan Makan",
                  _notifMakan,
                  (v) {
                    setState(() => _notifMakan = v);
                    _saveSetting('notifMakan', v);
                  },
                ),
                _buildSwitchTile(
                  Icons.security,
                  "Peringatan Gula Tinggi",
                  _notifGula,
                  (v) {
                    setState(() => _notifGula = v);
                    _saveSetting('notifGula', v);
                  },
                ),
                const Divider(),
                _sectionHeader("TAMPILAN", theme),
                _buildSwitchTile(
                  Icons.dark_mode_outlined,
                  "Mode Gelap",
                  _darkMode,
                  (v) => _onDarkModeChanged(v),
                ),
                const Divider(),
                _sectionHeader("TENTANG", theme),
                _buildListTile(
                  Icons.info_outline,
                  "Tentang NutriGenius",
                  () {},
                ),
                _buildListTile(
                  Icons.privacy_tip_outlined,
                  "Kebijakan Privasi",
                  () {},
                ),
                const SizedBox(height: 48),
                _buildDeleteAccountButton(),
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

  void _openChangePassword(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ganti Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password Lama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password Baru",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Simpan Password"),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _onDarkModeChanged(bool value) async {
    final pref = sl<SharedPreferences>();
    await pref.setBool('darkMode', value);
    themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
    setState(() {
      _darkMode = value;
    });
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Hapus Akun?"),
            content: const Text(
              "Aksi ini tidak dapat dibatalkan. Semua data Anda akan hilang.",
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
                child: const Text(
                  "Ya, Hapus",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _showDeleteConfirmDialog(context),
        child: const Text(
          "Hapus Akun Saya",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: theme.primaryColor,
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      trailing: Switch(
        value: value,
        activeColor: Colors.green,
        onChanged: onChanged,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
