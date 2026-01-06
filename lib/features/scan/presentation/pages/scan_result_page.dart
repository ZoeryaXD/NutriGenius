import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/scan_result.dart';
import '../bloc/scan_bloc.dart';


class ScanResultPage extends StatelessWidget {
  final ScanResult scanResult;

  const ScanResultPage({super.key, required this.scanResult});

  @override
  Widget build(BuildContext context) {
    // Logic URL Gambar
    final String imageUrl =
        "${ApiClient.baseUrl.replaceAll('/api', '')}/uploads/scans/${scanResult.imagePath}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Hasil Analisis",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.green), // Icon Close (Batal)
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // 👇 LISTEN STATE BLOC DISINI
      body: BlocListener<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state is ScanSaved) {
            // ✅ SUKSES SIMPAN: Balik ke Dashboard
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Berhasil disimpan ke Jurnal!"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
          if (state is ScanFailure) {
            // ❌ GAGAL
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Gambar Hasil Scan
              Container(
                height: 250,
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
              ),

              Text(
                scanResult.foodName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 20),

              // 2. Card Nutrisi
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    _buildNutrientRow("🔥 Kalori", "${scanResult.calories} kkal"),
                    _buildNutrientRow("💪 Protein", "${scanResult.protein}g"),
                    _buildNutrientRow("🍞 Karbohidrat", "${scanResult.carbs}g"),
                    _buildNutrientRow("🥑 Lemak", "${scanResult.fat}g"),
                    _buildNutrientRow("🍭 Gula", "${scanResult.sugar}g"),
                    const Divider(height: 30),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Saran AI:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      scanResult.aiSuggestion,
                      style: const TextStyle(color: Colors.black87, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 3. Action Buttons (LOGIC BARU)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    // TOMBOL BATAL
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context), // Cukup Pop (Data hilang)
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: const BorderSide(color: Colors.red),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // TOMBOL SIMPAN
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Ambil Email & Trigger SaveResultEvent
                          final prefs = await SharedPreferences.getInstance();
                          final email = prefs.getString('email');

                          if (email != null) {
                            context.read<ScanBloc>().add(
                              SaveResultEvent(result: scanResult, email: email),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Sesi habis, silakan login ulang.")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Simpan Jurnal",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}