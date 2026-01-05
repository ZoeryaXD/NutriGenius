part of 'scan_bloc.dart';

abstract class ScanEvent {}

class OnAnalyzeImage extends ScanEvent {
  final XFile image;
  final int userId;
  OnAnalyzeImage(this.image, this.userId);
}

class OnSaveResult extends ScanEvent {
  final ScanResult result;
  OnSaveResult(this.result);
}
