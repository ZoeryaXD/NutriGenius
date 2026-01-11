import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/scan_bloc.dart';
import 'camera_page.dart';
import 'scan_result_page.dart';
import '../../domain/entities/scan_result.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();

  /// 🖼️ PICK IMAGE FROM GALLERY
  Future<void> _pickFromGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (!mounted || image == null) return;

      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      if (!mounted) return;

      if (email == null || email.isEmpty) {
        _showError("Sesi habis, silakan login ulang");
        return;
      }

      context.read<ScanBloc>().add(
        AnalyzeImageEvent(
          imagePath: image.path,
          email: email,
          source: ScanSource.gallery,
        ),
      );
    } catch (e) {
      debugPrint("❌ Pick gallery error: $e");
      _showError("Gagal mengambil gambar dari galeri");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("❌ $message"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: BlocConsumer<ScanBloc, ScanState>(
          listener: (context, state) {
            if (state is ScanFailure) {
              _showError(state.message);
            }
          },
          builder: (context, state) {
            /// 🔄 ANALYZING
            if (state is ScanLoading) {
              return const _LoadingView();
            }

            /// ✅ ANALYSIS SUCCESS
            if (state is ScanSuccess) {
              return ScanResultPage(
                data: state.result,
                source: state.source,
              );
            }

            /// 🟢 IDLE (DEFAULT)
            return _IdleView(
              onCamera: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CameraPage()),
                );
              },
              onGallery: _pickFromGallery,
            );
          },
        ),
      ),
    );
  }
}

/// ======================
/// 🔄 LOADING VIEW
/// ======================
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
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
}

/// ======================
/// 🟢 IDLE VIEW
/// ======================
class _IdleView extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const _IdleView({
    required this.onCamera,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: 110,
            color: Colors.green.shade200,
          ),
          const SizedBox(height: 20),
          const Text(
            "Scan Makananmu",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Gunakan kamera atau pilih dari galeri",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 35),

          /// 📷 CAMERA
          ElevatedButton.icon(
            onPressed: onCamera,
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

          /// 🖼️ GALLERY
          ElevatedButton.icon(
            onPressed: onGallery,
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
  }
}