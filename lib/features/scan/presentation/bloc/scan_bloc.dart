import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/usecases/analyze_food_usecase.dart';
import '../../domain/usecases/save_scan_usecase.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final AnalyzeFoodUseCase analyzeFoodUseCase;
  final SaveScanUseCase saveScanUseCase;

  ScanBloc({required this.analyzeFoodUseCase, required this.saveScanUseCase})
    : super(ScanInitial()) {
    on<OnAnalyzeImage>((event, emit) async {
      emit(ScanLoading());
      try {
        final result = await analyzeFoodUseCase.execute(
          event.image,
          event.userId,
        );
        emit(ScanSuccess(result));
      } catch (e) {
        emit(ScanFailure(e.toString()));
      }
    });

    on<OnSaveResult>((event, emit) async {
      try {
        await saveScanUseCase.execute(event.result);
        // Bisa emit state baru jika butuh navigasi otomatis setelah simpan
      } catch (e) {
        emit(ScanFailure("Gagal menyimpan: ${e.toString()}"));
      }
    });
  }
}
