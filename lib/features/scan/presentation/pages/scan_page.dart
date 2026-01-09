import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/scan_bloc.dart';
import 'camera_page.dart';
import 'scan_result_page.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Scan Makanan",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ScanBloc, ScanState>(
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
          // 1. LOADING
          if (state is ScanLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 20),
                  Text(
                    "NutriGenius sedang menganalisis...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (state is ScanSuccess) {
            return ScanResultPage(
              data: state.result,
              onScanGallery: () => _pickImage(context, ImageSource.gallery),
            );
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraPage(),
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

                // ElevatedButton.icon(
                //   onPressed: () => _pickImage(context, ImageSource.gallery),
                //   icon: const Icon(Icons.photo_library),
                //   label: const Text("Pilih dari Galeri"),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green.shade400,
                //     shape: const StadiumBorder(),
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 30,
                //       vertical: 15,
                //     ),
                //   ),
                // ),

                const Text(
                   "Fitur Galeri Segera Hadir",
                   style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                ),
                
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final scanBloc = context.read<ScanBloc>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        final prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('email');

        if (email == null) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text("Sesi habis. Silakan Login ulang.")),
          );
          return;
        }

        scanBloc.add(AnalyzeImageEvent(imagePath: image.path, email: email));
      }
    } catch (e) {
      debugPrint("Error Pick Image: $e");
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Gagal mengambil gambar: $e")),
      );
    }
  }
}
