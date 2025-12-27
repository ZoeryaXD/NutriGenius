import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(LoadDashboard()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return Center(child: CircularProgressIndicator(color: Colors.green));
              } else if (state is DashboardLoaded) {
                return _buildDashboardContent(context, state.data);
              } else if (state is DashboardError) {
                return Center(child: Text("Gagal memuat data: ${state.message}"));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, dynamic data) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==============================
          // 1. LOGO & JUDUL (Sesuai Request)
          // ==============================
          Row(
            children: [
              // Ganti Icon dengan Gambar Aset
              Image.asset(
                'assets/images/logo.png',
                width: 32, 
                height: 32,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.eco, color: Colors.green, size: 32), // Fallback jika gambar gagal load
              ),
              SizedBox(width: 10),
              Text(
                "NutriGenius", 
                style: TextStyle(
                  color: Colors.green[800], 
                  fontWeight: FontWeight.bold, 
                  fontSize: 20
                )
              ),
            ],
          ),
          
          SizedBox(height: 24),

          // ==============================
          // 2. SAPAAN WAKTU & NAMA USER
          // ==============================
          Text(
            _getGreeting(), // Fungsi otomatis Pagi/Siang/Sore/Malam
            style: TextStyle(color: Colors.green[700], fontSize: 16),
          ),
          Text(
            data.displayName.isNotEmpty ? data.displayName : "Rifqi Falih Ramadhan", // Fallback nama
            style: TextStyle(
              color: Colors.green[800], 
              fontSize: 24, 
              fontWeight: FontWeight.bold
            )
          ),
          
          SizedBox(height: 24),

          // ==============================
          // 3. HERO CARD (Kalori)
          // ==============================
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sisa Kalori!", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    SizedBox(height: 4),
                    // Tampilkan Sisa Kalori
                    Text(
                      "${data.remainingCalories}", 
                      style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)
                    ),
                    Text(
                      "dari target ${data.tdee.toInt()} kkal", 
                      style: TextStyle(color: Colors.white70, fontSize: 12)
                    ),
                  ],
                ),
                // Circular Progress
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80, height: 80,
                      child: CircularProgressIndicator(
                        value: 1.0, // Lingkaran Penuh (Background)
                        color: Colors.white.withOpacity(0.2),
                        strokeWidth: 8,
                      ),
                    ),
                    SizedBox(
                      width: 80, height: 80,
                      child: CircularProgressIndicator(
                        value: data.progress, // Progress (Konsumsi / Target)
                        color: Colors.white,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Icon(Icons.local_fire_department, color: Colors.white, size: 32),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // ==============================
          // 4. MAKRO NUTRISI
          // ==============================
          Text("Makro Nutrisi", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 12),
          Row(
            children: [
              _buildMacroCard("Protein", "${data.proteinTarget}g", Icons.fitness_center),
              SizedBox(width: 12),
              _buildMacroCard("Carbs", "${data.carbsTarget}g", Icons.grain), 
              SizedBox(width: 12),
              _buildMacroCard("Fat", "${data.fatTarget}g", Icons.water_drop),
            ],
          ),

          SizedBox(height: 24),

          // ==============================
          // 5. TOMBOL SCAN (Logic BottomSheet)
          // ==============================
          Text("Scan Makananmu", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              onPressed: () => _showScanOptions(context), // Panggil BottomSheet
              child: Icon(Icons.center_focus_strong, size: 40, color: Colors.white),
            ),
          ),
          
          // Padding tambahan agar tidak mentok bawah scroll
          SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- LOGIC TAMBAHAN ---

  // 1. Logika Waktu Sapaan
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 11) {
      return 'Selamat Pagi,';
    } else if (hour < 15) {
      return 'Selamat Siang,';
    } else if (hour < 18) {
      return 'Selamat Sore,';
    } else {
      return 'Selamat Malam,';
    }
  }

  // 2. Logika BottomSheet Kamera
  void _showScanOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 180,
          child: Column(
            children: [
              Text("Pilih Metode Scan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionBtn(context, Icons.camera_alt, "Kamera", () {
                    Navigator.pop(context);
                    // TODO: Arahkan ke Fitur Scan Page (Mode Kamera)
                    print("Buka Kamera"); 
                  }),
                  _buildOptionBtn(context, Icons.photo_library, "Galeri", () {
                    Navigator.pop(context);
                    // TODO: Arahkan ke Fitur Scan Page (Mode Galeri)
                    print("Buka Galeri");
                  }),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionBtn(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green[100],
            child: Icon(icon, color: Colors.green[800], size: 30),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.green[800]))
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.orange, size: 24),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}