import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/food_item.dart';
import 'scan_result_page.dart';
//import '../../../../core/theme/app_colors.dart';
// import logic untuk upload gambar disini nanti

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(firstCamera, ResolutionPreset.medium);

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Camera Preview Full Screen
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: CameraPreview(_controller!),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),

          // 2. Overlay Kotak (Reticle)
          Center(
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_cornerIcon(0), _cornerIcon(1)],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_cornerIcon(3), _cornerIcon(2)],
                  ),
                ],
              ),
            ),
          ),

          // 3. Tombol Shutter & Back
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    // Logika Ambil Gambar
                    final image = await _controller!.takePicture();

                    // Create a sample FoodItem (in production, this would come from API)
                    final foodItem = FoodItem(
                      foodName: 'Food Item',
                      calories: 0,
                      protein: 0,
                      carbs: 0,
                      fat: 0,
                      imagePath: image.path,
                    );

                    // Navigate to ScanResultPage with image path and food item
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ScanResultPage(
                                imagePath: image.path,
                                foodItem: foodItem,
                              ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Arahkan kamera ke makanan",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          // Tombol Back di pojok kiri atas
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  // Widget kecil untuk membuat efek siku-siku di pojok frame
  Widget _cornerIcon(int turns) {
    return RotatedBox(
      quarterTurns: turns,
      child: const Icon(
        Icons.crop_free,
        color: Colors.white,
        size: 30,
      ), // Placeholder icon
    );
  }
}
