import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';
// import 'login_page.dart'; // Aktifkan jika file login sudah ada

class ProfilePage extends StatelessWidget {
  // Menerima data dari inputan sebelumnya
  final String weight;
  final String height;
  final int age;

  const ProfilePage({
    super.key,
    this.weight = "65", // Default value jika null
    this.height = "170",
    this.age = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: const [
                    Icon(Icons.spa, color: Colors.green), // Logo kecil dummy
                    SizedBox(width: 8),
                    Text(
                      "NutriGenius",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Profil Saya",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.green[900]
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Foto Profil & Nama
              CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFF81C784), // Hijau muda
                child: const Icon(Icons.person, size: 80, color: Color(0xFF1B5E20)),
              ),
              const SizedBox(height: 16),
              Text(
                "Royhan Firdaus",
                style: TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.green[900]
                ),
              ),
              const Text(
                "Pasien Diabetes",
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 30),

              // Statistik (Berat, Tinggi, Umur)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem("$weight kg", "Berat"),
                  _buildVerticalDivider(),
                  _buildStatItem("$height cm", "Tinggi"),
                  _buildVerticalDivider(),
                  _buildStatItem("$age th", "Umur"),
                ],
              ),
              const SizedBox(height: 40),

              // Menu Options
              _buildMenuButton(
                context, 
                "Edit Profil", 
                Icons.person, 
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()))
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context, 
                "Pengaturan", 
                Icons.settings,
                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()))
              ),
              const SizedBox(height: 40),

              // Tombol Keluar
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    // Logika Logout: Kembali ke Login (PushReplacement agar tidak bisa di-back)
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    
                    // Karena file login belum ada di konteks ini, saya pop ke root atau tampilkan snackbar
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text("Keluar", style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: Color(0xFF2E7D32)
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.green[700]),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green[800]),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(fontSize: 16, color: Colors.green[900], fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}