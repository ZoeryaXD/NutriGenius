import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan ini

// Core
import 'package:nutrigenius/core/network/network_info.dart';
import 'package:nutrigenius/core/usecases/database_helper.dart';
import 'package:nutrigenius/core/theme/theme_cubit.dart'; // Import ThemeCubit kamu

// Fitur-fitur
import 'package:nutrigenius/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:nutrigenius/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:nutrigenius/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:nutrigenius/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:nutrigenius/features/history/data/datasources/history_local_data_source.dart';
import 'package:nutrigenius/features/history/data/datasources/history_remote_data_source.dart';
import 'package:nutrigenius/features/history/data/repositories/history_repository_impl.dart';
import 'package:nutrigenius/features/history/domain/repositories/history_repository.dart';
import 'package:nutrigenius/features/history/domain/usecases/delete_history_usecase.dart';
import 'package:nutrigenius/features/history/domain/usecases/get_history_usecase.dart';
import 'package:nutrigenius/features/history/presentation/bloc/history_bloc.dart';
import 'package:nutrigenius/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nutrigenius/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:nutrigenius/features/profile/domain/repositories/profile_repository.dart';
import 'package:nutrigenius/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nutrigenius/features/scan/data/datasources/scan_remote_data_source.dart';
import 'package:nutrigenius/features/scan/data/repositories/scan_repository_impl.dart';
import 'package:nutrigenius/features/scan/domain/repositories/scan_repository.dart';
import 'package:nutrigenius/features/scan/domain/usecases/analyze_image_usecase.dart';
import 'package:nutrigenius/features/scan/domain/usecases/save_scan_usecase.dart';
import 'package:nutrigenius/features/scan/presentation/bloc/scan_bloc.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/firstpage/data/datasources/firstpage_remote_data_source.dart';
import 'features/firstpage/data/repositories/firstpage_repository_impl.dart';
import 'features/firstpage/domain/repositories/firstpage_repository.dart';
import 'features/firstpage/presentation/bloc/firstpage_bloc.dart';
import 'features/firstpage/domain/usecase/calculate_tdee.dart';
import 'features/profile/domain/usecases/delete_account_usecase.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/logout_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================
  // ! 0. EXTERNAL (Wajib di awal)
  // ==========================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  // ==========================
  // ! 1. THEME (Ganti Mode Gelap/Terang)
  // ==========================
  sl.registerLazySingleton(() => ThemeCubit(prefs: sl()));

  // ==========================
  // ! 2. FITUR AUTH
  // ==========================
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), client: sl()),
  );

  // ==========================
  // ! 3. FITUR FIRSTPAGE
  // ==========================
  sl.registerFactory(
    () => FirstPageBloc(calculateTDEE: sl(), repository: sl()),
  );
  sl.registerLazySingleton(() => CalculateTDEE());
  sl.registerLazySingleton<FirstPageRepository>(
    () => FirstPageRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<FirstpageRemoteDataSource>(
    () => FirstpageRemoteDataSourceImpl(client: sl()),
  );

  // ==========================
  // ! 4. FITUR DASHBOARD
  // ==========================
  sl.registerFactory(() => DashboardBloc(repository: sl()));
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(client: sl(), databaseHelper: sl()),
  );
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: sl()),
  );

  // ==========================
  // ! 5. FITUR PROFILE
  // ==========================

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      databaseHelper: sl(),
      sharedPreferences: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));

  sl.registerFactory(
    () => ProfileBloc(
      getProfile: sl(),
      logout: sl(),
      deleteAccount: sl(),
      repository: sl(),
    ),
  );

  // ==========================
  // ! 6. FITUR SCAN
  // ==========================
  sl.registerFactory(() => ScanBloc(analyzeImage: sl(), saveScan: sl()));
  sl.registerLazySingleton(() => AnalyzeImageUseCase(sl()));
  sl.registerLazySingleton(() => SaveScanUseCase(sl()));
  sl.registerLazySingleton<ScanRepository>(
    () => ScanRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ScanRemoteDataSource>(
    () => ScanRemoteDataSourceImpl(client: sl()),
  );

  // ==========================
  // ! 7. CORE (Network)
  // ==========================
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // ===========================
  // ! 8. FEATURE: HISTORY
  // ===========================
  sl.registerFactory(() => HistoryBloc(getHistory: sl(), deleteHistory: sl()));
  sl.registerLazySingleton(() => GetHistoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteHistoryUseCase(sl()));
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<HistoryLocalDataSource>(
    () => HistoryLocalDataSourceImpl(databaseHelper: sl()),
  );
}
