import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/scan_bloc.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hasil Analisis",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state is ScanFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ScanLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          if (state is ScanSuccess) {
            final data = state.result;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Image Preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        kIsWeb
                            ? Image.network(
                              data.imagePath,
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                            : Image.file(
                              File(data.imagePath),
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    data.foodName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nutrition Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hasil Analisis:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(),
                        _buildRow("Kalori", "${data.calories} kkal"),
                        _buildRow("Protein", "${data.protein}g"),
                        _buildRow("Karbo", "${data.carbs}g"),
                        _buildRow("Lemak", "${data.fat}g"),
                        const SizedBox(height: 15),
                        const Text(
                          "Saran AI:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          data.aiSuggestion,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickImage(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green),
                            shape: StadiumBorder(),
                          ),
                          child: const Text(
                            "Scan Lagi",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              () => context.read<ScanBloc>().add(
                                OnSaveResult(data),
                              ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade50,
                            foregroundColor: Colors.teal,
                            shape: StadiumBorder(),
                          ),
                          child: const Text("Simpan"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          // Initial State
          return Center(
            child: ElevatedButton.icon(
              onPressed: () => _pickImage(context),
              icon: const Icon(Icons.camera_alt),
              label: const Text("Ambil Foto Makanan"),
              style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Pastikan userId dikirim sesuai user yang sedang login
      context.read<ScanBloc>().add(OnAnalyzeImage(image, 1));
    }
  }
}
