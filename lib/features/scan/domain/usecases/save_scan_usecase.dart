import '../entities/scan_result.dart';
import '../repositories/scan_repository.dart';

class SaveScanUseCase {
  final ScanRepository repository;

  SaveScanUseCase(this.repository);

  Future<void> execute(ScanResult scanResult) async {
    return await repository.saveScanToHistory(scanResult);
  }
}
