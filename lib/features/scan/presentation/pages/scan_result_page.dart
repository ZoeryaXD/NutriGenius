import 'package:flutter/material.dart';
import 'package:nutrigenius/features/scan/domain/entities/scan_result.dart';
import '../../../../core/network/api_client.dart';
import 'camera_page.dart';

class ScanResultPage extends StatelessWidget {
  final ScanResult data;
  final VoidCallback onScanGallery;

  const ScanResultPage({
    super.key,
    required this.data,
    required this.onScanGallery,
  });

void _handleSaveAction(BuildContext context) {
  
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menyimpan ke Jurnal Makanan...'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/history', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    String cleanPath = data.imagePath.replaceAll(r'\', '/');
    cleanPath = cleanPath
        .replaceAll('public/', '')
        .replaceAll('uploads/scans/', '');

    final String imageUrl =
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
                errorBuilder:
                    (ctx, err, stack) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                          Text(
                            "Gagal memuat gambar",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text("🍲 ", style: TextStyle(fontSize: 24)),
                      Expanded(
                        child: Text(
                          data.foodName,
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
                  _buildMacroRow(
                    Icons.local_fire_department,
                    "Kalori",
                    "${data.calories} kcal",
                    Colors.orange,
                  ),
                  _buildMacroRow(
                    Icons.fitness_center,
                    "Protein",
                    "${data.protein}g",
                    Colors.redAccent,
                  ),
                  _buildMacroRow(
                    Icons.bakery_dining,
                    "Karbo",
                    "${data.carbs}g",
                    Colors.brown,
                  ),
                  _buildMacroRow(
                    Icons.opacity,
                    "Lemak",
                    "${data.fat}g",
                    Colors.yellow[800]!,
                  ),

                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Saran AI:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data.aiSuggestion,
                    style: TextStyle(color: Colors.grey[800], height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraPage()),
                  );
                },
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
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                       _handleSaveAction(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ), 
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
}
