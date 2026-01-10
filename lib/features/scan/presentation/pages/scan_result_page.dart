import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nutrigenius/features/scan/domain/entities/scan_result.dart';
import '../../../../core/network/api_client.dart';
import 'camera_page.dart';

class ScanResultPage extends StatefulWidget {
  final ScanResult data;
  final ScanSource source;

  const ScanResultPage({super.key, required this.data, required this.source});

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  Timer? _saveTimer;

  void _handleSaveAction() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menyimpan ke Jurnal Makanan...'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );

    _saveTimer = Timer(const Duration(seconds: 1), () {
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, '/history', (route) => false);
    });
  }

  void _scanUlang() {
    if (!mounted) return;

    if (widget.source == ScanSource.camera) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CameraPage()),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String cleanPath = widget.data.imagePath.replaceAll(r'\', '/');
    cleanPath = cleanPath
        .replaceAll('public/', '')
        .replaceAll('uploads/scans/', '');

    final imageUrl =
        "${ApiClient.baseUrl.replaceAll('/api', '')}/uploads/scans/$cleanPath";

    return Scaffold(
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
                onPressed: _scanUlang,
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
                      if (!mounted) return;
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
                    onPressed: _handleSaveAction,
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
    );
  }

  Widget _nutritionCard() {
    final d = widget.data;

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
          _macro(
            Icons.local_fire_department,
            "Kalori",
            "${d.calories} kcal",
            Colors.orange,
          ),
          _macro(
            Icons.fitness_center,
            "Protein",
            "${d.protein}g",
            Colors.redAccent,
          ),
          _macro(Icons.bakery_dining, "Karbo", "${d.carbs}g", Colors.brown),
          _macro(Icons.opacity, "Lemak", "${d.fat}g", Colors.amber),
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

  Widget _macro(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
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
