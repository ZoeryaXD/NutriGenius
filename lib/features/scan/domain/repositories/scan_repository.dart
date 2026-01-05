import 'package:image_picker/image_picker.dart';
import '../entities/scan_result.dart';

abstract class ScanRepository {
  /// Mengirim gambar ke Backend Node.js untuk dianalisis oleh Gemini
  /// dan mendapatkan data nutrisi awal.
  Future<ScanResult> analyzeImage(XFile image, int userId);

  /// Menyimpan hasil analisis ke SQLite lokal (termasuk path gambar)
  /// dan menyinkronkan data nutrisi ke MySQL server.
  Future<void> saveScanToHistory(ScanResult scanResult);

  /// Mengambil riwayat scan dari database lokal SQLite
  Future<List<ScanResult>> getLocalScanHistory();
}
