import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/scan_bloc.dart';
import 'scan_result_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (cameras.isEmpty) return;

    _controller = CameraController(cameras.first, ResolutionPreset.high);
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
      backgroundColor: Colors.black,
      body: BlocConsumer<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state is ScanSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ScanResultPage(
                      data: state.result,
                      onScanGallery: () {
                        Navigator.pop(context);
                      },
                    ),
              ),
            );
          } else if (state is ScanFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SizedBox.expand(child: CameraPreview(_controller!));
                  }
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
              ),

              Center(
                child: Container(
                  height: 280,
                  width: 280,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Positioned(top: 0, left: 0, child: _cornerIcon(0)),
                      Positioned(top: 0, right: 0, child: _cornerIcon(1)),
                      Positioned(bottom: 0, right: 0, child: _cornerIcon(2)),
                      Positioned(bottom: 0, left: 0, child: _cornerIcon(3)),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    if (state is ScanLoading)
                      const CircularProgressIndicator(color: Colors.green)
                    else
                      GestureDetector(
                        onTap: () async {
                          if (_controller == null ||
                              !_controller!.value.isInitialized)
                            return;
                          try {
                            final image = await _controller!.takePicture();
                            final prefs = await SharedPreferences.getInstance();
                            final email = prefs.getString('email');
                            if (!mounted) return;

                            if (email == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Sesi habis, silakan login ulang",
                                  ),
                                ),
                              );
                              return;
                            }

                            context.read<ScanBloc>().add(
                              AnalyzeImageEvent(
                                imagePath: image.path,
                                email: email,
                              ),
                            );
                          } catch (e) {
                            debugPrint("Error capture: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Gagal mengambil gambar"),
                              ),
                            );
                          }
                        },
                        child: _buildShutterButton(),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      "Arahkan kamera ke makanan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol Back
              Positioned(
                top: 50,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShutterButton() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Center(
        child: Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _cornerIcon(int turns) {
    return RotatedBox(
      quarterTurns: turns,
      child: const Icon(Icons.crop_free, color: Colors.green, size: 40),
    );
  }
}