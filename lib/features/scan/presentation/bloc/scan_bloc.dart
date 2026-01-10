import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/usecases/analyze_image_usecase.dart';
// 👇 1. Import UseCase Save
import '../../domain/usecases/save_scan_usecase.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final AnalyzeImageUseCase analyzeImage;
  // 👇 2. Tambahkan Variable SaveUseCase
  final SaveScanUseCase saveScan;

  ScanBloc({
    required this.analyzeImage,
    required this.saveScan, // 👇 3. Wajib diisi di Constructor
  }) : super(ScanInitial()) {
    // === EVENT 1: ANALYZE IMAGE (Preview) ===
    on<AnalyzeImageEvent>((event, emit) async {
      emit(ScanLoading());

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
          emit(ScanSuccess(data));
        },
      );
    });

    on<SaveResultEvent>((event, emit) async {
      emit(ScanLoading());

      final params = SaveScanParams(result: event.result, email: event.email);

      final result = await saveScan(params);

      result.fold(
        (failure) => emit(ScanFailure(failure.message)),
        (_) => emit(ScanSaved()),
      );
    });
  }
}
