import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../../scan/presentation/pages/scan_page.dart';
import '../../../scan/presentation/pages/camera_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../scan/presentation/bloc/scan_bloc.dart';

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
                return Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              } else if (state is DashboardLoaded) {
                return _buildDashboardContent(context, state.data);
              } else if (state is DashboardError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        SizedBox(height: 10),
                        Text(
                          "Gagal memuat data",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<DashboardBloc>().add(LoadDashboard());
                          },
                          child: Text("Coba Lagi"),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardEntity data) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==============================
          // 1. LOGO & APP NAME
          // ==============================
          Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 32,
                height: 32,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Icon(Icons.eco, color: Colors.green, size: 32),
              ),
              SizedBox(width: 10),
              Text(
                "NutriGenius",
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // ==============================
          // 2. SAPAAN & NAMA USER
          // ==============================
          Text(
            _getGreeting(),
            style: TextStyle(color: Colors.green[700], fontSize: 16),
          ),
          Text(
            // Tampilkan nama dari backend, atau default jika kosong
            (data.displayName.isNotEmpty) ? data.displayName : "Nutri User",
            style: TextStyle(
              color: Colors.green[800],
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 24),

          // ==============================
          // 3. HERO CARD (PROGRESS HARIAN)
          // ==============================
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kalori Masuk",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 4),

                    Text(
                      "${data.caloriesConsumed.toInt()}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "dari target ${data.tdee.toInt()} kkal",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),

                // CIRCULAR PROGRESS
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        color: Colors.white.withOpacity(0.2),
                        strokeWidth: 8,
                      ),
                    ),

                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: data.progress,
                        color: Colors.white,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                      ),
                    ),

                    Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 32,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // ==============================
          // 4. MAKRO NUTRISI
          // ==============================
          Text(
            "Makro Nutrisi (Harian)",
            style: TextStyle(
              color: Colors.green[800],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildMacroCard(
                "Protein",
                "${data.proteinConsumed.toInt()}g",
                Icons.fitness_center,
              ),
              SizedBox(width: 12),
              _buildMacroCard(
                "Karbo",
                "${data.carbsConsumed.toInt()}g",
                Icons.grain,
              ),
              SizedBox(width: 12),
              _buildMacroCard(
                "Lemak",
                "${data.fatConsumed.toInt()}g",
                Icons.water_drop,
              ),
            ],
          ),

          SizedBox(height: 24),

          // ==============================
          // 5. TOMBOL SCAN
          // ==============================
          Text(
            "Scan Makananmu",
            style: TextStyle(
              color: Colors.green[800],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              onPressed: () {
                _showScanOptions(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.center_focus_strong,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Mulai Scan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

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

  void _showScanOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Pilih Metode Scan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionBtn(context, Icons.camera_alt, "Kamera", () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const CameraPage(),
                      ),
                    );
                  }),
                  _buildOptionBtn(context, Icons.photo_library, "Galeri", () {
                    _handleScan(context, ImageSource.gallery);
                  }),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionBtn(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green[50],
            child: Icon(icon, color: Colors.green[700], size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.green[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.orange, size: 24),
            SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleScan(BuildContext context, ImageSource source) async {
    try {
      Navigator.pop(context);

      final picker = ImagePicker();
      final image = await picker.pickImage(source: source);

      if (image != null) {
        final prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('email');

        if (email == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sesi habis, silakan login ulang")),
          );
          return;
        }

        print("📸 Dashboard: Mengirim foto dengan email: $email");

        context.read<ScanBloc>().add(
          AnalyzeImageEvent(imagePath: image.path, email: email),
        );

        Navigator.pushNamed(context, '/scan');
      }
    } catch (e) {
      print("Error saat scan dashboard: $e");
    }
  }
}
