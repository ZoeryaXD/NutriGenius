import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Tentang NutriGenius",
          style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.green[800]),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green[50],
              ),
              child: Image.asset(
                'assets/images/logo.png',
                width: 80,
                height: 80,
                errorBuilder: (_, __, ___) => Icon(Icons.eco, size: 80, color: Colors.green),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "NutriGenius",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            Text(
              "Versi 1.0.0 (Beta)",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 30),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                "NutriGenius adalah asisten kesehatan pintar yang membantumu menghitung kebutuhan kalori harian (TDEE), memantau nutrisi, dan menjaga pola hidup sehat sesuai kondisi tubuhmu.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
              ),
            ),

            SizedBox(height: 30),
            Divider(),
            SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Meet the Creators",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildTeamMember("Rifqi Falih Ramadhan", "Auth (Login/Register) & FirstPage"),
            _buildTeamMember("Januar Surya Mukti", "Dashboard & AI Food Scan"),
            _buildTeamMember("Royhan Firdaus", "History Log & Profile"),
            _buildTeamMember("Ardika Fatnurivan", "Notification System"),
            
            SizedBox(height: 40),
            Text(
              "© 2026 NutriGenius Project",
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green[100],
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : "?",
                style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}