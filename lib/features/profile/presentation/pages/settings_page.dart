import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../auth/presentation/pages/login_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifMakan = true;
  bool _notifGula = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Pengaturan",
          style: TextStyle(
            color: Colors.green[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.green[800]),
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
          padding: EdgeInsets.all(20),
          children: [
            _sectionHeader("AKUN"),
            _buildListTile(Icons.lock_outline, "Ganti Password", () {}),
            Divider(),

            _sectionHeader("NOTIFIKASI"),
            _buildSwitchTile(
              Icons.access_time,
              "Ingatkan Makan",
              _notifMakan,
              (v) => setState(() => _notifMakan = v),
            ),
            _buildSwitchTile(
              Icons.security,
              "Peringatan Gula Tinggi",
              _notifGula,
              (v) => setState(() => _notifGula = v),
            ),
            Divider(),

            _sectionHeader("TAMPILAN"),
            _buildSwitchTile(
              Icons.dark_mode_outlined,
              "Mode Gelap",
              _darkMode,
              (v) => setState(() => _darkMode = v),
            ),
            _buildListTile(Icons.language, "Bahasa / Language", () {}),
            Divider(),

            _sectionHeader("TENTANG"),
            _buildListTile(Icons.info_outline, "Tentang NutriGenius", () {}),
            _buildListTile(
              Icons.privacy_tip_outlined,
              "Kebijakan Privasi",
              () {},
            ),

            SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _showDeleteConfirmDialog(context),
                child: Text(
                  "Hapus Akun Saya",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Versi 1.0.0 (Beta)",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text("Hapus Akun?"),
            content: Text(
              "Aksi ini tidak dapat dibatalkan. Semua data Anda akan hilang.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<ProfileBloc>().add(DeleteAccountRequested());
                },
                child: Text("Ya, Hapus"),
              ),
            ],
          ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.green[800],
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        activeColor: Colors.green,
        onChanged: onChanged,
      ),
    );
  }
}
