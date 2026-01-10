part of 'scan_bloc.dart';

abstract class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object> get props => [];
}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {
  final ScanSource source;
  const ScanLoading({required this.source});
}

class ScanSuccess extends ScanState {
  final ScanResult result;
  final ScanSource source;

  const ScanSuccess({required this.result, required this.source});

  @override
  List<Object> get props => [result, source];
}

class ScanFailure extends ScanState {
  final String message;

  const ScanFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ScanSaved extends ScanState {}
