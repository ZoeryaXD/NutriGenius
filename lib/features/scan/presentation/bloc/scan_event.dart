part of 'scan_bloc.dart';

abstract class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object> get props => [];
}

class AnalyzeImageEvent extends ScanEvent {
  final String imagePath;
  final String email;

  const AnalyzeImageEvent({required this.imagePath, required this.email});

  @override
  List<Object> get props => [imagePath, email];
}

class SaveResultEvent extends ScanEvent {
  final ScanResult result;
  final String email;

  const SaveResultEvent({required this.result, required this.email});

  @override
  List<Object> get props => [result, email];
}