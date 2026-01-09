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
  bool _isCameraInitialized = false; // Flag manual biar lebih stabil

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  // Menangani Minimize/Resume Aplikasi
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // Jika controller belum ada/mati, abaikan
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Aplikasi diminimize -> Stop kamera biar gak crash BufferQueue
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Aplikasi dibuka lagi -> Nyalakan ulang
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // 👇 UBAH JADI MEDIUM (PENTING!)
      // 'high' sering bikin crash BufferQueue di banyak HP Android.
      // 'medium' (720p/480p) sudah SANGAT CUKUP untuk AI NutriGenius.
      _controller = CameraController(
        cameras.first, 
        ResolutionPreset.high, 
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg, // Paksa format JPG biar aman
      );

      await _controller!.initialize();
      
      if (!mounted) return;
      
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint("Error Init Camera: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Hancurkan controller
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
            // Gunakan pushReplacement agar halaman kamera dimatikan total saat pindah
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ScanResultPage(
                  data: state.result,
                  // Karena CameraPage sudah di-kill (replacement), 
                  // kalau mau scan lagi user harus buka menu scan dari awal.
                  // Ini lebih aman buat memori.
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
              // 1. KAMERA PREVIEW
              // Kita cek manual flag-nya, jangan pakai FutureBuilder biar gak flicker
              if (_isCameraInitialized && _controller != null)
                SizedBox.expand(child: CameraPreview(_controller!))
              else
                const Center(child: CircularProgressIndicator(color: Colors.green)),

              // 2. FRAME KOTAK
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

              // 3. TOMBOL & INSTRUKSI
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
                          // Cek apakah controller siap
                          if (_controller == null || !_controller!.value.isInitialized) return;
                          
                          // Cek apakah sedang memproses (biar gak double tap)
                          if (_controller!.value.isTakingPicture) return;

                          // SNAPSHOT VARIABEL
                          final scanBloc = context.read<ScanBloc>();
                          final messenger = ScaffoldMessenger.of(context);

                          try {
                            // Ambil Foto
                            final image = await _controller!.takePicture();
                            
                            if (!mounted) return;

                            final prefs = await SharedPreferences.getInstance();
                            final email = prefs.getString('email');
                            
                            if (!mounted) return;

                            if (email == null) {
                              messenger.showSnackBar(
                                const SnackBar(content: Text("Sesi habis, silakan login ulang")),
                              );
                              return;
                            }

                            // Kirim ke Bloc
                            scanBloc.add(
                              AnalyzeImageEvent(imagePath: image.path, email: email),
                            );

                          } catch (e) {
                            debugPrint("Error capture: $e");
                            if (mounted) {
                              messenger.showSnackBar(
                                const SnackBar(content: Text("Gagal mengambil gambar")),
                              );
                            }
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

              // 4. TOMBOL BACK
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