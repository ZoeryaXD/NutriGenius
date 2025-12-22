import 'package:flutter/material.dart';
import 'package:nutrigenius/features/dashboard/presentation/pages/home_page.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Langkah 3 dari 3",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Target Nutrisi Kamu",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 40),

            // Lingkaran Kalori
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryGreen, width: 8),
                  ),
                ),
                Icon(Icons.local_fire_department, size: 60, color: primaryGreen),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "2000 Kcal",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
            ),
            const Text(
              "Batas Harian Kamu",
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            
            const SizedBox(height: 40),

            // Rincian
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Rincian:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryGreen)),
            ),
            const SizedBox(height: 10),
            _buildDetailItem("BMR (Energi Dasar): 1.600 kkal", primaryGreen),
            _buildDetailItem("Aktivitas Harian: +400 kkal", primaryGreen),

            const SizedBox(height: 40),
            Text(
              "Mulai hari ini, kami akan membantumu tetap di bawah angka 2000 kkal!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.green[800]),
            ),

            const Spacer(),
            // Tombol Dashboard
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                child: const Text("Masuk Dashboard", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 14, color: color),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.green[900], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}