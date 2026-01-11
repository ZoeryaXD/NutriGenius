import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/scan/domain/entities/scan_result.dart';
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
    final cameraController = _controller;

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

      final controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint("❌ Error Init Camera: $e");
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<ScanBloc, ScanState>(
        listener: (context, state) {
          if (!mounted) return;

          if (state is ScanSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ScanResultPage(data: state.result, source: ScanSource.camera,),
              ),
            );
          }

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
          return Stack(
            children: [
              if (_isCameraInitialized && _controller != null)
                SizedBox.expand(child: CameraPreview(_controller!))
              else
                const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                ),

              Center(child: _scanFrame()),

              _buildBottomControls(state),

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

  Widget _buildBottomControls(ScanState state) {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Column(
        children: [
          if (state is ScanLoading)
            const CircularProgressIndicator(color: Colors.green)
          else
            GestureDetector(
              onTap: _captureAndScan,
              child: _buildShutterButton(),
            ),
          const SizedBox(height: 20),
          const Text(
            "Arahkan kamera ke makanan",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _captureAndScan() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _controller!.value.isTakingPicture)
      return;

    try {
      final image = await _controller!.takePicture();
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;

      final email = prefs.getString('email');
      if (email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sesi habis, silakan login ulang")),
        );
        return;
      }

      context.read<ScanBloc>().add(
        AnalyzeImageEvent(imagePath: image.path, email: email, source: ScanSource.camera,),
      );
    } catch (e) {
      debugPrint("❌ Error capture: $e");
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal mengambil gambar")));
    }
  }

  Widget _scanFrame() {
    return Container(
      height: 280,
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white54),
      ),
      child: Stack(
        children: List.generate(
          4,
          (i) => Positioned(
            top: i < 2 ? 0 : null,
            bottom: i >= 2 ? 0 : null,
            left: i == 0 || i == 3 ? 0 : null,
            right: i == 1 || i == 2 ? 0 : null,
            child: _cornerIcon(i),
          ),
        ),
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
      child: const Center(
        child: CircleAvatar(radius: 30, backgroundColor: Colors.white),
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