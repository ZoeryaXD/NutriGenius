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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Scan Makanan",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
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
          if (state is ScanLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 20),
                  Text(
                    "NutriGenius sedang menganalisis...",
                    style: theme.textTheme.bodyMedium,
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
                  color: primaryColor.withOpacity(0.3),
                ),
                const SizedBox(height: 20),
                Text(
                  "Ayo Scan Makananmu!",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CameraPage()),
                      ),
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text(
                    "Ambil Foto",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Fitur Galeri Segera Hadir",
                  style: theme.textTheme.bodySmall,
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
    final messenger = ScaffoldMessenger.of(context);
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
          messenger.showSnackBar(
            const SnackBar(content: Text("Sesi habis. Login ulang.")),
          );
          return;
        }
        scanBloc.add(AnalyzeImageEvent(imagePath: image.path, email: email));
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text("Gagal mengambil gambar: $e")),
      );
    }
  }
}
