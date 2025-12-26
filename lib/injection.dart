import 'package:get_it/get_it.dart';
// import 'features/scan/presentation/bloc/scan_bloc.dart'; // Nanti di-uncomment saat BLoC sudah ada

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Scan
  // Bloc
  // sl.registerFactory(() => ScanBloc(sl()));

  // Use cases
  // sl.registerLazySingleton(() => ScanFoodUseCase(sl()));

  // Repository
  // sl.registerLazySingleton<ScanRepository>(() => ScanRepositoryImpl(sl()));

  // Data sources
  // sl.registerLazySingleton<ScanRemoteDataSource>(() => ScanRemoteDataSourceImpl(client: sl()));

  //! Core
  // sl.registerLazySingleton(() => http.Client());

  //! External
  // Disini nanti kita register SharedPreference, dll
}
