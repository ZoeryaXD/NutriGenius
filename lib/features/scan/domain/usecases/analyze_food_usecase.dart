import 'package:image_picker/image_picker.dart';
import '../entities/scan_result.dart';
import '../repositories/scan_repository.dart';

class AnalyzeFoodUseCase {
  final ScanRepository repository;

  AnalyzeFoodUseCase(this.repository);

  Future<ScanResult> execute(XFile image, int userId) async {
    return await repository.analyzeImage(image, userId);
  }
}
