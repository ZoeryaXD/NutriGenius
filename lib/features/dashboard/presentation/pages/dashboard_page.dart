import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../injection_container.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../../scan/presentation/pages/camera_page.dart';
import '../../../scan/presentation/bloc/scan_bloc.dart';
import 'package:nutrigenius/features/scan/domain/entities/scan_result.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Refresh otomatis setiap 5 detik agar kalau ada yang dihapus di history,
    // angka kalori di sini langsung update tanpa tarik-tarik layar lagi.
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        context.read<DashboardBloc>().add(RefreshDashboard());
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(LoadDashboard()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                );
              } else if (state is DashboardLoaded) {
                return _buildDashboardContent(
                  context,
                  state.data,
                  colorScheme,
                  isDark,
                );
              } else if (state is DashboardError) {
                return _buildErrorState(context, state.message, colorScheme);
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    DashboardEntity data,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(RefreshDashboard());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: colorScheme.primary,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section (Tanpa Logo Aset)
            Row(
              children: [
                Icon(Icons.spa_rounded, color: colorScheme.primary, size: 32),
                const SizedBox(width: 10),
                Text(
                  "NutriGenius",
                  style: TextStyle(
                    color: isDark ? Colors.white : colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Text(
              _getGreeting(),
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
              data.displayName.isNotEmpty ? data.displayName : "Nutri User",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // KARTU UTAMA: KALORI MASUK
            _buildCaloriesCard(data, colorScheme),

            const SizedBox(height: 32),

            Text(
              "Makro Nutrisi (Harian)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _buildMacroCard(
                  "Protein",
                  "${data.proteinConsumed.toInt()}g",
                  Icons.fitness_center_rounded,
                  Colors.blue,
                  isDark,
                  colorScheme,
                ),
                const SizedBox(width: 12),
                _buildMacroCard(
                  "Karbo",
                  "${data.carbsConsumed.toInt()}g",
                  Icons.bakery_dining_rounded,
                  Colors.orange,
                  isDark,
                  colorScheme,
                ),
                const SizedBox(width: 12),
                _buildMacroCard(
                  "Lemak",
                  "${data.fatConsumed.toInt()}g",
                  Icons.opacity_rounded,
                  Colors.teal,
                  isDark,
                  colorScheme,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // TOMBOL SCAN BESAR
            _buildScanButton(context, colorScheme),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesCard(DashboardEntity data, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, const Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kalori Masuk",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  child: Text(
                    "${data.caloriesConsumed.toInt()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "dari target ${data.tdee.toInt()} kkal",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          _buildProgressCircle(data.progress),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(double progress) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 85,
          height: 85,
          child: CircularProgressIndicator(
            value: 1.0,
            color: Colors.white.withOpacity(0.15),
            strokeWidth: 10,
          ),
        ),
        SizedBox(
          width: 85,
          height: 85,
          child: CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            color: Colors.white,
            strokeWidth: 10,
            strokeCap: StrokeCap.round,
          ),
        ),
        const Icon(Icons.bolt_rounded, color: Colors.white, size: 32),
      ],
    );
  }

  Widget _buildMacroCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanButton(BuildContext context, ColorScheme colorScheme) {
    return InkWell(
      onTap: () => _showScanOptions(context),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 28),
            SizedBox(width: 12),
            Text(
              "Mulai Scan Makanan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi,';
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  void _showScanOptions(BuildContext rootContext) {
    showModalBottomSheet(
      context: rootContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Pilih Metode Scan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOptionBtn(
                      context,
                      Icons.camera_rounded,
                      "Kamera",
                      () {
                        Navigator.pop(context);
                        Navigator.push(
                          rootContext,
                          MaterialPageRoute(builder: (_) => const CameraPage()),
                        );
                      },
                      rootContext,
                    ),
                    _buildOptionBtn(context, Icons.image_rounded, "Galeri", () {
                      _handleScanFromGallery(
                        rootContext: rootContext,
                        sheetContext: context,
                      );
                    }, rootContext),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  Widget _buildOptionBtn(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
    BuildContext rootContext,
  ) {
    final colorScheme = Theme.of(rootContext).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: colorScheme.primary.withOpacity(0.1),
            child: Icon(icon, color: colorScheme.primary, size: 30),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Fungsi Scan dari Galeri
  Future<void> _handleScanFromGallery({
    required BuildContext rootContext,
    required BuildContext sheetContext,
  }) async {
    Navigator.pop(sheetContext);
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email == null) return;

    rootContext.read<ScanBloc>().add(
      AnalyzeImageEvent(
        imagePath: image.path,
        email: email,
        source: ScanSource.gallery,
      ),
    );
    Navigator.pushNamed(rootContext, '/scan');
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<DashboardBloc>().add(LoadDashboard()),
            child: const Text("Refresh"),
          ),
        ],
      ),
    );
  }
}
