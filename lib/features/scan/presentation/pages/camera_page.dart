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

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized)
      return;

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint("Error Init Camera: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state is ScanSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ScanResultPage(
                      data: state.result,
                      onScanGallery: () => Navigator.pop(context),
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
              if (_isCameraInitialized && _controller != null)
                SizedBox.expand(child: CameraPreview(_controller!))
              else
                Center(child: CircularProgressIndicator(color: primaryColor)),
              Center(
                child: Container(
                  height: 280,
                  width: 280,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: _cornerIcon(0, primaryColor),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: _cornerIcon(1, primaryColor),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: _cornerIcon(2, primaryColor),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: _cornerIcon(3, primaryColor),
                      ),
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
                      CircularProgressIndicator(color: primaryColor)
                    else
                      GestureDetector(
                        onTap: () async {
                          if (_controller == null ||
                              !_controller!.value.isInitialized)
                            return;
                          if (_controller!.value.isTakingPicture) return;

                          final scanBloc = context.read<ScanBloc>();
                          final messenger = ScaffoldMessenger.of(context);

                          try {
                            final image = await _controller!.takePicture();
                            if (!mounted) return;
                            final prefs = await SharedPreferences.getInstance();
                            final email = prefs.getString('email');
                            if (!mounted) return;

                            if (email == null) {
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text("Sesi habis, login ulang"),
                                ),
                              );
                              return;
                            }
                            scanBloc.add(
                              AnalyzeImageEvent(
                                imagePath: image.path,
                                email: email,
                              ),
                            );
                          } catch (e) {
                            if (mounted)
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text("Gagal ambil gambar"),
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

  Widget _cornerIcon(int turns, Color color) {
    return RotatedBox(
      quarterTurns: turns,
      child: Icon(Icons.crop_free, color: color, size: 40),
    );
  }
}
