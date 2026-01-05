import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrigenius/core/usecases/database_helper.dart';

// Import Fitur Auth
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Import Fitur Firstpage
import 'features/firstpage/data/datasources/firstpage_remote_data_source.dart';
import 'features/firstpage/data/repositories/firstpage_repository_impl.dart';
import 'features/firstpage/domain/repositories/firstpage_repository.dart';
import 'features/firstpage/presentation/bloc/firstpage_bloc.dart';
import 'features/firstpage/domain/usecase/calculate_tdee.dart';

// Import Fitur Dashboard
import 'package:nutrigenius/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:nutrigenius/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:nutrigenius/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:nutrigenius/features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Import Fitur Profile
import 'package:nutrigenius/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nutrigenius/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:nutrigenius/features/profile/domain/repositories/profile_repository.dart';
import 'package:nutrigenius/features/profile/presentation/bloc/profile_bloc.dart';

// =========================================================
// ! IMPORT FITUR SCAN (TAMBAHAN BARU)
// =========================================================
import 'features/scan/data/repositories/scan_repository_impl.dart';
import 'features/scan/domain/repositories/scan_repository.dart';
import 'features/scan/domain/usecases/analyze_food_usecase.dart';
import 'features/scan/domain/usecases/save_scan_usecase.dart';
import 'features/scan/presentation/bloc/scan_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================
  // ! 1. FITUR AUTH
  // ==========================
  sl.registerFactory(() => AuthBloc(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), client: sl()),
  );

  // ==========================
  // ! 2. FITUR FIRSTPAGE
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
  // ! 3. FITUR DASHBOARD
  // ==========================
  sl.registerFactory(() => DashboardBloc(repository: sl()));

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(client: sl()),
  );

  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: sl()),
  );

  // ==========================
  // ! 4. FITUR PROFILE
  // ==========================
  sl.registerFactory(() => ProfileBloc(repository: sl()));

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(client: sl()),
  );

  // =========================================================
  // ! 5. FITUR SCAN (PERBAIKAN & PENAMBAHAN)
  // =========================================================
  // BLoC
  sl.registerFactory(
    () => ScanBloc(analyzeFoodUseCase: sl(), saveScanUseCase: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => AnalyzeFoodUseCase(sl()));
  sl.registerLazySingleton(() => SaveScanUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ScanRepository>(() => ScanRepositoryImpl());

  // ==========================
  // ! EXTERNAL
  // ==========================
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => DatabaseHelper.instance);
}
