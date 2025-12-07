import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    const MaterialApp(
      home: FoodAnalysisScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class FoodAnalysisScreen extends StatefulWidget {
  const FoodAnalysisScreen({super.key});

  @override
  State<FoodAnalysisScreen> createState() => _FoodAnalysisScreenState();
}

class _FoodAnalysisScreenState extends State<FoodAnalysisScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  Map<String, dynamic>? _resultData;

  // Controller untuk URL (supaya gampang diganti-ganti saat testing)
  final TextEditingController _urlController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // 1. Fungsi Ambil Gambar
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _resultData = null; // Reset hasil sebelumnya
      });
    }
  }

  // 2. Fungsi Kirim ke API (Backend Colab)
  Future<void> _analyzeFood() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih gambar dulu ya!")));
      return;
    }

    if (_urlController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Masukkan URL Ngrok dulu!")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Pastikan URL diakhiri dengan /analyze
      String apiUrl = _urlController.text.trim();
      if (!apiUrl.endsWith('/analyze')) {
        // Jika user lupa nulis /analyze, kita tambahkan otomatis
        apiUrl = apiUrl.endsWith('/') ? '${apiUrl}analyze' : '$apiUrl/analyze';
      }

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // 'file' adalah nama parameter yang kita set di FastAPI (api.py)
      request.files.add(
        await http.MultipartFile.fromPath('file', _selectedImage!.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decodedData = jsonDecode(responseData);

        setState(() {
          _resultData = decodedData;
        });
      } else {
        throw Exception("Gagal: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tes Nutrisi AI 🍎")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input URL Ngrok
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: "Paste URL Ngrok Disini",
                hintText: "https://xxxx-xx-xx.ngrok-free.app",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 20),

            // Preview Gambar
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage == null
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.grey,
                            ),
                            Text("Tap untuk pilih foto"),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Analisis
            ElevatedButton(
              onPressed: _isLoading ? null : _analyzeFood,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("🔍 ANALISIS SEKARANG"),
            ),

            const SizedBox(height: 20),

            // Menampilkan Hasil
            if (_resultData != null) ...[
              const Divider(),
              const Text(
                "Hasil Analisis:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildResultCard(),
            ],
          ],
        ),
      ),
    );
  }

  // Widget sederhana untuk menampilkan hasil JSON
  Widget _buildResultCard() {
    final foods = _resultData!['identified_foods'] as List;
    final macros = _resultData!['macronutrients'];
    final suggestions = _resultData!['improvements']['suggestions'] as List;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🍲 Makanan: ${foods.join(', ')}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            _rowDetail("🔥 Kalori", "${macros['calories']} kcal"),
            _rowDetail("🥩 Protein", "${macros['protein']}g"),
            _rowDetail("🍞 Karbo", "${macros['carbohydrates']}g"),
            _rowDetail("🥑 Lemak", "${macros['fat']}g"),
            const Divider(height: 20),
            const Text(
              "Saran AI:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...suggestions.map(
              (s) => Text("• $s", style: const TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
