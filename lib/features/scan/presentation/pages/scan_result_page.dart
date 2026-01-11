import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/scan_result.dart';
import '../bloc/scan_bloc.dart';
import 'camera_page.dart';

class ScanResultPage extends StatelessWidget {
  final ScanResult data;
  final ScanSource source;

  const ScanResultPage({super.key, required this.data, required this.source});

  void _scanUlang(BuildContext context) {
    if (source == ScanSource.camera) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CameraPage()),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String cleanPath = data.imagePath.replaceAll(r'\', '/');
    cleanPath = cleanPath
        .replaceAll('public/', '')
        .replaceAll('uploads/scans/', '');

    final imageUrl =
        "${ApiClient.baseUrl.replaceAll('/api', '')}/uploads/scans/$cleanPath";

    return BlocListener<ScanBloc, ScanState>(
      listener: (context, state) {
        if (state is ScanSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Data berhasil disimpan"),
              backgroundColor: Colors.green,
            ),
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/history',
              (route) => false,
            );
          });
        }

        if (state is ScanFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("❌ ${state.message}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            "Hasil Analisis",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.green),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imageError(),
                ),
              ),

              const SizedBox(height: 20),
              _nutritionCard(),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _scanUlang(context),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Scan Ulang"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: const StadiumBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/dashboard',
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final email = prefs.getString('email');

                        if (email == null) return;

                        context.read<ScanBloc>().add(
                          SaveResultEvent(result: data, email: email),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nutritionCard() {
    final d = data;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text("🍲 ", style: TextStyle(fontSize: 24)),
              Expanded(
                child: Text(
                  d.foodName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          _macro(Icons.local_fire_department, "Kalori", "${d.calories} kcal"),
          _macro(Icons.fitness_center, "Protein", "${d.protein}g"),
          _macro(Icons.bakery_dining, "Karbo", "${d.carbs}g"),
          _macro(Icons.opacity, "Lemak", "${d.fat}g"),
          const SizedBox(height: 15),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Saran AI:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          Text(d.aiSuggestion, style: const TextStyle(height: 1.5)),
        ],
      ),
    );
  }

  Widget _macro(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.black54)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _imageError() {
    return Container(
      height: 250,
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, size: 50, color: Colors.grey),
            Text("Gagal memuat gambar"),
          ],
        ),
      ),
    );
  }
}
