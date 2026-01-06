part of 'scan_bloc.dart';

abstract class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object> get props => [];
}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {
  final ScanResult result;

  const ScanSuccess(this.result);

  @override
  List<Object> get props => [result];
}

class ScanFailure extends ScanState {
  final String message;

  const ScanFailure(this.message);

  @override
  List<Object> get props => [message];
}

// 👇 State Baru: Tanda bahwa data sukses disimpan ke Database
class ScanSaved extends ScanState {}