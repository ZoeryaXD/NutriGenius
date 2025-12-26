import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State untuk Switch
  bool _mealReminder = true;
  bool _sugarWarning = true;
  bool _darkMode = false;

  final Color primaryGreen = const Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background agak abu sedikit biar list menonjol
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Pengaturan", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("AKUN"),
            _buildListTile(Icons.lock_outline, "Ganti Password"),
            _buildListTile(Icons.track_changes, "Target Kesehatan (TDEE)"),
            
            const SizedBox(height: 20),
            _buildSectionHeader("NOTIFIKASI"),
            _buildSwitchTile(
              Icons.access_time, 
              "Ingatkan Makan", 
              "Sarapan, Siang, Malam", 
              _mealReminder, 
              (val) => setState(() => _mealReminder = val)
            ),
            _buildSwitchTile(
              Icons.health_and_safety_outlined, 
              "Peringatan Gula Tinggi", 
              "Saat scan makanan", 
              _sugarWarning, 
              (val) => setState(() => _sugarWarning = val)
            ),

            const SizedBox(height: 20),
            _buildSectionHeader("TAMPILAN"),
            _buildSwitchTile(
              Icons.dark_mode_outlined, 
              "Mode Gelap", 
              null, 
              _darkMode, 
              (val) => setState(() => _darkMode = val)
            ),
            _buildListTile(Icons.language, "Bahasa / Language"),

            const SizedBox(height: 20),
            _buildSectionHeader("TENTANG"),
            _buildListTile(Icons.info_outline, "Tentang NutriGenius"),
            _buildListTile(Icons.privacy_tip_outlined, "Kebijakan Privasi"),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.white
                ),
                onPressed: () {
                  // Aksi Hapus Akun
                },
                child: const Text("Hapus Akun Saya", style: TextStyle(color: Colors.red, fontSize: 16)),
              ),
            ),
            
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Versi 1.0.0 (Beta)",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF2E7D32),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, spreadRadius: 1)],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String? subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, spreadRadius: 1)],
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
        value: value,
        activeColor: const Color(0xFF2E7D32),
        onChanged: onChanged,
      ),
    );
  }
}