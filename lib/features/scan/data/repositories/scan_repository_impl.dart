import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/scan_repository.dart';
import '../models/scan_result_model.dart';
import '../../../../core/usecases/database_helper.dart';
import 'package:http_parser/http_parser.dart';

class ScanRepositoryImpl implements ScanRepository {
  final Dio _dio = Dio();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Alamat API: Gunakan 10.0.2.2 untuk Emulator Android, localhost untuk Web
  String get baseUrl =>
      kIsWeb ? "http://localhost:3000" : "http://10.0.2.2:3000";

  @override
  Future<ScanResult> analyzeImage(XFile image, int userId) async {
    try {
      FormData formData;

      if (kIsWeb) {
        final bytes = await image.readAsBytes();

        // Ambil extension file (misal: .jpg, .png)
        String extension = p.extension(image.name).replaceAll('.', '');
        if (extension.isEmpty) extension = 'jpg'; // fallback

        formData = FormData.fromMap({
          "userId": userId.toString(), // Kirim sebagai String agar lebih stabil
          "image": MultipartFile.fromBytes(
            bytes,
            filename: image.name,
            // PENTING: Beri tahu server kalau ini adalah image
            contentType: MediaType(
              'image',
              extension == 'png' ? 'png' : 'jpeg',
            ),
          ),
        });
      } else {
        formData = FormData.fromMap({
          "userId": userId,
          "image": await MultipartFile.fromFile(
            image.path,
            filename: p.basename(image.path),
            contentType: MediaType('image', 'jpeg'), // Tambahkan ini juga
          ),
        });
      }

      final response = await _dio.post(
        "$baseUrl/api/scan/analyze",
        data: formData,
        options: Options(
          // Jangan set Content-Type manual, biarkan Dio yang menentukan boundary-nya
          headers: {"Accept": "application/json"},
        ),
      );
      if (response.statusCode == 200) {
        // Untuk imagePath di Web, kita gunakan image.path (blob url) sementara
        return ScanResultModel.fromJson(response.data['data'], image.path);
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Gagal terhubung ke server: $e");
    }
  }

  @override
  Future<void> saveScanToHistory(ScanResult scanResult) async {
    if (kIsWeb)
      return; // SQLite & PathProvider biasanya tidak digunakan di Web murni

    try {
      final db = await _dbHelper.database;
      final appDir = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(scanResult.imagePath);
      final String permanentPath = p.join(appDir.path, fileName);

      await File(scanResult.imagePath).copy(permanentPath);

      final model = ScanResultModel(
        foodName: scanResult.foodName,
        calories: scanResult.calories,
        protein: scanResult.protein,
        carbs: scanResult.carbs,
        fat: scanResult.fat,
        sugar: scanResult.sugar,
        imagePath: permanentPath,
        aiSuggestion: scanResult.aiSuggestion,
        date: scanResult.date,
      );

      await db.insert('local_scans', model.toSqliteMap());
    } catch (e) {
      throw Exception("Gagal simpan ke database lokal: $e");
    }
  }

  @override
  Future<List<ScanResult>> getLocalScanHistory() async {
    if (kIsWeb) return [];
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'local_scans',
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return ScanResult(
        id: maps[i]['id'],
        foodName: maps[i]['foodName'],
        calories: maps[i]['calories'],
        protein: maps[i]['protein'],
        carbs: maps[i]['carbs'],
        fat: maps[i]['fat'],
        sugar: maps[i]['sugar'],
        imagePath: maps[i]['imagePath'],
        aiSuggestion: '',
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }
}
