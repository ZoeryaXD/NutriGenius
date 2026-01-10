import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrigenius/features/scan/domain/entities/scan_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/scan_bloc.dart';
import 'camera_page.dart';
import 'scan_result_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (!mounted) return;

      if (image == null) return;

      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return;

      final email = prefs.getString('email');

      if (email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sesi habis. Silakan login ulang.")),
        );
        return;
      }

      context.read<ScanBloc>().add(
        AnalyzeImageEvent(imagePath: image.path, email: email, source: ScanSource.gallery),
      );
    } catch (e) {
      if (!mounted) return;

      debugPrint("❌ Error Pick Image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengambil gambar dari galeri")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: BlocConsumer<ScanBloc, ScanState>(
          listener: (context, state) {
            if (state is ScanFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ScanLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      "NutriGenius sedang menganalisis...",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            if (state is ScanSuccess) {
              return ScanResultPage(data: state.result, source: ScanSource.gallery,);
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 100,
                    color: Colors.green.shade200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Ayo Scan Makananmu!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed:
                        state is ScanLoading
                            ? null
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CameraPage(),
                                ),
                              );
                            },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Ambil Foto"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton.icon(
                    onPressed:
                        state is ScanLoading
                            ? null
                            : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Pilih dari Galeri"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}