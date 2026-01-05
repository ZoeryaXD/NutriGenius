part of 'scan_bloc.dart';

abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {
  final ScanResult result;
  ScanSuccess(this.result);
}

class ScanFailure extends ScanState {
  final String message;
  ScanFailure(this.message);
}