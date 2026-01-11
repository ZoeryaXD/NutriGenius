import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/usecases/analyze_image_usecase.dart';
import '../../domain/usecases/save_scan_usecase.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final AnalyzeImageUseCase analyzeImage;
  final SaveScanUseCase saveScan;

  ScanBloc({required this.analyzeImage, required this.saveScan})
    : super(ScanInitial()) {
    on<AnalyzeImageEvent>((event, emit) async {
      emit(ScanLoading(source: event.source));

      final params = AnalyzeImageParams(
        imagePath: event.imagePath,
        email: event.email,
      );

      final result = await analyzeImage(params);

      result.fold(
        (failure) {
          emit(ScanFailure(failure.message));
        },
        (data) {
          emit(ScanSuccess(result: data, source: event.source));
        },
      );
    });

    on<SaveResultEvent>((event, emit) async {
      final params = SaveScanParams(result: event.result, email: event.email);

      final result = await saveScan(params);

      result.fold(
        (failure) => emit(ScanFailure(failure.message)),
        (_) => emit(ScanSaved()),
      );
    });
  }
}